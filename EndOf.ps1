(Get-Process -Id $pid).PriorityClass = "Idle"

$starting = [System.DateTime]::UtcNow
$day = $starting.Date.ToString("yyyy-MM-dd")
$week = $starting.Date.AddDays(-$starting.DayOfWeek).ToString("yyyy-MM-dd")

Set-Location $PSScriptRoot

[System.IO.File]::WriteAllText("EndOf.Starting.txt", $starting.ToString("yyyy-MM-dd HH:mm:ss.fff"))

if ([System.IO.File]::Exists("EndOf.Day.txt") -and $day -eq [System.IO.File]::ReadAllText("EndOf.Day.txt"))
{
    $dayChanged = $false;
}
else
{
    $dayChanged = $true;
}
if ([System.IO.File]::Exists("EndOf.Week.txt") -and $week -eq [System.IO.File]::ReadAllText("EndOf.Week.txt"))
{
    $weekChanged = $false;
}
else
{
    $weekChanged = $true;
}

if ($dayChanged)
{
    Set-Location $PSScriptRoot
    & .\EndOfDay.ps1
}

if ($weekChanged)
{
    Set-Location $PSScriptRoot
    & .\EndOfWeek.ps1
}

Set-Location $PSScriptRoot

if ($dayChanged)
{
    [System.IO.File]::WriteAllText("EndOf.Day.txt", $day)
}

if ($weekChanged)
{
    [System.IO.File]::WriteAllText("EndOf.Week.txt", $week)
}

[System.IO.File]::WriteAllText("EndOf.Finished.txt", [System.DateTime]::UtcNow.ToString("yyyy-MM-dd HH:mm:ss.fff"))
