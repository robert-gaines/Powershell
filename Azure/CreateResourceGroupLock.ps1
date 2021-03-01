# Connect-AzAccount

New-AZResourceLock -ResourceGroupName NetworkWatcherRG -LockName PSLock -LockLevel CanNotDelete 

<# Will fail ... #>

Remove-AZResourceGroup -Name NetworkWatcherRG

<# Will work ... #>

Remove-AZResourceLock -ResourceGroupName NetworkWatcherRG -LockName PSLock

Remove-AzResourceGroup -Name NetworkWatcherRG 