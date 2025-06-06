Cloud-Init Rocky Linux VM Template on Proxmox
========
Create a Cloud-Init VM Template with the latest `Rocky Linux` on Proxmox VE host.

Tasks
-----
- Download latest Rocky Cloud image
- Add `public_ssh_key` to Cloud-Init
- Create VM
- Import image to VM
- Convert a VM to a template 


How to
------
```bash
ansible-playbook ./create_rocky_vm_tpl_on_proxmox.yml \
-e working_host=proxmox.example.com \
-e ansible_ssh_port=22 \
-e storage=local-zfs \
-e vm_id=1234 \
-e network_bridge=vmbr0 \
-e release_name=bullseye \
-e public_ssh_key="'ssh-ed25519 AAAA...'"
-e release_number=8
```

Variables description:
- `working_host`: Proxmox host IP
- `ansible_ssh_port`: Proxmox SSH port
- `storage`: Proxmox Storage name, execute `pvesm status` to display your storages
- `public_ssh_key`: Your SSH public key string

Default variables are declared in `./defaults/main.yml`

These and all other variables can be define in the file `create_rocky_vm_tpl_on_proxmox.yml`