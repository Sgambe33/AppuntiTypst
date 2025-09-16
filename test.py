import ctypes
import ctypes.wintypes as wintypes
import time
import os
import sys
import multiprocessing

# Define SIZE_T properly
if sys.maxsize > 2**32:
    SIZE_T = ctypes.c_uint64
else:
    SIZE_T = ctypes.c_uint32

# Constants
SystemProcessInformation = 5

# NtQuerySystemInformation prototype
ntdll = ctypes.WinDLL("ntdll")
NtQuerySystemInformation = ntdll.NtQuerySystemInformation
NtQuerySystemInformation.argtypes = [
    wintypes.ULONG,    # SystemInformationClass
    wintypes.LPVOID,   # SystemInformation
    wintypes.ULONG,    # SystemInformationLength
    wintypes.PULONG    # ReturnLength
]

# Define UNICODE_STRING struct
class UNICODE_STRING(ctypes.Structure):
    _fields_ = [
        ("Length", wintypes.USHORT),
        ("MaximumLength", wintypes.USHORT),
        ("Buffer", wintypes.LPWSTR)
    ]

# SYSTEM_PROCESS_INFORMATION (simplified)
class SYSTEM_PROCESS_INFORMATION(ctypes.Structure):
    _fields_ = [
        ("NextEntryOffset", wintypes.ULONG),
        ("NumberOfThreads", wintypes.ULONG),
        ("WorkingSetPrivateSize", ctypes.c_longlong),
        ("HardFaultCount", wintypes.ULONG),
        ("NumberOfThreadsHighWatermark", wintypes.ULONG),
        ("CycleTime", ctypes.c_ulonglong),
        ("CreateTime", ctypes.c_ulonglong),
        ("UserTime", ctypes.c_ulonglong),
        ("KernelTime", ctypes.c_ulonglong),
        ("ImageName", UNICODE_STRING),
        ("BasePriority", wintypes.LONG),
        ("UniqueProcessId", wintypes.HANDLE),
        ("InheritedFromUniqueProcessId", wintypes.HANDLE),
        ("HandleCount", wintypes.ULONG),
        ("SessionId", wintypes.ULONG),
        ("UniqueProcessKey", ctypes.c_ulonglong),
        ("PeakVirtualSize", SIZE_T),
        ("VirtualSize", SIZE_T),
        ("PageFaultCount", wintypes.ULONG),
        ("PeakWorkingSetSize", SIZE_T),
        ("WorkingSetSize", SIZE_T),
        ("QuotaPeakPagedPoolUsage", SIZE_T),
        ("QuotaPagedPoolUsage", SIZE_T),
        ("QuotaPeakNonPagedPoolUsage", SIZE_T),
        ("QuotaNonPagedPoolUsage", SIZE_T),
        ("PagefileUsage", SIZE_T),
        ("PeakPagefileUsage", SIZE_T),
        ("PrivatePageCount", SIZE_T),
        ("ReadOperationCount", ctypes.c_ulonglong),
        ("WriteOperationCount", ctypes.c_ulonglong),
        ("OtherOperationCount", ctypes.c_ulonglong),
        ("ReadTransferCount", ctypes.c_ulonglong),
        ("WriteTransferCount", ctypes.c_ulonglong),
        ("OtherTransferCount", ctypes.c_ulonglong),
    ]

def query_processes():
    """Query process list via NtQuerySystemInformation."""
    length = wintypes.ULONG(0)
    # First call: get required size
    NtQuerySystemInformation(SystemProcessInformation, None, 0, ctypes.byref(length))

    buf = ctypes.create_string_buffer(length.value)
    status = NtQuerySystemInformation(SystemProcessInformation, buf, length, ctypes.byref(length))
    if status != 0:
        raise OSError(f"NtQuerySystemInformation failed with status {status:x}")

    processes = {}
    offset = 0
    while True:
        proc = SYSTEM_PROCESS_INFORMATION.from_buffer_copy(buf[offset:])
        pid = ctypes.cast(proc.UniqueProcessId, ctypes.c_void_p).value or 0
        name = proc.ImageName.Buffer if proc.ImageName.Buffer else "System"
        cpu_time_100ns = proc.UserTime + proc.KernelTime  # in 100ns units
        mem = proc.WorkingSetSize // 1024  # KB
        io_read = proc.ReadTransferCount // 1024
        io_write = proc.WriteTransferCount // 1024

        processes[pid] = {
            "pid": pid,
            "name": name,
            "cpu_time_100ns": cpu_time_100ns,
            "memory_kb": mem,
            "io_read_kb": io_read,
            "io_write_kb": io_write
        }

        if proc.NextEntryOffset == 0:
            break
        offset += proc.NextEntryOffset

    return processes

def format_table(processes, cpu_usages):
    print(f"{'PID':>6} {'Name':<25} {'CPU %':>7} {'Mem KB':>10} {'Read KB':>10} {'Write KB':>10}")
    for pid, p in list(processes.items())[:25]:  # show top 25
        cpu = cpu_usages.get(pid, 0.0)
        print(f"{p['pid']:>6} {p['name']:<25} {cpu:>7.2f} {p['memory_kb']:>10} {p['io_read_kb']:>10} {p['io_write_kb']:>10}")

if __name__ == "__main__":
    cpu_count = multiprocessing.cpu_count()

    # Initial snapshot
    old_procs = query_processes()
    old_time = time.time()

    while True:
        time.sleep(2)  # sampling interval
        new_procs = query_processes()
        new_time = time.time()
        elapsed = (new_time - old_time)

        cpu_usages = {}
        for pid, new in new_procs.items():
            old = old_procs.get(pid)
            if old:
                delta = (new["cpu_time_100ns"] - old["cpu_time_100ns"]) / 10_000_000  # seconds
                cpu_percent = (delta / (elapsed * cpu_count)) * 100.0
                cpu_usages[pid] = max(cpu_percent, 0.0)

        os.system("cls" if os.name == "nt" else "clear")
        format_table(new_procs, cpu_usages)

        old_procs = new_procs
        old_time = new_time
