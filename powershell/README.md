# Powershell
> 由於每次都在各種編碼轉換遇到狀況，統一改用UTF-8 with BOM撰寫、儲存。

## 設定檔案secret.json
> 複製powershell\data\templet.json
> 改名secret.json並更改內容

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

## Invoke-Command 傳入參數
```ps
Invoke-Command -ComputerName $ip -credential $Credential -ScriptBlock {
    param($myparam)
    return "{'data':'$($myparam)'}
} -ArgumentList $myparam
```
1. 傳參數$myparam到遠端` -ArgumentList $myparam`
2. ScriptBlock內定義傳入參數`param($myparam)`

## Invoke-Command 取回參數
```ps
$invokeCommandResultJsonObject = Invoke-Command -ComputerName $ip -credential $Credential -ScriptBlock {
    param($myparam)
    return "{'data':'$($myparam)'}
} -ArgumentList $myparam | ConvertFrom-Json
```
> * 因為無法指定回傳物件，因此在遠端就把輸出轉成`JSON STRING`，並且在收回`JSON STRING`時轉為JSON物件` | ConvertFrom-Json`方便後續操作
> * 由於需要精細控制遠端輸出的文字，因此需要活用[不輸出](#不輸出)以免打亂回傳內容。

## 不輸出
> 通常用在`Invoke-Command`遠端收集資料時，隱藏非必要輸出，以利回傳使用

```cmd
dir > nul
```

```ps
dir > $null
dir | Out-Null
```