# Define the email parameters
$to = "scott.smith@segra.com"
$from = "scott.smith@segra.com"
$subject = "Test Email"
$body = "This is a test email sent using PowerShell."

# Create a credential object for the SMTP server
$smtpCredential = New-Object System.Management.Automation.PSCredential("domain\username", (ConvertTo-SecureString "password" -AsPlainText -Force))

# Define the SMTP server and port for Exchange Server
$smtpServer = "mxrelay.lumosnet.com"
$smtpPort = 25

# Create the email message object
$mailMessage = @{
    To = $to
    From = $from
    Subject = $subject
    Body = $body
    SmtpServer = $smtpServer
   # SmtpPort = $smtpPort
    UseSsl = $false
    Credential = $smtpCredential
}

# Send the email
Send-MailMessage @mailMessage
