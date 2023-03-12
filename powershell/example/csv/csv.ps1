# 建立JSON Array
$jsonArray = @"
[
    {
        "Name": "Darts",
        "Type": "Fun Stuff"
    },

    {
        "Name": "Clean Toilet",
        "Type": "Boring Stuff"
    }
]
"@ | ConvertFrom-Json

# 建立JSON Array轉存csv
$jsonArray |
    ConvertTo-Csv -NoTypeInformation |
    Set-Content "~\Desktop\testCsvOutput_$(Get-Date -Format "yyyy-MM-dd_HHmmss").csv"