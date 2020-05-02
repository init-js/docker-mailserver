#!/usr/bin/env python2.7

# Import smtplib for the actual sending function
import smtplib

# For guessing MIME type
import mimetypes

# Import the email modules we'll need
import email
import email.mime.application

# Create a text/plain message
msg = email.mime.Multipart.MIMEMultipart()
msg['Subject'] = 'Greetings'
msg['From'] = 'jslegare@gmail.com'
msg['To'] = 'foo@example.com'

# The main body is just another attachment
body = email.mime.Text.MIMEText("""Hello, how are you? I am fine.
This is a rather nice letter, don't you think?""")
msg.attach(body)

# PDF attachment
filename='eicar.txt'
fp=open(filename,'rb')
att = email.mime.application.MIMEApplication(fp.read())
fp.close()
att.add_header('Content-Disposition','attachment',filename=filename)
msg.attach(att)

# send via Gmail server
# NOTE: my ISP, Centurylink, seems to be automatically rewriting
# port 25 packets to be port 587 and it is trashing port 587 packets.
# So, I use the default port 25, but I authenticate.
s = smtplib.SMTP('localhost:10024')
#s.starttlDs()
#s.login('xyz@gDmail.com','xyzpassword')
s.sendmail('foo@example.com',['foo@example.com'], msg.as_string())
s.quit()
