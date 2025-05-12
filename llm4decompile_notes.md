# LLM4Decompile Deployment on AWS EC2 - Guide (Final Updated)

## 1. Choose EC2 Instance Type
- **GPU (recommended)**: `g5.xlarge` or `g4dn.xlarge`
- **CPU-only**: `c6i.large` or `m6i.large`

## 2. Recommended AMI (Amazon Machine Image)
- **Deep Learning AMI (Ubuntu 20.04)** – Recommended for GPU, comes with PyTorch/CUDA
- **Ubuntu Server 22.04 LTS** – Lightweight and stable
- **Amazon Linux 2023** – Only if you prefer minimal base

## 3. Dockerfile Example (Corrected for `test.py`)

```Dockerfile
FROM python:3.10-slim
WORKDIR /app
RUN apt-get update && apt-get install -y git gcc && pip install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt
RUN git clone https://github.com/albertan017/LLM4Decompile.git /app/LLM4Decompile
ENV TRANSFORMERS_CACHE=/app/hf_cache
CMD ["python", "LLM4Decompile/test.py", "--model_path", "Salesforce/codet5-base", "--test_file", "/app/data/input.json", "--output_file", "/app/data/output.json"]
```

## 4. `requirements.txt` Content

```text
transformers==4.36.2
torch==2.1.2
datasets==2.16.1
accelerate==0.25.0
scikit-learn==1.3.2
```

## 5. Security Best Practices
- Use VPC with private subnets for malware samples
- Use SSM instead of SSH
- Block unnecessary outbound traffic
- Terminate instance after test

## 6. Using S3 for Input/Output

```bash
aws s3 cp s3://your-bucket/input.json ./data/input.json
python test.py --model_path Salesforce/codet5-base --test_file ./data/input.json --output_file ./data/output.json
aws s3 cp ./data/output.json s3://your-bucket/results/
```

## 7. Detailed Example Usage Workflow for Running LLM4Decompile in Docker

### Step 1: Create the `data/` Directory

```bash
mkdir -p data
```

### Step 2: Prepare `data/input.json`

Example format:

```json
[
  {
    "id": "sample_001",
    "asm": "push ebp; mov ebp, esp; sub esp, 0x10; mov dword ptr [ebp - 4], 0; jmp label_1"
  }
]
```

### Step 3: Run the Docker Container

```bash
docker run --rm -it \
  --name llm4decompile-test \
  -v $(pwd)/data:/app/data \
  llm4decompile
```

### Step 4: Review the Output

The output will be saved to `./data/output.json`. Example:

```json
[
  {
    "id": "sample_001",
    "predicted_code": "int function() { return 0; }"
  }
]
```

---

## 8. Notes
- The correct script to run inference is `test.py` located at the root of the repo.
- The `predict.py` reference was incorrect and should be ignored.
