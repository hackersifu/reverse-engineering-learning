import subprocess
import os

func_name = 'func0'
OPT = ["O0", "O1", "O2", "O3"]
fileName = 'samples/sample'

for opt_state in OPT:
    output_file = fileName + '_' + opt_state
    input_file = fileName + '.c'

    compile_command = f'gcc -o {output_file}.o {input_file} -{opt_state} -lm'
    subprocess.run(compile_command, shell=True, check=True)

    disasm_command = f'objdump -d {output_file}.o > {output_file}.s'
    subprocess.run(disasm_command, shell=True, check=True)

    with open(output_file + '.s') as f:
        asm = f.read()
        if f'<{func_name}>:' not in asm:
            raise ValueError("compile fails")
        asm = '<' + func_name + '>:' + asm.split(f'<{func_name}>:')[-1].split('\n\n')[0]
        asm_clean = ""
        for line in asm.splitlines():
            if len(line.split("\t")) < 3 and '00' in line:
                continue
            idx = min(len(line.split("\t")) - 1, 2)
            tmp_asm = "\t".join(line.split("\t")[idx:])
            tmp_asm = tmp_asm.split("#")[0].strip()
            asm_clean += tmp_asm + "\n"
    input_asm_prompt = "# This is the assembly code:\n" + asm_clean.strip() + "\n# What is the source code?\n"
    with open(output_file + '.asm', 'w') as f:
        f.write(input_asm_prompt)
