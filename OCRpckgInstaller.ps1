if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$OCRPackages = Get-WindowsCapability -Online | Where-Object { $_.Name -Like 'Language.OCR*' }

$CountryCodes = $OCRPackages.Name | ForEach-Object { $_ -replace 'Language.OCR~~~', '' } | ForEach-Object { $_ -replace '~.*', '' }

foreach ($CountryCode in $CountryCodes) {
    $Capability = Get-WindowsCapability -Online | Where-Object { $_.Name -Like "Language.OCR*$CountryCode*" }
    $Capability | Add-WindowsCapability -Online
}