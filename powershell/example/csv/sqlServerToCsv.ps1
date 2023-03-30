$outputPath = "$([Environment]::GetFolderPath("Desktop"))\test.csv"

Invoke-Sqlcmd `
    -Query @"
        SELECT
            *
        FROM 
            USER
"@ `
    -ServerInstance "." `
| Export-Csv  `
    -Path $($outputPath)  `
    -NoTypeInformation `
    -encoding utf8

# 如果不想要讓csv有雙引號
# Get-Content $($outputPath) `
# | % {$_ -replace '"'} `
# | out-file `
#     -FilePath $($outputPath) `
#     -encoding utf8