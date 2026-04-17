[CmdletBinding()]
param(
    [double]$Size = 100,
    [double]$OriginX = 0,
    [double]$OriginY = 0,
    [string[]]$ProgIds = @(
        "AutoCAD.Application.25.1",
        "AutoCAD.Application.25",
        "AutoCAD.Application.24",
        "AutoCAD.Application.20",
        "AutoCAD.Application"
    )
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-OpenAutoCADApplication {
    param(
        [string[]]$CandidateProgIds
    )

    foreach ($progId in $CandidateProgIds) {
        try {
            $app = [System.Runtime.InteropServices.Marshal]::GetActiveObject($progId)
            if ($null -ne $app) {
                return [pscustomobject]@{
                    ProgId = $progId
                    App = $app
                }
            }
        }
        catch {
            continue
        }
    }

    throw "Could not attach to a running AutoCAD instance. Open AutoCAD Mechanical 2026 first."
}

if ($Size -le 0) {
    throw "Size must be greater than zero."
}

$connection = Get-OpenAutoCADApplication -CandidateProgIds $ProgIds
$app = $connection.App

try {
    $document = $app.ActiveDocument
}
catch {
    throw "AutoCAD is running, but there is no active document."
}

if ($null -eq $document) {
    throw "AutoCAD is running, but there is no active document."
}

$modelSpace = $document.ModelSpace
$points = New-Object "double[]" 8
$points[0] = $OriginX
$points[1] = $OriginY
$points[2] = $OriginX + $Size
$points[3] = $OriginY
$points[4] = $OriginX + $Size
$points[5] = $OriginY + $Size
$points[6] = $OriginX
$points[7] = $OriginY + $Size

$polyline = $modelSpace.AddLightWeightPolyline($points)
$polyline.Closed = $true
$document.Regen(1)
$app.ZoomExtents()

[pscustomobject]@{
    DocumentName = [string]$document.Name
    ProgId = [string]$connection.ProgId
    Origin = @($OriginX, $OriginY)
    Size = $Size
    Closed = [bool]$polyline.Closed
} | ConvertTo-Json -Compress
