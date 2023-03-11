$dataJsonObject = (Get-Content "0.data.json" -Raw) | ConvertFrom-Json

$ipList = $dataJsonObject.ipList
$User = $dataJsonObject.credential.account
$Password = ConvertTo-SecureString -String $dataJsonObject.credential.password -AsPlainText -Force
$Credential = [pscredential]::new($User,$Password)

$getDateOutputJsonArray = "[]"| ConvertFrom-Json
foreach ($ip in $ipList){
    $getRemoteDateOutput = Invoke-Command -ComputerName $ip -ScriptBlock { 
        Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    } -credential $Credential
    
    $getLocalDateOutput = Get-Date -Format "yyyy/MM/dd HH:mm:ss"

    $getDateOutputJsonObject = "{
        'ip':'$($ip)',
        'remoteDate': '$($getRemoteDateOutput)',
        'localDate': '$($getLocalDateOutput)'
    }" | ConvertFrom-Json
    
    $getDateOutputJsonArray += $getDateOutputJsonObject
    Write-Host "catching data from [$($ip)]"
}

# Write-Host ($getDateOutputJsonArray | ConvertTo-Json)

$getDateOutputJsonArray |
    ConvertTo-Csv -NoTypeInformation |
    Set-Content "~\Desktop\dateToCsv_$((Get-Date -Format "yyyy-MM-dd_HHmmss")).csv"