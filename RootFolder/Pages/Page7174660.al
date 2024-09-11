page 7174660 "Files Sharepoint list"
{
    CaptionML = ENU = 'Files Sharepoint list', ESP = 'Lista ficheros Sharepoint';
    InsertAllowed = false;
    SourceTable = 7174657;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Filter"; rec."Filter")
                {

                    Editable = FALSE;
                }
                field("Sharepoint Site Definition"; rec."Sharepoint Site Definition")
                {

                    Editable = FALSE;
                }
                field("File Name"; rec."File Name")
                {

                    Editable = FALSE;
                }
                field("Url"; rec."Url")
                {

                    ExtendedDatatype = URL;
                    Editable = FALSE;
                }
                field("Creation Date"; rec."Creation Date")
                {

                    Editable = FALSE;



                    ; trigger OnAssistEdit()
                    VAR
                        Job: Record 167;
                    BEGIN
                    END;


                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("Get files manual")
            {

                CaptionML = ENU = 'Get files manual', ESP = 'Traer ficheros manual';
                Promoted = true;
                PromotedIsBig = true;
                Image = GetSourceDoc;
                PromotedCategory = Process;
                PromotedOnly = true;


                trigger OnAction()
                BEGIN
                    fncGetFiles;
                END;


            }

        }
    }

    var
        vRecordId: RecordID;
        vTableNo: Integer;
        w: Dialog;
        TEXT50000: TextConst ENU = 'Update files #########1##', ESP = 'Actualizando datos ######1##';



    procedure fncSetRecordID(pRecordId: RecordID; pTableNo: Integer);
    begin

        vRecordId := pRecordId;
        vTableNo := pTableNo;
    end;

    LOCAL procedure fncGetFiles();
    var
        RecRef: RecordRef;
        SpSiteDef: Record 7174651;
        SiteLibrary: Text;
        cduDropArea: Codeunit 7174650;
        XDropAreaFile: Record 7174657 TEMPORARY;
        Job: Record 167;
    begin

        SpSiteDef.RESET;
        SpSiteDef.SETRANGE(IdTable, vTableNo);
        SpSiteDef.SETRANGE(Status, SpSiteDef.Status::Released);
        //Q7357 -
        if SpSiteDef.IdTable = DATABASE::Job then begin
            Job.GET(vRecordId);
            SpSiteDef.SETRANGE("Job Card Type", Job."Card Type");
        end;
        //Q7357 +
        SpSiteDef.FINDFIRST;

        RecRef.OPEN(vTableNo);
        RecRef.GET(vRecordId);

        w.OPEN(TEXT50000);
        SiteLibrary := cduDropArea.GetTitleLibrary(SpSiteDef."No.", RecRef);

        //Recogemos los ficheros y lo indicamos
        cduDropArea.FncGetFiles(SpSiteDef."No.", XDropAreaFile, SiteLibrary, vRecordId, FALSE);

        XDropAreaFile.RESET;
        if XDropAreaFile.FINDSET then
            repeat
                w.UPDATE(1, XDropAreaFile."File Name");
                Rec.INIT;
                Rec.TRANSFERFIELDS(XDropAreaFile);
                Rec.INSERT;
            until XDropAreaFile.NEXT = 0;

        w.CLOSE;
        CurrPage.UPDATE(FALSE);
    end;

    // begin
    /*{
      Q7357 JDC 13/11/19 - Modified function "fncGetFiles"
    }*///end
}








