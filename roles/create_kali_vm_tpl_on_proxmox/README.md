Cloud-Init Kali Linux VM Template on Proxmox
=========
Create a VM Template with the latest `Kali Linux` on Proxmox VE host.  
Install [Cloud-Init](https://www.kali.org/docs/cloud/digitalocean#install-required-packages) and enable [Serial Terminal](https://pve.proxmox.com/wiki/Serial_Terminal)

Tasks
-----
- Download latest Kali Linux VM image
- Chroot image
    - Install Cloud-Init
    - Disable `lock_passwd`
    - Enable `Serial Terminal (`ttyS0`)
    - Enable SSH Service
- Add `public_ssh_key` to Cloud-Init
- Create VM
- Import image to VM
- Convert a VM to a template 

How to
------
```bash
ansible-playbook ./create_kali_vm_tpl_on_proxmox.yml \
-e working_host=proxmox.example.com \
-e ansible_ssh_port=22 \
-e storage=local-zfs \
-e vm_id=1234 \
-e network_bridge-vmbr0 \
-e public_ssh_key="'ssh-ed25519 AAAA...'"
```

Variables description:
- `working_host`: Proxmox host IP
- `ansible_ssh_port`: Proxmox SSH port
- `storage`: Proxmox Storage name, execute `pvesm status` to display your storages
- `public_ssh_key`: Your SSH public key string

Default variables are declared in `./defaults/main.yml`

These and all other variables can be define in the file `create_kali_vm_tpl_on_proxmox.yml`

Tips
----
If you don't need Cloud-Init in Kali Linux, just skip this step:

```bash
ansible-playbook ./create_kali_vm_tpl_on_proxmox.yml \
... \
--skip-tags="cloud-init"
```