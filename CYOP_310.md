# CYOP 310 Notes

## Reading
Practical Malware Analysis by Michael Sikorski, Andrew Honig    
Malware Analysis Techniques by Dylan Barker 
Mastering Malware Analysis Second Edition by Alexey Kleymenov, Amr Thabet  
Practical Binary Analysis by Dennis Andriesse 
Learning Malware Analysis by Monnappa KA 
The Ghidra Book by Chris Eagle, Kara Nance
Quick Guide to Assembly - https://leocontent.umgc.edu/content/dam/course-content/tus/cyop/cyop-310/documents/dis06-assembly.pdf?ou=1346078

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
- Code constructs - A code construct is a code abstraction level that defines a functional property but not the details of its implementation. Examples of code constructs include loops, if statements, linked lists, switch statements, and so on. Programs can be broken down into individual constructs that, when combined, implement the overall functionality of the program.

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
- myCompiler - online compiler and debugger
    - Link: https://www.mycompiler.io/new/asm-x86_64
- certutil - Check the hash of the file
    - Example: `certutil -hashfile <filename> SHA1`
- RegShot - Registry comparison tool

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

## ELF Overall Details

### ELF Section Details
Sections of the file format:
-	.init – contains executable code that performs initialization tasks, and runs before any other code in the binary
-	.fini – runs after the main program completes, acting as the destructor of the program
-	.text – where the main code of the program resides
-	.bss – reserves spaces for uninitialized variables
-	.data – storage for initialized variables
-	.rodata – stands for “read-only” data, dedicated to storing constant variables. 
-	.plt – Procedure Linkage Table (PLT), and this is the code section that contains executable code
-	.got.plt – data section of the PLT
-	.rel.* - Contains relocation entries for the .text section
-	.init_array – holds pointers to functions that are executed before the main function is called
-	.fini_array - holds pointers to functions that are executed after the main function is called
-	.got – Global Offset Table (GOT), used for dynamic symbol resolution during runtime
-	.dynsym – stores the dynamic symbol table, used for dynamic linking
-	.dynstr – stores strings associated with dynamic symbols in the .dynsym table
-	.dynamic – contains information about dynamic linking, such as library dependencies and symbol resolution
-	.symtab – holds the symbol table used for linking and debugging
-	.strtab – stores strings for the names of symbols and sections referenced in .symtab
-	.debug – contains debugging information, such as line numbers and variable names (optional in production binaries)
-	.note – stores metadata, such as build information or identification notes
-	.tls – Thread Local Storage (TLS), used for variables that are unique to each thread

### ELF calculation of size of the complete ELF library
- size = e_shoff + (e_shentsize * e_shnum)

## Ghidra Notes
- You can rename variables in Ghidra by right-clicking on the variable and selecting "Rename Variable"
    - This is helpful to follow along in the analysis.
- Look up the total number of functions via the Help -> About File.
- Go to a specific function by using the Navigation -> Go To option in the top menu.

## Flirt Technology
- FLIRT (Fast Library Identification and Recognition Technology) is a tool that allows you to identify functions in a binary by comparing them to a database of known functions.

## Dynamic Analysis Process
### Prerequisites
- Open up Procmon
- Open Up Process Explorer (procexp)
- FakeNet-NG
- ProcWatch

## Using Debuggers
- Debuggers are used to run a program step by step, examine the contents of memory, and register values, and change the contents of memory and registers.
- Set breakpoints right before or after crucial function calls to understand the behavior of the program.