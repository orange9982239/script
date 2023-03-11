$dataJsonObjecy = (Get-Content "0.data.json" -Raw) | ConvertFrom-Json

$ipList = $dataJsonObjecy.ipList
$User = $dataJsonObjecy.credential.account
$Password = ConvertTo-SecureString -String $dataJsonObjecy.credential.password -AsPlainText -Force
$Credential = [pscredential]::new($User,$Password)

$netAccountsOutputJsonArray = "[]"| ConvertFrom-Json
foreach ($ip in $ipList){
    $invokeCommandJsonObject = Invoke-Command -ComputerName $ip -ScriptBlock {
        cmd /c "secedit /export /cfg C:\security.cfg" | Out-Null
        $PasswordComplexity = (Get-Content C:\security.cfg | Select-String "PasswordComplexity").ToString().replace(' ','').Split("=")[1]
        Remove-Item -Path C:\security.cfg | Out-Null
        
        $netAccounts = cmd /c "chcp 437 > nul & net accounts"

        return "{
            'ip':'$($ip)',
            '強制使用者登出網路時間': '$(($netAccounts | Select-String "Force user logoff how long after time expires?").ToString().replace(' ','').Split(":")[1])',
            '密碼最短使用期': '$(($netAccounts | Select-String "Minimum password age").ToString().replace(' ','').Split(":")[1])',
            '密碼最長使用期限': '$(($netAccounts | Select-String "Maximum password age").ToString().replace(' ','').Split(":")[1])',
            '密碼N代不重複': '$(($netAccounts | Select-String "Length of password history maintained").ToString().replace(' ','').Split(":")[1])',
            '失敗登入嘗試次數': '$(($netAccounts | Select-String "Lockout threshold").ToString().replace(' ','').Split(":")[1])',
            '鎖定持續期間': '$(($netAccounts | Select-String "Lockout duration").ToString().replace(' ','').Split(":")[1])',
            '鎖定觀測視窗': '$(($netAccounts | Select-String "Lockout observation window").ToString().replace(' ','').Split(":")[1])',
            '電腦角色': '$(($netAccounts | Select-String "Computer role").ToString().replace(' ','').Split(":")[1])',
            '啟用密碼複雜度': '$($PasswordComplexity)'
        }"
    } -credential $Credential | ConvertFrom-Json

    
    $netAccountsOutputJsonArray += $invokeCommandJsonObject
    Write-Host "catching data from [$($ip)]"
}

# Write-Host ($netAccountsOutputJsonArray | ConvertTo-Json)

$netAccountsOutputJsonArray |
    ConvertTo-Csv -NoTypeInformation |
    Set-Content "~\Desktop\accountsToCsvOutput_$((Get-Date -Format "yyyy-MM-dd_HHmmss")).csv"