$dataJsonObject = Get-Content (Convert-Path "$($PSScriptRoot)\..\..\data\secret.json") -Raw | ConvertFrom-Json
$lanTimeServer = "192.168.1.1"
$jobName = "timeSync"
$scriptText = "net time \\$($lanTimeServer) /set /y"

# 建立script
$scriptFileaPath = "C:\job\$($jobName).bat" 
New-Item $($scriptFileaPath) -Force
Set-Content $($scriptFileaPath) $($scriptText)

# 執行頻率
$trigger = New-ScheduledTaskTrigger `
    -Daily -At 00:00
$supportTrigger = New-ScheduledTaskTrigger `
    -Once -At 00:00 `
    -RepetitionInterval (New-TimeSpan -Minutes 5) `
    -RepetitionDuration (New-TimeSpan -Days 1)
$trigger.Repetition = $supportTrigger.Repetition

# 執行指令
$action = New-ScheduledTaskAction -Execute $($scriptFileaPath)

Register-ScheduledTask `
    -Action $($action) `
    -Trigger $($trigger) `
    -TaskName $($jobName) `
    -RunLevel Highest `
    -User $($dataJsonObject.credential.account) `
    -Password $($dataJsonObject.credential.password)