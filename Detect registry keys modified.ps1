# Registry key to monitor
$keyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"

# Set up event filter and query
$filter = [Microsoft.Win32.RegistryKeyChangeEvent]::new($keyPath)
$query = New-Object System.Management.EventQuery
$query.EventClassName = "__InstanceModificationEvent"
$query.WithinInterval = "00:00:01"
$query.Condition = $filter.QueryString

# Create event watcher
$watcher = New-Object System.Management.ManagementEventWatcher
$watcher.Query = $query

# Start monitoring registry key for changes
$watcher.Start() | Out-Null

# Loop to wait for events and show alerts
while ($true) {
    $event = $watcher.WaitForNextEvent()
    $message = "Registry key '$($event.TargetInstance.keyName)' was modified by $($event.TargetInstance.UserName)"
    Write-Host $message
    # Send alert through email, text message, or other means
    # Example: Send email alert using Send-MailMessage cmdlet
    Send-MailMessage -To "admin@example.com" -From "alerts@example.com" -Subject "Registry Change Detected" -Body $message -SmtpServer "smtp.example.com"
}
