ServiceRecovery
===============

Batch configure the Service Recovery Options for Windows Servers. Will email upon subsequent failures.
To update servers:
[PS]>ServiceRecovery.ps1 Install

To send an email:
[PS]>ServiceRecovery.ps1 Alert -Service ServiceName

![Before and After](BeforeAfter.PNG "Before and After")