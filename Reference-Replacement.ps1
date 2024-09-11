# Ensure the ImportExcel module is installed
# Install-Module -Name ImportExcel -Scope CurrentUser

# Specify the path to the Excel file
$excelFilePath = "C:\Users\preshma\PrefixSuffix\Prefix-CustomTables.xlsx"

# Read the Excel file to get mappings
$excelData = Import-Excel -Path $excelFilePath

# Get the folder path as input
$rootFolderPath = Read-Host "Enter the folder path"

# Get all .al files in the folder
$files = Get-ChildItem $rootFolderPath -Recurse -File

foreach ($file in $files) {
    # Read the entire file content
    $fileContent = Get-Content $file.FullName -Raw

    # Iterate through each mapping in the Excel data
    foreach ($row in $excelData) {
        $contentWithinQuotes = $row.'Content within Quotes'
        $modifiedContent = $row.'Modified Content'

        # Use regex to find and replace the content within quotes if it matches
        $pattern = '"'+[regex]::Escape($contentWithinQuotes)+'"'
        if ($fileContent -match $pattern) {
            $fileContent = $fileContent -replace $pattern, "`"$modifiedContent`""
        }
    }

    # Write the modified content back to the file
    Set-Content -Path $file.FullName -Value $fileContent
}

Write-Output "All files processed."