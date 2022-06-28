$environment=$args[0]

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn

Start-Transcript -Path "c:\automation\bulkcreatemailuser.txt"


Switch ($environment)
{
    prod {
        $ou = "domain/OU/Users"
        $rrsuffix = "@tennant1.mail.onmicrosoft.com"
    }

    test {
        $ou = "domain/OU/Users"
        $rrsuffix = "@tennant2.mail.onmicrosoft.com"

    }
}

$users = get-user -OrganizationalUnit $ou -resultsize unlimited

foreach ($user in $users) {

$usermail = $user.UserPrincipalname
$userRt = $user.RecipientType

if ($userrt -eq "User") {
    
    $userrr = $user.SamAccountName + $rrsuffix 

    write-host $usermail "not mail enabled"

    Enable-MailUser -Identity $usermail -ExternalEmailAddress $userrr
    Enable-RemoteMailBox $usermail
        
   }
}

Stop-Transcript