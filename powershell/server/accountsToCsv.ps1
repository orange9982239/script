$dataJsonObjecy = (Get-Content "0.data.json" -Raw) | ConvertFrom-Json

$ipList = $dataJsonObjecy.ipList
$User = $dataJsonObjecy.credential.account
$Password = ConvertTo-SecureString -String $dataJsonObjecy.credential.password -AsPlainText -Force
$Credential = [pscredential]::new($User,$Password)

$netAccountsOutputJsonArray = "[]"| ConvertFrom-Json
foreach ($ip in $ipList){
    $netAccountsOutput = Invoke-Command -ComputerName $ip -ScriptBlock {
        cmd /c "secedit /export /cfg C:\security.cfg" | Out-Null
        cmd /c "chcp 437 > nul & net accounts"
        (Get-Content C:\security.cfg | Select-String "PasswordComplexity").ToString()
        Remove-Item -Path C:\security.cfg
    } -credential $Credential

    $netAccountsOutputJsonObject = "{
        'ip':'$($ip)',
        'Force user logoff how long after time expires?': '$(($netAccountsOutput | Select-String "Force user logoff how long after time expires?").ToString().replace(' ','').Split(":")[1])',
        'Minimum password age (days)': '$(($netAccountsOutput | Select-String "Minimum password age").ToString().replace(' ','').Split(":")[1])',
        'Maximum password age (days)': '$(($netAccountsOutput | Select-String "Maximum password age").ToString().replace(' ','').Split(":")[1])',
        'Length of password history maintained': '$(($netAccountsOutput | Select-String "Length of password history maintained").ToString().replace(' ','').Split(":")[1])',
        'Lockout threshold': '$(($netAccountsOutput | Select-String "Lockout threshold").ToString().replace(' ','').Split(":")[1])',
        'Lockout duration (minutes)': '$(($netAccountsOutput | Select-String "Lockout duration").ToString().replace(' ','').Split(":")[1])',
        'Lockout observation window (minutes)': '$(($netAccountsOutput | Select-String "Lockout observation window").ToString().replace(' ','').Split(":")[1])',
        'Computer role': '$(($netAccountsOutput | Select-String "Computer role").ToString().replace(' ','').Split(":")[1])',
        'PasswordComplexity': '$(($netAccountsOutput | Select-String "PasswordComplexity").ToString().replace(' ','').Split("=")[1])'
    }" | ConvertFrom-Json
    
    $netAccountsOutputJsonArray += $netAccountsOutputJsonObject
    Write-Host "catching data from [$($ip)]"
}

# Write-Host ($netAccountsOutputJsonArray | ConvertTo-Json)

$netAccountsOutputJsonArray |
    ConvertTo-Csv -NoTypeInformation |
    Set-Content "~\Desktop\accountsToCsvOutput_$((Get-Date -Format "yyyy-MM-dd_HHmmss")).csv"