Certainly! Below is a template for a README file for your GitHub repository containing `webhook.py` and `switch_vm.sh`. This README provides an overview of the project, installation instructions, usage details, and additional notes. You can adjust the contents according to your specific project details.

---

# VM Control Webhook

## Overview
This project consists of two main components: `webhook.py` and `switch_vm.sh`. The `webhook.py` script is a Flask-based web server that listens for incoming HTTP POST requests to trigger VM control actions. The `switch_vm.sh` is a Bash script that interfaces with `virsh` to manage virtual machines based on commands received from the webhook.

## Installation

### Prerequisites
- A Linux-based system with KVM/QEMU virtualization.
- `virsh` tool for managing VMs.
- Python 3.x with Flask installed.

### Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/vm-control-webhook.git
   cd vm-control-webhook
   ```

2. **Install Python Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Make the Scripts Executable**:
   ```bash
   chmod +x webhook.py switch_vm.sh
   ```

## Usage

### Running the Webhook Server
Run the Flask webhook server using:
```bash
./webhook.py
```
By default, the server listens on port 5006.

### Sending Commands via Webhook
Send a POST request to the webhook with the desired VM name:
```bash
curl -X POST -H "Content-Type: application/json" -d '{"vm_name":"<VM_NAME>"}' http://<SERVER_IP>:5006/webhook
```
Replace `<VM_NAME>` with the name of the VM and `<SERVER_IP>` with the IP address of the server running `webhook.py`.

### VM Switch Script
The `switch_vm.sh` script is triggered by the webhook and handles the starting and stopping of VMs. It checks against predefined lists of VMs that are allowed or disallowed to be shut down.

## Configuration

- Modify the `ALLOWED_TO_SHUTDOWN` and `NOT_TO_SHUTDOWN` arrays in `switch_vm.sh` to specify which VMs can be safely shut down or should remain running.
- Configure Flask settings in `webhook.py` as needed for your environment.

## Contributing
Contributions to this project are welcome! Please fork the repository and submit pull requests with your improvements.


## Contact
For support or queries, contact elhamid.essam@gmail.com.

---

