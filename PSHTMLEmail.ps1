<#
Author          : Kuldeep Verma
Created Date    : 2nd Jan, 2018.
Title           : Send HTML Email using powershell
Description     : It will help to send HTML email body using powershell. 
#>

$smtp = "<SMTPSERVERHostName>"
#To specify multiple recipients declare in the array like below
[string[]]$recipients  = @("<EmailId1>","<EmailId2>","<EmailId3>")
#declare as below in case of single recipient 
#$recipients = "<EmailId>"
$from = "<SpecifySenderEmail>"
$subject = "HTML Email Test" 
$body = "<p>Hi there,&nbsp;</p>"
$body += '<p>This is just a test email. <strong><span style="color: #008000;">You have received email successfully.</span></strong></p>'
send-MailMessage -SmtpServer $smtp -To $recipients -From $from -Subject $subject -Body $body -BodyAsHtml -Priority high
Write-Host "Email sent succesfully!" -ForegroundColor Green
