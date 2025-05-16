```
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA -Value 0
git clone https://github.com/mr-narender/windows_dev_setup
cd windows_dev_setup
Set-ExecutionPolicy Bypass -Scope Process -Force
.\install.ps1
```
