Codeunit 50372 "File Management 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        Text001: TextConst ENU = 'Default', ESP = 'Gen‚rico';
        Text002: TextConst ENU = 'You must enter a file path.', ESP = 'Debe insertar una ruta de archivo.';
        Text003: TextConst ENU = 'You must enter a file name.', ESP = 'Debe introd. nombre fichero.';
        FileDoesNotExistErr: TextConst ENU = 'The file %1 does not exist.', ESP = 'El fichero %1 no existe.';
        Text006: TextConst ENU = 'Export', ESP = 'Exportar';
        Text007: TextConst ENU = 'Import', ESP = 'Importar';
        PathHelper: DotNet Path;
        [RUNONCLIENT]
        DirectoryHelper: DotNet Directory;
        [RUNONCLIENT]
        ClientFileHelper: DotNet File;
        ServerFileHelper: DotNet File;
        ServerDirectoryHelper: DotNet Directory;
        Text010: TextConst ENU = 'The file %1 has not been uploaded.', ESP = 'No se ha cargado el archivo %1.';
        Text011: TextConst ENU = 'You must specify a source file name.', ESP = 'Debe especificar un nombre de archivo de origen.';
        Text012: TextConst ENU = 'You must specify a target file name.', ESP = 'Debe especificar un nombre de archivo de destino.';
        Text013: TextConst ENU = 'The file name %1 already exists.', ESP = 'El nombre de archivo %1 ya existe.';
        DirectoryDoesNotExistErr: TextConst ENU = 'Directory %1 does not exist.', ESP = 'El directorio %1 no existe.';
        CreatePathQst: TextConst ENU = 'The path %1 does not exist. Do you want to add it now?', ESP = 'La ruta de acceso %1 no existe. ¨Desea agregarla ahora?';
        AllFilesFilterTxt: TextConst ENU = '*.*', ESP = '*.*';
        AllFilesDescriptionTxt: TextConst ENU = 'All Files (*.*)|*.*', ESP = 'Todos los archivos (*.*)|*.*';
        XMLFileType: TextConst ENU = 'XML Files (*.xml)|*.xml', ESP = 'Archivos XML (*.xml)|*.xml';
        WordFileType: TextConst ENU = 'Word Files (*.doc)|*.doc', ESP = 'Archivos de Word (*.doc)|*.doc';
        Word2007FileType: TextConst ENU = '"Word Files (*.docx;*.doc)|*.docx;*.doc"', ESP = '"Archivos de Word (*.docx;*.doc)|*.docx;*.doc"';
        ExcelFileType: TextConst ENU = 'Excel Files (*.xls)|*.xls', ESP = 'Archivos de Excel (*.xls)|*.xls';
        Excel2007FileType: TextConst ENU = '"Excel Files (*.xlsx;*.xls)|*.xlsx;*.xls"', ESP = '"Archivos de Excel (*.xlsx;*.xls)|*.xlsx;*.xls"';
        XSDFileType: TextConst ENU = 'XSD Files (*.xsd)|*.xsd', ESP = 'Archivos XSD (*.xsd)|*.xsd';
        HTMFileType: TextConst ENU = 'HTM Files (*.htm)|*.htm', ESP = 'Archivos HTM (*.htm)|*.htm';
        XSLTFileType: TextConst ENU = 'XSLT Files (*.xslt)|*.xslt', ESP = 'Archivos XSLT (*.xslt)|*.xslt';
        TXTFileType: TextConst ENU = 'Text Files (*.txt)|*.txt', ESP = 'Archivos de texto (*.txt)|*.txt';
        RDLFileTypeTok: TextConst ENU = '"SQL Report Builder (*.rdl;*.rdlc)|*.rdl;*.rdlc"', ESP = '"Generador de informes de SQL (*.rdl;*.rdlc)|*.rdl;*.rdlc"';
        UnsupportedFileExtErr: TextConst ENU = 'Unsupported file extension (.%1). The supported file extensions are (%2).', ESP = 'Extensi¢n de archivo no admitida (.%1). Las extensiones de archivo admitidas son (%2).';
        SingleFilterErr: TextConst ENU = 'Specify a file filter and an extension filter when using this function.', ESP = 'Especifique un filtro de archivo y un filtro de extensi¢n al usar est  funci¢n.';
        InvalidWindowsChrStringTxt: TextConst ENU = '"""#%&*:<>?\/{|}~"', ESP = '"""#%&*:<>?\/{|}~"';
        ZipArchive: DotNet ZipArchive;
        ZipArchiveMode: DotNet ZipArchiveMode;
        DownloadImageTxt: TextConst ENU = 'Download image', ESP = 'Descargar imagen';
        CanNotRunDotNetOnClientErr: TextConst ENU = 'Sorry, this action is not available for the web-based versions of the app. You must use the Windows client.', ESP = 'Esta acci¢n no est  disponible para las versiones basadas en web de la aplicaci¢n. Debe utilizar al cliente de Windows.';
        ChooseFileTitleMsg: TextConst ENU = 'Choose the file to upload.', ESP = 'Elija el archivo que desea cargar.';
        NotAllowedPathErr: TextConst ENU = 'Files outside of the current user''s folder cannot be accessed. Access is denied to file %1.', ESP = 'No se puede acceder a los archivos fuera de la carpeta del usuario actual. Acceso denegado al archivo %1.';


    LOCAL PROCEDURE BLOBExportLocal(VAR InStream: InStream; Name: Text; IsCommonDialog: Boolean): Text;
    VAR
        ToFile: Text;
        Path: Text;
        IsDownloaded: Boolean;
    BEGIN
        IF IsCommonDialog THEN BEGIN
            IF STRPOS(Name, '*') = 0 THEN
                ToFile := Name
            ELSE
                ToFile := DELCHR(INSSTR(Name, Text001, 1), '=', '*');
            Path := PathHelper.GetDirectoryName(ToFile);
            ToFile := GetFileName(ToFile);
        END ELSE BEGIN
            ToFile := ClientTempFileName(GetExtension(Name));
            Path := Magicpath;
        END;
        IsDownloaded := DOWNLOADFROMSTREAM(InStream, Text006, Path, GetToFilterText('', Name), ToFile);
        IF IsDownloaded THEN
            EXIT(ToFile);
        EXIT('');
    END;

    PROCEDURE BLOBExportWithEncoding(VAR TempBlob: codeunit "temp blob"; Name: Text; CommonDialog: Boolean; Encoding: TextEncoding): Text;
    VAR
        NVInStream: InStream;
    BEGIN
        TempBlob.CREATEINSTREAM(NVInStream, Encoding);
        EXIT(BLOBExportLocal(NVInStream, Name, CommonDialog));
    END;

    //[External]
    PROCEDURE BLOBExport(VAR TempBlob: codeunit "temp blob"; Name: Text; CommonDialog: Boolean): Text;
    VAR
        NVInStream: InStream;
    BEGIN
        TempBlob.CREATEINSTREAM(NVInStream);
        EXIT(BLOBExportLocal(NVInStream, Name, CommonDialog));
    END;

    //[Internal]
    PROCEDURE ServerTempFileName(FileExtension: Text) FileName: Text;
    VAR
        TempFile: File;
    BEGIN
        TempFile.CREATETEMPFILE;
        FileName := CreateFileNameWithExtension(TempFile.NAME, FileExtension);
        TempFile.CLOSE;
    END;

    //[Internal]
    PROCEDURE ClientTempFileName(FileExtension: Text) ClientFileName: Text;
    VAR
        TempFile: File;
        ClientTempPath: Text;
    BEGIN
        // Returns the pseudo uniquely generated name of a non existing file in the client temp directory
        TempFile.CREATETEMPFILE;
        ClientFileName := CreateFileNameWithExtension(TempFile.NAME, FileExtension);
        TempFile.CLOSE;
        TempFile.CREATE(ClientFileName);
        TempFile.CLOSE;
        ClientTempPath := GetDirectoryName(DownloadTempFile(ClientFileName));
        IF ERASE(ClientFileName) THEN;
        ClientFileHelper.Delete(ClientTempPath + '\' + PathHelper.GetFileName(ClientFileName));
        ClientFileName := CreateFileNameWithExtension(ClientTempPath + '\' + FORMAT(CREATEGUID), FileExtension);
    END;

    //[Internal]
    PROCEDURE CreateClientTempSubDirectory() ClientDirectory: Text;
    VAR
        ServerFile: File;
        ServerFileName: Text;
    BEGIN
        // Creates a new subdirectory in the client's TEMP folder
        ServerFile.CREATE(CREATEGUID);
        ServerFileName := ServerFile.NAME;
        ServerFile.CLOSE;
        ClientDirectory := GetDirectoryName(DownloadTempFile(ServerFileName));
        IF ERASE(ServerFileName) THEN;
        DeleteClientFile(CombinePath(ClientDirectory, GetFileName(ServerFileName)));
        ClientDirectory := CombinePath(ClientDirectory, CREATEGUID);
        CreateClientDirectory(ClientDirectory);
    END;

    //[External]
    PROCEDURE DownloadTempFile(ServerFileName: Text): Text;
    VAR
        FileName: Text;
        Path: Text;
    BEGIN
        FileName := ServerFileName;
        Path := Magicpath;
        DOWNLOAD(ServerFileName, '', Path, AllFilesDescriptionTxt, FileName);
        EXIT(FileName);
    END;

    //[Internal]
    PROCEDURE UploadFileSilent(ClientFilePath: Text): Text;
    BEGIN
        EXIT(
          UploadFileSilentToServerPath(ClientFilePath, ''));
    END;

    //[Internal]
    PROCEDURE UploadFileSilentToServerPath(ClientFilePath: Text; ServerFilePath: Text): Text;
    VAR
        ClientFileAttributes: DotNet FileAttributes;
        ServerFileName: Text;
        TempClientFile: Text;
        FileName: Text;
        FileExtension: Text;
    BEGIN
        IF NOT CanRunDotNetOnClient THEN
            ERROR(CanNotRunDotNetOnClientErr);

        IF NOT ClientFileHelper.Exists(ClientFilePath) THEN
            ERROR(FileDoesNotExistErr, ClientFilePath);
        FileName := GetFileName(ClientFilePath);
        FileExtension := GetExtension(FileName);

        TempClientFile := ClientTempFileName(FileExtension);
        ClientFileHelper.Copy(ClientFilePath, TempClientFile, TRUE);

        IF ServerFilePath <> '' THEN
            ServerFileName := ServerFilePath
        ELSE
            ServerFileName := ServerTempFileName(FileExtension);

        IF NOT UPLOAD('', Magicpath, AllFilesDescriptionTxt, GetFileName(TempClientFile), ServerFileName) THEN
            ERROR(Text010, ClientFilePath);

        ClientFileHelper.SetAttributes(TempClientFile, ClientFileAttributes.Normal);
        ClientFileHelper.Delete(TempClientFile);
        EXIT(ServerFileName);
    END;

    //[Internal]
    PROCEDURE UploadFileToServer(ClientFilePath: Text): Text;
    BEGIN
        IF CanRunDotNetOnClient THEN
            EXIT(UploadFileSilentToServerPath(ClientFilePath, ''));

        EXIT(UploadFile(ChooseFileTitleMsg, ''));
    END;

    //[Internal]
    PROCEDURE UploadFile(WindowTitle: Text[50]; ClientFileName: Text) ServerFileName: Text;
    VAR
        Filter: Text;
    BEGIN
        Filter := GetToFilterText('', ClientFileName);

        IF PathHelper.GetFileNameWithoutExtension(ClientFileName) = '' THEN
            ClientFileName := '';

        ServerFileName := UploadFileWithFilter(WindowTitle, ClientFileName, Filter, AllFilesFilterTxt);
    END;

    //[Internal]
    PROCEDURE UploadFileWithFilter(WindowTitle: Text[50]; ClientFileName: Text; FileFilter: Text; ExtFilter: Text) ServerFileName: Text;
    VAR
        Uploaded: Boolean;
    BEGIN
        CLEARLASTERROR;

        IF (FileFilter = '') XOR (ExtFilter = '') THEN
            ERROR(SingleFilterErr);

        Uploaded := UPLOAD(WindowTitle, '', FileFilter, ClientFileName, ServerFileName);
        IF Uploaded THEN
            ValidateFileExtension(ClientFileName, ExtFilter);
        IF Uploaded THEN
            EXIT(ServerFileName);

        IF GETLASTERRORTEXT <> '' THEN
            ERROR('%1', GETLASTERRORTEXT);

        EXIT('');
    END;

    //[External]
    PROCEDURE Magicpath(): Text;
    BEGIN
        EXIT('<TEMP>');   // MAGIC PATH makes sure we don't get a prompt
    END;

    //[Internal]
    PROCEDURE DownloadHandler(FromFile: Text; DialogTitle: Text; ToFolder: Text; ToFilter: Text; ToFile: Text): Boolean;
    VAR
        Downloaded: Boolean;
    BEGIN
        OnBeforeDownloadHandler(ToFolder, ToFile, FromFile);

        CLEARLASTERROR;
        Downloaded := DOWNLOAD(FromFile, DialogTitle, ToFolder, ToFilter, ToFile);
        IF NOT Downloaded THEN
            IF GETLASTERRORTEXT <> '' THEN
                ERROR('%1', GETLASTERRORTEXT);
        EXIT(Downloaded);
    END;

    //[Internal]
    PROCEDURE DownloadToFile(ServerFileName: Text; ClientFileName: Text);
    VAR
        TempClientFileName: Text;
    BEGIN
        IF CanRunDotNetOnClient THEN BEGIN
            ValidateFileNames(ServerFileName, ClientFileName);
            TempClientFileName := DownloadTempFile(ServerFileName);
            MoveFile(TempClientFileName, ClientFileName);
        END ELSE
            DownloadHandler(ServerFileName, '', '', '', ClientFileName);
    END;

    //[Internal]
    PROCEDURE AppendAllTextToClientFile(ServerFileName: Text; ClientFileName: Text);
    BEGIN
        ValidateFileNames(ServerFileName, ClientFileName);
        IsAllowedPath(ServerFileName, FALSE);
        ClientFileHelper.AppendAllText(ClientFileName, ServerFileHelper.ReadAllText(ServerFileName));
    END;

    //[Internal]
    PROCEDURE MoveAndRenameClientFile(OldFilePath: Text; NewFileName: Text; NewSubDirectoryName: Text) NewFilePath: Text;
    VAR
        directory: Text;
    BEGIN
        IF OldFilePath = '' THEN
            ERROR(Text002);

        IF NewFileName = '' THEN
            ERROR(Text003);

        IF NOT ClientFileHelper.Exists(OldFilePath) THEN
            ERROR(FileDoesNotExistErr, OldFilePath);

        // Get the directory from the OldFilePath, if directory is empty it will just use the current location.
        directory := GetDirectoryName(OldFilePath);

        // create the sub directory name is name is given
        IF NewSubDirectoryName <> '' THEN BEGIN
            directory := PathHelper.Combine(directory, NewSubDirectoryName);
            DirectoryHelper.CreateDirectory(directory);
        END;

        NewFilePath := PathHelper.Combine(directory, NewFileName);
        MoveFile(OldFilePath, NewFilePath);

        EXIT(NewFilePath);
    END;

    //[Internal]
    PROCEDURE CreateClientFile(FilePathName: Text);
    VAR
        [RUNONCLIENT]
        StreamWriter: DotNet StreamWriter;
    BEGIN
        IF NOT ClientFileHelper.Exists(FilePathName) THEN BEGIN
            StreamWriter := ClientFileHelper.CreateText(FilePathName);
            StreamWriter.Close;
        END;
    END;

    //[Internal]
    PROCEDURE DeleteClientFile(FilePath: Text): Boolean;
    BEGIN
        IF NOT ClientFileHelper.Exists(FilePath) THEN
            EXIT(FALSE);

        ClientFileHelper.Delete(FilePath);
        EXIT(TRUE);
    END;

    //[Internal]
    PROCEDURE CopyClientFile(SourceFileName: Text; DestFileName: Text; OverWrite: Boolean);
    BEGIN
        ClientFileHelper.Copy(SourceFileName, DestFileName, OverWrite);
    END;

    //[Internal]
    PROCEDURE ClientFileExists(FilePath: Text): Boolean;
    BEGIN
        IF NOT CanRunDotNetOnClient THEN
            EXIT(FALSE);
        EXIT(ClientFileHelper.Exists(FilePath));
    END;

    //[Internal]
    PROCEDURE ClientDirectoryExists(DirectoryPath: Text): Boolean;
    BEGIN
        IF NOT CanRunDotNetOnClient THEN
            EXIT(FALSE);
        EXIT(DirectoryHelper.Exists(DirectoryPath));
    END;

    //[Internal]
    PROCEDURE CreateClientDirectory(DirectoryPath: Text);
    BEGIN
        IF NOT ClientDirectoryExists(DirectoryPath) THEN
            DirectoryHelper.CreateDirectory(DirectoryPath);
    END;

    //[Internal]
    PROCEDURE DeleteClientDirectory(DirectoryPath: Text);
    BEGIN
        IF ClientDirectoryExists(DirectoryPath) THEN
            DirectoryHelper.Delete(DirectoryPath, TRUE);
    END;

    //[Internal]
    PROCEDURE UploadClientDirectorySilent(DirectoryPath: Text; FileExtensionFilter: Text; IncludeSubDirectories: Boolean) ServerDirectoryPath: Text;
    VAR
        [RUNONCLIENT]
        SearchOption: DotNet SearchOption;
        [RUNONCLIENT]
        ArrayHelper: DotNet Array;
        [RUNONCLIENT]
        ClientFilePath: DotNet String;
        ServerFilePath: Text;
        RelativeServerPath: Text;
        i: Integer;
        ArrayLength: Integer;
    BEGIN
        IF NOT ClientDirectoryExists(DirectoryPath) THEN
            ERROR(DirectoryDoesNotExistErr, DirectoryPath);

        IF IncludeSubDirectories THEN
            ArrayHelper := DirectoryHelper.GetFiles(DirectoryPath, FileExtensionFilter, SearchOption.AllDirectories)
        ELSE
            ArrayHelper := DirectoryHelper.GetFiles(DirectoryPath, FileExtensionFilter, SearchOption.TopDirectoryOnly);

        ArrayLength := ArrayHelper.GetLength(0);

        IF ArrayLength = 0 THEN
            EXIT;

        ServerDirectoryPath := ServerCreateTempSubDirectory;

        FOR i := 1 TO ArrayLength DO BEGIN
            ClientFilePath := ArrayHelper.GetValue(i - 1);
            RelativeServerPath := ClientFilePath.Replace(DirectoryPath, '');
            IF PathHelper.IsPathRooted(RelativeServerPath) THEN
                RelativeServerPath := DELCHR(RelativeServerPath, '<', '\');
            ServerFilePath := CombinePath(ServerDirectoryPath, RelativeServerPath);
            ServerCreateDirectory(GetDirectoryName(ServerFilePath));
            UploadFileSilentToServerPath(ClientFilePath, ServerFilePath);
        END;
    END;

    //[Internal]
    PROCEDURE MoveFile(SourceFileName: Text; TargetFileName: Text);
    BEGIN
        // System.IO.File.Move is not used due to a known issue in KB310316
        IF NOT ClientFileHelper.Exists(SourceFileName) THEN
            ERROR(FileDoesNotExistErr, SourceFileName);

        IF UPPERCASE(SourceFileName) = UPPERCASE(TargetFileName) THEN
            EXIT;

        ValidateClientPath(GetDirectoryName(TargetFileName));

        DeleteClientFile(TargetFileName);
        ClientFileHelper.Copy(SourceFileName, TargetFileName);
        ClientFileHelper.Delete(SourceFileName);
    END;

    //[Internal]
    PROCEDURE DeleteServerFile(FilePath: Text): Boolean;
    BEGIN
        IsAllowedPath(FilePath, FALSE);
        IF NOT EXISTS(FilePath) THEN
            EXIT(FALSE);

        ServerFileHelper.Delete(FilePath);
        EXIT(TRUE);
    END;

    //[Internal]
    PROCEDURE ServerDirectoryExists(DirectoryPath: Text): Boolean;
    BEGIN
        EXIT(ServerDirectoryHelper.Exists(DirectoryPath));
    END;

    //[Internal]
    PROCEDURE ServerCreateDirectory(DirectoryPath: Text);
    BEGIN
        IF NOT ServerDirectoryExists(DirectoryPath) THEN
            ServerDirectoryHelper.CreateDirectory(DirectoryPath);
    END;

    //[Internal]
    PROCEDURE ServerCreateTempSubDirectory() DirectoryPath: Text;
    VAR
        ServerTempFile: Text;
    BEGIN
        ServerTempFile := ServerTempFileName('tmp');
        DirectoryPath := CombinePath(GetDirectoryName(ServerTempFile), FORMAT(CREATEGUID));
        ServerCreateDirectory(DirectoryPath);
        DeleteServerFile(ServerTempFile);
    END;

    //[Internal]
    PROCEDURE ServerRemoveDirectory(DirectoryPath: Text; Recursive: Boolean);
    BEGIN
        IF ServerDirectoryExists(DirectoryPath) THEN
            ServerDirectoryHelper.Delete(DirectoryPath, Recursive);
    END;

    //[External]
    PROCEDURE GetFileName(FilePath: Text): Text;
    BEGIN
        EXIT(PathHelper.GetFileName(FilePath));
    END;



    //[External]
    PROCEDURE GetFileNameWithoutExtension(FilePath: Text): Text;
    BEGIN
        EXIT(PathHelper.GetFileNameWithoutExtension(FilePath));
    END;



    //[External]
    PROCEDURE GetFileNameMimeType(FileName: Text): Text;
    VAR
    // MimeMapping: DotNet MimeMapping;
    BEGIN
        // EXIT(MimeMapping.GetMimeMapping(FileName));
    END;

    //[External]
    PROCEDURE GetDirectoryName(FileName: Text): Text;
    BEGIN
        IF FileName = '' THEN
            EXIT(FileName);

        FileName := DELCHR(FileName, '<');
        EXIT(PathHelper.GetDirectoryName(FileName));
    END;

    //[Internal]
    PROCEDURE GetClientDirectoryFilesList(VAR NameValueBuffer: Record 823; DirectoryPath: Text);
    VAR
        [RUNONCLIENT]
        ArrayHelper: DotNet Array;
        i: Integer;
    BEGIN
        NameValueBuffer.RESET;
        NameValueBuffer.DELETEALL;

        ArrayHelper := DirectoryHelper.GetFiles(DirectoryPath);
        FOR i := 1 TO ArrayHelper.GetLength(0) DO BEGIN
            NameValueBuffer.ID := i;
            EVALUATE(NameValueBuffer.Name, ArrayHelper.GetValue(i - 1));
            NameValueBuffer.INSERT;
        END;
    END;

    //[Internal]
    PROCEDURE GetServerDirectoryFilesList(VAR NameValueBuffer: Record 823; DirectoryPath: Text);
    VAR
        ArrayHelper: DotNet Array;
        i: Integer;
    BEGIN
        NameValueBuffer.RESET;
        NameValueBuffer.DELETEALL;

        ArrayHelper := ServerDirectoryHelper.GetFiles(DirectoryPath);
        FOR i := 1 TO ArrayHelper.GetLength(0) DO BEGIN
            NameValueBuffer.ID := i;
            EVALUATE(NameValueBuffer.Name, ArrayHelper.GetValue(i - 1));
            NameValueBuffer.Value := COPYSTR(GetFileNameWithoutExtension(NameValueBuffer.Name), 1, 250);
            NameValueBuffer.INSERT;
        END;
    END;


    LOCAL PROCEDURE GetServerDirectoryFilesListInclSubDirsInner(VAR NameValueBuffer: Record 823; DirectoryPath: Text);
    VAR
        ArrayHelper: DotNet Array;
        FileSystemEntry: Text;
        Index: Integer;
        LastId: Integer;
    BEGIN
        ArrayHelper := ServerDirectoryHelper.GetFileSystemEntries(DirectoryPath);
        FOR Index := 1 TO ArrayHelper.GetLength(0) DO BEGIN
            IF NameValueBuffer.FINDLAST THEN
                LastId := NameValueBuffer.ID;
            EVALUATE(FileSystemEntry, ArrayHelper.GetValue(Index - 1));
            IF ServerDirectoryExists(FileSystemEntry) THEN
                GetServerDirectoryFilesListInclSubDirsInner(NameValueBuffer, FileSystemEntry)
            ELSE BEGIN
                NameValueBuffer.ID := LastId + 1;
                NameValueBuffer.Name := COPYSTR(FileSystemEntry, 1, 250);
                NameValueBuffer.Value := COPYSTR(GetFileNameWithoutExtension(NameValueBuffer.Name), 1, 250);
                NameValueBuffer.INSERT;
            END;
        END;
    END;

    [TryFunction]
    //[Internal]
    PROCEDURE GetClientFileProperties(FullFileName: Text; VAR ModifyDate: Date; VAR ModifyTime: Time; VAR Size: BigInteger);
    VAR
        [RUNONCLIENT]
        FileInfo: DotNet FileInfo;
        ModifyDateTime: DateTime;
    BEGIN
        ModifyDateTime := ClientFileHelper.GetLastWriteTime(FullFileName);
        ModifyDate := DT2DATE(ModifyDateTime);
        ModifyTime := DT2TIME(ModifyDateTime);
        Size := FileInfo.FileInfo(FullFileName).Length;
    END;

    [TryFunction]
    //[Internal]
    PROCEDURE GetServerFileProperties(FullFileName: Text; VAR ModifyDate: Date; VAR ModifyTime: Time; VAR Size: BigInteger);
    VAR
        FileInfo: DotNet FileInfo;
        ModifyDateTime: DateTime;
    BEGIN
        ModifyDateTime := ServerDirectoryHelper.GetLastWriteTime(FullFileName);
        ModifyDate := DT2DATE(ModifyDateTime);
        ModifyTime := DT2TIME(ModifyDateTime);
        Size := FileInfo.FileInfo(FullFileName).Length;
    END;

    //[Internal]
    PROCEDURE CombinePath(BasePath: Text; Suffix: Text): Text;
    BEGIN
        EXIT(PathHelper.Combine(BasePath, Suffix));
    END;



    //[External]
    PROCEDURE GetToFilterText(FilterString: Text; FileName: Text): Text;
    VAR
        OutExt: Text;
    BEGIN
        IF FilterString <> '' THEN
            EXIT(FilterString);

        CASE UPPERCASE(GetExtension(FileName)) OF
            'DOC':
                OutExt := WordFileType;
            'DOCX':
                OutExt := Word2007FileType;
            'XLS':
                OutExt := ExcelFileType;
            'XLSX':
                OutExt := Excel2007FileType;
            'XSLT':
                OutExt := XSLTFileType;
            'XML':
                OutExt := XMLFileType;
            'XSD':
                OutExt := XSDFileType;
            'HTM':
                OutExt := HTMFileType;
            'TXT':
                OutExt := TXTFileType;
            'RDL':
                OutExt := RDLFileTypeTok;
            'RDLC':
                OutExt := RDLFileTypeTok;
        END;

        OnAfterGetToFilterTextSetOutExt(FileName, OutExt);

        IF OutExt = '' THEN
            EXIT(AllFilesDescriptionTxt);
        EXIT(OutExt + '|' + AllFilesDescriptionTxt);  // Also give the option of the general selection
    END;

    //[External]
    PROCEDURE GetExtension(Name: Text): Text;
    VAR
        FileExtension: Text;
    BEGIN
        FileExtension := PathHelper.GetExtension(Name);

        IF FileExtension <> '' THEN
            FileExtension := DELCHR(FileExtension, '<', '.');

        EXIT(FileExtension);
    END;

    //[External]
    PROCEDURE OpenFileDialog(WindowTitle: Text[50]; DefaultFileName: Text; FilterString: Text): Text;
    VAR
        // OpenFileDialog: DotNet OpenFileDialog;
        [RUNONCLIENT]
        DialogResult: DotNet DialogResult;
    BEGIN
        IF IsWebClient THEN
            EXIT(UploadFile(WindowTitle, DefaultFileName));

        // OpenFileDialog := OpenFileDialog.OpenFileDialog;
        // OpenFileDialog.ShowReadOnly := FALSE;
        // OpenFileDialog.FileName := GetFileName(DefaultFileName);
        // OpenFileDialog.Title := WindowTitle;
        // OpenFileDialog.Filter := GetToFilterText(FilterString, DefaultFileName);
        // OpenFileDialog.InitialDirectory := GetDirectoryName(DefaultFileName);

        // DialogResult := OpenFileDialog.ShowDialog;
        // IF DialogResult.CompareTo(DialogResult.OK) = 0 THEN
        //     EXIT(OpenFileDialog.FileName);
        EXIT('');
    END;

    //[Internal]
    PROCEDURE SaveFileDialog(WindowTitle: Text[50]; DefaultFileName: Text; FilterString: Text): Text;
    VAR
        // SaveFileDialog: DotNet SaveFileDialog;
        DialogResult: DotNet DialogResult;
    BEGIN
        IF IsWebClient THEN
            EXIT('');
        // SaveFileDialog := SaveFileDialog.SaveFileDialog;
        // SaveFileDialog.CheckPathExists := TRUE;
        // SaveFileDialog.OverwritePrompt := TRUE;
        // SaveFileDialog.FileName := GetFileName(DefaultFileName);
        // SaveFileDialog.Title := WindowTitle;
        // SaveFileDialog.Filter := GetToFilterText(FilterString, DefaultFileName);
        // SaveFileDialog.InitialDirectory := GetDirectoryName(DefaultFileName);

        // DialogResult := SaveFileDialog.ShowDialog;
        // IF DialogResult.CompareTo(DialogResult.OK) = 0 THEN
        //     EXIT(SaveFileDialog.FileName);
        EXIT('');
    END;

    //[External]
    PROCEDURE SelectFolderDialog(WindowTitle: Text; VAR SelectedFolder: Text): Boolean;
    VAR
        // FolderBrowser: DotNet FolderBrowserDialog;
        DialogResult: DotNet DialogResult;
    BEGIN
        // FolderBrowser := FolderBrowser.FolderBrowserDialog;
        // FolderBrowser.ShowNewFolderButton := TRUE;
        // FolderBrowser.Description := WindowTitle;

        // DialogResult := FolderBrowser.ShowDialog;
        // IF DialogResult = 1 THEN BEGIN
        //     SelectedFolder := FolderBrowser.SelectedPath;
        //     EXIT(TRUE);
        // END;
    END;

    //[External]
    PROCEDURE CanRunDotNetOnClient(): Boolean;
    VAR
        ClientTypeManagement: Codeunit 50192;
    BEGIN
        EXIT(ClientTypeManagement.IsWindowsClientType);
    END;

    //[External]
    PROCEDURE IsWebClient(): Boolean;
    VAR
        ClientTypeManagement: Codeunit 50192;
    BEGIN
        EXIT(ClientTypeManagement.IsCommonWebClientType);
    END;

    //[External]
    PROCEDURE IsWindowsClient(): Boolean;
    VAR
        ClientTypeManagement: Codeunit 50192;
    BEGIN
        EXIT(ClientTypeManagement.IsWindowsClientType);
    END;

    PROCEDURE IsValidFileName(FileName: Text): Boolean;
    VAR
        String: DotNet String;
    BEGIN
        IF FileName = '' THEN
            EXIT(FALSE);

        String := GetFileName(FileName);
        IF String.IndexOfAny(PathHelper.GetInvalidFileNameChars) <> -1 THEN
            EXIT(FALSE);

        String := GetDirectoryName(FileName);
        IF String.IndexOfAny(PathHelper.GetInvalidPathChars) <> -1 THEN
            EXIT(FALSE);

        EXIT(TRUE);
    END;

    LOCAL PROCEDURE ValidateFileNames(ServerFileName: Text; ClientFileName: Text);
    BEGIN
        IF NOT IsValidFileName(ServerFileName) THEN
            ERROR(Text011);

        IF NOT IsValidFileName(ClientFileName) THEN
            ERROR(Text012);
    END;

    //[External]
    PROCEDURE ValidateFileExtension(FilePath: Text; ValidExtensions: Text);
    VAR
        FileExt: Text;
        LowerValidExts: Text;
    BEGIN
        IF STRPOS(ValidExtensions, AllFilesFilterTxt) <> 0 THEN
            EXIT;

        FileExt := LOWERCASE(GetExtension(GetFileName(FilePath)));
        LowerValidExts := LOWERCASE(ValidExtensions);

        IF STRPOS(LowerValidExts, FileExt) = 0 THEN
            ERROR(UnsupportedFileExtErr, FileExt, LowerValidExts);
    END;

    LOCAL PROCEDURE ValidateClientPath(FilePath: Text);
    BEGIN
        IF FilePath = '' THEN
            EXIT;
        IF DirectoryHelper.Exists(FilePath) THEN
            EXIT;

        IF CONFIRM(CreatePathQst, TRUE, FilePath) THEN
            DirectoryHelper.CreateDirectory(FilePath)
        ELSE
            ERROR('');
    END;

    LOCAL PROCEDURE CreateFileNameWithExtension(FileNameWithoutExtension: Text; Extension: Text) FileName: Text;
    BEGIN
        FileName := FileNameWithoutExtension;
        IF Extension <> '' THEN BEGIN
            IF Extension[1] <> '.' THEN
                FileName := FileName + '.';
            FileName := FileName + Extension;
        END
    END;

    PROCEDURE Ansi2SystemEncoding(Destination: OutStream; Source: InStream);
    VAR
        StreamReader: DotNet StreamReader;
        Encoding: DotNet Encoding;
        EncodedTxt: Text;
    BEGIN
        StreamReader := StreamReader.StreamReader(Source, Encoding.Default, TRUE);
        EncodedTxt := StreamReader.ReadToEnd;
        Destination.WRITETEXT(EncodedTxt);
    END;

    PROCEDURE Ansi2SystemEncodingTxt(Destination: OutStream; Source: Text);
    VAR
        StreamWriter: DotNet StreamWriter;
        Encoding: DotNet Encoding;
    BEGIN
        StreamWriter := StreamWriter.StreamWriter(Destination, Encoding.Default);
        StreamWriter.Write(Source);
        StreamWriter.Close;
    END;

    //[External]
    PROCEDURE BrowseForFolderDialog(WindowTitle: Text[50]; DefaultFolderName: Text; ShowNewFolderButton: Boolean): Text;
    VAR
        // FolderBrowserDialog: DotNet FolderBrowserDialog;
        DialagResult: DotNet DialogResult;
    BEGIN
        // FolderBrowserDialog := FolderBrowserDialog.FolderBrowserDialog;
        // FolderBrowserDialog.Description := WindowTitle;
        // FolderBrowserDialog.SelectedPath := DefaultFolderName;
        // FolderBrowserDialog.ShowNewFolderButton := ShowNewFolderButton;

        // DialagResult := FolderBrowserDialog.ShowDialog;
        // IF DialagResult.CompareTo(DialagResult.OK) = 0 THEN
        //     EXIT(FolderBrowserDialog.SelectedPath);
        EXIT(DefaultFolderName);
    END;

    //[External]
    PROCEDURE StripNotsupportChrInFileName(InText: Text): Text;
    BEGIN
        EXIT(DELCHR(InText, '=', InvalidWindowsChrStringTxt));
    END;

    //[Internal]
    PROCEDURE CreateZipArchiveObject() FilePath: Text;
    BEGIN
        FilePath := ServerTempFileName('zip');
        OpenZipFile(FilePath);
    END;

    //[Internal]
    PROCEDURE OpenZipFile(ServerZipFilePath: Text);
    VAR
        Zipfile: DotNet ZipFile;
        ZipAchiveMode: DotNet ZipArchiveMode;
    BEGIN
        IsAllowedPath(ServerZipFilePath, FALSE);
        ZipArchive := Zipfile.Open(ServerZipFilePath, ZipAchiveMode.Create);
    END;

    //[Internal]
    PROCEDURE AddFileToZipArchive(SourceFileFullPath: Text; PathInZipFile: Text);
    VAR
        Zip: DotNet ZipFileExtensions;
    BEGIN
        IsAllowedPath(SourceFileFullPath, FALSE);
        Zip.CreateEntryFromFile(ZipArchive, SourceFileFullPath, PathInZipFile);
    END;

    //[Internal]
    PROCEDURE CloseZipArchive();
    BEGIN
        IF NOT ISNULL(ZipArchive) THEN
            ZipArchive.Dispose;
    END;

    //[Internal]
    PROCEDURE IsGZip(ServerSideFileName: Text): Boolean;
    VAR
        FileStream: DotNet FileStream;
        FileMode: DotNet FileMode;
        ID: ARRAY[2] OF Integer;
    BEGIN
        IsAllowedPath(ServerSideFileName, FALSE);

        FileStream := FileStream.FileStream(ServerSideFileName, FileMode.Open);
        ID[1] := FileStream.ReadByte;
        ID[2] := FileStream.ReadByte;
        FileStream.Close;

        // from GZIP file format specification version 4.3
        // Member header and trailer
        // ID1 (IDentification 1)
        // ID2 (IDentification 2)
        // These have the fixed values ID1 = 31 (0x1f, \037), ID2 = 139 (0x8b, \213), to identify the file as being in gzip format.

        EXIT((ID[1] = 31) AND (ID[2] = 139));
    END;

    [TryFunction]
    //[Internal]
    PROCEDURE ExtractZipFile(ZipFilePath: Text; DestinationFolder: Text);
    VAR
        Zip: DotNet ZipFileExtensions;
        ZipFile: DotNet ZipFile;
    BEGIN
        IsAllowedPath(ZipFilePath, FALSE);

        IF NOT ServerFileHelper.Exists(ZipFilePath) THEN
            ERROR(FileDoesNotExistErr, ZipFilePath);

        // Create directory if it doesn't exist
        ServerCreateDirectory(DestinationFolder);

        ZipArchive := ZipFile.Open(ZipFilePath, ZipArchiveMode.Read);
        Zip.ExtractToDirectory(ZipArchive, DestinationFolder);
        CloseZipArchive;
    END;

    //[Internal]
    PROCEDURE ExtractZipFileAndGetFileList(ServerZipFilePath: Text; VAR NameValueBuffer: Record 823);
    VAR
        ServerDestinationFolder: Text;
    BEGIN
        ServerDestinationFolder := ServerCreateTempSubDirectory;
        ExtractZipFile(ServerZipFilePath, ServerDestinationFolder);
        GetServerDirectoryFilesList(NameValueBuffer, ServerDestinationFolder);
    END;


    //[Internal]
    PROCEDURE IsServerDirectoryEmpty(Path: Text): Boolean;
    BEGIN
        IF ServerDirectoryHelper.Exists(Path) THEN
            EXIT(ServerDirectoryHelper.GetFiles(Path).Length = 0);
        EXIT(FALSE);
    END;

    //[External]
    PROCEDURE IsWebOrDeviceClient(): Boolean;
    BEGIN
        EXIT(CURRENTCLIENTTYPE IN [CLIENTTYPE::Web, CLIENTTYPE::Phone, CLIENTTYPE::Tablet, CLIENTTYPE::Desktop]);
    END;

    //[Internal]
    PROCEDURE GetFileContent(FilePath: Text) Result: Text;
    VAR
        FileHandle: File;
        InStr: InStream;
    BEGIN
        IF NOT FILE.EXISTS(FilePath) THEN
            EXIT;

        FileHandle.OPEN(FilePath, TEXTENCODING::UTF8);
        FileHandle.CREATEINSTREAM(InStr);

        InStr.READTEXT(Result);
    END;

    //[External]
    PROCEDURE AddStreamToZipStream(ZipStream: OutStream; StreamToAdd: InStream; PathInArchive: Text);
    VAR
        ZipArchiveLocal: DotNet ZipArchive;
        ZipArchiveEntry: DotNet ZipArchiveEntry;
        StreamReader: DotNet StreamReader;
        StreamWriter: DotNet StreamWriter;
        Encoding: DotNet Encoding;
    BEGIN
        ZipArchiveLocal := ZipArchiveLocal.ZipArchive(ZipStream, ZipArchiveMode.Update, TRUE);
        ZipArchiveEntry := ZipArchiveLocal.CreateEntry(PathInArchive);
        StreamReader := StreamReader.StreamReader(StreamToAdd, Encoding.Default);
        StreamWriter := StreamWriter.StreamWriter(ZipArchiveEntry.Open, StreamReader.CurrentEncoding);
        StreamWriter.Write(StreamReader.ReadToEnd);
        StreamWriter.Close;
        StreamReader.Close;
    END;

    //[External]
    PROCEDURE IsAllowedPath(Path: Text; SkipError: Boolean): Boolean;
    VAR
        MembershipEntitlement: Record 2000000195;
        WebRequestHelper: Codeunit 1299;
    BEGIN
        IF NOT MembershipEntitlement.ISEMPTY THEN
            IF NOT WebRequestHelper.IsHttpUrl(Path) THEN
                IF NOT FILE.ISPATHTEMPORARY(Path) THEN BEGIN
                    IF SkipError THEN
                        EXIT(FALSE);
                    ERROR(NotAllowedPathErr, Path);
                END;
        EXIT(TRUE);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterGetToFilterTextSetOutExt(FileName: Text; VAR OutExt: Text);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeDownloadHandler(VAR ToFolder: Text; ToFileName: Text; FromFileName: Text);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}





