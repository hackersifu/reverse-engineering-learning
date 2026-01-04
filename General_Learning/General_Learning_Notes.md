# General Learning Notes

# Why Malware Analysis?
- Exploit dev uses it
- Malware analysis for fornesnics during an investigation (of course)

## Benefits
- Assess the nature of malware threats
- Determine the scope of the incident
- Eradicate malicious artifacts and code
- Fortify system and network defenses
- Strengthen your ability to respond to future incidents

# What drives malware analysis for customers?
- What questions do you need answered?
- Examples: Does this software meet our reqiuirements for safe software?


# Looking up File Types
- `file <filename>` - Linux command to identify file types

# PE Files
- Always have the 4D 5A header (MZ Header)

# TrID - Looks up file types

- 80 00 00 00 - PE Header (4 bytes) Little Endian

- Symbols (or references)

- Mutex -
- A mutual exclusion object that allows multiple program threads to share the same resource, such as file access, but not simultaneously.
- Used to prevent multiple instances of a program from running at the same time.
- If A tries to run and sees that B is already running (by checking for the mutex), A will exit.

- Beacons - A type of malware that establishes a persistent connection to a command and control (C2) server, allowing attackers to remotely control the infected system and exfiltrate data.

# Unicode
- Each character is represented by two bytes instead of one byte.
- Example: "A" in ASCII is 41 in hex, but in Unicode it is 41 00 in hex.
- Unicode UTF-16LE (Little Endian) - 41 00 42 00 43 00 = "ABC"


# Strings
- strings <sample.exe> -e l - for little endian unicode strings
- strings <sample.exe> -e b - for big endian

# pestr
- A tool to extract strings from PE files, including obfuscated and encoded strings.
- pestr <sample.exe> -d - decodes obfuscated strings


%s?i=%&c=%s&p=%s decrypts to
http://maliciousdomain.com/index.php?i=1&c=2&s=3

# PE Studio
- Difference between virtual-address and virtual-size
- Virtual Address - The address of the section when loaded into memory.
- Virtual Size - The size of the section when loaded into memory.
- entry-point > location - The entry point is the address where the execution of the program begins. It is specified in the PE header and is typically located in the .text section of the PE file.
- image-base & ASLR - The image base is the preferred address where the PE file is loaded into memory. ASLR (Address Space Layout Randomization) is a security feature that randomizes the memory addresses used by a program, making it more difficult for attackers to predict the location of specific code or data.

Decompliation vs Disassembly
- Decompilation - The process of converting low-level machine code back into high-level source code
- Disassembly - The process of converting machine code into assembly language, which is a low-level representation of the code that is closer to the original source code but still requires knowledge of assembly language to understand.

# Assembly
- As a reverse engineer, you don't need to be a assembly programmer.
- Some common instructions a RE should know:
    - mov - Move data from one location to another
    - push - Push data onto the stack
    - pop - Pop data off the stack
    - call - Call a function
    - ret - Return from a function
    - jmp - Jump to a different location in the code
    - jz - Jump if zero
    - jnz - Jump if not zero

# Pointers
- A pointer is a variable that stores the memory address of another variable.
- Pay attention to the brackets [] - they indicate that the value is a pointer.
- Example:
    - mov eax, [ebx] - Move the value at the memory address stored in   ebx into eax
    - mov eax, ebx - Move the value of ebx into eax

# Function Calling Conventions
- cdecl - The caller cleans the stack. Used in C programs.
    - Example in disassembly:
        - push 
        - push ecx
        - call <function>
        - add esp, 8  ; Clean up the stack (2 arguments * 4 bytes each)
- stdcall - The callee cleans the stack. Used in Windows API functions.
    - Example in disassembly:
        - push 
        - push ecx
        - call <function>
        - ret 8  ; Clean up the stack (2 arguments * 4 bytes each)
- fastcall - The first two arguments are passed in registers (ecx and edx), the rest are passed on the stack. Used in some C++ programs.
    - Example in disassembly:
        - mov ecx, <arg1>
        - mov edx, <arg2>
        - push <arg3>
        - call <function>
        - add esp, 4  ; Clean up the stack (1 argument * 4 bytes)
- thiscall - The this pointer is passed in ecx, the rest of the arguments are passed on the stack. Used in C++ member functions.
    - Example in disassembly:
        - mov ecx, <this>
        - push <arg1>
        - call <function>
        - add esp, 4  ; Clean up the stack (1 argument * 4 bytes)

# More Stack Notes
- push is subtract 4 from esp and then write the value to the address in esp
- LEA - Load Effective Address
    - Used to get the address of a variable
    - Example:
        - lea eax, [ebx+4] - Load the address of ebx + 4 into eax
    - Brackets don't mean anything with LEA, it's the only instruction where they don't indicate a pointer dereference
- JC - Jump if Carry, used for unsigned comparisons
- JB - Jump if Below, used for unsigned comparisons
    - JB and JC are the same instruction. They are just different mnemonics for the same opcode.
- JNC - Jump if Not Carry, used for unsigned comparisons
- If I see a JZ and JNC pointing to the same function, I'm probably looking at an AND statement.

# Ghidra Usage Tips
- Search - Press G
- Defined Strings - Right click on a string in the decompiler window and select "Defined Strings" to see all instances of that string in the code.
- Function Graph - Right click on a function in the decompiler window and select "Function Graph" to see a graphical representation of the function's control flow.
- Using Show References versus Function Call Tree
    - Show References - Shows all references to a selected function or variable in the code.
    - Function Call Tree - Shows the call hierarchy of functions in the code, allowing you to see which functions call which other functions.
    - Differences: Show References is more focused on a specific function or variable, while Function Call Tree provides a broader view of the entire codebase's function calls.
- Browser Field Formatter - Click on the "Edit the Listing Field" button within the Listing window.

# Dropper Analysis (Analyzing DLLs)
- A dropper is a tool that drops the next stage to disk and runs it.
    - Look for WriteFile, CreateFile, and CloseHandle API calls to identify where the drop

# 32 vs 64 Bit
- WoW64 - Windows on Windows 64, a compatibility layer that allows 32-bit Windows applications to run on 64-bit Windows.
- General purpose registers:
    - 32-bit: EAX, EBX, ECX, EDX, ESI, EDI, EBP, ESP
    - 64-bit: RAX, RBX, RCX, RDX, RSI, RDI, RBP, RSP, R8-R15
    - Special-use registers are extended and renamed (e.g., EIP becomes RIP)
- Calling conventions:
    - 32-bit: cdecl, stdcall, fastcall, thiscall
    - 64-bit: Microsoft x64 calling convention (first four arguments in RCX,
    - Calling convention resembles fastcall, but with more registers available for argument passing)
        - First four integer or pointer arguments are passed in RCX, RDX, R8, and R9
        - Additional arguments are passed on the stack
- There is a new addressing mode called RIP-relative addressing, which allows for position-independent code.
    - RIP + Displacement = Effective Address
    - Example: mov eax, [RIP + 0x200] ; Load the value at the address RIP + 0x200 into eax
- Stack alignment: 64-bit requires the stack to be 16-byte aligned at the point of a function call.


# Parsing PDFs
- Look for the header %PDF-1.x (where x is the version number)
- startxref - Indicates the byte offset of the start of the cross-reference table
- Indirect objects - Objects that are defined in the PDF file and can be referenced by other objects using their object number and generation number.
    - Example: 12 0 obj ... endobj
        - endobj indicates the end of the object definition
- pdfid.py - A tool to identify PDF files and check for common vulnerabilities.
- pdf-parser.py - A tool to parse and analyze PDF files, allowing you to extract objects, streams, and metadata.
- XObject - An external object that is referenced in the PDF file, such as an image or font (mostly images though).
    - Example: /Type /XObject
- PDF Object Types
    - /AA - Additional Actions
    - /OpenAction - Action to be performed when the document is opened
    - /JS - JavaScript action
    - /URI - Uniform Resource Identifier action


# Microsoft Office and VBA Macros
- MOTW - Mark of the Web, a security feature that indicates the origin of a file downloaded from the internet.
    - Example: <!-- saved from url=(0014)about:internet -->
- scdbgct - A tool to decode and analyze VBA macros in Microsoft Office documents.
    - Example usage: scdbgct -f <document.docm>


# Locating kernel32.dll
- Process Environment Block (PEB) - A data structure in Windows that contains information about the currently running process, including a list of loaded modules (DLLs).
    - This points to the PEB:
        - mov eax, fs:[0x30] - For x86
        - mov rax, gs:[0x60] - For x64
- Thread Environment Block (TEB) - A data structure in Windows that contains information about the currently running thread, including a pointer to the PEB.
- Thread Information Block (TIB) - Another name for the TEB.

# Packers
- Command for Packing a file with UPX
    upx -9 original.exe -o packed.exe
- Unpacking a file with UPX: upx -d
    upx -d packed.exe unpacked.exe
- Using x64dbg - make sure to use MEM_WRITE when you dump the unpacked file (Book 4 Page 40)

# Breakpoints
- Software Breakpoints - INT 3 (0xCC) instruction is inserted into the code to trigger a breakpoint.
    - Alternate Software Breakpoints (for countering anti-debugging techniques) - Overwrite the first byte of an instruction with a JMP instruction (0xE9) to jump to a breakpoint handler.
    - Use a divide by zero instruction (0xF7 0xF6) to trigger an exception.
- Hardware Breakpoints - Use CPU registers to monitor specific memory addresses or conditions without modifying the code
- Memory Breakpoints - Monitor read, write, or execute access to a specific memory region.

# Analyzing Multi-Technology Malware
- Set up
    - Process Monitor - To monitor file system, registry, and process/thread activity.
    - Regshot - To take snapshots of the registry before and after running the malware to identify changes.
    - Wireshark - To capture and analyze network traffic generated by the malware.
    - System Informer - To gather detailed information about the system's hardware and software configuration.

# Windows Functions of Interest to Reverse Engineers
- VirtualAlloc - Allocates memory in the virtual address space of the calling process (https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualalloc)
- VirtualAllocEx - Allocates memory in the virtual address space of a specified process (https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualallocex)
- To change the permissions of a 
- CreateFile - Creates or opens a file or I/O device (https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilew)
- Process32First - Retrieves information about the first process encountered in a system snapshot (https://learn.microsoft.com/en-us/windows/win32/api/tlhelp32/nf-tlhelp32-process32first)
- IsDebuggerPresent - Determines whether the calling process is being debugged (https://learn.microsoft.com/en-us/windows/win32/api/debugapi/nf-debugapi-isdebuggerpresent)
- RtlDecompressBuffer - Decompresses a buffer using the specified compression format (https://learn.microsoft.com/en-us/windows/win32/api/ntcompressapi/nf-ntcompressapi-rtldecompressbuffer)
    - Second parameter is UncompressedBuffer, it's the buffer that will hold the decompressed datas
- NTQueryInformationProcess - Retrieves information about the specified process (https://learn.microsoft.com/en-us/windows/win32/api/winternl/nf-winternl-ntqueryinformationprocess)
    - ProcessBasicInformation - 0
    - ProcessDebugPort - 7
    - ProcessWow64Information - 26
    - ProcessImageFileName - 27
    - ProcessBreakOnTermination - 29
- GetModuleHandle - Retrieves a module handle for the specified module (https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulehandlew)
- VirtualProtect - Changes the protection on a region of committed pages in the virtual address space of the calling process (https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualprotect)

# peframes
- A tool to analyze PE files and extract various attributes and indicators of compromise (IOCs).
- peframes -f <sample.exe> - Analyzes the PE file and generates a report with various attributes and IOCs.
    - Useful for identifying packers, compilers, and other characteristics of the PE file.
    - Comparison to other similar tools:
        - PE Studio - GUI-based tool for analyzing PE files, provides a comprehensive overview of the file's attributes and IOCs.
        - CFF Explorer - GUI-based tool for analyzing and editing PE files, provides detailed information about the file's structure and attributes.
        - Detect It Easy (DIE) - GUI-based tool for identifying packers and compilers used in PE files, provides a quick overview of the file's characteristics.

# Reflective Code Loading
- A technique used by malware to load and execute code directly from memory without writing it to disk. This helps evade detection by traditional antivirus software that scans files on disk.
- Commonly used in fileless malware attacks, where the entire attack is carried out in memory without leaving any traces on the file system.

# Code Injection for Malware
- A technique used by malware to inject malicious code into the address space of a legitimate process. This allows the malware to run with the privileges of the target process, making it harder to detect and remove.
- Common methods of code injection include:
    - DLL Injection - Injecting a malicious DLL into a target process using functions like CreateRemoteThread and LoadLibrary.
        - APIs used: OpenProcess, VirtualAllocEx, WriteProcessMemory, CreateRemoteThread, LoadLibrary
    - Process Hollowing - Creating a new process in a suspended state, replacing its memory with malicious code, and then resuming the process.
    - APC Injection - Using Asynchronous Procedure Calls (APCs) to execute malicious code in the context of a target thread.
- APIs used for Code Injection for Windows:
    - OpenProcess - Opens an existing process and returns a handle to it.
    - VirtualAllocEx - Allocates memory in the address space of a specified process.
    - WriteProcessMemory - Writes data to the memory of a specified process.
    - CreateRemoteThread - Creates a thread in the address space of a specified process.
    - LoadLibrary - Loads a DLL into the address space of the calling process.
        - LoadLibraryA - ANSI version
    - CreateToolhelp32Snapshot - Takes a snapshot of the specified processes, as well as the heaps, modules, and threads used by these processes.
    - EnumProcesses - Enumerates all processes currently running on the system.
    - Nt and Zw Functions - Native API functions used for low-level operations, including process and memory management.
        - Nt meaning - Native API function
        - Zw meaning - Zw functions are the same as Nt functions, but they are used in kernel mode. They are essentially a wrapper around the Nt functions that provides additional functionality for kernel-mode drivers.

# TEB/TIB and PEB
- TEB - Thread Environment Block, a data structure in Windows that contains information about a specific
thread, including its stack, exception handling, and thread-local storage.
- TIB - Thread Information Block, another name for the TEB.
- PEB - Process Environment Block, a data structure in Windows that contains information about a specific process, including its loaded modules, process parameters, and environment variables.
- Accessing the PEB in x86 assembly:
    - mov eax, fs:[0x30] - Move the address of the PEB into eax (for x86)
    - mov rax, gs:[0x60] - Move the address of the PEB into rax (for x64)
- Segment Registers:
    - fs - Used to access the TEB in x86 architecture.
    - gs - Used to access the TEB in x64 architecture.

# PE Headers to Look For
- 50 45 00 00 - PE Header (4 bytes) Little Endian
- 4C 01 - Machine Type (2 bytes) Little Endian (x86
- 64 86 - Machine Type (2 bytes) Little Endian (x64)
- 0B 01 - Number of Sections (2 bytes) Little Endian
- 4D 5A - MZ Header (2 bytes) Little Endian


# Process Hollowing- A technique used by malware to create a new process in a suspended state, replace its memory with malicious code, and then resume the process. This allows the malware to run with the privileges of the target process, making it harder to detect and remove.
- Usually involves CreateProcess, NtUnmapViewOfSection, VirtualAllocEx, WriteProcessMemory, and ResumeThread.
    - Uses CreateProcess with the CREATE_SUSPENDED flag to create a new process in a suspended state.
        - Example: CreateProcess("C:\\Windows\\System32\\notepad.exe", NULL, NULL, NULL, FALSE, CREATE_SUSPENDED, NULL, NULL, &si, &pi);


# Virtualization Avoidance Techniques
- Techniques used by malware to detect and avoid running in virtualized environments, such as virtual machines (VMs) or sandboxes. This helps the malware evade analysis and detection by security researchers and automated analysis tools.
- SetWindowsHookEx - A Windows API function that allows an application to install a hook procedure into a hook chain. Malware can use this function to detect user interactions, such as mouse movements or keyboard input, which may indicate that the malware is running in a virtualized environment.
    - Example: SetWindowsHookEx(WH_KEYBOARD_LL, KeyboardProc, NULL, 0); - Installs a low-level keyboard hook to monitor keyboard input.

# Disabling ASLR
- To disable ASLR, you can use setdllcharactistics within x32dbg or x64dbg.
    - setdllcharacteristics -d <address> <characteristics>
    - Example: setdllcharacteristics -d 00400000 0x0040
        - This command disables ASLR for the module loaded at address 00400000 by removing the IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE flag (0x0040) from the module's characteristics.


# Ghidra
- Using Set Equate - Right-click on a value -> Set Equate -> Enter the name of the equate (e.g., "ERROR_SUCCESS") -> Click OK
    - This will replace all instances of the value with the equate name in the disassembly and decompilation views. It knows this due to the Windows API definitions that come with Ghidra.

# Structured Exception Handling (SEH)
- A mechanism in Windows that allows applications to handle exceptions and errors in a structured way. 
    - Example in the debugger: mov eax, fs:[0] - Move the address of the SEH chain into eax
    - Frame-based Exception Handling - A method of exception handling that uses a linked list of exception registration records to manage exceptions. This is specific to 32-bit Windows applications.
    - Table-based Exception Handling - A method of exception handling that uses a table of exception handlers to manage exceptions. This is specific to 64-bit Windows applications.
    - Windows determines the address of the first SEH record by reading the value at fs:[0] (for x86) or gs:[0] (for x64).

# Segment Registers Information
- fs - Used to access the TEB in x86 architecture.
- gs - Used to access the TEB in x64 architecture.
- You can change the segment registers using the MOV instruction.
    - Example: mov fs, ax - Move the value in ax into the fs segment register

# Bypassing Self-Defensive Measures (or Anti-Debugging Techniques)


# RDTSC Instruction
- RDTSC (Read Time-Stamp Counter) is an assembly instruction that reads the current value of the processor's time-stamp counter, which is a 64-bit register that counts the number of clock cycles since the last reset.
- It is often used in anti-debugging techniques to measure the time taken to execute certain code sections, as debuggers can introduce delays that can be detected by the malware.
- Example usage in assembly:
    - rdtsc - Reads the time-stamp counter and stores the lower 32 bits in EAX and the upper 32 bits in EDX.
    - You can then compare the values before and after a code section to determine if a debugger is present based on the time taken to execute that section.

# Random Questions
- In 32-bit Windows, the RET instruction affects the register of:
    - ESP (Extended Stack Pointer) - The RET instruction pops the return address from the stack and transfers control to that address, effectively modifying the ESP register.
    - EIP (Extended Instruction Pointer) - The RET instruction updates the EIP register to point to the return address, allowing the CPU to continue executing instructions from that address.
- The registers value that is pushed into the stack to store "saved frame data" is EBP (Extended Base Pointer). The EBP register is used to create a stack frame for a function, and it is typically pushed onto the stack at the beginning of a function to save the previous frame's base pointer. This allows the function to access its local variables and parameters relative to the EBP register.
- To pass the fourth argument to a subroutine, use this following instruction written in hex: [EBP + 0x10]. In the cdecl calling convention, the first three arguments are passed in registers (ECX, EDX, and R8), while any additional arguments are passed on the stack. The fourth argument is located at an offset of 0x10 from the base pointer (EBP) in the stack frame.
- In JavaScript, the function to detect source code modifications is arguments.callee. 
- To add code libraries to a compiled file, you would use a linker. A linker is a tool that combines object files and libraries into a single executable file, resolving references between them and ensuring that all necessary code is included in the final binary.
- PDF obj format
    - obj 2 0
        - object number 2, generation number 0
        - The object ID is "2 0"