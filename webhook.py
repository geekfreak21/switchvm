from flask import Flask, request
import subprocess

app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def webhook():
    if request.method == 'POST':
        # Parse JSON data from the request
        data = request.json
        vm_name = data.get('vm_name')
        print(vm_name)

        # Call your bash script here with the VM name
        subprocess.call(['./mnt/user/webhooks/switch_vm.sh', vm_name])

        return 'Webhook received', 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5006)
