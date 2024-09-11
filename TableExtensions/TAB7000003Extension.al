tableextension 50223 "QBU Posted Cartera Doc.Ext" extends "Posted Cartera Doc."
{


    CaptionML = ENU = 'Posted Cartera Doc.', ESP = 'Doc. cartera regis.';
    LookupPageID = "Posted Cartera Documents";
    DrillDownPageID = "Posted Cartera Documents";

    fields
    {
        field(7207270; "Original Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Vencimiento contractual';
            Description = 'QB 1.06.15 - JAV 21/09/20 Fecha de vencimiento del documento original';
            Editable = false;


        }
        field(7207271; "Confirming Line"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.06.15 - JAV 23/09/20 L�nea de Confirming asociada a la orden de pago Registrada';


        }
        field(7207272; "Factoring Line"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.06.15 - JAV 23/09/20 L�nea de Factoring asociada a la remesa Registrada';


        }
        field(7207273; "Unrisk Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Riesgo no asegurado';
            Description = 'QB 1.06.15 - JAV 23/09/20 Parte del riesgo de la factura no cubierta por el Factoring';
            Editable = false;


        }
        field(7207274; "Category"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Customer"."QB Category" WHERE("No." = FIELD("Account No.")));
            CaptionML = ESP = 'Categor�a';
            Description = 'QB 1.06.15 - PGR 28/09/20: - Categor�a del cliente';
            CaptionClass = '7206910,18,7207284';


        }
        field(7207275; "Sub-Category"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Customer"."QB Sub-Category" WHERE("No." = FIELD("Account No.")));
            CaptionML = ESP = 'Sub-Categor�a';
            Description = 'QB 1.06.15 - PGR 28/09/20: - Sub-Categor�a del cliente';
            CaptionClass = '7206910,18,7207306';


        }
        field(7207276; "Document Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Entry"."Document Date" WHERE("Document No." = FIELD("Document No."),
                                                                                                         "External Document No." = FILTER(<> '')));
            CaptionML = ENU = 'External Document', ESP = 'Fecha del Documento';
            Description = 'QB 1.06.19 - JAV 08/10/20: - Fecha de la factura de compra';
            Editable = false;


        }
        field(7207290; "Job No."; Code[20])
        {
            CaptionML = ENU = 'Job No.', ESP = 'No. Proyecto';
            Description = 'QB 1.00 - JAV 08/03/20: - N�mero del proyecto';
            Editable = false;


        }
        field(7207291; "External Document No."; Code[35])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Entry"."External Document No." WHERE("Document No." = FIELD("Document No."),
                                                                                                                 "External Document No." = FILTER(<> '')));
            CaptionML = ENU = 'External Document', ESP = 'No. Documento Externo';
            Description = 'QB 1.00 - JAV 08/03/20: - N�mero de documento externo de la factura de compra';
            Editable = false;


        }
        field(7207292; "Customer Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Customer"."Name" WHERE("No." = FIELD("Account No.")));
            CaptionML = ENU = 'Vendor Name', ESP = 'Nombre Cliente';
            Description = 'QB 1.00 - JAV 12/03/20: - DP17a Nombre del cliente';
            Editable = false;


        }
        field(7207293; "Vendor Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor"."Name" WHERE("No." = FIELD("Account No.")));
            CaptionML = ENU = 'Vendor Name', ESP = 'Nombre Proveedor';
            Description = 'QB 1.00 - JAV 12/03/20: - DP17a Nombre del proveedor';
            Editable = false;


        }
        field(7207295; "Obralia Entry"; Integer)
        {
            TableRelation = "Obralia Log Entry";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Obralia User ID', ESP = 'Obralia';
            Description = 'QB 1.05.06 - JAV 23/07/20 : - Entrada en el registro de Obralia';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 ObraliaLogEntry@1100286000 :
                ObraliaLogEntry: Record 7206904;
                //                                                                 PurchasesPayablesSetup@1100286001 :
                PurchasesPayablesSetup: Record 312;
            BEGIN
            END;


        }
        field(7207298; "Approval Status"; Option)
        {
            OptionMembers = "Open","Released","Pending Approval","Due Open","Due Released","Due Pending Approval";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = 'Estado Aprobaci�n';
            OptionCaptionML = ENU = 'Open,Released,Pending Approval,Due Open,Due Released,Due Pending Approval', ESP = 'Abierto,Lanzado,Aprobaci�n pendiente,Cert.Ven. Abierto,Cert.Ven. Lanzado,Cert.Ven. Aprobaci�n pendiente';

            Description = 'QB 1.00 - JAV 14/10/19: - Se a�ade el campo de Status a partir de QBAPP   JAV 02/03/20: - Aprobaci�n para certificados vencidos';


        }
        field(7207299; "OLD_Approval Situation"; Option)
        {
            OptionMembers = "Pending","Approved","Rejected","Withheld";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = 'Situaci�n de la Aprobaci�n';
            OptionCaptionML = ESP = 'Pendiente,Aprobado,Rechazado,Retenido';

            Description = '###ELIMINAR### no se usa';
            Editable = false;


        }
        field(7207300; "OLD_Approval Coment"; Text[80])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Comentario Aprobaci�n';
            Description = '###ELIMINAR### no se usa';
            Editable = false;


        }
        field(7207301; "OLD_Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha aprobaci�n';
            Description = '###ELIMINAR### no se usa';


        }
        field(7207302; "Approval Check 1"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Aprobaci�n, Check 1';
            Description = 'QB 1.05 - Aprobaciones';
            CaptionClass = '7206910,7000002,7207302';


        }
        field(7207303; "Approval Check 2"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Aprobaci�n, Check 2';
            Description = 'QB 1.05 - Aprobaciones';
            CaptionClass = '7206910,7000002,7207303';


        }
        field(7207304; "Approval Check 3"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Aprobaci�n, Check 3';
            Description = 'QB 1.05 - Aprobaciones';
            CaptionClass = '7206910,7000002,7207304';


        }
        field(7207305; "Approval Check 4"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Aprobaci�n, Check 4';
            Description = 'QB 1.05 - Aprobaciones';
            CaptionClass = '7206910,7000002,7207305';


        }
        field(7207306; "Approval Check 5"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Aprobaci�n, Check 5';
            Description = 'QB 1.05 - Aprobaciones';
            CaptionClass = '7206910,7000002,7207306';


        }
        field(7207336; "QB Approval Circuit Code"; Code[20])
        {
            TableRelation = "QB Approval Circuit Header";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Approval Circuit Code', ESP = 'Circuito de Aprobaci�n';
            Description = 'TO-DO Debe pasar el dato de al aprobaci�n para tenerlo como referencia';


        }
        field(7238177; "QB Budget item"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Account Type" = FILTER("Unit"));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Partida Presupuestaria';
            Description = 'TO-DO Debe pasar el dato de al aprobaci�n para tenerlo como referencia';


        }
    }
    keys
    {
        // key(key1;"Type","Entry No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Type","Document No.")
        //  {
        /* ;
  */
        // }
        // key(key3;"Bill Gr./Pmt. Order No.","Status","Category Code","Redrawn","Due Date")
        //  {
        /* SumIndexFields="Amount for Collection","Remaining Amount","Amt. for Collection (LCY)","Remaining Amt. (LCY)";
  */
        // }
        // key(key4;"Bank Account No.","Dealing Type","Status","Category Code","Redrawn","Honored/Rejtd. at Date","Due Date","Document Type")
        //  {
        /* SumIndexFields="Amount for Collection","Remaining Amount","Amt. for Collection (LCY)","Remaining Amt. (LCY)";
  */
        // }
        // key(key5;"Bank Account No.","Dealing Type","Status","Redrawn","Due Date")
        //  {
        /* SumIndexFields="Amount for Collection","Remaining Amount","Amt. for Collection (LCY)","Remaining Amt. (LCY)";
  */
        // }
        // key(No6;"Bank Account No.","Global Dimension 1 Code","Global Dimension 2 Code","Dealing Type","Status","Category Code","Redrawn","Honored/Rejtd. at Date","Due Date")
        // {
        /* SumIndexFields="Amount for Collection","Remaining Amount","Amt. for Collection (LCY)","Remaining Amt. (LCY)";
  */
        // }
        // key(key7;"Bank Account No.","Bill Gr./Pmt. Order No.","Status","Category Code","Redrawn","Due Date","Document Type")
        //  {
        /* SumIndexFields="Amount for Collection","Remaining Amount","Amt. for Collection (LCY)","Remaining Amt. (LCY)";
  */
        // }
        // key(key8;"Bank Account No.","Dealing Type","Status","Redrawn","Due Date","Document Type")
        //  {
        /* SumIndexFields="Amount for Collection","Remaining Amount","Amt. for Collection (LCY)","Remaining Amt. (LCY)";
  */
        // }
        // key(key9;"Type","Bill Gr./Pmt. Order No.","Global Dimension 1 Code","Global Dimension 2 Code")
        //  {
        /* SumIndexFields="Amount for Collection","Remaining Amount","Amt. for Collection (LCY)","Remaining Amt. (LCY)";
  */
        // }
        // key(key10;"Type","Original Document No.")
        //  {
        /* ;
  */
        // }
        //To be refactored by EU TEam
        // key(Extkey11;"Confirming Line")
        // {
        //     SumIndexFields="Remaining Amount";
        // }
        //key(Extkey12;"Factoring Line","Account No.")
        // {
        /*  SumIndexFields="Remaining Amount";
 */
        // }
    }
    fieldgroups
    {
    }

    var
        //       Text1100000@1000 :
        Text1100000: TextConst ENU = 'untitled', ESP = 'sin t�tulo';


    /*
    procedure Caption () : Text[100];
        var
    //       BankAcc@1100000 :
          BankAcc: Record 270;
        begin
          if "Bank Account No." = '' then
            exit(Text1100000);
          BankAcc.GET("Bank Account No.");
          exit(STRSUBSTNO(BankAcc.Name));
        end;
    */



    /*
    procedure ShowDimensions ()
        var
    //       DimMgt@1100000 :
          DimMgt: Codeunit 408;
        begin
          DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',Type,"Entry No.","Document No."));
        end;

        /*begin
        end.
      */
}





