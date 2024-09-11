table 7207288 "Tran. Between Jobs Post Header"
{


    CaptionML = ENU = 'Posted Hea T. Costs-Invoices', ESP = 'Hist. cab. t. costes-factura';
    LookupPageID = "Tran. Between Jobs Post List";

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'No.';


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
        field(9; "Preassigned Serie No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Preassigned Serie No.', ESP = 'No. serie preasignado';
            Editable = false;


        }
        field(10; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Posting No. Series', ESP = 'No. serie registro';


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
            CaptionML = ENU = 'User ID', ESP = 'ID usuario';


        }
        field(17; "Source Code"; Code[20])
        {
            TableRelation = "Source Code";
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
        //       UserSetupManagement@7001100 :
        UserSetupManagement: Codeunit 5700;
        //       HasGotSalesUserSetup@7001101 :
        HasGotSalesUserSetup: Boolean;
        //       UserRespCenter@7001102 :
        UserRespCenter: Code[20];
        //       QBCommentLine@7001103 :
        QBCommentLine: Record 7207270;
        //       PostedLinTraCostInvoice@7001104 :
        PostedLinTraCostInvoice: Record 7207289;

    procedure Navigate()
    var
        //       NavigatePage@1000 :
        NavigatePage: Page "Navigate";
    begin
        NavigatePage.SetDoc("Posting Date", "No.");
        NavigatePage.RUN;
    end;

    /*begin
    //{
//      JAV 28/10/19: - Se cambia el name y caption de la tabla para que sea mas significativo del contenido
//                    - La clave principal pasa de "Document Type" y "No." a solo "No.", ahora el tipo de documento es un campo mas de la tabla
//                    - Se elimina el campo "Document Type" de las l�neas y su parte de la clave
//    }
    end.
  */
}







