# powshell 基础语法

### 变量
- 变量以 `$` 开头，后跟变量名。例如：`$myVariable = "Hello, World!"`

### 注释
- 单行注释以 `#` 开头。

### 命令别名
- 使用 `Set-Alias` 命令创建别名。
```powershell
Set-Alias -Name lh -Value Get-ChildItem
```

### 执行命令
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
### 管道
- 使用 `|` 将一个命令的输出传递给另一个命令。
```powershell
Get-ChildItem | Where-Object { $_.Name -like "*.txt" }
```

### 对象属性和方法
- 使用点操作符访问对象的属性和方法。
```powershell
$myVariable.Length
```

### 条件语句
- `if`、`else` 和 `elseif` 用于条件判断。
```powershell
if ($condition) {
    # 条件为真时执行的代码
} elseif ($otherCondition) {
    # 其他条件为真时执行的代码
} else {
    # 以上条件都不为真时执行的代码
}
```
### 循环
- `for`、`foreach`、`while` 和 `do-while` 用于循环。
```powershell
foreach ($item in $collection) {
    # 对集合中的每个项目执行的代码
}
```

### 函数
- 使用 `function` 关键字定义函数。
```powershell
function Get-Greeting {
    param($name)
    "Hello, $name"
}
```

### 脚本块
- 使用 `{}` 创建脚本块。
```powershell
& { Get-Date; Get-ChildItem }
```

### 特殊变量
- `$PSScriptRoot`：当前脚本所在的目录路径。
- `$PSCommandPath`：当前脚本的完整路径。
- `$PSVersionTable`：包含 PowerShell 版本信息的哈希表。

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