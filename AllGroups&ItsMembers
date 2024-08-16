Set-Location C:\Temp
Clear-Host
Connect-ExchangeOnline

$Result = @()
$groups = Get-DistributionGroup -ResultSize Unlimited
$totalGroups = $groups.Count
$i = 1

$groups | ForEach-Object {
    Write-Progress -Activity "Processing $_.DisplayName" -Status "$i out of $totalGroups completed"
    $group = $_

    # Retrieve members of each mail-enabled group
    Get-DistributionGroupMember -Identity $group.Identity -ResultSize Unlimited | ForEach-Object {
        $member = $_
        $Result += New-Object PSObject -Property @{
            GroupName = $group.DisplayName
            GroupEmailAddress = $group.PrimarySmtpAddress
            Member = $member.DisplayName
            EmailAddress = $member.PrimarySMTPAddress
            RecipientType = $member.RecipientTypeDetails 
        }
    }
    $i++
}

$Result | Export-Csv "C:\Temp\All-Mail-Enabled-Groups-Members-16AUG2024.csv" -NoTypeInformation -Encoding UTF8
