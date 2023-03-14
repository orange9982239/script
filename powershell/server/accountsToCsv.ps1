# 讀取JSON設定檔案，用於遠端登入收集資料，自行複製\data\templet.json改成\data\secret.json
$dataJsonObject = Get-Content (Convert-Path "$($PSScriptRoot)\..\data\secret.json") -Raw | ConvertFrom-Json

$ipList = $dataJsonObject.ipList
$User = $dataJsonObject.credential.account
$Password = ConvertTo-SecureString -String $dataJsonObject.credential.password -AsPlainText -Force
$Credential = [pscredential]::new($User,$Password)

# 定義空JSON ARRAY用來接收資料
$netAccountsOutputJsonArray = "[]"| ConvertFrom-Json

foreach ($ip in $ipList){
    # 遠端操作並透過-ArgumentList傳入$ip
    $invokeCommandJsonObject = Invoke-Command -ComputerName $ip -credential $Credential -ScriptBlock {
        param($ip)
        # 收集PasswordComplexity參數
        cmd /c "secedit /export /cfg C:\security.cfg" | Out-Null
        $PasswordComplexity = (Get-Content C:\security.cfg | Select-String "PasswordComplexity").ToString().replace(' ','').Split("=")[1]
        Remove-Item -Path C:\security.cfg | Out-Null
        
        # 收集密碼元則參數
        $netAccounts = cmd /c "chcp 437 > nul & net accounts"

        return "{
            'ip':'$($ip)',
            'Force user logoff how long after time expires?': '$(($netAccounts | Select-String "Force user logoff how long after time expires?").ToString().replace(' ','').Split(":")[1])',
            'Minimum password age': '$(($netAccounts | Select-String "Minimum password age").ToString().replace(' ','').Split(":")[1])',
            'Maximum password age': '$(($netAccounts | Select-String "Maximum password age").ToString().replace(' ','').Split(":")[1])',
            'Length of password history maintained': '$(($netAccounts | Select-String "Length of password history maintained").ToString().replace(' ','').Split(":")[1])',
            'Lockout threshold': '$(($netAccounts | Select-String "Lockout threshold").ToString().replace(' ','').Split(":")[1])',
            'Lockout duration': '$(($netAccounts | Select-String "Lockout duration").ToString().replace(' ','').Split(":")[1])',
            'Lockout observation window': '$(($netAccounts | Select-String "Lockout observation window").ToString().replace(' ','').Split(":")[1])',
            'Computer role': '$(($netAccounts | Select-String "Computer role").ToString().replace(' ','').Split(":")[1])',
            'PasswordComplexity': '$($PasswordComplexity)',
            'RemoteTime': '$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")'
        }"
    } -ArgumentList $ip | ConvertFrom-Json
    
    # JSON OBJECT加入參數 控制電腦時間
    Add-Member -InputObject $invokeCommandJsonObject -MemberType NoteProperty -Name "LocalTime" -Value $(Get-Date -Format "yyyy/MM/dd HH:mm:ss")

    # 收集到的JSON OBJECT加入JSON ARRAY中
    $netAccountsOutputJsonArray += $invokeCommandJsonObject
    
    # JSON OBJECT收集成果印在console用來debug
    Write-Host "catching data from [$($ip)]"
    Write-Host ($invokeCommandJsonObject | ConvertTo-Json)
}
# 全部資料 JSON ARRAY 印在console用來debug
# Write-Host ($netAccountsOutputJsonArray | ConvertTo-Json)

# JSON ARRAY轉成csv檔案，預設存在桌面，~代表Home目錄
$netAccountsOutputJsonArray |
    ConvertTo-Csv -NoTypeInformation |
    Set-Content "~\Desktop\accountsToCsvOutput_$(Get-Date -Format "yyyy-MM-dd_HHmmss").csv"