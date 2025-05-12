from transformers import AutoTokenizer, AutoModelForCausalLM
import torch

model_path = 'LLM4Binary/llm4decompile-6.7b-v1.5'
tokenizer = AutoTokenizer.from_pretrained(model_path)
model = AutoModelForCausalLM.from_pretrained(model_path, torch_dtype=torch.bfloat16).cuda()

with open('samples/sample_O0.asm', 'r') as f:
    asm_func = f.read()

inputs = tokenizer(asm_func, return_tensors="pt").to(model.device)
with torch.no_grad():
    outputs = model.generate(**inputs, max_new_tokens=2048)

c_func_decompile = tokenizer.decode(outputs[0][len(inputs["input_ids"][0]):-1])
print("Decompiled Function:\n", c_func_decompile)
