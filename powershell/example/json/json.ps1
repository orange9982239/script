$objectList = @"
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

# get value
Write-Output("objectList[0]   =>  " + $objectList[0])
Write-Output("objectList[1].Name   =>  " + $objectList[1].Name)

# # loop
# foreach ($object in $objectList)
# {
#     Write-Output("Name   =>  " + $object.Name) 
#     Write-Output("Type   =>  " + $object.Type)
# }