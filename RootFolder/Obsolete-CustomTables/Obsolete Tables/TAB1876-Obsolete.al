table 51146 "Business Setup Icon 1"
{


    DataPerCompany = false;
    CaptionML = ENU = 'Business Setup Icon', ESP = 'Icono de configuraci¢n de negocio';

    fields
    {
        field(1; "Business Setup Name"; Text[50])
        {
            CaptionML = ENU = 'Business Setup Name', ESP = 'Nombre de configuraci¢n de negocio';


        }
        field(2; "Icon"; Media)
        {
            CaptionML = ENU = 'Icon', ESP = 'Icono';


        }
        field(3; "Media Resources Ref"; Code[50])
        {
            CaptionML = ENU = 'Media Resources Ref', ESP = 'Referencia de recursos multimedia';
            ;


        }
    }
    keys
    {
        key(key1; "Business Setup Name")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }


    // procedure SetIconFromInstream (MediaResourceRef@1000 : Code[50];MediaInstream@1001 :
    procedure SetIconFromInstream(MediaResourceRef: Code[50]; MediaInstream: InStream)
    var
        //       MediaResourcesMgt@1002 :
        MediaResourcesMgt: Codeunit 9755;
    begin
        if not MediaResourcesMgt.InsertMediaFromInstream(MediaResourceRef, MediaInstream) then
            exit;

        VALIDATE("Media Resources Ref", MediaResourceRef);
        MODIFY(TRUE);
    end;

    //     procedure SetIconFromFile (MediaResourceRef@1000 : Code[50];FileName@1001 :
    procedure SetIconFromFile(MediaResourceRef: Code[50]; FileName: Text)
    var
        //       MediaResourcesMgt@1002 :
        MediaResourcesMgt: Codeunit 9755;
    begin
        if not MediaResourcesMgt.InsertMediaFromFile(MediaResourceRef, FileName) then
            exit;

        VALIDATE("Media Resources Ref", MediaResourceRef);
        MODIFY(TRUE);
    end;


    //     procedure GetIcon (var TempBusinessSetup@1001 :
    procedure GetIcon(var TempBusinessSetup: Record 51145 TEMPORARY)
    var
        //       MediaResources@1000 :
        MediaResources: Record 2000000182;
    begin
        if Icon.HASVALUE then begin
            TempBusinessSetup.Icon := Icon;
            TempBusinessSetup.MODIFY(TRUE);
        end else
            if MediaResources.GET("Media Resources Ref") then begin
                TempBusinessSetup.Icon := MediaResources."Media Reference";
                TempBusinessSetup.MODIFY(TRUE);
            end;
    end;

    /*begin
    end.
  */
}


