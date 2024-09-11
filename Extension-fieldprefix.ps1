# Ensure the ImportExcel module is installed
if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    Install-Module -Name ImportExcel -Scope CurrentUser -Force
}

# Get the folder path as input
$folderPath = Read-Host "Enter the folder path"

# Get all .al files in the folder
$files = Get-ChildItem $folderPath -Filter *.al

# Create a new Excel file
$excelFilePath = "C:\Users\preshma\OneDrive - Computer Enterprises Inc\Affix\TableEXT-Field.xlsx"
if (Test-Path $excelFilePath) {
    Remove-Item $excelFilePath
}
$excelData = @()

foreach ($file in $files) {
    # Read the entire file content
    $fileContent = Get-Content $file.FullName -Raw

    # Use regex to find and extract the content within double quotes
    $pattern = 'field\(\d+;"([^"]+)";.*\)'
    $matches = [regex]::Matches($fileContent, $pattern)

    foreach ($match in $matches) {
        $originalLine = $match.Value
        $originalContent = $match.Groups[1].Value
        $originalLine
        $originalContent
        # Check if the field name already starts with QB
        if ($originalContent -like "QB*") {
            $modifiedContent = $originalContent -replace "QB", "QBU"
            $modifiedContent = $modifiedContent -replace "QBU_","QBU "
        } else {
            $modifiedContent = "QBU " + $originalContent
        }

        # Modify the matched line with the modified content
        $modifiedLine = $originalLine -replace [regex]::Escape($originalContent), $modifiedContent
        $modifiedLine
        # Replace the original line with the modified line in the file content
        $fileContent = $fileContent -replace [regex]::Escape($originalLine), ($modifiedLine)

        # Add data to the Excel array
        $excelData += [PSCustomObject]@{
            OriginalContent = $originalContent
            ModifiedContent = $modifiedContent
        }
    }

    # Write the modified content back to the file
    Set-Content -Path $file.FullName -Value $fileContent
    Write-Output "Modified file content written back to $($file.Name)"
}

# Export the data to an Excel file
$excelData | Export-Excel -Path $excelFilePath -AutoSize
Write-Output "Excel file created at $excelFilePath"