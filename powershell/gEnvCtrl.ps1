# open in GBK, not utf-8
# �������������ű�

# ����ֵ��ָ����������
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
    Write-Host "������ֵ���������� $Name"
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
        Write-Host "�Ѵӻ������� $Name �Ƴ�ֵ$Value"
    } else {
        Write-Host "�������� $Name �����ڻ�Ϊ��"
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
        Write-Host "�������� $Name �ѱ����"
    } else {
        Write-Host "�������� $Name ������"
    }
}

# �г����л�������
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
        Write-Host "�������� $Name ��ֵΪ: "
        $values = $value -split ';'
        for ($i = 0;$i -lt $values.Length;$i++) {
            Write-Host ("[{0, 2}]: {1}" -f ($i + 1), $values[$i])
        }
    } else {
        Write-Host "�������� $Name �����ڻ�Ϊ��"
    }
}


# backup
$BACKUP_DIR = "./EnvVarBackup"

function Backup-EnvValue {
    param (
        [string]$BackupType = "AutoBackup_"
    )    
    # ��ȡ��ǰʱ�䲢ת��Ϊ�ض���ʽ���ַ���
    $currentDateTime = Get-Date -Format "yyyy_MM_dd_HH_mm_ss"
    # ָ���ļ�����������ǰʱ���ַ���
    $filename = "$BACKUP_DIR/$BackupType$currentDateTime.json"
    # ��ȡ���л�������
    # $envVars = @{
    #     "User" = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    #     "Machine" = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::Machine)
    # }
    $envVars = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    # ����������ת��ΪJSON��ʽ
    $jsonData = $envVars | ConvertTo-Json -Depth 4

    # ����ļ����Ƿ����
    if (-not (Test-Path -Path $BACKUP_DIR)) {
        # �ļ��в����ڣ�������
        New-Item -ItemType Directory -Path $BACKUP_DIR
    }

    # ��JSON����д���ļ�
    $jsonData | Out-File -FilePath $filename -Encoding UTF8
    Write-Host "���������ѱ��浽 $filename"
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
        [string]$BackupType
    ) 
    if ([string]::IsNullOrWhiteSpace($BackupType)) {
        $BackupType = "Manual"
    } 
    # ��ȡ��ǰĿ¼��������"Manual"��ͷ���ļ�
    $files = Get-ChildItem -Path $BACKUP_DIR -Filter "$BackupType*"
    # ����ҵ����ļ������������
    if ($files.Count -gt 0) {
        # ������ʱ�併�������ļ�����ѡ�����µ�һ��
        $latestFile = $files | Sort-Object CreationTime -Descending | Select-Object -First 1
        # ��������ļ�������
        Write-Output "����Backup�ļ���: $($latestFile.Name)"
    } else {
        # ���û���ҵ��ļ��������ʾ��Ϣ
        Write-Output "û���ҵ�$BackupType Backup�ļ���"
        return
    }
    # ����֮ǰ�����JSON�ļ�·��
    $jsonFilePath = "$BACKUP_DIR/$latestFile"
    if (-not (Test-Path $jsonFilePath)) {
        Write-Host "�ļ� $jsonFilePath ������"
        return
    }
    # ��ȡJSON�ļ��еĻ�������
    $oldEnvVars = Get-Content -Raw -Path $jsonFilePath | ConvertFrom-Json | ConvertTo-Hashtable
    # ��ȡ��ǰ�Ļ�������
    # $currentEnvVars = @{
    #     "User" = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    #     "Machine" = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::Machine)
    # }
    $currentEnvVars = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    # ����һ���յ��������洢����
    $differences = @()
    # ȡ��������ϣ���е����м������ϲ�������
    $allKeys = $oldEnvVars.Keys + $currentEnvVars.Keys | Sort-Object | Select-Object -Unique

    # �����ϲ���ļ�����
    # �ԱȲ���
    foreach ($key in $allKeys) {
        # �����Ҫ��Ҳ���Լ��ÿ�����Ƿ�����ڹ�ϣ���У�����ȡ��ֵ
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
        # ��������ֵ
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
    
    # ���Ϊ����
    $differences | Format-Table -AutoSize
    # ���û�в��죬�����Ӧ����Ϣ
    if ($differences.Count -eq 0) {
        Write-Host "û�м�⵽���������Ĳ��졣"
    }
}

# help
function Show-Help {
    Write-Host "�÷�: .\env-manage.ps1 <Command> [Name] [Value]"
    Write-Host "Command List:"
    Write-Host "  add     - ����ֵ��ָ���������� usage: .\script add [Name] [Value]"
    Write-Host "  sub     - ��ָ�����������Ƴ�ֵ usage: .\script sub [Name] [Value]"
    Write-Host "  show    - ��ʾָ����������������ֵ usage: .\script show [Name]"
    Write-Host "  clear   - ���ָ������������ֵ usage: .\script clear [Name]"
    Write-Host "  list    - �г����л������� usage: .\script list"
    Write-Host "  cmp     - �Ա�backup�ļ� usage: .\script cmp [Manual|Auto]"
    Write-Host "  backup  - �ֶ��洢���л������� usage: .\script backup"
    Write-Host "  restore - �����ļ���ԭ��������(not implemented)"
}

function Run {
    # ���������в���
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
        Write-Host "��������: $_"
        Show-Help
    }
}
Run $args[0] $args[1] $args[2]
