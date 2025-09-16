from notion_client import Client
import json

import os
import requests
from datetime import datetime

# ensure images folder exists
os.makedirs("images", exist_ok=True)

def download_image(url):
    """Download image to images/ folder with timestamp filename and return relative path"""
    now = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"images/{now}.png"

    r = requests.get(url, stream=True)
    if r.status_code == 200:
        with open(filename, "wb") as f:
            for chunk in r.iter_content(1024):
                f.write(chunk)
    else:
        raise Exception(f"Failed to download image: {r.status_code}")

    return filename


notion = Client(auth="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")

def get_all_blocks(block_id):
    """Recursively fetch all blocks inside a page/block"""
    blocks = []
    cursor = None

    while True:
        response = notion.blocks.children.list(block_id, start_cursor=cursor)
        for block in response["results"]:
            blocks.append(block)
            if block["has_children"]:
                child_blocks = get_all_blocks(block["id"])
                block["children"] = child_blocks
        if not response.get("has_more"):
            break
        cursor = response["next_cursor"]

    return blocks

def rich_text_to_typst(rich_text_array):
    """Convert Notion rich_text objects into Typst strings, including inline equations"""
    parts = []
    for rt in rich_text_array:
        rtype = rt.get("type")

        if rtype == "text":
            text = rt["plain_text"]
            ann = rt.get("annotations", {})

            # Basic inline formatting
            if ann.get("bold"):
                text = f"#strong[{text}]"
            if ann.get("italic"):
                text = f"_{text}_"
            if ann.get("code"):
                text = f"`{text}`"
            if ann.get("strikethrough"):
                text = f"#strike[{text}]"
            if ann.get("underline"):
                text = f"#underline[{text}]"

            parts.append(text)

        elif rtype == "equation":
            expr = rt["equation"]["expression"]
            expr = expr.replace("\\", "")
            parts.append(f"${expr}$")

        else:
            parts.append(rt.get("plain_text", ""))

    return "".join(parts)



def block_to_typst(block, depth=0):
    """Convert a Notion block into Typst markup"""
    btype = block["type"]
    text = block.get(btype, {}).get("rich_text", [])

    if btype == "paragraph":
        return rich_text_to_typst(text)
    elif btype == "heading_1":
        return f"= {rich_text_to_typst(text)}"
    elif btype == "heading_2":
        return f"== {rich_text_to_typst(text)}"
    elif btype == "heading_3":
        return f"=== {rich_text_to_typst(text)}"
    elif btype == "bulleted_list_item":
        return f"- {rich_text_to_typst(text)}"
    elif btype == "numbered_list_item":
        return f"+ {rich_text_to_typst(text)}"
    elif btype == "to_do":
        checked = block[btype].get("checked", False)
        box = "[x]" if checked else "[ ]"
        return f"- {rich_text_to_typst(text)}"
    elif btype == "quote":
        return f"> {rich_text_to_typst(text)}"
    elif btype == "code":
        lang = block[btype].get("language", "")
        code_text = "".join(rt["plain_text"] for rt in text)
        return f"```{lang}\n{code_text}\n```"
    elif btype == "child_page":
        return f"= {block[btype]['title']}"
    elif btype == "equation":
        content = block[btype]['expression'].replace('\\', '')
        return f"${content}$"
    elif btype == "image":
        if block[btype]["type"] == "file":
            url = block[btype]["file"]["url"]
        else:
            url = block[btype]["external"]["url"]

        local_path = download_image(url)

        if block[btype]["caption"]:
            caption = block[btype]["caption"][0]["plain_text"]
            return f"#figure(image(\"{local_path}\"), caption:\"{caption}\")"

        return f"#figure(image(\"{local_path}\"))"
    else:
        return f"// Unsupported block type: {btype}"

def blocks_to_typst(blocks, depth=0):
    lines = []
    for block in blocks:
        block_text = block_to_typst(block, depth)
        if block_text:
            lines.append(block_text)
        if "children" in block:
            child_text = blocks_to_typst(block["children"], depth + 1)
            if child_text:
                lines.append(child_text)

    # If depth == 0 (top-level), separate blocks with double newlines
    sep = "\n\n" if depth == 0 else "\n"
    return sep.join(lines)



all_blocks = get_all_blocks("154fd949e11780fe9c60ea079cca576e")
# ALGEBRA: 154fd949e11780fe9c60ea079cca576e
# TEST PAGE: 25efd949e11780cbac61d8a8151b75d8
with open("dump.json", "w", encoding="utf-8") as f:
    json.dump(all_blocks, f)

typst_doc = blocks_to_typst(all_blocks)

with open("notion_page.typ", "w", encoding="utf-8") as f:
    f.write(typst_doc)