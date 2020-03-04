function grep {
    param (
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
        if (-Not ($path -Or $input)) {
            Write-Error 'Invalid Argument Error!'
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
                } elseif ($input) {
                    # case insensitive, not match, input stream(pipeline)
                    $input | Out-String -Stream | Select-String -Pattern $expresion -NotMatch
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
                } elseif ($input) {
                    Write-Host input
                    # case insensitive, match, input stream(pipeline)
                    $input | Out-String -Stream | Select-String -Pattern $expresion
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
                } elseif ($input) {
                    # # case sensitive, not match, input stream(pipeline)
                    $input | Out-String -Stream | Select-String -Pattern $expresion -CaseSensitive -NotMatch
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
                } elseif ($input) {
                    # case sensitive, match, input stream(pipeline)
                    $input | Out-String -Stream | Select-String -Pattern $expresion -CaseSensitive
                }
            }
        }
    }
    end {
        if ($h -Or $help) {
            Write-Host "Usage:"
            Write-Host "`tgrep `$expresion `$path [-i] [-v] [-r [-Include `$include] [-Exclude `$exclude]]"
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
