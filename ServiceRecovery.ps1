[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True,Position=1)]
		[string]$phase,
	[Parameter(Mandatory=$False)]
		[string]$service
)

if ($phase -eq "Install") { #This will Install the script to a list of remote servers
	$ServerList = ".\ServerList.txt" # List of servers to modify
	$Computers = Get-Content $ServerList # Pull that list into memeory
	$Services = @("Service1", "Service2") # These are the services you'd like to modify
	foreach($computer in $Computers) {
		foreach ($ServiceName in $Services) {
			$reset = "86400" # When to reset the reset counter. 86400 = 1 Day
			$actions = "restart/60000/restart/60000/run/60000" # The actions to perform
			$command = "`"Powershell C:\Scripts\ServiceRecovery.ps1 Alert -service $ServiceName`"" # Run Action
			
			sc.exe \\$computer failure $ServiceName reset= $reset  actions= $actions command= $command # This is the SC Command to remotely set the services
		}
		$PWD = get-location #Get the working directory
		robocopy $PWD \\$computer\c$\Scripts ServiceRecovery.ps1 /nfl /ndl /njh /njs /ns /nc /np #Copy the script to the sever
	}
} elseif ($phase -eq "Alert") { #This will actually send an alert
	$SMTPServer = "smtp.example.com" # SMTP Server, obviously
	$AlertAddress = "alert@example.com" # Address to Alert
	$address = $env:COMPUTERNAME + "@example.com" # From Address
	$subject = $service + " has failed on " + $env:COMPUTERNAME # Subject Line
	$body =  "Please restart the " + $service + " Service on server " + $env:COMPUTERNAME # Message Body
	
	Send-MailMessage -To $AlertAddress -Subject $subject -Body $body -SmtpServer $SMTPServer -From $address # Send an email!
}