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

```
* * * * * flock --exclusive --nonblock /var/lock/ssh_80.lock  --command "/usr/bin/ssh {user}@{public IP} -p {public port} -NL 0.0.0.0:80:127.0.0.1:8096" # Emby
* * * * * flock --exclusive --nonblock /var/lock/ssh_139.lock --command "/usr/bin/ssh {user}@{public IP} -p {public port} -NL 0.0.0.0:139:127.0.0.1:139" # SMB
* * * * * flock --exclusive --nonblock /var/lock/ssh_445.lock --command "/usr/bin/ssh {user}@{public IP} -p {public port} -NL 0.0.0.0:445:127.0.0.1:445" # SMB
```


### `sudo nano /etc/fstab`

```
tmpfs   /tmp       tmpfs   defaults,noatime,nosuid            0   0
tmpfs   /var/log   tmpfs   defaults,noatime,nosuid,size=64m   0   0
```
