function tail {
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $path,
        [Parameter()]
        [int] $n = 10,
        [switch] $f
    )
    begin { }
    process {
        if (Test-Path $path) {
            if ($f) {
                Get-Content $path -Tail $n -Wait
            } else {
                Get-Content $path -Tail $n
            }
        } else {
            Write-Host "not found: $path"
        }
    }
    end { }
}
