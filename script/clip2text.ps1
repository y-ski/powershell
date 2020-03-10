$ErrorActionPreference = "Stop"

function main {
    try {
        # is text?
        $textFile = $PSScriptRoot + "\clip.txt"
        $text = Get-Clipboard -Format Text
        if ($text) {
            # save text in utf8 with lf
            $text + "`n" `
            | % { [Text.Encoding]::UTF8.GetBytes($_) } `
            | Add-Content -Path $textFile -Encoding Byte
            $result = showMessageBox -message ("save text`n`n" + $text)
            Get-Content $textFile -Encoding UTF8 -tail 10
            exit
        }

        # is image
        $imgFile = $PSScriptRoot + "\" + $(Get-Date -Format "yyyyMMdd_HHmmss") + ".png"
        $img = Get-Clipboard -Format Image
        if ($img) {
            # save image as date formatt filename
            $img.save($imgFile)
            $result = showMessageBox -message "save image"
            exit
        }

        # neither text nor image
        echo "neither text nor image. may be audio or file list."
        $null = Read-Host "Enter for continue..."
    } catch {
        Write-Host $_
        $null = Read-Host "Enter for continue..."
    }
}

function showMessageBox {
    param (
        [String] $message = "",
        [String] $title = "Message Box",
        [Int] $time = 1,
        [Int] $type = 1
    )

    $messageBox = New-Object -comobject wscript.shell
    $result = $messageBox.popup($message, $time, $title, $type)
    return $result
}

main
