# open in GBK, not utf-8
# 环境变量操作脚本

# 添加值到指定环境变量
function Add-EnvValue {
    param (
        [string]$Name,
        [string]$Value
    )
    Backup-EnvValue

    $currentValue = [Environment]::GetEnvironmentVariable($Name, [EnvironmentVariableTarget]::User)
    if ($currentValue) {
        [Environment]::SetEnvironmentVariable($Name, "$currentValue;$Value", [EnvironmentVariableTarget]::User)
    } else {
        [Environment]::SetEnvironmentVariable($Name, $Value, [EnvironmentVariableTarget]::User)
    }
    Write-Host "已添加值到环境变量 $Name"
}

function Sub-EnvValue {
    param (
        [string]$Name,
        [string]$Value
    )
    Backup-EnvValue

    $currentValue = [System.Environment]::GetEnvironmentVariable($Name, [System.EnvironmentVariableTarget]::User)
    if ($currentValue) {
        $values = $currentValue.Split(';')
        $values = $values | Where-Object { $_ -ne $Value }
        $newValue = $values -join ';'
        [System.Environment]::SetEnvironmentVariable($Name, $newValue, [System.EnvironmentVariableTarget]::User)
        Write-Host "已从环境变量 $Name 移除值$Value"
    } else {
        Write-Host "环境变量 $Name 不存在或为空"
    }
}

function Clear-EnvValue {
    param (
        [string]$Name
    )
    Backup-EnvValue

    $currentValue = [System.Environment]::GetEnvironmentVariable($Name, [System.EnvironmentVariableTarget]::User)
    if ($currentValue) {
        [Environment]::SetEnvironmentVariable($Name, "", [EnvironmentVariableTarget]::User)
        Write-Host "环境变量 $Name 已被清空"
    } else {
        Write-Host "环境变量 $Name 不存在"
    }
}

# 列出所有环境变量
function List-EnvironmentVariables {
    $envVars = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    $envVars.GetEnumerator() | Sort-Object Name | ForEach-Object {
        $name = $_.Name
        $values = $_.Value -split ';'
        for ($i = 0;$i -lt $values.Length;$i++) {
            Write-Host ("[{0, 20}][{1, 2}]: {2}" -f $name, ($i + 1), $values[$i])
        }
    }
}

function Show-EnvValue {
    param (
        [string]$Name
    )

    $value = [System.Environment]::GetEnvironmentVariable($Name, [System.EnvironmentVariableTarget]::User)
    if ($value) {
        Write-Host "环境变量 $Name 的值为: "
        $values = $value -split ';'
        for ($i = 0;$i -lt $values.Length;$i++) {
            Write-Host ("[{0, 2}]: {1}" -f ($i + 1), $values[$i])
        }
    } else {
        Write-Host "环境变量 $Name 不存在或为空"
    }
}


# backup
$BACKUP_DIR = "./EnvVarBackup"

function Backup-EnvValue {
    param (
        [string]$BackupType = "AutoBackup_"
    )    
    # 获取当前时间并转换为特定格式的字符串
    $currentDateTime = Get-Date -Format "yyyy_MM_dd_HH_mm_ss"
    # 指定文件名，包含当前时间字符串
    $filename = "$BACKUP_DIR/$BackupType$currentDateTime.json"
    # 获取所有环境变量
    # $envVars = @{
    #     "User" = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    #     "Machine" = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::Machine)
    # }
    $envVars = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    # 将环境变量转换为JSON格式
    $jsonData = $envVars | ConvertTo-Json -Depth 4

    # 检查文件夹是否存在
    if (-not (Test-Path -Path $BACKUP_DIR)) {
        # 文件夹不存在，创建它
        New-Item -ItemType Directory -Path $BACKUP_DIR
    }

    # 将JSON数据写入文件
    $jsonData | Out-File -FilePath $filename -Encoding UTF8
    Write-Host "环境变量已保存到 $filename"
}

function ConvertTo-Hashtable {
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
    process {
        if ($null -eq $InputObject) { return $null }
        if ($InputObject -is [System.Collections.IEnumerable] -and$InputObject -isnot [string]) {
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

function Compare-EnvValue {
    param (
        [string]$BackupType
    ) 
    if ([string]::IsNullOrWhiteSpace($BackupType)) {
        $BackupType = "Manual"
    } 
    # 获取当前目录下所有以"Manual"开头的文件
    $files = Get-ChildItem -Path $BACKUP_DIR -Filter "$BackupType*"
    # 如果找到了文件，则继续操作
    if ($files.Count -gt 0) {
        # 按创建时间降序排列文件，并选择最新的一个
        $latestFile = $files | Sort-Object CreationTime -Descending | Select-Object -First 1
        # 输出最新文件的名称
        Write-Output "最新Backup文件是: $($latestFile.Name)"
    } else {
        # 如果没有找到文件，输出提示信息
        Write-Output "没有找到$BackupType Backup文件。"
        return
    }
    # 定义之前保存的JSON文件路径
    $jsonFilePath = "$BACKUP_DIR/$latestFile"
    if (-not (Test-Path $jsonFilePath)) {
        Write-Host "文件 $jsonFilePath 不存在"
        return
    }
    # 读取JSON文件中的环境变量
    $oldEnvVars = Get-Content -Raw -Path $jsonFilePath | ConvertFrom-Json | ConvertTo-Hashtable
    # 获取当前的环境变量
    # $currentEnvVars = @{
    #     "User" = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    #     "Machine" = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::Machine)
    # }
    $currentEnvVars = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    # 创建一个空的数组来存储差异
    $differences = @()
    # 取出两个哈希表中的所有键，并合并成数组
    $allKeys = $oldEnvVars.Keys + $currentEnvVars.Keys | Sort-Object | Select-Object -Unique

    # 遍历合并后的键数组
    # 对比差异
    foreach ($key in $allKeys) {
        # 如果需要，也可以检查每个键是否存在于哈希表中，并获取其值
        if (-not $currentEnvVars.ContainsKey($key)) {
            $differences += [PSCustomObject]@{
                Variable = $key
                Update = "New Variable"
                Value = $oldEnvVars[$key]
            }
            continue
        } 
        if (-not $oldEnvVars.ContainsKey($key)) {
            $differences += [PSCustomObject]@{
                Variable = $key
                Update = "Delete Variable"
                Value = $currentEnvVars[$key]
            }
            continue
        } 
        $oldValues = $oldEnvVars[$key] -split ';'
        $newValues = $currentEnvVars[$key] -split ';'
        $allValues = $oldValues + $newValues
        # 遍历所有值
        foreach ($value in $allValues) {
            if ( -not $oldValues.Contains($value)) {
                $differences += [PSCustomObject]@{
                    Variable = $key
                    Update = "New Value"
                    Value = $value
                }
            } elseif ( -not $newValues.Contains($value)) {
                $differences += [PSCustomObject]@{
                    Variable = $key
                    Update = "Delete Value"
                    Value = $value
                }
            }
        }
    }
    
    # 输出为表格
    $differences | Format-Table -AutoSize
    # 如果没有差异，输出相应的消息
    if ($differences.Count -eq 0) {
        Write-Host "没有检测到环境变量的差异。"
    }
}

# help
function Show-Help {
    Write-Host "用法: .\env-manage.ps1 <Command> [Name] [Value]"
    Write-Host "Command List:"
    Write-Host "  add     - 添加值到指定环境变量"
    Write-Host "  sub     - 从指定环境变量移除值"
    Write-Host "  show    - 显示指定环境变量的所有值"
    Write-Host "  clear   - 清空指定环境变量的值"
    Write-Host "  list    - 列出所有环境变量"
    Write-Host "  cmp     - 对比backup文件"
    Write-Host "  backup  - 手动存储所有环境变量"
    Write-Host "  restore - 根据文件还原环境变量(not implemented)"
}

function Run {
    # 解析命令行参数
    param (
        [string]$Command,
        [string]$Name,
        [string]$Value
    )
    
    try {
        switch ($Command) {
            "add" { Add-EnvValue -Name $Name -Value $Value }
            "sub" { Sub-EnvValue -Name $Name -Value $Value }
            "show" { Show-EnvValue -Name $Name }
            "clear" { Clear-EnvValue -Name $Name }
            "list" { List-EnvironmentVariables  }
            "cmp" { Compare-EnvValue -BackupType $Name }
            "backup" { Backup-EnvValue -BackupType "ManualBackup_" }
            default { 
                Write-Host "Command: $Command"
                Write-Host "Name: $Name"
                Write-Host "Value: $Value"
                Show-Help 
            }
        }
    } catch {
        Write-Host "发生错误: $_"
        Show-Help
    }
}
Run $args[0] $args[1] $args[2]
