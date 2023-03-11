# Powershell
> 由於每次都在各種編碼轉換遇到狀況，統一改用UTF8撰寫、儲存。

## 控制端(GATE)設定
1. 信任任何Host
    > 因為登入過程會傳送credential，因此有此保護，但通常在內網中操作
    ```PS
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*'
    ```

## 被控端(SERVER)設定
1. 不過期的管理密碼(否則管理會很困難)
2. 啟動
   1. WinRM
    ```PS
        Enable-PSRemoting -Force
    ```
   2. RemoteSigned
    ```PS
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
    ```

## 強制utf8編碼
### 臨時改法
```cmd
chcp 65001
```
```ps
[console]::InputEncoding = [console]::OutputEncoding = [Text.UTF8Encoding]::UTF8
```