<#
Author          : Kuldeep Verma
Created Date    : 16 th July, 2020.
Title           : Install and unistall DLL
Description     : Simple powershell to install and unistall dll from GAC , IIS reset is required to replicate the change. 
#>

#replace it with your dll path 
$dllPath ="C:\temp\FileName.dll" 
[System.Reflection.Assembly]::Load("System.EnterpriseServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")            
$publish = New-Object System.EnterpriseServices.Internal.Publish      

#to unistall dll from GAC
$publish.GacRemove($dllPath)
iisreset

#to install dll from GAC
$publish.GacInstall($dllPath)
iisreset
