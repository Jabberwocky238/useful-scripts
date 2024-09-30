# Add-EnvValue
# Sub-EnvValue
# Clear-EnvValue
# List-EnvValues

# Backup-EnvValue
# Compare-EnvValue
# Restore-EnvValue

# Show-Help

param (
    [string]$Command = $args[0],
    [string]$Name,
    [string]$Value,
    [string]$With = $args[1],
    [bool]$Json = $false
)

function Write-Debug {
    param (
        [string]$Info,
        [bool]$IsData = $false
    )
    if ( -not $Json -and -not $IsData ) {
        Write-Host $Info
    } elseif ( $Json -and -not $IsData ) {
        
    } elseif ( $Json -and $IsData ) {
        Write-Host ($Info | ConvertTo-Json -Depth 4)
    } else {
        Write-Host $Info
    }
}

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
    Write-Host "Successful add $Name"
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
        Write-Host "Successful sub $Name $Value"
    } else {
        Write-Host "No Variable Named $Name "
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
        Write-Host "Successful set $Name"
    } else {
        Write-Host "No Variable Named $Name"
    }
}

function List-EnvValues {
    param (
        [string]$Info,
        [string]$Json = $false
    )
    $envVars = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    $envVars.GetEnumerator() | Sort-Object Name | ForEach-Object {
        $name = $_.Name
        $values = $_.Value -split ';'
        for ($i = 0;$i -lt $values.Length;$i++) {
            Write-Debug ("[{0, 20}][{1, 2}]: {2}" -f $name, ($i + 1), $values[$i]) -IsData $true
        }
    }
}

function Show-EnvValue {
    param (
        [string]$Name
    )
    $value = [System.Environment]::GetEnvironmentVariable($Name, [System.EnvironmentVariableTarget]::User)
    if ($value) {
        Write-Debug "Successful show $Name"
        $values = $value -split ';'
        for ($i = 0;$i -lt $values.Length;$i++) {
            Write-Debug ("[{0, 2}]: {1}" -f ($i + 1), $values[$i])
        }
    } else {
        Write-Debug "No Variable Named $Name "
    }
}

# backup
$BACKUP_DIR = "./EnvVarBackup"

function Backup-EnvValue {
    param (
        [string]$BackupType = "AutoBackup_"
    )    
    $currentDateTime = Get-Date -Format "yyyy_MM_dd_HH_mm_ss"
    $filename = "$BACKUP_DIR/$BackupType$currentDateTime.json"
    # $envVars = @{
    #     "User" = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    #     "Machine" = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::Machine)
    # }
    $envVars = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    $jsonData = $envVars | ConvertTo-Json -Depth 4
    if (-not (Test-Path -Path $BACKUP_DIR)) {
        New-Item -ItemType Directory -Path $BACKUP_DIR
    }
    $jsonData | Out-File -FilePath $filename -Encoding UTF8
    Write-Host "Successful backup at $filename"
}


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


function Compare-EnvValue {
    param (
        [string]$BackupType,
        [string]$OutputType = "Table"
    ) 
    if ([string]::IsNullOrWhiteSpace($BackupType)) {
        $BackupType = "Manual"
    } 
    Write-Output "Compare Mode: [$($BackupType)]"
    $files = Get-ChildItem -Path $BACKUP_DIR -Filter "$BackupType*"
    if ($files.Count -gt 0) {
        $latestFile = $files | Sort-Object CreationTime -Descending | Select-Object -First 1
        Write-Output "Found Backup: $($latestFile.Name)"
    } else {
        Write-Output "There is no $BackupType Backup file found."
        return
    }
    # JSON
    $jsonFilePath = "$BACKUP_DIR/$latestFile"
    if (-not (Test-Path $jsonFilePath)) {
        Write-Host "File $jsonFilePath Not Found."
        return
    }
    $oldEnvVars = Get-Content -Raw -Path $jsonFilePath | ConvertFrom-Json | ConvertTo-Hashtable
    # $currentEnvVars = @{
    #     "User" = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    #     "Machine" = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::Machine)
    # }
    $currentEnvVars = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    $differences = @()
    $allKeys = $oldEnvVars.Keys + $currentEnvVars.Keys | Sort-Object | Select-Object -Unique
    foreach ($key in $allKeys) {
        if (-not $currentEnvVars.ContainsKey($key)) {
            $differences += [PSCustomObject]@{
                Variable = $key
                Update = "Delete Variable"
                Value = $oldEnvVars[$key]
            }
            continue
        } 
        if (-not $oldEnvVars.ContainsKey($key)) {
            $differences += [PSCustomObject]@{
                Variable = $key
                Update = "New Variable"
                Value = $currentEnvVars[$key]
            }
            continue
        } 
        $oldValues = $oldEnvVars[$key] -split ';'
        $newValues = $currentEnvVars[$key] -split ';'
        $allValues = $oldValues + $newValues
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

    if ($differences.Count -eq 0) {
        Write-Host "No changes found."
        return
    }

    if ($OutputType -eq "Table") {
        return $differences | Format-Table -AutoSize
    } elseif ($OutputType -eq "Json") {
        return $differences | ConvertTo-Json -Depth 4
    } else {
        return $differences
    }
}

function Restore-EnvValue {
    param (
        [string]$BackupType
    ) 
    if ([string]::IsNullOrWhiteSpace($BackupType)) {
        $BackupType = "Manual"
    }
    Backup-EnvValue -BackupType "RestoreBackup_"
    Write-Output "Restore Mode: [$($BackupType)]"

    $files = Get-ChildItem -Path $BACKUP_DIR -Filter "$BackupType*"
    if ($files.Count -gt 0) {
        $latestFile = $files | Sort-Object CreationTime -Descending | Select-Object -First 1
        Write-Output "Found Backup: $($latestFile.Name)"
    } else {
        Write-Output "There is no $BackupType Backup file found."
        return
    }
    # JSON
    $jsonFilePath = "$BACKUP_DIR/$latestFile"

    $differenceKeys = Compare-EnvValue -BackupType $BackupType -OutputType "Raw"
    $differenceKeys = $differenceKeys | ForEach-Object { $_.Variable } | Select-Object -Unique
    $oldEnvVars = Get-Content -Raw -Path $jsonFilePath | ConvertFrom-Json | ConvertTo-Hashtable
    
    if ($differenceKeys) {
        Write-Output "Found Differences: $($differenceKeys.Count)"
        $differenceKeys | ForEach-Object {
            [Environment]::SetEnvironmentVariable($_, $oldEnvVars[$_], [EnvironmentVariableTarget]::User) 
        }
        Write-Output "Restore Complete."
    }
}

# help
function Show-Help {
    $desc = @{
        "add" = "Add value to environment variable"
        "sub" = "Sub value from environment variable"
        "show" = "Show environment variable"
        "clear" = "Clear environment variable"
        "list" = "List all user environment variables"
        "cmp" = "Compare with backup file"
        "backup" = "Backup environment variables to file"
        "restore" = "Restore environment variables from backup file"
    }
    $usage = @{
        "add" = "add [-Name <Name>] [-Value <Value>]"
        "sub" = "sub [-Name <Name>] [-Value <Value>]"
        "show" = "show [-Name <Name>]"
        "clear" = "clear [-Name <Name>]"
        "list" = "list"
        "cmp" = "cmp [Manual|Auto|Restore]"
        "backup" = "backup"
        "restore" = "restore [Manual|Auto|Restore]"
    }
    Write-Host "usage: .\gEnvCtrl.ps1 <Command> [Name] [Value]"
    $table = @()
    $keys = $desc.Keys | Sort-Object
    foreach ($key in $keys) {
        $table += [PSCustomObject]@{
            Command = $key
            Description = ("{0, 7}" -f $desc[$key])
            Usage = (".\gEnvCtrl.ps1 {0}" -f $usage[$key])
        }
    }
    $table | Format-Table -AutoSize
}


try {
    switch ($Command) {
        "add" { Add-EnvValue -Name $Name -Value $Value }
        "sub" { Sub-EnvValue -Name $Name -Value $Value }
        "show" { Show-EnvValue -Name $Name }
        "clear" { Clear-EnvValue -Name $Name }
        "list" { List-EnvValues }
        "cmp" { Compare-EnvValue -BackupType $With }
        "backup" { Backup-EnvValue -BackupType "ManualBackup_" }
        "restore" { Restore-EnvValue -BackupType $With }
        default { 
            Show-Help 
        }
    }
} catch {
    Write-Host "ERROR: $_"
    Show-Help
}