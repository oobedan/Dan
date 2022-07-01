# https://blog.oholics.net/scripted-provisioning-of-office-365-unified-labels/
# Create Labels
Connect-IPPSSession

$thisLabel = 'UNOFFICIAL'
# Create Label
New-Label -DisplayName $thisLabel -Name $thisLabel -Comment ('This is ' + $thisLabel) -Tooltip ($thisLabel + ' Tooltip') -AdvancedSettings @{color="#32CD32"}
# Set Header properties (FontSize 10, Centered and Red)
$labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabel -LabelActions $labelActionHeader
# Set Footer properties (FontSize 10, Centered and Red)
$labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabel -LabelActions $labelActionFooter

$thisLabel = 'OFFICIAL'
# Create Label
New-Label -DisplayName $thisLabel -Name $thisLabel -Comment ('This is ' + $thisLabel) -Tooltip ($thisLabel + ' Tooltip') -AdvancedSettings @{color="#32CD32"}
# Set Header properties (FontSize 10, Centered and Red)
$labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabel -LabelActions $labelActionHeader
# Set Footer properties (FontSize 10, Centered and Red)
$labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabel -LabelActions $labelActionFooter

$thisLabelName = 'OFFICIAL Sensitive'
$thisLabel = 'OFFICIAL:Sensitive' 
# Create Label
New-Label -DisplayName $thisLabelName -Name $thisLabelName -Comment ('This is ' + $thisLabel) -Tooltip ($thisLabel + ' Tooltip') -AdvancedSettings @{color="#32CD32"}
# Set Header properties (FontSize 10, Centered and Red)
$labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionHeader
# Set Footer properties (FontSize 10, Centered and Red)
$labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionFooter

$thisLabelName = 'OFFICIAL Sensitive ACCESS=Legal-Privilege'
$thisLabel = 'OFFICIAL:Sensitive, ACCESS=Legal-Privilege' 
# Create Label
New-Label -DisplayName $thisLabelName -Name $thisLabelName -Comment ('This is ' + $thisLabel) -Tooltip ($thisLabel + ' Tooltip') -AdvancedSettings @{color="#32CD32"}
# Set Header properties (FontSize 10, Centered and Red)
$labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionHeader
# Set Footer properties (FontSize 10, Centered and Red)
$labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionFooter

$thisLabelName = 'OFFICIAL Sensitive ACCESS=Legislative-Secrecy'
$thisLabel = 'OFFICIAL: Sensitive, ACCESS=Legislative-Secrecy' 
# Create Label
New-Label -DisplayName $thisLabelName -Name $thisLabelName -Comment ('This is ' + $thisLabel) -Tooltip ($thisLabel + ' Tooltip') -AdvancedSettings @{color="#32CD32"}
# Set Header properties (FontSize 10, Centered and Red)
$labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionHeader
# Set Footer properties (FontSize 10, Centered and Red)
$labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionFooter

$thisLabelName = 'OFFICIAL Sensitive ACCESS=Personal-Privacy'
$thisLabel = 'OFFICIAL: Sensitive, ACCESS=Personal-Privacy' 
# Create Label
New-Label -DisplayName $thisLabelName -Name $thisLabelName -Comment ('This is ' + $thisLabel) -Tooltip ($thisLabel + ' Tooltip') -AdvancedSettings @{color="#32CD32"}
# Set Header properties (FontSize 10, Centered and Red)
$labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionHeader
# Set Footer properties (FontSize 10, Centered and Red)
$labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionFooter

$thisLabel = 'PROTECTED'
# Create Label
New-Label -DisplayName $thisLabel -Name $thisLabel -Comment ('This is ' + $thisLabel) -Tooltip ($thisLabel + ' Tooltip') -AdvancedSettings @{color="#32CD32"}
# Set Header properties (FontSize 10, Centered and Red)
$labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabel -LabelActions $labelActionHeader
# Set Footer properties (FontSize 10, Centered and Red)
$labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabel -LabelActions $labelActionFooter

$thisLabelName = 'PROTECTED ACCESS=Legal-Privilege'
$thisLabel = 'PROTECTED, ACCESS=Legal-Privilege' 
# Create Label
New-Label -DisplayName $thisLabelName -Name $thisLabelName -Comment ('This is ' + $thisLabel) -Tooltip ($thisLabel + ' Tooltip') -AdvancedSettings @{color="#32CD32"}
# Set Header properties (FontSize 10, Centered and Red)
$labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionHeader
# Set Footer properties (FontSize 10, Centered and Red)
$labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionFooter

$thisLabelName = 'PROTECTED ACCESS=Legislative-Secrecy'
$thisLabel = 'PROTECTED, ACCESS=Legislative-Secrecy' 
# Create Label
New-Label -DisplayName $thisLabelName -Name $thisLabelName -Comment ('This is ' + $thisLabel) -Tooltip ($thisLabel + ' Tooltip') -AdvancedSettings @{color="#32CD32"}
# Set Header properties (FontSize 10, Centered and Red)
$labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionHeader
# Set Footer properties (FontSize 10, Centered and Red)
$labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionFooter

$thisLabelName = 'PROTECTED ACCESS=Personal-Privacy'
$thisLabel = 'PROTECTED, ACCESS=Personal-Privacy' 
# Create Label
New-Label -DisplayName $thisLabelName -Name $thisLabelName -Comment ('This is ' + $thisLabel) -Tooltip ($thisLabel + ' Tooltip') -AdvancedSettings @{color="#32CD32"}
# Set Header properties (FontSize 10, Centered and Red)
$labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionHeader
# Set Footer properties (FontSize 10, Centered and Red)
$labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionFooter

$thisLabelName = 'PROTECTED CAVEAT=SH CABINET'
$thisLabel = 'PROTECTED, CAVEAT=SH:CABINET' 
# Create Label
New-Label -DisplayName $thisLabelName -Name $thisLabelName -Comment ('This is ' + $thisLabel) -Tooltip ($thisLabel + ' Tooltip') -AdvancedSettings @{color="#32CD32"}
# Set Header properties (FontSize 10, Centered and Red)
$labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionHeader
# Set Footer properties (FontSize 10, Centered and Red)
$labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionFooter

$thisLabelName = 'PROTECTED ACCESS=Legal-Privilege CAVEAT=SH CABINET'
$thisLabel = 'PROTECTED, ACCESS=Legal-Privilege, CAVEAT=SH:CABINET' 
# Create Label
New-Label -DisplayName $thisLabelName -Name $thisLabelName -Comment ('This is ' + $thisLabel) -Tooltip ($thisLabel + ' Tooltip') -AdvancedSettings @{color="#32CD32"}
# Set Header properties (FontSize 10, Centered and Red)
$labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionHeader
# Set Footer properties (FontSize 10, Centered and Red)
$labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionFooter

$thisLabelName = 'PROTECTED ACCESS=Legislative-Secrecy CAVEAT=SH CABINET'
$thisLabel = 'PROTECTED, ACCESS=Legislative-Secrecy, CAVEAT=SH:CABINET' 
# Create Label
New-Label -DisplayName $thisLabelName -Name $thisLabelName -Comment ('This is ' + $thisLabel) -Tooltip ($thisLabel + ' Tooltip') -AdvancedSettings @{color="#32CD32"}
# Set Header properties (FontSize 10, Centered and Red)
$labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionHeader
# Set Footer properties (FontSize 10, Centered and Red)
$labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionFooter

$thisLabelName = 'PROTECTED ACCESS=Personal-Privacy CAVEAT=SH CABINET'
$thisLabel = 'PROTECTED, ACCESS=Personal-Privacy, CAVEAT=SH:CABINET' 
# Create Label
New-Label -DisplayName $thisLabelName -Name $thisLabelName -Comment ('This is ' + $thisLabel) -Tooltip ($thisLabel + ' Tooltip') -AdvancedSettings @{color="#32CD32"}
# Set Header properties (FontSize 10, Centered and Red)
$labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionHeader
# Set Footer properties (FontSize 10, Centered and Red)
$labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"fontsize","Value":"10"},{"Key":"placement","Value":"' + $thisLabel + '"},{"Key":"text","Value":"' + `
    $thisLabel + '"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"disabled","Value":"false"}]}'
Set-Label -Identity $thisLabelName -LabelActions $labelActionFooter


# Publish All labels
$LabelPolicy = "LabelPublishing"
$labels = Get-Label | Where-Object {$_.Mode -eq 'Enforce'} | Select-Object Name

#New-LabelPolicy -Labels $labels.name -ExchangeLocation ALL -Name $LabelPolicy
#Set-LabelPolicy -Identity $LabelPolicy -AdvancedSettings @{EnableCustomPermissions="False"}
#Set-LabelPolicy -Identity $LabelPolicy -AdvancedSettings @{RequireDowngradeJustification="True"}
#Set-LabelPolicy -Identity $LabelPolicy -AdvancedSettings @{Mandatory="True"}