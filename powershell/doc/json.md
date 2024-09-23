# JSON转化

## 写入文件
```powershell
$jsonData | Out-File -FilePath "output.json" -Encoding UTF8
```

## 读取文件
```powershell
$jsonData = Get-Content -Path "output.json" -Raw | ConvertFrom-Json
```

## 转化哈希表为json对象
```powershell
$envVars = @{
    "name" = "John"
    "age" = 30
    "city" = "New York"
}
$jsonData = $envVars | ConvertTo-Json -Depth 4
```

## 转化json对象为哈希表
```powershell
function ConvertTo-Hashtable {
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
    process {
        if ($null -eq $InputObject) { return $null }
        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            $collection = @(
                foreach ($object in $InputObject) {
                    ConvertTo-Hashtable $object
                }
            )
            Write-Output -NoEnumerate $collection
        } elseif ($InputObject -is [psobject]) {
            $hashTable = @{}
            foreach ($property in $InputObject.PSObject.Properties) {
                $hashTable[$property.Name] = ConvertTo-Hashtable $property.Value
            }
            $hashTable
        } else {
            $InputObject
        }
    }
}

$jsonHashtable = $jsonData | ConvertTo-Hashtable
```

