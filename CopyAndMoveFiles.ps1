<#
Author          : Kuldeep Verma
Created Date    : 13th June, 2019.
Title           : Copy or Move file based on date 
Description     : It will help to copy content from folder to another folder. Based on calculated date. 
#>
$SourcePath ="<Source folder path>"
$DestinationPath= "<Destination folder path>"
$DesitnationDriveLetter= "C"

#caculate date one month older than now
$CalculatedDate = (Get-Date).AddMonths(-1)

<# Sample to calculate date based on day or year 

#caculate date one days older than now
$CalculatedDate = (Get-Date).Adddays(-1)

#caculate date one year older than now
$CalculatedDate = (Get-Date).AddYears(-1)

#>

# finds files older than $CalculatedDate months in source directory and saves as variable
Get-ChildItem -Path $SourcePath -Recurse |
    Where-Object { $_.CreationTime -lt $CalculatedDate } |
    Select-Object -OutVariable MoveFiles

# gets total file size of all files older than CalculatedDate
$FilesSize = ($MoveFiles | Measure-Object -Sum Length).Sum

#check available free space at destination drive. 
[int64]$FreeSpace = (Get-Volume -DriveLetter $DesitnationDriveLetter |
    Select-Object -ExpandProperty SizeRemaining)

# Checking and moving only if destination drive is having enough space. 
If ($FreeSpace -gt $FilesSize) {
    
    Try
    {
        Get-ChildItem -Path $SourcePath -Recurse |
        Where-Object { $_.CreationTime -lt $CalculatedDate } | 
        Move-Item -Destination $DestinationPath
       
        #uncomment below statment if you wanted to only copy content 
        <#
        Get-ChildItem -Path $SourcePath -Recurse |
        Where-Object { $_.CreationTime -lt $CalculatedDate } | 
        Copy-Item -Destination $DestinationPath
        #>
        write-host "Transfer done succesfully!" -ForegroundColor Green
    }
    Catch
    {
        write-host $_.Exception.Message -BackgroundColor Yellow -ForegroundColor Red
        Break
    }
}
else
{
    write-host $DesitnationDriveLetter" drive don't have enough space to tranfer data" -ForegroundColor Red
}