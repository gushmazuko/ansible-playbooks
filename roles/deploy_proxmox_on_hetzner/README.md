# Deploy Proxmox on Hetzner
This role deploys Proxmox on a Hetzner server via the rescue system.

## How to
```bash
ansible-playbook ./deploy_proxmox_on_hetzner.yml \
-e working_host=rescue_ip_address \
-e ansible_ssh_port=22
```

Hint: use a public key for the rescue system! (or deal with -k however this is not supported)

Variables description:
- `working_host`: Proxmox host IP
- `vnc_password`: VNC password
- `proxmox_password`: Proxmox root user password
- `proxmox_pause_for_manual_intervention`: Pause the playbook for manual intervention
- `vm_memory`: VM memory in MB

Default variables are declared in `./defaults/main.yml`

## Troubleshooting
If you can't connect to the proxmox web interface, try to regenate the certificates:
```bash
rm -f /etc/pve/pve-root-ca.pem /etc/pve/priv/pve-root-ca.* /etc/pve/local/pve-ssl.*;
pvecm updatecerts -f;
```


## Manual Boot Installed Proxmox

### Start QEMU on physical disks
qemu-system-x86_64 -daemonize -enable-kvm -m 10240 \
        -hda /dev/$VM_DISK1 \
        -hdb /dev/$VM_DISK2 \
        -vnc :0,password=on -monitor telnet:127.0.0.1:4444,server,nowait \
        -net user,hostfwd=tcp::2222-:22 -net nic

## Set VNC Password
echo "change vnc password $MySecurePassword" | nc -q 1 127.0.0.1 4444


### Access the VM (Proxmox)
Connect to the VM (Proxmox) via:
- VNC at $RESCUE_IP_ADDRESS:5900 using the password $MySecurePassword
- SSH at `root@$RESCUE_IP_ADDRESS -p 2222` using the password $YourRealProxmoxPassword