wmic product get InstallDate,Name,Vendor,Version /format:csv `
    | ConvertFrom-Csv `
    | ConvertTo-Json

# wmic product get InstallDate,Name,Vendor,Version /format:csv `
#     | ConvertFrom-Csv `
#     | Where-Object {$_.Vendor -ne "Microsoft Corporation" } `     # 過濾
#     | ConvertTo-Json