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

    # Ensure unique identification by using DistinguishedName or Guid
    $groupIdentity = $group.DistinguishedName

    try {
        # Retrieve members of each mail-enabled group
        $members = Get-DistributionGroupMember -Identity $groupIdentity -ResultSize Unlimited

        $members | ForEach-Object {
            $member = $_
            $Result += New-Object PSObject -Property @{
                GroupName = $group.DisplayName
                GroupEmailAddress = $group.PrimarySmtpAddress
                Member = $member.DisplayName
                EmailAddress = $member.PrimarySMTPAddress
                RecipientType = $member.RecipientTypeDetails 
            }
        }
    }
    catch {
        Write-Error "Failed to process group: $($group.DisplayName) with Identity: $($groupIdentity) - $($_.Exception.Message)"
    }

    $i++
}

# Export results to CSV
$Result | Export-Csv "C:\Temp\All-Groups--Members-21AUG2024.csv" -NoTypeInformation -Encoding UTF8

Write-Host "Script completed. Results exported to C:\Temp\All-Groups--Members-21AUG2024.csv"
