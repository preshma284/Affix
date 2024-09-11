# Ensure the ImportExcel module is installed
if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    Install-Module -Name ImportExcel -Scope CurrentUser -Force
}

# Get the folder path as input
$folderPath = Read-Host "Enter the folder path"

# Get all .al files in the folder
$files = Get-ChildItem $folderPath -Filter *.al

# Create a new Excel file
$excelFilePath = "C:\Users\preshma\OneDrive - Computer Enterprises Inc\Affix\TableEXT-Prefix.xlsx"
if (Test-Path $excelFilePath) {
    Remove-Item $excelFilePath
}
$excelData = @()

foreach ($file in $files) {
    # Read the first line from the file
    $firstLine = Get-Content $file.FullName -First 1

    # Use regex to find and extract the content within double quotes
    $pattern = 'tableextension\s+\d+\s+"([^"]+)"\s+extends\s+"([^"]+)"'
    if ($firstLine -match $pattern) {
        $extensionName = $matches[1]
        $baseTableName = $matches[2]

        # Check if the table name already starts with QB
        if ($contentWithinQuotes -like "QB*") {
            #Write-Output "Table name in file $($file.Name) already starts with QB"
            $modifiedContent = $contentWithinQuotes -replace "QB", "QBU"
            $modifiedContent
            $modifiedContent = $modifiedContent -replace "QBU_","QBU "
            $modifiedContent
        } else {
            $baseTableName = "QBU " + $baseTableName + "Ext"
        }

        # Replace the original content within quotes with the modified content in the first line
        $modifiedFirstLine = $firstLine -replace $extensionName, $baseTableName
        Write-Output "Modified first line: $modifiedFirstLine"
        # Read the entire file content
        $fileContent = Get-Content $file.FullName

        # Replace the first line with the modified first line
        $fileContent[0] = $modifiedFirstLine

        # Write the modified content back to the file
        Set-Content -Path $file.FullName -Value $fileContent

        # Add data to the Excel array
        $excelData += [PSCustomObject]@{
            OriginalContent = $extensionName
            ModifiedContent = $baseTableName
        }
    } else {
        Write-Output "No content within double quotes found in the first line of file $($file.Name)."
    }
}

# Export the data to an Excel file
$excelData | Export-Excel -Path $excelFilePath -AutoSize
Write-Output "Excel file created at $excelFilePath"