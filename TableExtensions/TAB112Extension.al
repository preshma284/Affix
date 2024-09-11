tableextension 50132 "QBU Sales Invoice HeaderExt" extends "Sales Invoice Header"
{

    DataCaptionFields = "No.", "Sell-to Customer Name";
    CaptionML = ENU = 'Sales Invoice Header', ESP = 'Hist�rico cab. factura venta';
    LookupPageID = "Posted Sales Invoices";
    DrillDownPageID = "Posted Sales Invoices";

    fields
    {
        field(50002; "G.E.W. mod."; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Invoice Line" WHERE("Document No." = FIELD("No."),
                                                                                                 "G.E.W. mod." = CONST(true)));
            CaptionML = ENU = 'G.E.W. mod.', ESP = 'Ret. B.E. modificada';
            Description = 'BS::20668';
            Editable = false;


        }
        field(50003; "Certification Period"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Certification Period', ESP = 'Periodo certificaci�n';
            Description = 'BS::21212';


        }
        field(50035; "Price review percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Price review percentage', ESP = 'Porcentaje revision precios';
            Description = 'Q12733';


        }
        field(50036; "IPC/Rev aplicado"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'IPC/Rev aplicado', ESP = 'IPC/Rev aplicado';
            Description = 'Q12733';


        }
        field(50120; "Price review"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Price review', ESP = 'Revision precios';
            Description = 'Q12733';


        }
        field(50121; "Price review code"; Code[10])
        {
            TableRelation = "QB Price x job review"."Review code" WHERE("Job No." = FIELD("Job No."));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Price review code', ESP = 'Cod. Revision precios';
            Description = 'Q12733';


        }
        field(50900; "Several Customers Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Several Customers Name', ESP = 'Nombre clientes varios';
            Description = 'Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)';
            Editable = false;


        }
        field(50901; "Several Customers VAT Reg. No."; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Several Cust. VAT Registration No.', ESP = 'CIF/NIF clientes varios';
            Description = 'Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)';
            Editable = false;


        }
        field(7174331; "QuoSII Entity"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SIIEntity"),
                                                                                                   "SII Entity" = CONST(''));


            CaptionML = ENU = 'SII Entity', ESP = 'Entidad SII';
            Description = 'QuoSII_1.4.2.042';

            trigger OnValidate();
            VAR
                //                                                                 SalesLine@7174331 :
                SalesLine: Record 37;
            BEGIN
            END;


        }
        field(7174332; "QuoSII Sales Invoice Type QS"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SalesInvType"));
            CaptionML = ENU = 'Invoice Type', ESP = 'Tipo Factura';
            Description = 'QuoSII';


        }
        field(7174333; "QuoSII Sales Corr. Inv. Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SalesInvType"));
            CaptionML = ENU = 'Corrected Invoice Type', ESP = 'Tipo Factura Rectificativa';
            Description = 'QuoSII';


        }
        field(7174334; "QuoSII Sales Cr.Memo Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SalesInvType"));
            CaptionML = ENU = 'Cr.Memo Type', ESP = 'Tipo Abono';
            Description = 'QuoSII';


        }
        field(7174335; "QuoSII Sales Special Regimen"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"));
            CaptionML = ENU = 'Special Regimen', ESP = 'R�gimen Especial';
            Description = 'QuoSII';


        }
        field(7174336; "QuoSII Sales UE Inv Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("IntraKey"));
            CaptionML = ENU = 'Sales UE Inv Type', ESP = 'Tipo Factura IntraComunitaria';
            Description = 'QuoSII';


        }
        field(7174337; "QuoSII Sales Special Regimen 1"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"));
            CaptionML = ENU = 'Special Regimen 1', ESP = 'R�gimen Especial 1';
            Description = 'QuoSII';


        }
        field(7174338; "QuoSII Sales Special Regimen 2"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"));
            CaptionML = ENU = 'Special Regimen 2', ESP = 'R�gimen Especial 2';
            Description = 'QuoSII';


        }
        field(7174339; "QuoSII Bienes Description"; Text[40])
        {
            CaptionML = ENU = 'Bienes Description', ESP = 'Descripci�n Bienes';
            Description = 'QuoSII';


        }
        field(7174340; "QuoSII Operator Address"; Text[120])
        {
            CaptionML = ENU = 'Operator Address', ESP = 'Direcci�n Operador';
            Description = 'QuoSII';


        }
        field(7174341; "QuoSII Last Ticket No."; Code[20])
        {
            CaptionML = ENU = 'Last Ticket No.', ESP = '�ltimo N� Ticket';
            Description = 'QuoSII';


        }
        field(7174342; "QuoSII Third Party"; Boolean)
        {
            CaptionML = ENU = 'Third Party', ESP = 'Emitida por tercero';
            Description = 'QuoSII';


        }
        field(7174343; "QuoSII First Ticket No."; Code[20])
        {
            CaptionML = ENU = 'First Ticket No.', ESP = 'Primer N� Ticket';
            Description = 'QuoSII';


        }
        field(7174347; "QuoSII Exercise-Period"; Code[7])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'SII Entity', ESP = 'Periodo Liquidaci�n';
            Description = 'QuoSII 1.5d   JAV 12/04/21 Ejercicio y Periodo en que se declara';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 QuoSII@7174331 :
                QuoSII: Integer;
                //                                                                 PurchaseLine@7174332 :
                PurchaseLine: Record 39;
                //                                                                 txtQuoSII000@1100286000 :
                txtQuoSII000: TextConst ESP = 'No se puede cambiar el campo %1 cuando existen l�neas.';
            BEGIN
            END;


        }
        field(7174348; "QuoSII Operation Date"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'SII Entity', ESP = 'Fecha operaci�n';
            Description = 'QuoSII 1.5d   JAV 12/04/21 Fecha de la operaci�n';

            trigger OnValidate();
            VAR
                //                                                                 QuoSII@7174331 :
                QuoSII: Integer;
                //                                                                 PurchaseLine@7174332 :
                PurchaseLine: Record 39;
                //                                                                 txtQuoSII000@1100286000 :
                txtQuoSII000: TextConst ESP = 'No se puede cambiar el campo %1 cuando existen l�neas.';
            BEGIN
            END;


        }
        field(7174365; "QFA Period Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Periodo de Facturaci�n Inicio';
            Description = 'QFA JAV 20/03/21 - Fecha de inicio del periodo de facturaci�n';


        }
        field(7174366; "QFA Period End Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Periodo de Facturaci�n Final';
            Description = 'QFA JAV 20/03/21 - Fecha de fin del periodo de facturaci�n';


        }
        field(7174376; "QFA QuoFacturae status"; Option)
        {
            OptionMembers = "Posted","Posted in RCF","Payment mandatory posted","Paid","Refused","Canceled";
            FieldClass = FlowField;
            CalcFormula = Max("QuoFacturae Entry"."Status" WHERE("Document type" = CONST("Sales invoice"),
                                                                                                     "Document no." = FIELD("No.")));
            CaptionML = ENU = 'Factura-e status', ESP = 'Estado Factura-e';
            OptionCaptionML = ENU = 'Posted,Posted in RCF,Payment mandatory posted,Paid,Refused,Canceled', ESP = 'Registrada,Registrada en RCF,Contabilizada la obligaci�n de pago,Pagada,Rechazada,Anulada';

            Description = 'QFA 0.1';


        }
        field(7207270; "QW Cod. Withholding by GE"; Code[20])
        {
            TableRelation = "Withholding Group"."Code" WHERE("Withholding Type" = FILTER("G.E"));
            CaptionML = ENU = 'Cod. Withholding by G.E', ESP = 'C�d. retenci�n por B.E.';
            Description = 'QB 1.0 - QB22111';


        }
        field(7207271; "QW Cod. Withholding by PIT"; Code[20])
        {
            TableRelation = "Withholding Group"."Code" WHERE("Withholding Type" = FILTER("PIT"));
            CaptionML = ENU = 'Cod. Withholding by PIT', ESP = 'C�d. retenci�n por IRPF';
            Description = 'QB 1.0 - QB22111';


        }
        field(7207272; "QW Total Withholding GE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Invoice Line"."QW Withholding Amount by GE" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Withholding G.E', ESP = 'Total retenci�n B.E.';
            Description = 'QB 1.0 - QB22111';
            Editable = false;


        }
        field(7207273; "QW Total Withholding PIT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Invoice Line"."QW Withholding Amount by PIT" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Withholding PIT', ESP = 'Total retenci�n IRPF';
            Description = 'QB 1.0 - QB22111';
            Editable = false;


        }
        field(7207274; "QW Total Receivable"; Decimal)
        {
            CaptionML = ENU = 'Total a cobrar', ESP = 'Total a cobrar';
            Description = 'QB 1.0 - QB22111';
            Editable = false;


        }
        field(7207275; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';
            Description = 'QB 1.0 - QB2412';


        }
        field(7207276; "Job Sale Doc. Type"; Option)
        {
            OptionMembers = "Standar","Equipament Advance","Advance by Store","Price Review";
            CaptionML = ENU = 'Job Sale Doc. Type', ESP = 'Tipo doc. venta proyecto';
            OptionCaptionML = ENU = 'Standar,Equipament Advance,Advance by Store,Price Review', ESP = 'Estandar,Anticipo de maquinaria,Anticipo por acopios,Revisi�n precios';

            Description = 'QB 1.0 - QB28123';


        }
        field(7207279; "Payment bank No."; Code[20])
        {
            TableRelation = "Bank Account"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment bank No.', ESP = 'N� de banco de pago';
            Description = 'QB 1.0 - Q3707';


        }
        field(7207280; "QB Operation date SII"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha operaci�n SII';
            Description = 'QB 1.0 - QB5555 JAV 04/07/19: Fecha de operaci�n para el SII';


        }
        field(7207282; "QW Withholding mov liq."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Liquida mov. retenci�n n�';
            Description = 'QB 1.04 - JAV 26/05/20: Que movimiento de retenci�n de garant�a liquida esta factura';


        }
        field(7207283; "QB Prepayment Use"; Option)
        {
            OptionMembers = "No","Prepayment","Application";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Uso del Anticipo';
            OptionCaptionML = ENU = 'No,Prepayment,Application', ESP = 'No,Anticipo,Aplicaci�n';

            Description = 'QB 1,06 - Si es un anticipo de proyecto';


        }
        field(7207285; "QB Prepayment Apply"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Descontar Anticipo';
            Description = 'QB 1,06 - Importe del anticipo a descontar';


        }
        field(7207287; "QB Prepayment Type"; Option)
        {
            OptionMembers = "No","Invoice","Bill";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Tipo de Prepago';
            OptionCaptionML = ENU = 'No,Invoice,Bill', ESP = 'No,Factura,Pago';

            Description = 'QB 1.08.43 - Tipo de prepago a generar';


        }
        field(7207289; "QB Prepayment Data"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Datos del Anticipo Aplicado';
            Description = 'QB 1.10.49 JAV 13/06/22: [TT] Indica el c�digo de los datos aplicados del anticipo al documento';


        }



        field(7207296; "QW Base Withholding GE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Invoice Line"."QW Base Withholding by GE" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Withholding G.E', ESP = 'Base retenci�n B.E.';
            Description = 'QB 1.0 - QB22111';
            Editable = false;


        }
        field(7207297; "QW Base Withholding PIT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Invoice Line"."QW Base Withholding by PIT" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Withholding PIT', ESP = 'Base retenci�n IRPF';
            Description = 'QB 1.0 - QB22111';
            Editable = false;


        }
        field(7207298; "QW Total Withholding GE Before"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Invoice Line"."Amount" WHERE("Document No." = FIELD("No."),
                                                                                                      "QW Withholding by GE Line" = CONST(true)));
            CaptionML = ENU = 'Total Withholding G.E', ESP = 'Total retenci�n B.E. Fra.';
            Description = 'QB 1.0 - JAV 23/10/19: - Se doblan los campos de la retenci�n de B.E. para tener ambos importes disponibles';
            Editable = false;


        }
        field(7207306; "SII Year-Month"; Text[7])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'SII Ejercicio-Periodo';
            Description = 'QB 1.05 - JAV Ejercicio y periodo en que se declar� en el SII de Microsoft';
            Editable = false;


        }
        field(7207307; "Certification code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Certification code', ESP = 'C�d. certificaci�n';
            Description = 'QB 1.06 - Nro de la certificaci�n generada';


        }
        field(7207313; "QW Witholding Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha Vto. Retenci�n';
            Description = 'QB 1.06.07 - JAV 30/07/20: - Fecha de vencimiento de la retenci�n de buena ejecuci�n';


        }
    }
    keys
    {
        // key(key1;"No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Order No.")
        //  {
        /* ;
  */
        // }
        // key(key3;"Pre-Assigned No.")
        //  {
        /* ;
  */
        // }
        // key(key4;"Sell-to Customer No.","External Document No.")
        //  {
        /* MaintainSQLIndex=false;
  */
        // }
        // key(key5;"Sell-to Customer No.","Order Date")
        //  {
        /* MaintainSQLIndex=false;
  */
        // }
        // key(key6;"Sell-to Customer No.")
        //  {
        /* ;
  */
        // }
        // key(key7;"Prepayment Order No.","Prepayment Invoice")
        //  {
        /* ;
  */
        // }
        // key(key8;"Bill-to Customer No.")
        //  {
        /* ;
  */
        // }
        // key(key9;"Posting Date")
        //  {
        /* ;
  */
        // }
        // key(key10;"Document Exchange Status")
        //  {
        /* ;
  */
        // }
    }
    fieldgroups
    {
        // fieldgroup(DropDown;"No.","Sell-to Customer No.","Bill-to Customer No.","Posting Date","Posting Description")
        // {
        // 
        // }
        // fieldgroup(Brick;"No.","Sell-to Customer Name","Amount","Due Date","Amount Including VAT")
        // {
        // 
        // }
    }

    var
        //       SalesCommentLine@1001 :
        SalesCommentLine: Record 44;
        //       SalesSetup@1007 :
        SalesSetup: Record 311;
        //       CustLedgEntry@1003 :
        CustLedgEntry: Record 21;
        //       DimMgt@1005 :
        DimMgt: Codeunit 408;
        //       ApprovalsMgmt@1008 :
        ApprovalsMgmt: Codeunit 1535;
        //       UserSetupMgt@1002 :
        UserSetupMgt: Codeunit 5700;
        //       DocTxt@1000 :
        DocTxt: TextConst ENU = 'Invoice', ESP = 'Factura';
        //       PaymentReference@1214 :
        PaymentReference: Text;
        //       PaymentReferenceLbl@1215 :
        PaymentReferenceLbl: Text;
        //       CorrInvDoesNotExistErr@1100000 :
        CorrInvDoesNotExistErr:
// "%1 = number of document"
TextConst ENU = 'The Corrected Invoice No. does not exist. \Identification fields and values:\Corrected Invoice No. = %1.', ESP = 'El N� de factura corregida no existe. \Campos y valores identificativos:\N� factura corregida = %1.';





    /*
    trigger OnDelete();    var
    //                PostedDeferralHeader@1002 :
                   PostedDeferralHeader: Record 1704;
    //                PostSalesDelete@1003 :
                   PostSalesDelete: Codeunit 363;
    //                DeferralUtilities@1001 :
                   DeferralUtilities: Codeunit 1720;
                 begin
                   PostSalesDelete.IsDocumentDeletionAllowed("Posting Date");
                   TESTFIELD("No. Printed");
                   LOCKTABLE;
                   PostSalesDelete.DeleteSalesInvLines(Rec);

                   SalesCommentLine.SETRANGE("Document Type",SalesCommentLine."Document Type"::"Posted Invoice");
                   SalesCommentLine.SETRANGE("No.","No.");
                   SalesCommentLine.DELETEALL;

                   ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);
                   PostedDeferralHeader.DeleteForDoc(DeferralUtilities.GetSalesDeferralDocType,'','',
                     SalesCommentLine."Document Type"::"Posted Invoice","No.");
                 end;

    */




    /*
    procedure SendRecords ()
        var
    //       DocumentSendingProfile@1001 :
          DocumentSendingProfile: Record 60;
    //       DummyReportSelections@1000 :
          DummyReportSelections: Record 77;
    //       IsHandled@1002 :
          IsHandled: Boolean;
        begin
          IsHandled := FALSE;
          OnBeforeSendRecords(DummyReportSelections,Rec,DocTxt,IsHandled);
          if not IsHandled then
            DocumentSendingProfile.SendCustomerRecords(
              DummyReportSelections.Usage::"S.Invoice",Rec,DocTxt,"Bill-to Customer No.","No.",
              FIELDNO("Bill-to Customer No."),FIELDNO("No."));
        end;
    */



    //     procedure SendProfile (var DocumentSendingProfile@1000 :

    /*
    procedure SendProfile (var DocumentSendingProfile: Record 60)
        var
    //       DummyReportSelections@1003 :
          DummyReportSelections: Record 77;
    //       IsHandled@1001 :
          IsHandled: Boolean;
        begin
          IsHandled := FALSE;
          OnBeforeSendProfile(DummyReportSelections,Rec,DocTxt,IsHandled,DocumentSendingProfile);
          if not IsHandled then
            DocumentSendingProfile.Send(
              DummyReportSelections.Usage::"S.Invoice",Rec,"No.","Bill-to Customer No.",
              DocTxt,FIELDNO("Bill-to Customer No."),FIELDNO("No."));
        end;
    */



    //     procedure PrintRecords (ShowRequestPage@1000 :

    /*
    procedure PrintRecords (ShowRequestPage: Boolean)
        var
    //       DocumentSendingProfile@1002 :
          DocumentSendingProfile: Record 60;
    //       DummyReportSelections@1001 :
          DummyReportSelections: Record 77;
    //       IsHandled@1003 :
          IsHandled: Boolean;
        begin
          IsHandled := FALSE;
          OnBeforePrintRecords(DummyReportSelections,Rec,ShowRequestPage,IsHandled);
          if not IsHandled then
            DocumentSendingProfile.TrySendToPrinter(
              DummyReportSelections.Usage::"S.Invoice",Rec,FIELDNO("Bill-to Customer No."),ShowRequestPage);
        end;
    */



    //     procedure EmailRecords (ShowDialog@1000 :

    /*
    procedure EmailRecords (ShowDialog: Boolean)
        var
    //       DocumentSendingProfile@1003 :
          DocumentSendingProfile: Record 60;
    //       DummyReportSelections@1001 :
          DummyReportSelections: Record 77;
    //       IsHandled@1002 :
          IsHandled: Boolean;
        begin
          IsHandled := FALSE;
          OnBeforeEmailRecords(DummyReportSelections,Rec,DocTxt,ShowDialog,IsHandled);
          if not IsHandled then
            DocumentSendingProfile.TrySendToEMail(
              DummyReportSelections.Usage::"S.Invoice",Rec,FIELDNO("No."),DocTxt,FIELDNO("Bill-to Customer No."),ShowDialog);
        end;
    */




    /*
    procedure GetDocTypeTxt () : Text[50];
        begin
          exit(DocTxt);
        end;
    */




    /*
    procedure Navigate ()
        var
    //       NavigateForm@1000 :
          NavigateForm: Page 344;
        begin
          NavigateForm.SetDoc("Posting Date","No.");
          NavigateForm.RUN;
        end;
    */




    /*
    procedure LookupAdjmtValueEntries ()
        var
    //       ValueEntry@1000 :
          ValueEntry: Record 5802;
        begin
          ValueEntry.SETCURRENTKEY("Document No.");
          ValueEntry.SETRANGE("Document No.","No.");
          ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Invoice");
          ValueEntry.SETRANGE(Adjustment,TRUE);
          PAGE.RUNMODAL(0,ValueEntry);
        end;
    */


    //     procedure LookupInvoice (CustNo@1100000 :

    /*
    procedure LookupInvoice (CustNo: Code[20]) Selected : Boolean;
        var
    //       PostedSalesInvoices@1100001 :
          PostedSalesInvoices: Page 143;
        begin
          SETCURRENTKEY("No.");
          SETRANGE("Bill-to Customer No.",CustNo);

          PostedSalesInvoices.SETTABLEVIEW(Rec);
          PostedSalesInvoices.SETRECORD(Rec);
          PostedSalesInvoices.LOOKUPMODE(TRUE);
          if PostedSalesInvoices.RUNMODAL = ACTION::LookupOK then begin
            PostedSalesInvoices.GETRECORD(Rec);
            Selected := TRUE;
          end;
          CLEAR(PostedSalesInvoices);
          exit(Selected);
        end;
    */




    /*
    procedure GetCustomerVATRegistrationNumber () : Text;
        begin
          exit("VAT Registration No.");
        end;
    */




    /*
    procedure GetCustomerVATRegistrationNumberLbl () : Text;
        begin
          if "VAT Registration No." = '' then
            exit('');
          exit(FIELDCAPTION("VAT Registration No."));
        end;
    */




    /*
    procedure GetCustomerGlobalLocationNumber () : Text;
        var
    //       Customer@1000 :
          Customer: Record 18;
        begin
          if Customer.GET("Sell-to Customer No.") then
            exit(Customer.GLN);
          exit('');
        end;
    */




    /*
    procedure GetCustomerGlobalLocationNumberLbl () : Text;
        var
    //       Customer@1000 :
          Customer: Record 18;
        begin
          if Customer.GET("Sell-to Customer No.") then
            exit(Customer.FIELDCAPTION(GLN));
          exit('');
        end;
    */




    /*
    procedure GetPaymentReference () : Text;
        begin
          OnGetPaymentReference(PaymentReference);
          exit(PaymentReference);
        end;
    */




    /*
    procedure GetPaymentReferenceLbl () : Text;
        begin
          OnGetPaymentReferenceLbl(PaymentReferenceLbl);
          exit(PaymentReferenceLbl);
        end;
    */




    /*
    procedure GetLegalStatement () : Text;
        begin
          SalesSetup.GET;
          exit(SalesSetup.GetLegalStatement);
        end;
    */




    /*
    procedure GetRemainingAmount () : Decimal;
        var
    //       CustLedgerEntry@1000 :
          CustLedgerEntry: Record 21;
        begin
          CustLedgerEntry.SETRANGE("Customer No.","Bill-to Customer No.");
          CustLedgerEntry.SETRANGE("Posting Date","Posting Date");
          CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice);
          CustLedgerEntry.SETRANGE("Document No.","No.");
          CustLedgerEntry.SETAUTOCALCFIELDS("Remaining Amount");

          if not CustLedgerEntry.FINDFIRST then
            exit(0);

          exit(CustLedgerEntry."Remaining Amount");
        end;
    */


    //     procedure CheckCorrectedDocumentExist (CustNo@1100000 : Code[20];CorrInvNo@1100001 :

    /*
    procedure CheckCorrectedDocumentExist (CustNo: Code[20];CorrInvNo: Code[20])
        begin
          SETRANGE("Bill-to Customer No.",CustNo);
          SETRANGE("No.",CorrInvNo);
          if not FINDFIRST then
            ERROR(CorrInvDoesNotExistErr,CorrInvNo);
        end;
    */




    /*
    procedure ShowDimensions ()
        begin
          DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."));
        end;
    */




    /*
    procedure SetSecurityFilterOnRespCenter ()
        begin
          if UserSetupMgt.GetSalesFilter <> '' then begin
            FILTERGROUP(2);
            SETRANGE("Responsibility Center",UserSetupMgt.GetSalesFilter);
            FILTERGROUP(0);
          end;
        end;
    */




    /*
    procedure GetDocExchStatusStyle () : Text;
        begin
          CASE "Document Exchange Status" OF
            "Document Exchange Status"::"not Sent":
              exit('Standard');
            "Document Exchange Status"::"Sent to Document Exchange Service":
              exit('Ambiguous');
            "Document Exchange Status"::"Delivered to Recipient":
              exit('Favorable');
            else
              exit('Unfavorable');
          end;
        end;
    */




    /*
    procedure ShowActivityLog ()
        var
    //       ActivityLog@1000 :
          ActivityLog: Record 710;
        begin
          ActivityLog.ShowEntries(RECORDID);
        end;
    */




    /*
    procedure GetSelectedPaymentsText () : Text;
        var
    //       PaymentServiceSetup@1000 :
          PaymentServiceSetup: Record 1060;
        begin
          exit(PaymentServiceSetup.GetSelectedPaymentsText("Payment Service Set ID"));
        end;
    */




    /*
    procedure GetWorkDescription () : Text;
        begin
          CALCFIELDS("Work Description");
          exit(GetWorkDescriptionWorkDescriptionCalculated);
        end;
    */




    /*
    procedure GetWorkDescriptionWorkDescriptionCalculated () : Text;
        var
          TempBlob : Codeunit "Temp Blob";
    Blob : OutStream;
    InStr : InStream;

    //       CR@1004 :
          CR: Text[1];
        begin
          if not "Work Description".HASVALUE then
            exit('');

          CR[1] := 10;
          // TempBlob.Blob := "Work Description";
    //To be tested

    TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
    Blob.Write("Work Description");
          // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
    //To be tested

    TempBlob.CreateInStream(InStr, TextEncoding::Windows);
    InStr.Read(CR);
    exit(CR);
        end;
    */




    /*
    procedure GetCurrencySymbol () : Text[10];
        var
    //       GeneralLedgerSetup@1000 :
          GeneralLedgerSetup: Record 98;
    //       Currency@1001 :
          Currency: Record 4;
        begin
          if GeneralLedgerSetup.GET then
            if ("Currency Code" = '') or ("Currency Code" = GeneralLedgerSetup."LCY Code") then
              exit(GeneralLedgerSetup.GetCurrencySymbol);

          if Currency.GET("Currency Code") then
            exit(Currency.GetCurrencySymbol);

          exit("Currency Code");
        end;
    */




    /*
    procedure DocExchangeStatusIsSent () : Boolean;
        begin
          exit("Document Exchange Status" <> "Document Exchange Status"::"not Sent");
        end;
    */




    /*
    procedure ShowCanceledOrCorrCrMemo ()
        begin
          CALCFIELDS(Cancelled,Corrective);
          CASE TRUE OF
            Cancelled:
              ShowCorrectiveCreditMemo;
            Corrective:
              ShowCancelledCreditMemo;
          end;
        end;
    */




    /*
    procedure ShowCorrectiveCreditMemo ()
        var
    //       CancelledDocument@1000 :
          CancelledDocument: Record 1900;
    //       SalesCrMemoHeader@1001 :
          SalesCrMemoHeader: Record 114;
        begin
          CALCFIELDS(Cancelled);
          if not Cancelled then
            exit;

          if CancelledDocument.FindSalesCancelledInvoice("No.") then begin
            SalesCrMemoHeader.GET(CancelledDocument."Cancelled By Doc. No.");
            PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
          end;
        end;
    */




    /*
    procedure ShowCancelledCreditMemo ()
        var
    //       CancelledDocument@1000 :
          CancelledDocument: Record 1900;
    //       SalesCrMemoHeader@1001 :
          SalesCrMemoHeader: Record 114;
        begin
          CALCFIELDS(Corrective);
          if not Corrective then
            exit;

          if CancelledDocument.FindSalesCorrectiveInvoice("No.") then begin
            SalesCrMemoHeader.GET(CancelledDocument."Cancelled Doc. No.");
            PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
          end;
        end;
    */




    /*
    procedure GetDefaultEmailDocumentName () : Text[150];
        begin
          exit(DocTxt);
        end;
    */



    //     LOCAL procedure OnBeforeEmailRecords (ReportSelections@1003 : Record 77;SalesInvoiceHeader@1002 : Record 112;DocTxt@1004 : Text;ShowDialog@1001 : Boolean;var IsHandled@1000 :

    /*
    LOCAL procedure OnBeforeEmailRecords (ReportSelections: Record 77;SalesInvoiceHeader: Record 112;DocTxt: Text;ShowDialog: Boolean;var IsHandled: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforePrintRecords (ReportSelections@1003 : Record 77;SalesInvoiceHeader@1002 : Record 112;ShowRequestPage@1001 : Boolean;var IsHandled@1000 :

    /*
    LOCAL procedure OnBeforePrintRecords (ReportSelections: Record 77;SalesInvoiceHeader: Record 112;ShowRequestPage: Boolean;var IsHandled: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeSendProfile (ReportSelections@1003 : Record 77;SalesInvoiceHeader@1002 : Record 112;DocTxt@1001 : Text;var IsHandled@1000 : Boolean;var DocumentSendingProfile@1004 :

    /*
    LOCAL procedure OnBeforeSendProfile (ReportSelections: Record 77;SalesInvoiceHeader: Record 112;DocTxt: Text;var IsHandled: Boolean;var DocumentSendingProfile: Record 60)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeSendRecords (ReportSelections@1000 : Record 77;SalesInvoiceHeader@1001 : Record 112;DocTxt@1002 : Text;var IsHandled@1003 :

    /*
    LOCAL procedure OnBeforeSendRecords (ReportSelections: Record 77;SalesInvoiceHeader: Record 112;DocTxt: Text;var IsHandled: Boolean)
        begin
        end;

        [Integration(TRUE)]
    */

    //     LOCAL procedure OnGetPaymentReference (var PaymentReference@1213 :

    /*
    LOCAL procedure OnGetPaymentReference (var PaymentReference: Text)
        begin
        end;
    */



    //     LOCAL procedure OnGetPaymentReferenceLbl (var PaymentReferenceLbl@1213 :

    /*
    LOCAL procedure OnGetPaymentReferenceLbl (var PaymentReferenceLbl: Text)
        begin
        end;

        /*begin
        //{
    //      QuoSII1.4 23/04/18 PEL - Cambiado primer semestre en Sales Invoice Type, Sales Invoice Type 1 y Sales Invoice Type 2
    //      MCG 19/07/18: - Q3707 A�adido campo "Payment bank No."
    //      JAV 23/10/19: - Se a�aden los campos "Base Withholding G.E", "Base Withholding PIT" y "Total Withholding G.E Before"
    //      Q12733 EPV 16/02/22: Add fields "Price review", "Price review code", "Price review percentage" and IPC/Rev aplicadO
    //      Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.).  NewFields: 50900, 50901
    //      BS::20668 CSM 04/01/24 � VEN027 Modificar importe retenci�n en venta.
    //      BS::21212 CSM 18/03/24 � VEN017 Inf. Clientes previsi�n tesorer�a V3-CR.  New Field: 50003
    //    }
        end.
      */
}





