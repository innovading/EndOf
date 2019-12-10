Set-Variable -Name "location" -Value "location" -Scope Global
Set-Variable -Name "threads" -Value 1 -Scope Global

$endOfDays = @( )

$endOfWeeks = @( )

(Get-Process -Id $pid).priorityclass = "Idle"

Set-Location $PSScriptRoot
$now = [System.DateTime]::UtcNow.Date
$day = $now.ToString("yyyy-MM-dd")
if ([System.IO.File]::Exists("EndOfDay.txt") -and $day -eq [System.IO.File]::ReadAllText("EndOfDay.txt"))
{
    $dayChanged = $false;
}
else
{
    $dayChanged = $true;
}

if ($dayChanged)
{
    foreach ($location in $endOfDays)
    {
        Set-Location $location
        & .\EndOfDay.ps1
    }
}

Set-Location $PSScriptRoot
$now = [System.DateTime]::UtcNow.Date
$week = $now.AddDays(-$now.DayOfWeek).ToString("yyyy-MM-dd")
if ([System.IO.File]::Exists("EndOfWeek.txt") -and $week -eq [System.IO.File]::ReadAllText("EndOfWeek.txt"))
{
    $weekChanged = $false;
}
else
{
    $weekChanged = $true;
}

if ($weekChanged)
{
    foreach ($location in $endOfWeeks)
    {
        Set-Location $location
        & .\EndOfWeek.ps1
    }
}

if ($dayChanged)
{
    [System.IO.File]::WriteAllText("EndOfDay.txt", $day)
}

if ($weekChanged)
{
    [System.IO.File]::WriteAllText("EndOfWeek.txt", $week)
}
