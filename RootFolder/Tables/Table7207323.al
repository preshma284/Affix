table 7207323 "Hist. Expense Notes Header"
{


    CaptionML = ENU = 'Hist. Expense Notes Header', ESP = 'Hist. Cab. notas de gasto';
    LookupPageID = "Hist. Expense Notes List";
    DrillDownPageID = "Hist. Expense Notes List";

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'N�';


        }
        field(2; "Employee"; Code[20])
        {
            TableRelation = Vendor."No." WHERE("QB Employee" = CONST(true));
            CaptionML = ENU = 'Employee', ESP = 'Empleado';


        }
        field(3; "Expense Description"; Text[50])
        {
            CaptionML = ENU = 'Expense Description', ESP = 'Descripcion Gasto';


        }
        field(4; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(6; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(7; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Texto de registro';


        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(10; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�digo de divisa';


        }
        field(11; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;


        }
        field(12; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Comment Lines Expen. Notes" WHERE("Document Type" = CONST("Expense Notes"),
                                                                                                         "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(13; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�d. auditor�a';


        }
        field(14; "Pre-Assigned No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Pre-Assigned No. Series', ESP = 'N� serie preasignado';
            Editable = true;


        }
        field(15; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(17; "Expense Note Date"; Date)
        {
            CaptionML = ENU = 'Expense Note Date', ESP = 'Fecha Nota Gastos';


        }
        field(18; "PIT Withholding Group"; Code[20])
        {
            TableRelation = "Withholding Group"."Code" WHERE("Withholding Type" = CONST("PIT"));
            CaptionML = ENU = 'PIT Deduction Groups', ESP = 'Grupo Retenci�n IRPF';


        }
        field(19; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsibility Center', ESP = 'Centro de Responsabilidad';

            trigger OnValidate();
            VAR
                //                                                                 Respcenter@7207270 :
                Respcenter: Record 5714;
            BEGIN
                IF NOT UserMgt.CheckRespCenter(3, "Responsibility Center") THEN
                    ERROR(
                      Text027,
                       Respcenter.TABLECAPTION, FunctionQB.GetUserJobResponsibilityCenter);
            END;


        }
        field(23; "User ID"; Code[50])
        {
            TableRelation = User."User Name";


            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'User ID', ESP = 'Id. usuario';

            trigger OnLookup();
            VAR
                //                                                               LoginMgt@7001100 :
                LoginMgt: Codeunit "User Management 1";
            BEGIN
                LoginMgt.LookupUserID("User ID");
            END;


        }
        field(24; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'C�d. origen';


        }
        field(25; "Applies-to Doc. Type"; Option)
        {
            OptionMembers = " ","Payment","Invoce","Credit Memo","Finance Charge Memo","Reminder","Refund","Bill";

            CaptionML = ENU = 'Applies-to Doc. Type', ESP = 'Liq. por tipo documento';
            OptionCaptionML = ENU = '" ,Payment,Invoce,Credit Memo,Finance Charge Memo,Reminder,Refund,,,,,,,,,,,,,,Bill"', ESP = '" ,Pago,Factura,Abonos,Docs. inter�s,Recordatorio,Reembolso,,,,,,,,,,,,,,Efecto"';


            trigger OnValidate();
            BEGIN
                IF "Applies-to Doc. Type" <> xRec."Applies-to Doc. Type" THEN
                    VALIDATE("Applies-to Doc. No.", '');
            END;


        }
        field(26; "Applies-to Doc. No."; Code[20])
        {
            CaptionML = ENU = 'Applies-to Doc. No.', ESP = 'Liq. por N� documento';


        }
        field(27; "Remaining Advance Amount DL"; Decimal)
        {
            CaptionML = ENU = 'Remaining Advance Amount DL', ESP = 'Importe pdte. anticipo DL';
            BlankZero = true;
            Editable = false;


        }
        field(30; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';


        }
        field(31; "Bal. Account Type"; Option)
        {
            OptionMembers = " ","Account","Bank";
            CaptionML = ENU = 'Bal. Account Type', ESP = 'Tipo Contrapartida';
            OptionCaptionML = ENU = ',Account, Banco', ESP = ',Cuenta,Banco';



        }
        field(32; "Bal. Account Code"; Code[20])
        {
            TableRelation = IF ("Bal. Account Type" = CONST("Account")) "G/L Account" ELSE IF ("Bal. Account Type" = CONST("Bank")) "Bank Account";


            CaptionML = ENU = 'Bal. Account Code', ESP = 'C�d. Contrapartida';

            trigger OnValidate();
            VAR
                //                                                                 BankAccount@7207270 :
                BankAccount: Record 270;
            BEGIN
            END;


        }
        field(33; "Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";
            CaptionML = ENU = 'Payment Code', ESP = 'Metodo pago';


        }
        field(34; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


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
        field(121; "OLD_Approval Situation"; Option)
        {
            OptionMembers = "Pending","Approved","Rejected","Withheld";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = 'Situaci�n de la Aprobaci�n';
            OptionCaptionML = ESP = 'Pendiente,Aprobado,Rechazado,Retenido';

            Description = '###ELIMINAR### no se usa';
            Editable = false;


        }
        field(122; "OLD_Approval Coment"; Text[80])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Comentario Aprobaci�n';
            Description = '###ELIMINAR### no se usa';
            Editable = false;


        }
        field(123; "OLD_Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha aprobaci�n';
            Description = '###ELIMINAR### no se usa';


        }
        field(7207336; "QB Approval Circuit Code"; Code[20])
        {
            TableRelation = "QB Approval Circuit Header";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Approval Circuit Code', ESP = 'Circuito de Aprobaci�n';
            Description = 'TO-DO Debe pasar el dato de la aprobaci�n como referencia';


        }
        field(7238177; "QB Budget item"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Account Type" = FILTER("Unit"));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Partida Presupuestaria';
            Description = 'TO-DO Debe pasar el dato de la aprobaci�n como referencia';


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
        //       HistExpenseNotesHeader@7001105 :
        HistExpenseNotesHeader: Record 7207323;
        //       HistExpenseNotesLines@7001104 :
        HistExpenseNotesLines: Record 7207324;
        //       CommentLinesExpenNotes@7001103 :
        CommentLinesExpenNotes: Record 7207322;
        //       DimMgt@7001102 :
        DimMgt: Codeunit "DimensionManagement";
        //       FunctionQB@7001107 :
        FunctionQB: Codeunit 7207272;
        //       UserMgt@7001101 :
        UserMgt: Codeunit 5700;
        //       Respcenter@7001100 :
        Respcenter: Record 5714;
        //       Text027@7001106 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 to %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 a %2.';



    trigger OnDelete();
    begin
        LOCKTABLE;

        HistExpenseNotesLines.RESET;
        HistExpenseNotesLines.SETRANGE("Document No.", "No.");
        HistExpenseNotesLines.DELETEALL(TRUE);

        CommentLinesExpenNotes.SETRANGE("No.", "No.");
        CommentLinesExpenNotes.DELETEALL;
    end;



    procedure Navigate()
    var
        //       NavigatePage@1000 :
        NavigatePage: Page "Navigate";
    begin
        NavigatePage.SetDoc("Posting Date", "No.");
        NavigatePage.RUN;
    end;

    //     procedure FunFilterResponsability (var NoteToFilter@1000000000 :
    procedure FunFilterResponsability(var NoteToFilter: Record 7207323)
    begin
        if FunctionQB.GetUserJobResponsibilityCenter <> '' then begin
            NoteToFilter.FILTERGROUP(2);
            NoteToFilter.SETRANGE("Responsibility Center", FunctionQB.GetUserJobResponsibilityCenter);
            NoteToFilter.FILTERGROUP(0);
        end;
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;

    /*begin
    end.
  */
}







