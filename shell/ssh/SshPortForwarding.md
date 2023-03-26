# Local Port Forwarding
## Example
### ssh tunnel rdp to local
```sh
# ssh -NL {to_local_port}:{rdp_ip}:{rdp_port} {user}@{proxy_server_ip}
ssh -NL 13389:192.168.1.1:3389 administrator@192.168.1.1
```
### ssh tunnel mssql to local
```sh
# ssh -NL {to_local_port}:{mssql_ip}:{mssql_port} {user}@{proxy_server_ip}
ssh -NL 1433:192.168.1.1:1433 sysdev@192.168.1.1
```
### ssh tunnel kms to local
```sh
# ssh -NL {to_local_port}:{kms_server_ip}:{kms_server_port} {user}@{proxy_server_ip}
ssh -NL 1688:192.168.1.1:1688 sysdev@192.168.1.1
```
```ps
# add KMS key
slmgr /ipk 00000-00000-00000-00000-00000

# 指定 KMS server 為本機
slmgr -skms localhost

# 啟用 Windows
slmgr -skms localhost

# 查詢啟用狀態
slmgr -dlv
```
# Remote Port Forwarding
## Example
# Dynamic Port Forwarding
## Example
### ssh dynamic socks5
> 配合Chrome的SwitchyOmega外掛
```sh
# ssh -ND {to_local_port} {user}@{proxy_server_ip}
ssh -ND 9090 administrator@192.168.1.1
```

## REF
https://johnliu55.tw/ssh-tunnel.html
