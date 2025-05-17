# Reverse Engineering and Malware Analysis - Workflow Notes

### Typical Analysis Workflow

- Triage
  - Analyze the PE header
  - Check if the sample is packed
  - Check for known IoCs (e.g. hashes, network artifacts, AV detections)
- Behavioral Analysis
  - Run the sample in a controlled environment (e.g. VM, sandbox)
  - Monitor system changes (e.g. file system, registry, network)
  - Capture network traffic
- Unpacking the sample
- Static Analysis
  - Start from the strings available, along with what Windows functions are used
- Dynamic Analysis
  - This is when debuggers are used (e.g. x64dbg, WinDbg)
  - Confirm functionality
  - Handling of strings, APIs, embedded payloads, and communication encryption