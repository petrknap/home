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
* * * * * flock --exclusive --nonblock /var/lock/ssh_r_{remote port}_22.lock --command "/usr/bin/ssh -o ServerAliveInterval=60 -R 127.0.0.1:{remote port}:127.0.0.1:22 -p {public port} {user}@{public IP} -N" # reverse SSH
* * * * * flock --exclusive --nonblock /var/lock/ssh_l_8096_80.lock --command "/usr/bin/ssh -o ServerAliveInterval=60 -L 0.0.0.0:80:127.0.0.1:8096 -p {public port} {user}@{public IP} -N" # Emby
* * * * * flock --exclusive --nonblock /var/lock/ssh_l_8920_443.lock --command "/usr/bin/ssh -o ServerAliveInterval=60 -L 0.0.0.0:443:127.0.0.1:8920 -p {public port} {user}@{public IP} -N" # Emby
* * * * * flock --exclusive --nonblock /var/lock/ssh_l_445_445.lock --command "/usr/bin/ssh -o ServerAliveInterval=60 -L 0.0.0.0:445:127.0.0.1:445 -p {public port} {user}@{public IP} -N" # SMB
```


### `sudo nano /etc/fstab`

Add these lines:

```
tmpfs   /tmp       tmpfs   defaults,noatime,nosuid            0   0
tmpfs   /var/log   tmpfs   defaults,noatime,nosuid,size=64m   0   0
```
