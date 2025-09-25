# FOR 610 Overall Notes

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

# Packers
- Command for Packing a file with UPX
    upx -9 original.exe -o packed.exe
- Unpacking a file with UPX: upx -d
    upx -d packed.exe unpacked.exe