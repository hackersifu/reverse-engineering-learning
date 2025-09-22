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
