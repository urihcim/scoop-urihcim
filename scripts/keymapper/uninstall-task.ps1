if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Unregister-ScheduledTask -TaskName "keymapperd" -Confirm:$false
Unregister-ScheduledTask -TaskName "keymapper" -Confirm:$false
