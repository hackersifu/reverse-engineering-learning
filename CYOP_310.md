# CYOP 310 Notes

## Reading
Practical Malware Analysis by Michael Sikorski, Andrew Honig    
Malware Analysis Techniques by Dylan Barker 
Mastering Malware Analysis Second Edition by Alexey Kleymenov, Amr Thabet  
Practical Binary Analysis by Dennis Andriesse 
Learning Malware Analysis by Monnappa KA 
The Ghidra Book by Chris Eagle, Kara Nance 

## Terms
- Binary Analysis - The science and art of analyzing the properties of binary computer programs, called binaries, and the machine code and data they contain.
- Binary Static Analysis - analysis without the binary running
- Binary Dynamic Analysis - runs the binary and analyzes it as it executes.
- Binary instrumentation
- ISA = Instruction Set Architecture
    - Example: x86 ISA, x64ISA
- Intel syntax
- AT&T syntax
- Malware Analysis Definitions:
    - The study of malicious software. The objective of malware analysis is to understand the working of malware and how to detect and eliminate it. 
    - Usually to provide the information you need to respond to a network intrusion.
- Debugger - a tool that allows you to run a program step by step, examine the contents of memory, and register values, and change the contents of memory and registers.
- Disassembler - a tool that converts machine code into assembly code.
    - Difference between debuggers and dissassemblers: https://danielmiessler.com/blog/the-difference-between-decompilers-disassemblers-debuggers-and-hex-editors
- PE - Portable Executable
- Import hashing - a technique used to identify the functions imported by a binary.
    - https://blog.virustotal.com/2014/02/virustotal-imphash.html
- Fuzzy hashing - a technique used to identify similar files.
    - https://ssdeep-project.github.io/ssdeep/index.html

## Tools
- ldd - list dynamic dependencies
    - Example: `ldd <binary>`
- xxd - hexdump utility
    - Example: `xxd <binary>`
Powershell Tips:
- Utilizing `Get-ChildItem` and piping the output to `Get-FileHash` is a great way to get the hashes of files in bulk and saves a great deal of time in triage, as opposed to manually providing each filename to Get-FileHash manually.
- ssdeep - tool for fuzzy hashing
    - Example: `ssdeep <binary>`
    - Importing ssdeep hashes into VirusTotal: https://blog.virustotal.com/2014/02/virustotal-imphash.html
    - ssdeep Advanced Usage: https://ssdeep-project.github.io/ssdeep/index.html
    - ssdeep -l -r -p <directory> - generate ssdeep hashes for all files in a directory, and provides a percentage match between files.
- strings - extract strings from binary
    - Example: `strings <binary>`
    - Example: `strings -n 8 <binary>` - extract strings with 8 or more characters
- CFF Explorer - PE analysis tool
    - Link: https://ntcore.com/explorer-suite/

## PE Header Structure
- PE Headers are used to identify the file as a PE file.
    - Common sections: `.text`, `.data`, `.rdata`, `.rsrc`, `.reloc`

## File Headers to file type
- ELF - Executable and Linkable Format (Linux)
- PE - Portable Executable (Windows)
- Mach-O - Mach Object (macOS)
- MZ - DOS Executable (Windows)
- PK... - ZIP Archive
- Rar! - RAR Archive
- X.S.BB` - Mac Disk image file
- %PDF - PDF file
- MSCF - CAB file