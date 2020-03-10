# alias/function
####################

# change cd linux like
Remove-Item Alias:cd
function cd {
    if ($args.Length -gt 0) {
        Set-Location $args[0]
    }
    elseif ($Env:HOME) {
        Set-Location $Env:HOME
    }
    elseif ($HOME) {
        Set-Location $HOME
    }
    elseif ($Env:HOMEPATH -And $Env:HOMEDRIVE) {
        Set-Location $Env:HOMEDRIVE$Env:HOMEPATH
    }
    else {
        Write-Output "no home directory"
    }
}

function Set-Location-Parent-Directory {
    Set-Location ..
}
Set-Alias .. Set-Location-Parent-Directory

Remove-Item Alias:pwd
function Show-Working-Directory {
    (Get-Location).Path
}
Set-Alias pwd Show-Working-Directory

# sudo command
function Invoke-CommandRunAs {
    $cd = (Get-Location).Path
    $commands = "Set-Location `"$cd`"; Write-Host `"[Administrator] $cd> $args`"; $args; Pause; exit"
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($commands)
    $encodedCommand = [Convert]::ToBase64String($bytes)
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit", "-encodedCommand", $encodedCommand
}
Set-Alias sudo Invoke-CommandRunAs

# su command
function Start-RunAs {
    $cd = (Get-Location).Path
    $commands = "Set-Location `"$cd`"; (Get-Host).UI.RawUI.WindowTitle += `" [Administrator]`""
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($commands)
    $encodedCommand = [Convert]::ToBase64String($bytes)
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit", "-encodedCommand", $encodedCommand
}
Set-Alias su Start-RunAs

# which
function which {
    Param([switch]$Alias, [switch]$Function)
    if ($args.Length -gt 0) {
        $c = $args[0]
        if ($Alias) {
            Get-Alias $args[0] 2>$null | % { $_.Name, $_.Definition -join "`t" }
        } elseif ($Function) {
            (Get-ChildItem -path function: | ? { $_.Name -eq $c}).Name
            return
        } else {
            (Get-Command $args[0] 2>$null).source
        }
    }
}

# override clip command because of barbled
function clip {
    # switch output encoding
    $OutputEncoding = [System.Text.Encoding]::GetEncoding("shift_jis")
    # get pipeline input
    $buffer = ($input | Out-String)
    # remove last crlf
    $buffer.Substring(0, $buffer.Length - 2) | clip.exe
}

# touch
function touch {
    if ($args.Length -gt 0) {
        for ($i = 0; $i -lt $args.Length; ++$i) {
            # file/directory exist?
            if (Test-Path $args[$i]) {
                # file or directory?
                if (-Not (Get-Item $args[$i]).PSIsContainer) {
                    # update timestamp
                    (Get-Item $args[$i]).LastWriteTime = (Get-Date)
                }
            }
            else {
                # create new empty file
                New-Item -ItemType file $args[$i]
            }
        }
    }
}

# grep
. "C:\Workspace\powershell\script\grep.ps1"

# out-file in utf8
. "C:\Workspace\powershell\script\out-utf8n.ps1"

# head/tial
. "C:\Workspace\powershell\script\head.ps1"
. "C:\Workspace\powershell\script\tail.ps1"

# less
. "C:\Workspace\powershell\script\less.ps1"

# alias
Set-Alias la Get-ChildItem -Force
Set-Alias ll Get-ChildItem
Set-Alias l Get-ChildItem
Set-Alias jobs Get-Job
Set-Alias py python
Remove-Item alias:curl
Remove-Item alias:wget
Set-Alias d docker
Set-Alias dcm docker-compose
Set-Alias g git
Set-Alias tg tgit

# path
####################

# editor
function xy {
    C:\Tools\xyzzy\xyzzycli.exe $args
}

function vi {
    C:\Tools\vim\vim.exe $args
}
function vim {
    C:\Tools\vim\vim.exe $args
}
function view {
    C:\Tools\vim\vim.exe -R $args
}

# jq
function jq {
    C:\Tools\jq\jq-win64.exe
}

# clip2text
function clip2text {
    C:\Tools\Clip2Text\clip2text.ps1
}

function phppath {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $Version = "7.0"
    )
    if ($Version -eq "7.0") {
        $Env:Path += ";C:\Tools\php\php-7.0.33-Win32-VC14-x64"
    } else {
        $Env:Path += ";C:\Tools\php\php-7.0.33-Win32-VC14-x64"
    }
}

function utilpath {
    $Env:Path += ";C:\Tools\poppler\bin"
    $Env:Path += ";C:\Tools\ImageMagick"
}

# anaconda
####################

function condapath {
    # exec conda initialization
    $ANACONDABASE = (ls Env:\USERPROFILE).Value + "\Anaconda3"
    (& "${ANACONDABASE}\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
    # add path
    # $ANACONDABASE = (ls Env:\USERPROFILE).Value + "\Anaconda3"
    # $Env:Path = "${ANACONDABASE};${ANACONDABASE}\Library\mingw-w64\bin;${ANACONDABASE}\Library\usr\bin;${ANACONDABASE}\Library\bin;${ANACONDABASE}\Scripts;${ANACONDABASE}\bin;${ANACONDABASE}\condabin;$Env:Path"
    # $Env:CONDA_EXE = "${ANACONDABASE}\Scripts\conda.exe"
    # $Env:_CE_M = ""
    # $Env:_CE_CONDA = ""
    # $Env:_CONDA_ROOT = "${ANACONDABASE}"
    # $Env:_CONDA_EXE = "${ANACONDABASE}\Scripts\conda.exe"
    # Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1"
    # conda activate base
}

function act {
    Get-Command conda > $null
    if ($?) {
        conda activate $args[0]
    }
    else {
        Write-Host "conda command not found."
    }
}

function deact {
    Get-Command conda > $null
    if ($?) {
        conda deactivate
        condapath
    }
    else {
        Write-Host "conda command not found."
    }
}

# module
####################

# change policy to make script runable
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# change repository policy to enable installation from PSGallery
# Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
# check repository policy
# Get-PSRepository

# PSReadLine
# Install-Module PSReadLine
Import-Module PSReadLine
$PSReadlineOption = @{
    EditMode  = "Emacs"
    BellStyle = "None"
    #    Colors = @{
    #        "Operator" = "#FFFFFF"
    #        "Parameter" = "#FFFFFF"
    #    }
}
Set-PSReadlineOption @PSReadlineOption
# keybinding
Set-PSReadlineKeyHandler -Key Ctrl+v -Function Paste
Set-PSReadlineKeyHandler -Key Shift+Insert -Function Paste
Set-PSReadlineKeyHandler -Key Ctrl+h -Function BackwardDeleteChar
Set-PSReadlineKeyHandler -Key Ctrl+l -Function ClearScreen

# change prompt for posh-git
function prompt {
    #backup last exit code
    $origLastExitCode = $LASTEXITCODE
    #set current directory on window title
    (Get-Host).UI.RawUI.WindowTitle = "Windows PowerShell " + $pwd

    #get current directory
    $idx = $pwd.ProviderPath.LastIndexof("\") + 1

    #set prompt
    $cdn = $pwd.ProviderPath.Remove(0, $idx)
    Write-Host $cdn -nonewline -ForegroundColor Green
    Write-VcsStatus
    Write-Host " " -nonewline

    #restore last exit code
    $LASTEXITCODE = $origLastExitCode
    "$('>' * ($nestedPromptLevel + 1)) "
}

# posh-git(git-completion)
try {
    # Install-Module posh-git
    Import-Module posh-git

    $Global:TortoiseGitSettings.TortoiseGitCommands.add("d", "diff")
    $Global:TortoiseGitSettings.TortoiseGitCommands.add("l", "log")
}
catch {
    Write-Host "posh-git is not installed"
    Write-Host "Install-Module posh-git"
}
