function grep {
    param (
        [Parameter(ValueFromPipeline=$True)]
        [string[]] $stream,
        [Parameter(Position=1)]
        [string] $expresion,
        [Parameter(Position=2)]
        [string] $path,
        [Parameter()]
        [string] $include = "",
        [string] $exclude = "",
        [switch] $i,
        [switch] $v,
        [switch] $r,
        [switch] $h,
        [switch] $help
    )
    begin {
    }
    process {
        if ($h -Or $help) {
            return
        }
        if ((-Not $file) -And (-Not $stream)) {
            $h = $True
            return
        }
        if ($i) {
            # case insensitive
            if ($v) {
                # case insensitive, not match
                if ($path) {
                    # case insensitive, not match, file/directory
                    if ($r) {
                        # case insensitive, not match, directory recursive
                        Get-ChildItem $path -Include $include -Exclude $exclude -Recurse -Force -File | Select-String -Pattern $expresion -NotMatch
                    } else {
                        # # case insensitive, not match, file
                        Select-String $path -Pattern $expresion -NotMatch
                    }
                } elseif ($stream) {
                    # case insensitive, not match, stream(pipe)
                    Write-Output $stream | Select-String -Pattern $expresion -NotMatch
                }
            } else {
                # case insensitive, match
                if ($path) {
                    # case insensitive, match, file/directory
                    if ($r) {
                        # case insensitive, match, directory recursive
                        Get-ChildItem $path -Include $include -Exclude $exclude -Recurse -Force -File | Select-String -Pattern $expresion
                    } else {
                        # case insensitive, match, file
                        Select-String $path -Pattern $expresion
                    }
                } elseif ($stream) {
                    # case insensitive, match, stream(pipe)
                    Write-Output $stream | Select-String -Pattern $expresion
                }
            }
        } else {
            # case sensitive
            if ($v) {
                # case sensitive, not match
                if ($path) {
                    # case sensitive, not match, file/directory
                    if ($r) {
                        # case sensitive, not match, directory recursive
                        Get-ChildItem $path -Include $include -Exclude $exclude -Recurse -Force -File | Select-String -Pattern $expresion -CaseSensitive -NotMatch
                    } else {
                        # case sensitive, not match, file
                        Select-String $path -Pattern $expresion -CaseSensitive -NotMatch
                    }
                } elseif ($stream) {
                    # # case sensitive, not match, stream(pipe)
                    Write-Output $stream | Select-String -Pattern $expresion -CaseSensitive -NotMatch
                }
            } else {
                # case sensitive, match
                if ($path) {
                    # case sensitive, match, file/directory
                    if ($r) {
                        # case sensitive, match, directory recursive
                        Get-ChildItem $path -Include $include -Exclude $exclude -Recurse -Force -File | Select-String -Pattern $expresion -CaseSensitive
                    } else {
                        # case sensitive, match, file
                        Select-String $path -Pattern $expresion -CaseSensitive
                    }
                } elseif ($stream) {
                    # case sensitive, match, stream(pipe)
                    Write-Output $stream | Select-String -Pattern $expresion -CaseSensitive
                }
            }
        }
    }
    end {
        if ($h -Or $help) {
            Write-Host "Usage:"
            Write-Host "`tgrep `$path `$expresion [-i] [-v] [-r [-Include `$include] [-Exclude `$exclude]]"
            Write-Host "`tGet-Content `$path | grep `$expresion [-i] [-v]"
            Write-Host "Options:"
            Write-Host "`t-i: case insensitive"
            Write-Host "`t-v: not match"
            Write-Host "`t-r: recursively"
            Write-Host "`t-Include: with recursively, include file name pattern w/wo wildcard."
            Write-Host "`t-Exclude: with recursively, exclude file name pattern w/wo wildcard."
            Write-Host "Examples:"
            Write-Host "`tgrep expresion .\filename.txt -i"
            Write-Host "`tgrep expresion ./ -i -r -Exclude `".git`""
        }
    }
}
