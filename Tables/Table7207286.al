table 7207286 "QBU Transfers Between Jobs Header"
{


    CaptionML = ENU = 'Transfers Between Jobs Header', ESP = 'Cabecera de Traspasos entre Proyectos';

    fields
    {
        field(1; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'No.';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    QuoBuildingSetup.GET;
                    NoSeriesManagement.TestManual(GetNoSeriesCode);
                    "Serie No." := '';
                END;
            END;


        }
        field(3; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(5; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(7; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(8; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'Cod. auditor�a';


        }
        field(9; "Serie No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie No.', ESP = 'Serie No.';
            Editable = false;


        }
        field(10; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Posting No. Series', ESP = 'No. serie registro';

            trigger OnValidate();
            BEGIN
                IF "Posting No. Series" <> '' THEN BEGIN
                    QuoBuildingSetup.GET;
                    TestNoSeries;
                    NoSeriesManagement.TestSeries(GetPostingNoSeriesCode, "Posting No. Series");
                END;
            END;

            trigger OnLookup();
            BEGIN
                /*To be Tested*/
                // WITH HeaderTransCostsInvoice DO BEGIN 
                HeaderTransCostsInvoice := Rec;
                QuoBuildingSetup.GET;
                TestNoSeries;
                IF NoSeriesManagement.LookupSeries(GetPostingNoSeriesCode, "Posting No. Series") THEN
                    VALIDATE("Posting No. Series");
                Rec := HeaderTransCostsInvoice;
                // END;
            END;


        }
        field(11; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Fecha filtro';


        }
        field(13; "Balance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Transfers Between Jobs Lines"."Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Balance', ESP = 'Saldo';
            Editable = false;


        }
        field(16; "User ID"; Code[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            //TestTableRelation=false;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'User ID', ESP = 'ID usuario';


        }
        field(17; "Source Code"; Code[20])
        {
            TableRelation = "Source Code";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source Code', ESP = 'Cod. origen';


        }
        field(120; "Approval Status"; Option)
        {
            OptionMembers = "Open","Released","Pending Approval";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Estado Aprobaci�n';
            OptionCaptionML = ENU = 'Open,Released,Pending Approval', ESP = 'Abierto,Lanzado,Aprobaci�n pendiente';

            Description = 'QB 1.00- JAV 10/03/20: - Estado de aprobaci�n';
            Editable = false;


        }
        field(7207336; "QB Approval Circuit Code"; Code[20])
        {
            TableRelation = "QB Approval Circuit Header" WHERE("Document Type" = CONST("Transfers"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Approval Circuit Code', ESP = 'Circuito de Aprobaci�n';
            Description = 'QB 1.10.22 - JAV 22/02/22 [TT] Que circuito de aprobaci�n que se utilizar� para este documento';


        }
        field(7207337; "QB Approval Job No"; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proyecto para la Aprobaci�n';
            Description = 'QB 1.10.57 JAV 30/06/22 [TT] Indica el proyecto que se usar� para aprobar este documento, puede ser diferente al establecido para el documento en general';


        }
        field(7207338; "QB Approval Budget item"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("QB Approval Job No"),
                                                                                                                         "Account Type" = FILTER("Unit"));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'P.Presup. para la Aprobaci�n';
            Description = 'QB 1.10.57 JAV 30/06/22 [TT] Indica la partida presupuestaria o la U.Obra que se usar� para aprobar este documento, puede ser diferente al establecido para el documento en general';


        }
        field(7207339; "QB Approval Department"; Code[20])
        {
            TableRelation = "QB Department";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Departamento para la Aprobaci�n';
            Description = 'QB 1.10.57 JAV 30/06/22 [TT] Indica el departamento organizativo que se emplear� para la aprobaci�n del documento';


        }
    }
    keys
    {
        key(key1; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       QuoBuildingSetup@7001100 :
        QuoBuildingSetup: Record 7207278;
        //       NoSeriesManagement@7001101 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";
        //       Text000@7001102 :
        Text000: TextConst ENU = 'Transfer ', ESP = 'Traspaso ';
        //       TransferCostandInvoiceLine@7001103 :
        TransferCostandInvoiceLine: Record 7207287;
        //       UserSetupManagement@7001104 :
        UserSetupManagement: Codeunit 5700;
        //       QBCommentLine@7001105 :
        QBCommentLine: Record 7207270;
        //       Text003@7001106 :
        Text003: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       HeaderTransCostsInvoice@7001107 :
        HeaderTransCostsInvoice: Record 7207286;
        //       Text027@7001108 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       ResponsibilityCenter@7001109 :
        ResponsibilityCenter: Record 5714;
        //       HasGotSalesUserSetup@7001110 :
        HasGotSalesUserSetup: Boolean;
        //       UserRespCenter@7001111 :
        UserRespCenter: Code[20];



    trigger OnInsert();
    begin
        if "No." = '' then begin
            QuoBuildingSetup.GET;
            TestNoSeries;
            NoSeriesManagement.InitSeries(GetNoSeriesCode, xRec."Serie No.", "Posting Date", "No.", "Serie No.");
        end;
        InitRecord;
    end;

    trigger OnDelete();
    begin
        TransferCostandInvoiceLine.LOCKTABLE;

        //Se borran las l�neas asociadas al documento
        TransferCostandInvoiceLine.SETRANGE("Document No.", "No.");
        TransferCostandInvoiceLine.DELETEALL(TRUE);
        QBCommentLine.SETRANGE("No.", "No.");
        QBCommentLine.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;



    procedure InitRecord()
    begin
        QuoBuildingSetup.GET;
        NoSeriesManagement.SetDefaultSeries("Posting No. Series", QuoBuildingSetup."Serie for Transfers Post");
        "Posting Date" := WORKDATE;
        Description := Text000;
        "User ID" := USERID;
    end;

    //     procedure AssistEdit (HeaderTransCostsInvoiceOld@1000 :
    procedure AssistEdit(HeaderTransCostsInvoiceOld: Record 7207286): Boolean;
    var
        //       No@7001100 :
        No: Code[10];
    begin
        QuoBuildingSetup.GET;
        TestNoSeries;
        if NoSeriesManagement.SelectSeries(GetNoSeriesCode, HeaderTransCostsInvoiceOld."Serie No.", "Serie No.") then begin
            TestNoSeries;
            NoSeriesManagement.SetSeries(No);
            exit(TRUE);
        end;
    end;

    LOCAL procedure TestNoSeries(): Boolean;
    begin
        QuoBuildingSetup.TESTFIELD(QuoBuildingSetup."Serie for Transfers");
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
        exit(QuoBuildingSetup."Serie for Transfers");
    end;

    LOCAL procedure GetPostingNoSeriesCode(): Code[20];
    begin
        exit(QuoBuildingSetup."Serie for Transfers Post");
    end;

    procedure ConfirmDeletion(): Boolean;
    begin
        // Aqui estableceremos las condiciones de borrado de la cabecera, se llama a una funci�n que lo comprueba
        exit(TRUE);
    end;

    procedure ExistLinesSheep(): Boolean;
    begin

        TransferCostandInvoiceLine.LOCKTABLE;
        TransferCostandInvoiceLine.RESET;
        TransferCostandInvoiceLine.SETRANGE("Document No.", "No.");
        exit(TransferCostandInvoiceLine.FINDFIRST);
    end;

    /*begin
    //{
//      JAV 28/10/19: - Se cambia el name y caption de la tabla para que sea mas significativo del contenido
//                    - La clave principal pasa de "Document Type" y "No." a solo "No.", ahora el tipo de documento es un campo mas de la tabla de l�neas
//                    - Se elimina el campo "Document Type"
//      JAV 15/09/21: - QB 1.09.17 se amplia el retorno de las funciones GetNoSeriesCode y GetPostingNoSeriesCode de 10 a 20
//    }
    end.
  */
}







