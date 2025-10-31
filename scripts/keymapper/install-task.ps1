if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$trigger = New-ScheduledTaskTrigger -AtLogon -User $env:USERNAME
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -ExecutionTimeLimit (New-TimeSpan -Seconds 0)
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest
$server = New-ScheduledTaskAction -Execute "%DIR%\keymapperd.exe" -WorkingDirectory "%DIR%"
$client = New-ScheduledTaskAction -Execute "%DIR%\keymapper.exe" -Argument "-u" -WorkingDirectory "%DIR%"
Register-ScheduledTask -TaskName "keymapperd" -Trigger $trigger -Action $server -Settings $settings -Principal $principal -Force
Register-ScheduledTask -TaskName "keymapper" -Trigger $trigger -Action $client -Settings $settings -Force
