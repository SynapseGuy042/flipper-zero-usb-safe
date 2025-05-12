Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

$form = New-Object Windows.Forms.Form
$form.FormBorderStyle = 'None'
$form.WindowState = 'Maximized'
$form.TopMost = $true
$form.BackColor = 'Black'
$form.ShowInTaskbar = $false
$form.Show()

$graphics = $form.CreateGraphics()
$rand = New-Object System.Random

# Load Omni-Man image from desktop
$omniImagePath = "$env:USERPROFILE\Desktop\omni.png"
if (Test-Path $omniImagePath) {
    $omniImage = [System.Drawing.Image]::FromFile($omniImagePath)
}

function Draw-Glitches {
    for ($i = 0; $i -lt 50; $i++) {
        $x = $rand.Next(0, $screenWidth)
        $y = $rand.Next(0, $screenHeight)
        $w = $rand.Next(10, 100)
        $h = $rand.Next(10, 100)
        $color = [System.Drawing.Color]::FromArgb($rand.Next(256), $rand.Next(256), $rand.Next(256))
        $brush = New-Object Drawing.SolidBrush($color)
        $graphics.FillRectangle($brush, $x, $y, $w, $h)
        $brush.Dispose()
    }
}

function Flash-Screen {
    $form.BackColor = [System.Drawing.Color]::FromArgb($rand.Next(256), $rand.Next(256), $rand.Next(256))
}

function Zoom-Tunnel {
    for ($i = 0; $i -lt 10; $i++) {
        $w = $screenWidth - ($i * 30)
        $h = $screenHeight - ($i * 30)
        $x = ($screenWidth - $w) / 2
        $y = ($screenHeight - $h) / 2
        $rect = [System.Drawing.Rectangle]::FromLTRB($x, $y, $x + $w, $y + $h)
        $pen = New-Object Drawing.Pen([System.Drawing.Color]::White, 2)
        $graphics.DrawRectangle($pen, $rect)
        $pen.Dispose()
    }
}

function Draw-Message {
    $fonts = @("Impact", "Comic Sans MS", "Segoe UI", "Courier New")
    $fontSize = $rand.Next(20, 50)
    $font = New-Object Drawing.Font($fonts[$rand.Next(0, $fonts.Length)], $fontSize, [Drawing.FontStyle]::Bold)
    $brush = New-Object Drawing.SolidBrush([System.Drawing.Color]::FromArgb($rand.Next(256), $rand.Next(256), $rand.Next(256)))
    $x = $rand.Next(0, $screenWidth - 500)
    $y = $rand.Next(0, $screenHeight - 100)
    $graphics.DrawString("WHAT WILL YOU HAVE AFTER 500 YEARS?", $font, $brush, $x, $y)
    $font.Dispose()
    $brush.Dispose()
}

function Draw-OmniImage {
    if ($null -ne $omniImage) {
        $imgW = $rand.Next(150, 400)
        $imgH = $rand.Next(150, 400)
        $imgX = $rand.Next(0, $screenWidth - $imgW)
        $imgY = $rand.Next(0, $screenHeight - $imgH)
        $graphics.DrawImage($omniImage, $imgX, $imgY, $imgW, $imgH)
    }
}

# Main loop
while ($true) {
    Flash-Screen
    Draw-Glitches
    if ($rand.Next(0, 3) -eq 0) { Draw-Message }
    if ($rand.Next(0, 2) -eq 0) { Draw-OmniImage }
    Zoom-Tunnel
    Start-Sleep -Milliseconds 100
}
