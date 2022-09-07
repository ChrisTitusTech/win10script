while($true){
    $vm = Read-Host 'Please enter the VM name'
    if(Get-VM $vm -ErrorAction SilentlyContinue){ #Checks if entered VM exists
        while($true){
            $horizontal = Read-Host 'Please enter the new horizontal resolution of the VM'
            Try {
                $Null = [convert]::ToInt32($horizontal) #Attempts to convert the input to an integer
                $isString = $False
            }Catch{$isString = $True} #If the input is not an integer, an error is thrown and $isString is set to true
            if($isString){
                Write-Host 'Please enter a valid number'
            }else{
                break #Breaks the inner loop if the input is an integer
            }
        }
        while($true){
            $vertical = Read-Host 'Please enter the new vertical resolution of the VM'
            Try {
                $Null = [convert]::ToInt32($vertical) #Attempts to convert the input to an integer
                $isString = $False
            }Catch{$isString = $True} #If the input is not an integer, an error is thrown and $isString is set to true
            if($isString){
                Write-Host 'Please enter a valid number'
            }else{
                break #Breaks the inner loop if the input is an integer
            }
        }
        break #Breaks the outer loop if the VM exists
    }else{
        Write-Host 'The VM you entered does not exist'
    }
}
Set-VMVideo -VMName $vm -HorizontalResolution $horizontal -VerticalResolution $vertical -ResolutionType Single #Sets the resolution of the VM to the entered values