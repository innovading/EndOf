Set-Variable -Name "location" -Value "location" -Scope Global
Set-Variable -Name "threads" -Value 1 -Scope Global

(Get-Process -Id $pid).priorityclass = "Idle"
