# Powershell 基础语法
- 单行注释以 `#` 开头。

- 变量以 `$` 开头，后跟变量名。例如：`$myVariable = "Hello, World!"`
- `$PSScriptRoot`：当前脚本所在的目录路径。
- `$PSCommandPath`：当前脚本的完整路径。
- `$PSVersionTable`：包含 PowerShell 版本信息的哈希表。
- `$PSCmdlet`: 是一个在自定义 cmdlet（即通过 CmdletBinding 特性定义的函数）中使用的自动化变量。它提供了对当前运行的 cmdlet 的引用，使你能够访问和操作当前 cmdlet 的上下文和属性。
- `@{}`：创建哈希表。
- `@()`：创建数组。

### 基本命令
- 使用 `Get-Command` 命令列出可用的命令。
```powershell
Get-Command
```

- 使用 `Set-Alias` 命令创建别名。
```powershell
Set-Alias -Name lh -Value Get-ChildItem
```

- 执行命令时，通常不需要引号，除非字符串中包含空格或其他特殊字符。
```powershell
# 列出当前目录的所有文件和文件夹
Get-ChildItem
# 列出特定目录的所有文件和文件夹
Get-ChildItem -Path C:\Users\Public\Documents
# 列出特定目录下所有的文本文件
Get-ChildItem -Path C:\Users\Public\Documents -Filter "*.txt"
# 递归列出目录及其子目录中的所有文件
Get-ChildItem -Path C:\Users\Public\Documents -Recurse -File
# 排除项
Get-ChildItem -Path C:\Windows\System32 -Exclude "*.dll"
# 文件类型
Get-ChildItem -Path C:\Windows\System32 -File
Get-ChildItem -Path C:\Windows\System32 -Directory
# 格式化输出
Get-ChildItem -Path C:\Windows\System32 | Format-Table
Get-ChildItem -Path C:\Windows\System32 | Format-List
```

- 使用 `{}` 创建脚本块。
```powershell
& { Get-Date; Get-ChildItem }
```

- 使用 `|` 将一个命令的输出传递给另一个命令。
```powershell
Get-ChildItem | Where-Object { $_.Name -like "*.txt" }
```

- 使用点操作符访问对象的属性和方法。
```powershell
$myVariable.Length
```

### 条件语句
- `if`、`else` 和 `elseif` 用于条件判断。
```powershell
if ($condition -and $null -eq $InputObject) {
    # 条件为真时执行的代码
} elseif ($otherCondition -or $InputObject -isnot [string]) {
    # 其他条件为真时执行的代码
} else {
    # 以上条件都不为真时执行的代码
}
# -is -isnot -contains -notcontains -like -notlike -eq -ne -gt -ge -lt -le
for ($i = 0;$i -lt $values.Length;$i++) {
    Write-Host ("[{0, 2}]: {1}" -f ($i + 1), $values[$i])
}
```
### 循环
- `for`、`foreach`、`while` 和 `do-while` 用于循环。
```powershell
foreach ($item in $collection) {
    # 对集合中的每个项目执行的代码
}
foreach ($property in $InputObject.PSObject.Properties) {
    $hashTable[$property.Name] = ConvertTo-Hashtable $property.Value
}
# 另一种循环
$envVars.GetEnumerator() | Sort-Object Name | ForEach-Object {
    $name = $_.Name
    $values = $_.Value -split ';'
    for ($i = 0;$i -lt $values.Length;$i++) {
        Write-Host ("[{0, 20}][{1, 2}]: {2}" -f $name, ($i + 1), $values[$i])
    }
}
```

### 函数
- 使用 `function` 关键字定义函数。
```powershell
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
    return $currentValue
}
```

### 错误处理
- 使用 `try`、`catch`、`finally` 和 `throw` 进行错误处理。
```powershell
try {
# 尝试执行的代码
} catch {
# 发生错误时执行的代码
} finally {
# 无论是否发生错误都会执行的代码
}
```