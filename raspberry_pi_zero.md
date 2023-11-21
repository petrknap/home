# Raspberry Pi Zero

Used as tunneling device to HTPC



## Prepare OS

* Download [Raspbian Lite](https://www.raspberrypi.org/downloads/raspbian/)
* Download [Etcher](https://etcher.io/)
* Flash OS to SD card
* Mount flashed SD card back to host OS


### `nano {SD card}/boot/wpa_supplicant.conf`

```
country=cz
update_config=1
ctrl_interface=/var/run/wpa_supplicant

network={
 ssid="{visible Wi-Fi name}"
 psk="{visible Wi-Fi password}"
}

network={
 ssid="{alternative Wi-Fi name}"
 psk="{alternative Wi-Fi password}"
}

network={
 scan_ssid=1
 ssid="{hidden Wi-Fi name}"
 psk="{hidden Wi-Fi password}"
}
```


### `touch {SD card}/boot/ssh`



## Set it up

* Insert flashed SD card to Raspberry
* Turn on Raspberry
* Wait while LED is flashing


### `sudo nmap -sP {host's IP address}/24`


### `ssh pi@{Raspberry's IP address}`

Password: `raspberry`


### `sudo raspi-config`

```
> Change User Password
```

```
> Interfacing Options
> SSH
Would you like the SSH server to be enabled? <Yes>
```


### `sudo crontab -e`

Add these lines:

```
* * * * * flock --exclusive --nonblock /var/lock/ssh_r_{remote port}_22.lock --command "/usr/bin/ssh -o ServerAliveInterval=60 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -R 127.0.0.1:{remote port}:127.0.0.1:22 -p {public port} {user}@{public IP} -N" # reverse SSH (ignores certificate changes)
* * * * * flock --exclusive --nonblock /var/lock/ssh_l_80_80.lock --command "/usr/bin/ssh -o ServerAliveInterval=60 -L 0.0.0.0:80:127.0.0.1:80 -p {public port} {user}@{public IP} -N" # HTTP
* * * * * flock --exclusive --nonblock /var/lock/ssh_l_443_443.lock --command "/usr/bin/ssh -o ServerAliveInterval=60 -L 0.0.0.0:443:127.0.0.1:443 -p {public port} {user}@{public IP} -N" # HTTPS
* * * * * flock --exclusive --nonblock /var/lock/ssh_l_445_445.lock --command "/usr/bin/ssh -o ServerAliveInterval=60 -L 0.0.0.0:445:127.0.0.1:445 -p {public port} {user}@{public IP} -N" # SMB
* * * * * flock --exclusive --nonblock /var/lock/ssh_l_8096_8096.lock --command "/usr/bin/ssh -o ServerAliveInterval=60 -L 0.0.0.0:8096:127.0.0.1:8096 -p {public port} {user}@{public IP} -N" # Emby (HTTP)
* * * * * flock --exclusive --nonblock /var/lock/ssdp_emby.lock --command "/home/pi/emby.bash {Embys UUID} 8096 2>&1 > /home/pi/emby.log" # Emby (SSDP)
* * * * * flock --exclusive --nonblock /var/lock/socat_l_53_udp4.lock --command "while true; do (socat -T15 udp4-recvfrom:53,reuseaddr,fork udp:{primary public IP}:{primary public port} & PID=\"\${!}\"; sleep 5; while timeout 5 dig dns-check.petrknap.cz @127.0.0.1; do (sleep 60); done; kill \"\${PID}\"; timeout 600 socat -T15 udp4-recvfrom:53,reuseaddr,fork udp:{secondary public IP}:{secondary public port}); done" # DNS
* * * * * flock --exclusive --nonblock /var/lock/socat_l_53_tcp4.lock --command "socat -T15 tcp4-listen:53,reuseaddr,fork tcp:{primary public IP}:{primary public port}" # DNS
```

Emby **requires `node` and [`ssdp-faker`](https://github.com/petrknap/ssdp-faker)**.
DNS **requires `socat` and `dnsutils`** packages and IPs can't be domain names (only for DNS).


### `nano /home/pi/emby.bash`

```bash
#!/usr/bin/env bash
set -e
set -x
DIR=`realpath "${BASH_SOURCE%/*}"`

UUID="${1}"
SOCKET="$(hostname -I | cut -d ' ' -f 1):${2}"

sudo -u nobody \
node "${DIR}/ssdp-faker/ssdp-faker.js" run-server \
        http://${SOCKET}/dlna/${UUID}/description.xml \
        uuid:${UUID}::urn:schemas-upnp-org:device:MediaServer:1
```


### `sudo nano /etc/fstab`

Add these lines:

```
tmpfs   /tmp       tmpfs   defaults,noatime,nosuid            0   0
tmpfs   /var/cache tmpfs   defaults,noatime,nosuid            0   0
tmpfs   /var/log   tmpfs   defaults,noatime,nosuid,size=64m   0   0
```



## Set up remote backup


### Make encrypted backup device

1. `lsblk` to find device
1. `sudo apt install cryptsetup`
1. `sudo modprobe dm-crypt sha256 aes` or `sudo reboot`
1. `sudo cryptsetup --verify-passphrase luksFormat /dev/{device} -c aes -s 256 -h sha256` and use passphrase
1. `sudo cryptsetup luksOpen /dev/{device} backup`
1. `sudo mkfs -t ext4 -m 1 /dev/mapper/backup`
1. `sudo mkdir /media/backup`
1. `sudo mount /dev/mapper/backup /media/backup/`
1. `sudo chown pi:pi /media/backup/`
1. create key file `{path to key file}`
1. `sudo cryptsetup luksAddKey /dev/{device} {path to key file}`
1. `sudo nano /etc/crypttab` and insert `backup /dev/{device} {path to key file} luks`
1. `sudo nano /etc/fstab` and insert `/dev/mapper/backup /media/backup ext4 defaults,rw 0 0`


### Create `/home/pi/remote_backup`

```bash
#!/usr/bin/env bash
set -e

BACKUP="$1"
shift 1

if [[ ! -e "/home/pi/.home" ]]; then (
    git clone "https://github.com/petrknap/home.git" "/home/pi/.home"
); fi

(
cd "/home/pi/.home"
(
flock -e 200
git reset --hard
git pull
) 200>/var/lock/remote_backup.lock

#region local
if [[ "${BACKUP}" == "local" ]]; then (

if [[ ! -e "/media/backup/local" ]]; then
    mkdir "/media/backup/local"
fi

./bin/remote_backup "/home/pi" 22 "/media/backup/local" "
.home
.cache
.config
" "" "${BACKUP}"
); fi
#endregion

#region server
if [[ "${BACKUP}" == "server" ]]; then (

if [[ ! -e "/media/backup/server" ]]; then
    mkdir "/media/backup/server"
fi

./bin/remote_backup "{user}@{public IP}:/home/" {public port} "/media/backup/server" "
*.img
*/.keep
user/.cache
user/.config
" "--bwlimit=200 --size-only" "${BACKUP}"
); fi
#endregion

#region hosting
if [[ "${BACKUP}" == "hosting" ]]; then (

if [[ ! -e "/media/backup/hosting" ]]; then
    mkdir "/media/backup/hosting"
fi

if [[ ! -e "/media/backup/ftp/hosting" ]]; then
    mkdir -p "/media/backup/ftp/hosting"
fi

./bin/wget_mirror "ftp://{public IP}:{public port}/{folder}" "/media/backup/ftp" {user} {password}
./bin/remote_backup "/media/backup/ftp/hosting" 22 "/media/backup/hosting" "
*/.listing
" "" "${BACKUP}"
); fi
#endregion
)
```


### `crontab -e`

Add this line:

```
0 12 * * * flock --exclusive --nonblock /var/lock/remote_backup-local.lock --command "/home/pi/remote_backup local"
0 12 * * * flock --exclusive --nonblock /var/lock/remote_backup-server.lock --command "/home/pi/remote_backup server"
0 12 * * * flock --exclusive --nonblock /var/lock/remote_backup-hosting.lock --command "/home/pi/remote_backup hosting"
```
