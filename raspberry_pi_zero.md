# Raspberry Pi Zero

Used as tunneling device to HTPC


## `nano boot/wpa_supplicant.conf`

```
country=cz
update_config=1
ctrl_interface=/var/run/wpa_supplicant

network={
 scan_ssid=1
 ssid="{Wi-Fi name}"
 psk="{Wi-Fi password}"
}
```


## `touch boot/ssh`


## `sudo nmap -sP {local IP address}/24`


## `ssh pi@{Raspberry IP address}`

Password: `raspberry`


## `sudo raspi-config`

```
> Change User Password
```

```
> Interfacing Options
> SSH
Would you like the SSH server to be enabled? <Yes>
```


## `crontab -e`

```
*/5 * * * * flock --exclusive --nonblock /var/lock/htpc_ssh_80.lock --command "/usr/bin/ssh {user}@{public IP} -p 36278 -NL 80:127.0.0.1:8096"
*/5 * * * * flock --exclusive --nonblock /var/lock/htpc_ssh_139.lock --command "/usr/bin/ssh {user}@{public IP} -p 36278 -NL 139:127.0.0.1:139"
```
