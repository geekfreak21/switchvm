#!/bin/bash

# VM to start
VM_TO_START="$1"

# Check if the VM to start exists
if ! virsh dominfo "$VM_TO_START" &> /dev/null; then
    echo "Error: VM '$VM_TO_START' not found."
    exit 1
fi

# VMs that are allowed to be shut down (add as many as needed)
ALLOWED_TO_SHUTDOWN=("Linux" "Windows 11v3")  # Replace with the VMs you allow to shut down

# VMs that should not be shut down (add as many as needed)
NOT_TO_SHUTDOWN=("HomeAssistant" "Ubuntu Cluster 1" "Ubuntu Cluster 2" "Ubuntu")

# Function to check if a VM is in the given array
containsElement () {
  local element
  for element in "${@:2}"; do
    [[ "$element" == "$1" ]] && return 0
  done
  return 1
}

# Initialize VM_TO_SHUTDOWN
VM_TO_SHUTDOWN=""

# Find a running VM that is in the ALLOWED_TO_SHUTDOWN array and not VM_TO_START
while IFS= read -r vm; do
    if [[ "$vm" != "$VM_TO_START" ]] && containsElement "$vm" "${ALLOWED_TO_SHUTDOWN[@]}"; then
        VM_TO_SHUTDOWN="$vm"
        echo "$vm"
        break
    fi
done < <(virsh list --state-running --name)

# Check if a VM was found to shut down
if [ -n "$VM_TO_SHUTDOWN" ]; then
    # Shut down the found VM
    virsh shutdown "$VM_TO_SHUTDOWN"
    while virsh list --state-running | grep -q "$VM_TO_SHUTDOWN"; do
        echo "Waiting for $VM_TO_SHUTDOWN to shut down..."
        sleep 5
    done
    echo "$VM_TO_SHUTDOWN is now shut down."
fi

# Start the specified VM if it's not already running and not in the NOT_TO_SHUTDOWN array
if ! containsElement "$VM_TO_START" "${NOT_TO_SHUTDOWN[@]}" && ! virsh list --state-running | grep -q "$VM_TO_START"; then
    virsh start "$VM_TO_START"
    echo "$VM_TO_START is starting."
else
    echo "$VM_TO_START is already running or is a VM not to be shut down."
fi
