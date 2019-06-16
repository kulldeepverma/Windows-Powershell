<#
Author          : Kuldeep Verma
Created Date    : 12th Jan, 2018.
Title           : Automate Service Restart using Powershell
Description     : With the help of this script you can schedule to restart service and send the status in email. Only you have to schedule this script in windows scheduler. 
#>

$hostname = hostname
#specify the service name which you wanted to restart.
$oServiceName = '<ServiceName>' 
#sepecify the SMTP server to sent email
$oSMTPServer = '<Hostname of mail server>'
$from = "<SenerEmailID>" 

[string[]]$recipients = @("<EmailId1>", "<EmailId2>", "<EmailId3>")
[string[]]$cc = @("<EmailId1>", "<EmailId2>", "<EmailId3>")
[string[]]$bcc = @("<EmailId1>", "<EmailId2>", "<EmailId3>")

#HTML template for email.
$EmailBody = '<p>Hi there,&nbsp;</p><p>{0} has been restarted successfully on {1}.</p><p><strong>Current Service Status:</strong>{2}</p><p><strong>TimeStamp:</strong>{3}&nbsp;</p><div><div>&nbsp;</div><div>&nbsp;</div><div><em><span style="text-decoration: underline;"><span style="color: #ff0000; text-decoration: underline;">This is a system generated an email, do not reply to this email id.</span></span></em></div></div>'
if (Get-Service $oServiceName -ErrorAction SilentlyContinue) {
    try {
        # Stop service   
        Stop-Service -name $oServiceName -Verbose 
        do { 
            Start-sleep -s 5 
        }  
        until ((get-service $oServiceName).Status -eq 'Stopped') 
  
        # Start service 
        start-Service -name $oServiceName -Verbose 
        do { 
            Start-sleep -s 5 
        }  
        until ((get-service $oServiceName).Status -eq 'Running') 
  
        # Send confirmation that service has restarted successfully 
        $body = $EmailBody -f $oServiceName, $hostname, (get-service $oServiceName).Status , (Get-Date -Format g)
        $Subject = "PS1 Alert- {0} Service Restarted Successfully on {1} on {2}" -f $oServiceName, $hostname, (Get-Date -Format g)
        Send-MailMessage -To $recipients -Subject $Subject -Body $body -BodyAsHtml -From $from -Cc $cc -Bcc $bcc -SmtpServer $oSMTPServer
    }
    catch {
        $error = $_.Exception.Message 
        $Subject = "PS1 Alert-There was some internal error $hostname - Daily Status on: " + (Get-Date -Format g)  
        $body = "There was some internal error on $hostname.Please check this error $error" 
        Start-Sleep -s 5 
        Send-MailMessage -To $recipients -Subject $Subject -Body $body -From $from -SmtpServer $oSMTPServer
    }
}
else {
    Write-Host $oServiceName" service not available in host"$hostname -ForegroundColor Red
}

  
