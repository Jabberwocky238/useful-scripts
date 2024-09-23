# Environment环境变量
```powershell
[EnvironmentVariableTarget]::User
[EnvironmentVariableTarget]::Machine
[EnvironmentVariableTarget]::Process
```

## 方法
```powershell
$expandedEnvVar = [Environment]::ExpandEnvironmentVariables("%SystemRoot%")
$commandLineArgs = [Environment]::GetCommandLineArgs()
$envVarValue = [Environment]::GetEnvironmentVariable("环境变量名称")
$envVarValueUser = [Environment]::GetEnvironmentVariable("环境变量名称", "User")
[Environment]::SetEnvironmentVariable("新环境变量名称", "值")
[Environment]::SetEnvironmentVariable("新环境变量名称", "值", "User")
[Environment]::FailFast("错误消息")
$logicalDrives = [Environment]::GetLogicalDrives()
```

## 属性
```powershell
$currentDirectory = [Environment]::CurrentDirectory
$exitCode = [Environment]::ExitCode
$hasShutdownStarted = [Environment]::HasShutdownStarted
$machineName = [Environment]::MachineName
$newLine = [Environment]::NewLine
$osVersion = [Environment]::OSVersion
$stackTrace = [Environment]::StackTrace
$systemDirectory = [Environment]::SystemDirectory
$tickCount = [Environment]::TickCount
$userDomainName = [Environment]::UserDomainName
$userName = [Environment]::UserName
$version = [Environment]::Version
$workingSet = [Environment]::WorkingSet
```
