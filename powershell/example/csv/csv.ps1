# 建立JSON Array
$jsonArray = @"
[
    {
        "Name": "中文喔喔喔",
        "Type": "Fun Stuff"
    },

    {
        "Name": "Clean Toilet",
        "Type": "Boring Stuff"
    }
]
"@ | ConvertFrom-Json

# 建立JSON Array轉存csv
$jsonArray `
    | ConvertTo-Csv -NoTypeInformation `
    | Set-Content "~\Desktop\testCsvOutput_$(Get-Date -Format "yyyy-MM-dd_HHmmss").csv"  `
        -Encoding utf8