$content = Get-Content -Path "C:\3_Portfolio_Github\QA_Handbook\12 - Templates.md" -Raw

$content = [System.Text.RegularExpressions.Regex]::Replace($content, '\| (12-Templates/[^| ]+) \|', {
    param($match)
    return "| [" + $match.Groups[1].Value + "](" + $match.Groups[1].Value + ") |"
})

$content = [System.Text.RegularExpressions.Regex]::Replace($content, '\]\(([0-9]{2}-[a-zA-Z-]+/[A-Z_a-z-]+\.md)\)', {
    param($match)
    return "](12-Templates/" + $match.Groups[1].Value + ")"
})

$content = [System.Text.RegularExpressions.Regex]::Replace($content, '\]\([0-9]{2}-[a-zA-Z-]+/([0-9]{2} - [^.]+\.md)\)', {
    param($match)
    $filename = $match.Groups[1].Value
    $filename = $filename -replace ' ', '%20'
    return "](" + $filename + ")"
})

Set-Content -Path "C:\3_Portfolio_Github\QA_Handbook\12 - Templates.md" -Value $content -NoNewline
