$files = Get-ChildItem -Path "C:\3_Portfolio_Github\QA_Handbook" -Filter "*.md" -Recurse
foreach ($file in $files) {
    if ($file.Name -eq "12 - Templates.md") { continue }
    $content = Get-Content -Path $file.FullName -Raw
    $orig = $content
    $content = $content -replace '12-Templates/12%20-%20Templates\.md', '12%20-%20Templates.md'
    $content = $content -replace '12-Templates/12 - Templates\.md', '12%20-%20Templates.md'
    if ($orig -ne $content) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
    }
}
