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

### Choosing an Analysis Strategy
Reverse engineering is a time-consuming process, and in many cases, there aren't the resources available to allow engineers to dive as deep as they would like to.

- Understand the audience (potential use cases)
   - For Threat Intelligence
      - Focuses on obtaining IoCs (files, hashes, network artifacts). Extraction of embedded payloads and downloading remote samples are priorities, as well as identifying the C2 infrastructure and finding related modules.
   - For AV detection
   - For a technical article or conference presentation
   - For the general public
      - 


### Straightforward Techniques
- Check the hash with certutil
- Use CFF Explorer to analyze PE headers
  - On Flare VM, right-click the file and select "Open with CFF Explorer"
- Use strings to look for interesting indicators, such as error codes, URLs, IP addresses, mutex names, and file paths
- Use PeStudio to get a quick overview of the PE file
  - On Flare VM, PeStudio is located in the Tools folder under the C:\ drive
