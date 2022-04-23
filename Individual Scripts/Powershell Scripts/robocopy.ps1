

$S = Read-Host -Prompt 'Input Source Directory'
$D = Read-Host -Prompt 'Input Destination Directory'
robocopy $S $D /e /w:5 /r:2 /COPY:DATSOU /DCOPY:DAT /MT