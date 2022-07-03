# Connect PS Sessions as required
# Function to create label
# Function to create exchange transport rule
# Function to create DLP Rule
# Unable to create the Autolabel rule
# Function to string them all together

# Set parameters for each label and then call it

$oldPref = $ErrorActionPreference
$ErrorActionPreference = "SilentlyContinue"
if(-not(Get-Command Get-Label)){Connect-IPPSSession}
if(-not(Get-Command New-TransportRule)){Connect-ExchangeOnline}
$ErrorActionPreference = $oldPref

# TODO: Modify for colors, Check description of labels is correct.
$unofficialColor = ""
$officialColor = "#32CD32"
$protectedColor = "#32CD32"

Function New-PSPFLabel{
    param(
        $LabelName,
        $LabelHeaderFooterText,
        $LabelDisplayName,
        $LabelParentGuid,
        $LabelDescription
    )
        # Create the label
        if($LabelParentGuid){
            $NewLabel = New-Label -DisplayName $LabelDisplayName -Name $LabelName -Comment $LabelDescription `
            -Tooltip $LabelDescription -ParentId $LabelParentGuid -AdvancedSettings @{color=$protectedColor}
            # Set Header properties (Fontname ARIAL, FontSize 12, Centered and Red)
            $labelActionHeader = '{"Type":"applycontentmarking","SubType":"header","Settings":[{"Key":"text","Value":"'+$LabelHeaderFooterText+'"},{"Key":"fontsize","Value":"12"},{"Key":"fontname","Value":"ARIAL"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"margin","Value":"5"},{"Key":"placement","Value":"Header"},{"Key":"disabled","Value":"false"}]}'
            Set-Label -Identity $NewLabel.Guid -LabelActions $labelActionHeader
            # Set Footer properties (Fontname ARIAL, FontSize 12, Centered and Red)
            $labelActionFooter = '{"Type":"applycontentmarking","SubType":"footer","Settings":[{"Key":"text","Value":"'+$LabelHeaderFooterText+'"},{"Key":"fontsize","Value":"12"},{"Key":"fontname","Value":"ARIAL"},{"Key":"fontcolor","Value":"#FF0000"},{"Key":"alignment","Value":"Center"},{"Key":"margin","Value":"5"},{"Key":"placement","Value":"Footer"},{"Key":"disabled","Value":"false"}]}'
            Set-Label -Identity $NewLabel.Guid -LabelActions $labelActionFooter
        }else { # This is a group label
            $NewLabel = New-Label -DisplayName $LabelDisplayName -Name $LabelName -Comment $LabelDescription `
            -Tooltip $LabelDescription
        }
        return $NewLabel
}

Function New-X_Prot_TransportRule{
    param(
        $labelName,
        $labelGuid,
        $x_prot_value
    )
    $HeaderContains = "MSIP_Label_" + $labelGuid + "_Enabled=true"
    New-TransportRule -Name "Outbound $($labelName) x-prot-marking" `
    -HeaderContainsMessageHeader 'msip_labels' `
    -HeaderContainsWords $HeaderContains `
    -StopRuleProcessing $true `
    -Enabled $true -SetHeaderName "x-protective-marking" `
    -setheadervalue $x_prot_value #`
    # -FromMemberOf $group
}

Function New-PSPFDLPRule{
    param(
        $LabelName,
        [string]$SubjectText
    )
        $policyName = ("DLP Modify Subject for " + $LabelName) 
        $createdDLPPolicy = New-DlpCompliancePolicy -Name $policyName -ExchangeLocation ALL -Mode TestWithNotifications

        $subjectRules= @(
            @{
                operator = "And"
                groups = @(
                    @{
                        operator="Or"
                        name="Default"
                        labels = @(
                            @{
                                name="$($LabelName)"
                                type="Sensitivity"
                            } 
                        )
                    }
                )
            }
        )
        $newSubject = @{
            ReplaceStrategy = "append"
            Patterns = "{\s?\[SEC=.*?\]}"
            SubjectText = $SubjectText
        }

        New-DlpComplianceRule -Policy $createdDLPPolicy.Name -ModifySubject $newSubject `
        -Name ("DLP Modify Subject Rule for " + $labelName) -ContentContainsSensitiveInformation $subjectRules
    }

    # # Create the autolabel rule for incoming emails
    # # "AutoLabel PROTECTED Emails Policy" `
    # if($LabelParentGuid){
    #     $labelToApply = $NewLabel.guid.Guid
    #     $createdAutoLabelPolicy = New-AutoSensitivityLabelPolicy -Name (New-Guid).Guid `
    #     -ApplySensitivityLabel $labelToApply `
    #     -Mode TestWithoutNotifications `
    #     -ExchangeLocation ALL

    #     [string]$headerHash = "(?im)(sec=protected\saccess=legislative-secrecy)"
    #     New-AutoSensitivityLabelRule -Policy $createdAutoLabelPolicy.Name `
    #     -Name ($createdAutoLabelPolicy.Name + "-Rule") `
    #     -HeaderMatchesPatterns @{"x-protective-marking" =  $headerHash} `
    #     -Workload Exchange
    # }
    
Function New-PSPFConfig{
    param(
        $thisPSPFLabelName,
        $thisPSPFLabelHeaderFooterText,
        $desc,
        $x_prot,
        $thisPSPFLabelDisplayName,
        $parentGuid,
        $subject
    )
    # Create label
    $labelCreated = New-PSPFLabel -LabelName $thisPSPFLabelName -LabelHeaderFooterText $thisPSPFLabelHeaderFooterText -LabelDescription $desc `
    -LabelDisplayName $thisPSPFLabelDisplayName -LabelParentGuid $parentGuid
    # Create the transport rule 
    New-X_Prot_TransportRule -labelName $labelCreated.Name -labelGuid $labelCreated.Guid -x_prot_value $x_prot
    # Create the DLP rule
    New-PSPFDLPRule -LabelName $labelCreated.Name -SubjectText $subject
    # Create the Autolabel rule
}

# PROTECTED Group
$thisLabelName =  'PROT-Group'
$desc = 'Protected Label group'
$parent = New-PSPFLabel -LabelName $thisLabelName -LabelDescription $desc -LabelDisplayName $thisLabelName

$parentGuid = $parent.Guid.guid # Required for all child labels

# PROTECTED
$thisLabelName = 'P'
$thisLabelHeaderFooterText = 'PROTECTED'
$thisLabelDisplayName = 'PROTECTED'
$desc = 'Valuable, important and sensitive information. Compromise of PROTECTED information would be expected to cause damage to the national interest, organisations or individuals.'
$x_prot = "VER=2018.5, NS=gov.au, SEC=PROTECTED"
$subject = " [SEC=PROTECTED]"
New-PSPFConfig -thisPSPFLabelName $thisLabelName -thisPSPFLabelHeaderFooterText $thisLabelHeaderFooterText -desc $desc `
-x_prot $x_prot -parentGuid $parentGuid -subject $subject -thisPSPFLabelDisplayName $thisLabelDisplayName

# PROTECTED//Legal-Privilege
$thisLabelName = 'P-LP'
$thisLabelHeaderFooterText = 'PROTECTED//Legal-Privilege'
$thisLabelDisplayName = 'Legal-Privilege'
$desc = 'Valuable, important and sensitive information. Compromise of PROTECTED information would be expected to cause damage to the national interest, organisations or individuals.'
$x_prot = "VER=2018.5, NS=gov.au, SEC=PROTECTED, ACCESS=Legal-Privilege"
$subject = " [SEC=PROTECTED, ACCESS=Legal-Privilege]"
New-PSPFConfig -thisPSPFLabelName $thisLabelName -thisPSPFLabelHeaderFooterText $thisLabelHeaderFooterText -desc $desc `
-x_prot $x_prot -parentGuid $parentGuid -subject $subject -thisPSPFLabelDisplayName $thisLabelDisplayName

# PROTECTED//Legislative-Secrecy
$thisLabelName = 'P-LS'
$thisLabelHeaderFooterText = 'PROTECTED//Legislative-Secrecy'
$thisLabelDisplayName = 'Legislative-Secrecy'
$desc = 'Valuable, important and sensitive information. Compromise of PROTECTED information would be expected to cause damage to the national interest, organisations or individuals.'
$x_prot = "VER=2018.5, NS=gov.au, SEC=PROTECTED, ACCESS=Legislative-Secrecy"
$subject = " [SEC=PROTECTED, ACCESS=Legislative-Secrecy]"
New-PSPFConfig -thisPSPFLabelName $thisLabelName -thisPSPFLabelHeaderFooterText $thisLabelHeaderFooterText -desc $desc `
-x_prot $x_prot -parentGuid $parentGuid -subject $subject -thisPSPFLabelDisplayName $thisLabelDisplayName

# PROTECTED//Personal-Privacy
$thisLabelName = 'P-PP'
$thisLabelHeaderFooterText = 'PROTECTED//Personal-Privacy'
$thisLabelDisplayName = 'Personal-Privacy'
$desc = 'Valuable, important and sensitive information. Compromise of PROTECTED information would be expected to cause damage to the national interest, organisations or individuals.'
$x_prot = "VER=2018.5, NS=gov.au, SEC=PROTECTED, ACCESS=Personal-Privacy"
$subject = " [SEC=PROTECTED, ACCESS=Personal-Privacy]"
New-PSPFConfig -thisPSPFLabelName $thisLabelName -thisPSPFLabelHeaderFooterText $thisLabelHeaderFooterText -desc $desc `
-x_prot $x_prot -parentGuid $parentGuid -subject $subject -thisPSPFLabelDisplayName $thisLabelDisplayName

# PROTECTED//CABINET
$thisLabelName = 'P-CAB'
$thisLabelHeaderFooterText = 'PROTECTED//CABINET'
$thisLabelDisplayName = 'CABINET'
$desc = 'Valuable, important and sensitive information. Compromise of PROTECTED information would be expected to cause damage to the national interest, organisations or individuals.'
$x_prot = "VER=2018.5, NS=gov.au, SEC=PROTECTED, CAVEAT=CABINET"
$subject = " [SEC=PROTECTED, CAVEAT=CABINET]"
New-PSPFConfig -thisPSPFLabelName $thisLabelName -thisPSPFLabelHeaderFooterText $thisLabelHeaderFooterText -desc $desc `
-x_prot $x_prot -parentGuid $parentGuid -subject $subject -thisPSPFLabelDisplayName $thisLabelDisplayName

# PROTECTED//CABINET//Legal-Privilege
$thisLabelName = 'P-CAB-LP'
$thisLabelHeaderFooterText = 'PROTECTED//CABINET//Legal-Privilege'
$thisLabelDisplayName = 'CABINET Legal-Privilege'
$desc = 'Valuable, important and sensitive information. Compromise of PROTECTED information would be expected to cause damage to the national interest, organisations or individuals.'
$x_prot = "VER=2018.5, NS=gov.au, SEC=PROTECTED, CAVEAT=CABINET, ACCESS=Legal-Privilege"
$subject = " [SEC=PROTECTED, CAVEAT=CABINET, ACCESS=Legal-Privilege]"
New-PSPFConfig -thisPSPFLabelName $thisLabelName -thisPSPFLabelHeaderFooterText $thisLabelHeaderFooterText -desc $desc `
-x_prot $x_prot -parentGuid $parentGuid -subject $subject -thisPSPFLabelDisplayName $thisLabelDisplayName

# PROTECTED//CABINET//Legislative-Secrecy
$thisLabelName = 'P-CAB-LS'
$thisLabelHeaderFooterText = 'PROTECTED//CABINET//Legislative-Secrecy'
$thisLabelDisplayName = 'CABINET Legislative-Secrecy'
$desc = 'Valuable, important and sensitive information. Compromise of PROTECTED information would be expected to cause damage to the national interest, organisations or individuals.'
$x_prot = "VER=2018.5, NS=gov.au, SEC=PROTECTED, CAVEAT=CABINET, ACCESS=Legislative-Secrecy"
$subject = " [SEC=PROTECTED, CAVEAT=CABINET, ACCESS=Legislative-Secrecy]"
New-PSPFConfig -thisPSPFLabelName $thisLabelName -thisPSPFLabelHeaderFooterText $thisLabelHeaderFooterText -desc $desc `
-x_prot $x_prot -parentGuid $parentGuid -subject $subject -thisPSPFLabelDisplayName $thisLabelDisplayName

# PROTECTED//CABINET//Personal-Privacy
$thisLabelName = 'P-CAB-PP'
$thisLabelHeaderFooterText = 'PROTECTED//CABINET//Personal-Privacy'
$thisLabelDisplayName = 'CABINET Personal-Privacy'
$desc = 'Valuable, important and sensitive information. Compromise of PROTECTED information would be expected to cause damage to the national interest, organisations or individuals.'
$x_prot = "VER=2018.5, NS=gov.au, SEC=PROTECTED, CAVEAT=CABINET, ACCESS=Personal-Privacy"
$subject = " [SEC=PROTECTED, CAVEAT=CABINET, ACCESS=Personal-Privacy]"
New-PSPFConfig -thisPSPFLabelName $thisLabelName -thisPSPFLabelHeaderFooterText $thisLabelHeaderFooterText -desc $desc `
-x_prot $x_prot -parentGuid $parentGuid -subject $subject -thisPSPFLabelDisplayName $thisLabelDisplayName

# PROTECTED//NATIONAL CABINET
$thisLabelName = 'P-NATCAB'
$thisLabelHeaderFooterText = 'PROTECTED//NATIONAL CABINET'
$thisLabelDisplayName = 'NATIONAL CABINET'
$desc = 'Valuable, important and sensitive information. Compromise of PROTECTED information would be expected to cause damage to the national interest, organisations or individuals.'
$x_prot = "VER=2018.5, NS=gov.au, SEC=PROTECTED, CAVEAT=NATIONAL CABINET"
$subject = " [SEC=PROTECTED, CAVEAT=NATIONAL CABINET]"
New-PSPFConfig -thisPSPFLabelName $thisLabelName -thisPSPFLabelHeaderFooterText $thisLabelHeaderFooterText -desc $desc `
-x_prot $x_prot -parentGuid $parentGuid -subject $subject -thisPSPFLabelDisplayName $thisLabelDisplayName

# PROTECTED//NATIONAL CABINET//Legal-Privilege
$thisLabelName = 'P-NATCAB-LP'
$thisLabelHeaderFooterText = 'PROTECTED//NATIONAL CABINET//Legal-Privilege'
$thisLabelDisplayName = 'NATIONAL CABINET Legal-Privilege'
$desc = 'Valuable, important and sensitive information. Compromise of PROTECTED information would be expected to cause damage to the national interest, organisations or individuals.'
$x_prot = "VER=2018.5, NS=gov.au, SEC=PROTECTED, CAVEAT=NATIONAL CABINET, ACCESS=Legal-Privilege"
$subject = " [SEC=PROTECTED, CAVEAT=NATIONAL CABINET, ACCESS=Legal-Privilege]"
New-PSPFConfig -thisPSPFLabelName $thisLabelName -thisPSPFLabelHeaderFooterText $thisLabelHeaderFooterText -desc $desc `
-x_prot $x_prot -parentGuid $parentGuid -subject $subject -thisPSPFLabelDisplayName $thisLabelDisplayName

# PROTECTED//NATIONAL CABINET//Legislative-Secrecy
$thisLabelName = 'P-NATCAB-LS'
$thisLabelHeaderFooterText = 'PROTECTED//NATIONAL CABINET//Legislative-Secrecy'
$thisLabelDisplayName = 'NATIONAL CABINET Legislative-Secrecy'
$desc = 'Valuable, important and sensitive information. Compromise of PROTECTED information would be expected to cause damage to the national interest, organisations or individuals.'
$x_prot = "VER=2018.5, NS=gov.au, SEC=PROTECTED, CAVEAT=NATIONAL CABINET, ACCESS=Legislative-Secrecy"
$subject = " [SEC=PROTECTED, CAVEAT=NATIONAL CABINET, ACCESS=Legislative-Secrecy]"
New-PSPFConfig -thisPSPFLabelName $thisLabelName -thisPSPFLabelHeaderFooterText $thisLabelHeaderFooterText -desc $desc `
-x_prot $x_prot -parentGuid $parentGuid -subject $subject -thisPSPFLabelDisplayName $thisLabelDisplayName

# PROTECTED//NATIONAL CABINET//Personal-Privacy
$thisLabelName = 'P-NATCAB-PP'
$thisLabelHeaderFooterText = 'PROTECTED//NATIONAL CABINET//Personal-Privacy'
$thisLabelDisplayName = 'NATIONAL CABINET Personal-Privacy'
$desc = 'Valuable, important and sensitive information. Compromise of PROTECTED information would be expected to cause damage to the national interest, organisations or individuals.'
$x_prot = "VER=2018.5, NS=gov.au, SEC=PROTECTED, CAVEAT=NATIONAL CABINET, ACCESS=Personal-Privacy"
$subject = " [SEC=PROTECTED, CAVEAT=NATIONAL CABINET, ACCESS=Personal-Privacy]"
New-PSPFConfig -thisPSPFLabelName $thisLabelName -thisPSPFLabelHeaderFooterText $thisLabelHeaderFooterText -desc $desc `
-x_prot $x_prot -parentGuid $parentGuid -subject $subject -thisPSPFLabelDisplayName $thisLabelDisplayName





# Publish All Protected labels
$LabelPolicy = "Protected Labels"
$labels = Get-Label | Where-Object {$_.Name -like "P*"} | Select-Object Name

New-LabelPolicy -Labels $labels.name -ExchangeLocation ALL -Name $LabelPolicy
Set-LabelPolicy -Identity $LabelPolicy -AdvancedSettings @{EnableCustomPermissions="False"}
Set-LabelPolicy -Identity $LabelPolicy -AdvancedSettings @{RequireDowngradeJustification="True"}
Set-LabelPolicy -Identity $LabelPolicy -AdvancedSettings @{Mandatory="True"}









