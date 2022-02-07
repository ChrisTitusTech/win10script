#Gets CPU Logical Processor Count
$CPUs = (wmic cpu get NumberOfLogicalProcessors | Select-String -NotMatch NumberOfLogicalProcessors)
$num = 0
foreach($line in $CPUs){
    if($num -eq 1){
        $CPUs = $line
    }
    $num++
}


$S = Read-Host -Prompt 'Input Source Directory'
$D = Read-Host -Prompt 'Input Destination Directory'
robocopy $S $D /e /w:5 /r:2 /COPY:DATSOU /DCOPY:DAT /MT:$CPUs