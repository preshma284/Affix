tableextension 50110 "QBU Vendor Ledger EntryExt" extends "Vendor Ledger Entry"
{


    CaptionML = ENU = 'Vendor Ledger Entry', ESP = 'Mov. proveedor';
    LookupPageID = "Vendor Ledger Entries";
    DrillDownPageID = "Vendor Ledger Entries";

    fields
    {
        field(50000; "QBU En Relaci�n de efectos"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("QB Crear Efectos Linea"."Relacion No." WHERE("Vendor No." = FIELD("Vendor No."),
                                                                                                                     "Document Type" = FIELD("Document Type"),
                                                                                                                     "Document No." = FIELD("Document No."),
                                                                                                                     "Bill No." = FIELD("Bill No.")));
            CaptionML = ESP = 'En Relaci�n de efectos';
            Description = '18765';
            Editable = false;


        }
        field(50001; "QBU Several Vendors Name"; Text[50])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Several Vendors Name', ESP = 'Nombre proveedores varios';
            Description = 'Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)';


        }
        field(50002; "QBU Several Vendors VAT Reg. No."; Text[20])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Several Vendors VAT Registration No.', ESP = 'CIF/NIF proveedores varios';
            Description = 'Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)';


        }
        field(50003; "QBU Fecha Recepci�n"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Q20198';


        }
        field(50011; "QBU Comentarios filtro"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Filter Comment', ESP = 'Comentarios filtro';
            Description = 'BS::19798';
            Editable = false;


        }
        field(50012; "QBU Notas filtro"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Notas filtro', ESP = 'Notas filtro';
            Description = 'BS::19798';
            Editable = false;


        }
        field(7174331; "QBU QuoSII Exported"; Boolean)
        {
            CaptionML = ENU = 'SII Exported', ESP = 'Exportado SII';
            Description = 'QuoSII';


        }
        field(7174332; "QBU QuoSII Purch. Invoice Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("PurchInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Invoice Type', ESP = 'Tipo Factura';
            Description = 'QuoSII';


        }
        field(7174333; "QBU QuoSII Purch. Corr. Inv. Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("PurchInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Corrected Invoice Type', ESP = 'Tipo Factura Rectificativa';
            Description = 'QuoSII';


        }
        field(7174334; "QBU QuoSII Purch. Cr.Memo Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("CorrectedInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Cr. Memo Type', ESP = 'Tipo Abono';
            Description = 'QuoSII';


        }
        field(7174335; "QBU QuoSII Purch. Special Reg."; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialPurchInv"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Special Regimen', ESP = 'R�gimen Especial';
            Description = 'QuoSII';


        }
        field(7174336; "QBU QuoSII Purch. Special Reg. 1"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialPurchInv"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Special Regimen 1', ESP = 'R�gimen Especial 1';
            Description = 'QuoSII';


        }
        field(7174337; "QBU QuoSII Purch. Special Reg. 2"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialPurchInv"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Special Regimen 2', ESP = 'R�gimen Especial 2';
            Description = 'QuoSII';


        }
        field(7174338; "QBU QuoSII Purch. UE Inv Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("IntraKey"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Sales UE Inv Type', ESP = 'Tipo Factura IntraComunitaria';
            Description = 'QuoSII';


        }
        field(7174339; "QBU QuoSII UE Country"; Code[10])
        {
            TableRelation = "Country/Region"."QuoSII Country Code";
            CaptionML = ENU = 'UE Country', ESP = 'Estado Miembro';
            Description = 'QuoSII';


        }
        field(7174340; "QBU QuoSII Bienes Description"; Text[40])
        {
            CaptionML = ENU = 'Bienes Description', ESP = 'Descripci�n Bienes';
            Description = 'QuoSII';


        }
        field(7174341; "QBU QuoSII Operator Address"; Text[120])
        {
            CaptionML = ENU = 'Operator Address', ESP = 'Direcci�n Operador';
            Description = 'QuoSII';


        }
        field(7174342; "QBU QuoSII Medio Pago"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("PaymentMethod"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Payment Method', ESP = 'Medio Pago';
            Description = 'QuoSII';


        }
        field(7174343; "QBU QuoSII CuentaMedioPago"; Text[34])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("PaymentMethod"));
            CaptionML = ENU = 'Payment Account', ESP = 'Cuenta Pago';
            Description = 'QuoSII';


        }
        field(7174344; "QBU QuoSII Last Ticket No."; Code[20])
        {
            CaptionML = ENU = 'Last Ticket No.', ESP = '�ltimo N� Ticket';
            Description = 'QuoSII';


        }
        field(7174345; "QBU QuoSII Third Party"; Boolean)
        {
            CaptionML = ENU = 'Third Party', ESP = 'Emitida por tercero';
            Description = 'QuoSII';


        }
        field(7174346; "QBU QuoSII AEAT Status"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("SII Document Shipment Line"."AEAT Status" WHERE("Entry No." = FIELD("Entry No."),
                                                                                                                        "Document Type" = FILTER('FR' | 'PR' | 'OI')));
            CaptionML = ENU = 'AEAT Status', ESP = 'Estado AEAT';
            Description = 'QuoSII';
            Editable = false;


        }
        field(7174347; "QBU QuoSII Ship No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("SII Document Shipment Line"."Ship No." WHERE("Entry No." = FIELD("Entry No."),
                                                                                                                     "Document Type" = FILTER('FR' | 'PR' | 'OI')));
            CaptionML = ENU = 'Ship No.', ESP = 'N� Env�o';
            Description = 'QuoSII';
            Editable = false;


        }
        field(7174348; "QBU QuoSII Entity"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SIIEntity"),
                                                                                                   "SII Entity" = CONST(''));
            CaptionML = ENU = 'SII Entity', ESP = 'Entidad SII';
            Description = 'QuoSII_1.4.2.042';


        }
        field(7174350; "QBU QuoSII Auto Posting Date"; Date)
        {
            CaptionML = ENU = 'SII Auto Posting Date', ESP = 'SII Fecha Registro Auto';
            Description = 'QuoSII_1.3.03.006';


        }
        field(7174351; "QBU QuoSII Use Auto Date"; Boolean)
        {
            CaptionML = ENU = 'Use Auto Date', ESP = 'Usar Fecha Auto';
            Description = 'QuoSII_1.3.03.006';


        }
        field(7207270; "QBU Expense Note Code"; Code[20])
        {
            CaptionML = ENU = 'Expense Note Code', ESP = 'C�d. Nota gasto';
            Description = 'QB 1.00 - QB22111';
            Editable = false;


        }
        field(7207271; "QBU Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';
            Description = 'QB 1.00';


        }
        field(7207272; "QBU To Liquidate"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'To Liquidate', ESP = 'A liquidar';
            Description = 'QB 1.06.15';


        }
        field(7207273; "QBU Original Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Vencimiento Contractual';
            Description = 'QB 1.06.15 - JAV 23/09/20: - Fecha de vencimiento original del documento, solo se establece si se ha cambiado el vto tras el registro.';


        }
        field(7207274; "QBU Shipment Remaining Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount" WHERE("Vendor Ledger Entry No." = FIELD("Entry No."),
                                                                                                               "Posting Date" = FIELD("Date Filter")));
            CaptionML = ENU = 'Remaining Amount', ESP = 'Importe pendiente del Albar�n';
            Description = 'QB 1.06.20 - JAV 12/10/20: - Importe pendiente para el caso de que el tipo de moivimiento sea albar�n';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(7207275; "QBU Shipment Remaining Am (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor Ledger Entry No." = FIELD("Entry No."),
                                                                                                                       "Posting Date" = FIELD("Date Filter")));
            CaptionML = ENU = 'Remaining Amt. (LCY)', ESP = 'Importe pendiente  del Albar�n (DL)';
            Description = 'QB 1.06.20 - JAV 12/10/20: - Importe pendiente para el caso de que el tipo de moivimiento sea albar�n';
            Editable = false;
            AutoFormatType = 1;


        }
        field(7207276; "QBU Vendor Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor"."Name" WHERE("No." = FIELD("Vendor No.")));
            CaptionML = ESP = 'Nombre del Proveedor';
            Description = 'QB 1.10.27 JAV 23/03/22: - [TT: Nombre del proveedor asociado al movimiento]';


        }
        field(7207290; "QBU QW Withholding Entry"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Withholding Entry', ESP = 'M�v. retenci�n';
            Description = 'QB 1.00 - QB180720';


        }
        field(7207292; "QBU Shipment Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� L�nea del albar�n';
            Description = 'QB 1.06.21  - JAV 21/10/20: - Si es un albar�n de compra, de que l�nea es';


        }
        field(7207294; "QBU Prepayment"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'QB Prepayment', ESP = 'Prepago QB';
            Description = 'QB 1.08.43,Q13154';


        }
        field(7207300; "QBU Do not sent to SII"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'No subir al SII';
            Description = 'QB 1.10.40 - QuoSII 1.06.07  JAV 11/05/22: - Si se marca este campo, el movimiento no debe subir al SII de MS ni al QuoSII';


        }
        field(7207499; "QBU Payable Bank No."; Code[20])
        {
            TableRelation = "Bank Account";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'QB Payable Bank No.', ESP = 'N� de banco de pago';
            Description = 'QB 1.09.22 JAV 06/10/21 Banco por defecto para los pagos a este proveedor';


        }
        field(7207500; "QBU Budget Item"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Partida Presupuestaria';
            Description = 'QB 1.10.44 JAV 25/05/22: - Partida presupuestaria asociada al movimiento';


        }
    }
    keys
    {
        // key(key1;"Entry No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Vendor No.","Posting Date","Currency Code")
        //  {
        /* SumIndexFields="Purchase (LCY)","Inv. Discount (LCY)";
  */
        // }
        // key(No3;"Vendor No.","Currency Code","Posting Date")
        // {
        /* ;
  */
        // }
        // key(key4;"Document No.")
        //  {
        /* ;
  */
        // }
        // key(key5;"External Document No.")
        //  {
        /* ;
  */
        // }
        // key(key6;"Vendor No.","Open","Positive","Due Date","Currency Code")
        //  {
        /* ;
  */
        // }
        // key(key7;"Open","Due Date")
        //  {
        /* ;
  */
        // }
        // key(key8;"Closed by Entry No.")
        //  {
        /* ;
  */
        // }
        // key(key9;"Transaction No.")
        //  {
        /* ;
  */
        // }
        // key(key10;"Vendor No.","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date","Currency Code")
        //  {
        /* SumIndexFields="Purchase (LCY)","Inv. Discount (LCY)","Pmt. Disc. Rcd.(LCY)";
  */
        // }
        // key(No11;"Vendor No.","Open","Global Dimension 1 Code","Global Dimension 2 Code","Positive","Due Date","Currency Code")
        // {
        /* ;
  */
        // }
        // key(No12;"Open","Global Dimension 1 Code","Global Dimension 2 Code","Due Date")
        // {
        /* ;
  */
        // }
        // key(key13;"Vendor No.","Applies-to ID","Open","Positive","Due Date")
        //  {
        /* ;
  */
        // }
        // key(key14;"Vendor No.","Document Type","Document Situation","Document Status")
        //  {
        /* SumIndexFields="Remaining Amount (LCY) stats.","Amount (LCY) stats.";
  */
        // }
        // key(key15;"Document No.","Document Type","Vendor No.")
        //  {
        /* ;
  */
        // }
        // key(key16;"Applies-to ID","Document Type")
        //  {
        /* ;
  */
        // }
        // key(key17;"Document Type","Vendor No.","Document Date","Currency Code")
        //  {
        /* ;
  */
        // }
        // key(key18;"Vendor Posting Group")
        //  {
        /* ;
  */
        // }
    }
    fieldgroups
    {
        // fieldgroup(DropDown;"Entry No.","Description","Vendor No.","Posting Date","Document Type","Document No.")
        // {
        // 
        // }
        // fieldgroup(Brick;"Document No.","Description","Remaining Amt. (LCY)","Due Date")
        // {
        // 
        // }
    }

    var
        //       FieldIsNotEmptyErr@1002 :
        FieldIsNotEmptyErr:
// "%1=Field;%2=Field"
TextConst ENU = '%1 cannot be used while %2 has a value.', ESP = '%1 no se puede usar mientras %2 contenga un valor.';
        //       MustHaveSameSignErr@1000 :
        MustHaveSameSignErr: TextConst ENU = 'must have the same sign as %1', ESP = 'debe tener el mismo signo que %1.';
        //       MustNotBeLargerErr@1001 :
        MustNotBeLargerErr: TextConst ENU = 'must not be larger than %1', ESP = 'no debe ser mayor que %1.';
        //       Text1100000@1100001 :
        Text1100000: TextConst ENU = 'Payment Discount (VAT Excl.)', ESP = '% Dto. P.P. (IVA exclu�do)';
        //       Text1100001@1100002 :
        Text1100001: TextConst ENU = 'Payment Discount (VAT Adjustment)', ESP = '% Dto. P.P. (IVA ajustado)';
        //       DocMisc@1100000 :
        DocMisc: Codeunit 7000007;
        //       CannotChangePmtMethodErr@1100003 :
        CannotChangePmtMethodErr: TextConst ENU = 'For Cartera-based bills and invoices, you cannot change the Payment Method Code to this value.', ESP = 'Para los efectos y las facturas basadas en Cartera, no puede modificar el C�digo de forma de pago a este valor.';



    /*
    procedure ShowDoc () : Boolean;
        var
    //       PurchInvHeader@1003 :
          PurchInvHeader: Record 122;
    //       PurchCrMemoHdr@1002 :
          PurchCrMemoHdr: Record 124;
        begin
          CASE "Document Type" OF
            "Document Type"::Invoice:
              if PurchInvHeader.GET("Document No.") then begin
                PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
                exit(TRUE);
              end;
            "Document Type"::"Credit Memo":
              if PurchCrMemoHdr.GET("Document No.") then begin
                PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHdr);
                exit(TRUE);
              end
          end;
        end;
    */



    //     procedure DrillDownOnEntries (var DtldVendLedgEntry@1000 :

    /*
    procedure DrillDownOnEntries (var DtldVendLedgEntry: Record 380)
        var
    //       VendLedgEntry@1001 :
          VendLedgEntry: Record 25;
        begin
          VendLedgEntry.RESET;
          DtldVendLedgEntry.COPYFILTER("Vendor No.",VendLedgEntry."Vendor No.");
          DtldVendLedgEntry.COPYFILTER("Currency Code",VendLedgEntry."Currency Code");
          DtldVendLedgEntry.COPYFILTER("Initial Entry Global Dim. 1",VendLedgEntry."Global Dimension 1 Code");
          DtldVendLedgEntry.COPYFILTER("Initial Entry Global Dim. 2",VendLedgEntry."Global Dimension 2 Code");
          DtldVendLedgEntry.COPYFILTER("Initial Entry Due Date",VendLedgEntry."Due Date");
          VendLedgEntry.SETCURRENTKEY("Vendor No.","Posting Date");
          VendLedgEntry.SETRANGE(Open,TRUE);
          OnBeforeDrillDownEntries(VendLedgEntry,DtldVendLedgEntry);
          PAGE.RUN(0,VendLedgEntry);
        end;
    */



    //     procedure DrillDownOnOverdueEntries (var DtldVendLedgEntry@1000 :

    /*
    procedure DrillDownOnOverdueEntries (var DtldVendLedgEntry: Record 380)
        var
    //       VendLedgEntry@1001 :
          VendLedgEntry: Record 25;
        begin
          VendLedgEntry.RESET;
          DtldVendLedgEntry.COPYFILTER("Vendor No.",VendLedgEntry."Vendor No.");
          DtldVendLedgEntry.COPYFILTER("Currency Code",VendLedgEntry."Currency Code");
          DtldVendLedgEntry.COPYFILTER("Initial Entry Global Dim. 1",VendLedgEntry."Global Dimension 1 Code");
          DtldVendLedgEntry.COPYFILTER("Initial Entry Global Dim. 2",VendLedgEntry."Global Dimension 2 Code");
          VendLedgEntry.SETCURRENTKEY("Vendor No.","Posting Date");
          VendLedgEntry.SETFILTER("Date Filter",'..%1',WORKDATE);
          VendLedgEntry.SETFILTER("Due Date",'<%1',WORKDATE);
          VendLedgEntry.SETFILTER("Remaining Amount",'<>%1',0);
          OnBeforeDrillDownOnOverdueEntries(VendLedgEntry,DtldVendLedgEntry);
          PAGE.RUN(0,VendLedgEntry);
        end;
    */




    /*
    procedure GetOriginalCurrencyFactor () : Decimal;
        begin
          if "Original Currency Factor" = 0 then
            exit(1);
          exit("Original Currency Factor");
        end;
    */



    /*
    procedure CheckBillSituation ()
        var
    //       Doc@1000 :
          Doc: Record 7000002;
    //       Text1100100@1100002 :
          Text1100100: TextConst ENU='%1 cannot be applied, since it is included in a payment order.',ESP='%1 no se puede liquidar, ya que est� incluido en una orden pago.';
    //       Text1100101@1100001 :
          Text1100101: TextConst ENU=' Remove it from its payment order and try again.',ESP=' B�rrelo de la orden de pago e int�ntelo de nuevo.';
        begin
          if Doc.GET(Doc.Type::Payable,Rec."Entry No.") then
            if Doc."Bill Gr./Pmt. Order No." <> '' then
              ERROR(
                Text1100100 +
                Text1100101,
                Rec.Description);
        end;
    */




    /*
    procedure GetAdjustedCurrencyFactor () : Decimal;
        begin
          if "Adjusted Currency Factor" = 0 then
            exit(1);
          exit("Adjusted Currency Factor");
        end;
    */




    /*
    procedure ShowDimensions ()
        var
    //       DimMgt@1000 :
          DimMgt: Codeunit 408;
        begin
          DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
        end;
    */




    /*
    procedure SetStyle () : Text;
        begin
          if Open then begin
            if WORKDATE > "Due Date" then
              exit('Unfavorable')
          end else
            if "Closed at Date" > "Due Date" then
              exit('Attention');
          exit('');
        end;
    */



    //     procedure CopyFromGenJnlLine (GenJnlLine@1000 :

    /*
    procedure CopyFromGenJnlLine (GenJnlLine: Record 81)
        begin
          "Vendor No." := GenJnlLine."Account No.";
          "Posting Date" := GenJnlLine."Posting Date";
          "Document Date" := GenJnlLine."Document Date";
          "Document Type" := GenJnlLine."Document Type";
          "Document No." := GenJnlLine."Document No.";
          "External Document No." := GenJnlLine."External Document No.";
          Description := GenJnlLine.Description;
          "Currency Code" := GenJnlLine."Currency Code";
          "Purchase (LCY)" := GenJnlLine."Sales/Purch. (LCY)";
          "Inv. Discount (LCY)" := GenJnlLine."Inv. Discount (LCY)";
          "Buy-from Vendor No." := GenJnlLine."Sell-to/Buy-from No.";
          "Vendor Posting Group" := GenJnlLine."Posting Group";
          "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
          "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
          "Dimension Set ID" := GenJnlLine."Dimension Set ID";
          "Purchaser Code" := GenJnlLine."Salespers./Purch. Code";
          "Source Code" := GenJnlLine."Source Code";
          "On Hold" := GenJnlLine."On Hold";
          "Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
          "Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
          "Due Date" := GenJnlLine."Due Date";
          "Pmt. Discount Date" := GenJnlLine."Pmt. Discount Date";
          "Applies-to ID" := GenJnlLine."Applies-to ID";
          "Journal Batch Name" := GenJnlLine."Journal Batch Name";
          "Reason Code" := GenJnlLine."Reason Code";
          "User ID" := USERID;
          "Bal. Account Type" := GenJnlLine."Bal. Account Type";
          "Bal. Account No." := GenJnlLine."Bal. Account No.";
          "No. Series" := GenJnlLine."Posting No. Series";
          "IC Partner Code" := GenJnlLine."IC Partner Code";
          Prepayment := GenJnlLine.Prepayment;
          "Recipient Bank Account" := GenJnlLine."Recipient Bank Account";
          "Message to Recipient" := GenJnlLine."Message to Recipient";
          "Applies-to Ext. Doc. No." := GenJnlLine."Applies-to Ext. Doc. No.";
          "Creditor No." := GenJnlLine."Creditor No.";
          "Payment Reference" := GenJnlLine."Payment Reference";
          "Payment Method Code" := GenJnlLine."Payment Method Code";
          "Exported to Payment File" := GenJnlLine."Exported to Payment File";
          "Generated Autodocument" := GenJnlLine."Generate AutoInvoices";
          "Autodocument No." := GenJnlLine."AutoDoc. No.";
          "Payment Terms Code" := GenJnlLine."Payment Terms Code";
          "Bill No." := GenJnlLine."Bill No.";
          "Applies-to Bill No." := GenJnlLine."Applies-to Bill No.";
          "Invoice Type" := GenJnlLine."Purch. Invoice Type";
          "Cr. Memo Type" := GenJnlLine."Purch. Cr. Memo Type";
          "Special Scheme Code" := GenJnlLine."Purch. Special Scheme Code";
          "Correction Type" := GenJnlLine."Correction Type";
          "Corrected Invoice No." := GenJnlLine."Corrected Invoice No.";
          "Succeeded Company Name" := GenJnlLine."Succeeded Company Name";
          "Succeeded VAT Registration No." := GenJnlLine."Succeeded VAT Registration No.";

          OnAfterCopyVendLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
        end;
    */



    //     procedure CopyFromCVLedgEntryBuffer (var CVLedgerEntryBuffer@1000 :

    /*
    procedure CopyFromCVLedgEntryBuffer (var CVLedgerEntryBuffer: Record 382)
        begin
          "Entry No." := CVLedgerEntryBuffer."Entry No.";
          "Vendor No." := CVLedgerEntryBuffer."CV No.";
          "Posting Date" := CVLedgerEntryBuffer."Posting Date";
          "Document Type" := CVLedgerEntryBuffer."Document Type";
          "Document No." := CVLedgerEntryBuffer."Document No.";
          Description := CVLedgerEntryBuffer.Description;
          "Currency Code" := CVLedgerEntryBuffer."Currency Code";
          Amount := CVLedgerEntryBuffer.Amount;
          "Remaining Amount" := CVLedgerEntryBuffer."Remaining Amount";
          "Original Amount" := CVLedgerEntryBuffer."Original Amount";
          "Original Amt. (LCY)" := CVLedgerEntryBuffer."Original Amt. (LCY)";
          "Remaining Amt. (LCY)" := CVLedgerEntryBuffer."Remaining Amt. (LCY)";
          "Amount (LCY)" := CVLedgerEntryBuffer."Amount (LCY)";
          "Purchase (LCY)" := CVLedgerEntryBuffer."Sales/Purchase (LCY)";
          "Inv. Discount (LCY)" := CVLedgerEntryBuffer."Inv. Discount (LCY)";
          "Buy-from Vendor No." := CVLedgerEntryBuffer."Bill-to/Pay-to CV No.";
          "Vendor Posting Group" := CVLedgerEntryBuffer."CV Posting Group";
          "Global Dimension 1 Code" := CVLedgerEntryBuffer."Global Dimension 1 Code";
          "Global Dimension 2 Code" := CVLedgerEntryBuffer."Global Dimension 2 Code";
          "Dimension Set ID" := CVLedgerEntryBuffer."Dimension Set ID";
          "Purchaser Code" := CVLedgerEntryBuffer."Salesperson Code";
          "User ID" := CVLedgerEntryBuffer."User ID";
          "Source Code" := CVLedgerEntryBuffer."Source Code";
          "On Hold" := CVLedgerEntryBuffer."On Hold";
          "Applies-to Doc. Type" := CVLedgerEntryBuffer."Applies-to Doc. Type";
          "Applies-to Doc. No." := CVLedgerEntryBuffer."Applies-to Doc. No.";
          Open := CVLedgerEntryBuffer.Open;
          "Due Date" := CVLedgerEntryBuffer."Due Date" ;
          "Pmt. Discount Date" := CVLedgerEntryBuffer."Pmt. Discount Date";
          "Original Pmt. Disc. Possible" := CVLedgerEntryBuffer."Original Pmt. Disc. Possible";
          "Remaining Pmt. Disc. Possible" := CVLedgerEntryBuffer."Remaining Pmt. Disc. Possible";
          "Pmt. Disc. Rcd.(LCY)" := CVLedgerEntryBuffer."Pmt. Disc. Given (LCY)";
          Positive := CVLedgerEntryBuffer.Positive;
          "Closed by Entry No." := CVLedgerEntryBuffer."Closed by Entry No.";
          "Closed at Date" := CVLedgerEntryBuffer."Closed at Date";
          "Closed by Amount" := CVLedgerEntryBuffer."Closed by Amount";
          "Applies-to ID" := CVLedgerEntryBuffer."Applies-to ID";
          "Journal Batch Name" := CVLedgerEntryBuffer."Journal Batch Name";
          "Reason Code" := CVLedgerEntryBuffer."Reason Code";
          "Bal. Account Type" := CVLedgerEntryBuffer."Bal. Account Type";
          "Bal. Account No." := CVLedgerEntryBuffer."Bal. Account No.";
          "Transaction No." := CVLedgerEntryBuffer."Transaction No.";
          "Closed by Amount (LCY)" := CVLedgerEntryBuffer."Closed by Amount (LCY)";
          "Debit Amount" := CVLedgerEntryBuffer."Debit Amount";
          "Credit Amount" := CVLedgerEntryBuffer."Credit Amount";
          "Debit Amount (LCY)" := CVLedgerEntryBuffer."Debit Amount (LCY)";
          "Credit Amount (LCY)" := CVLedgerEntryBuffer."Credit Amount (LCY)";
          "Document Date" := CVLedgerEntryBuffer."Document Date";
          "External Document No." := CVLedgerEntryBuffer."External Document No.";
          "No. Series" := CVLedgerEntryBuffer."No. Series";
          "Closed by Currency Code" := CVLedgerEntryBuffer."Closed by Currency Code";
          "Closed by Currency Amount" := CVLedgerEntryBuffer."Closed by Currency Amount";
          "Adjusted Currency Factor" := CVLedgerEntryBuffer."Adjusted Currency Factor";
          "Original Currency Factor" := CVLedgerEntryBuffer."Original Currency Factor";
          "Pmt. Disc. Tolerance Date" := CVLedgerEntryBuffer."Pmt. Disc. Tolerance Date";
          "Max. Payment Tolerance" := CVLedgerEntryBuffer."Max. Payment Tolerance";
          "Accepted Payment Tolerance" := CVLedgerEntryBuffer."Accepted Payment Tolerance";
          "Accepted Pmt. Disc. Tolerance" := CVLedgerEntryBuffer."Accepted Pmt. Disc. Tolerance";
          "Pmt. Tolerance (LCY)" := CVLedgerEntryBuffer."Pmt. Tolerance (LCY)";
          "Amount to Apply" := CVLedgerEntryBuffer."Amount to Apply";
          Prepayment := CVLedgerEntryBuffer.Prepayment;
          "Bill No." := CVLedgerEntryBuffer."Bill No.";
          "Document Situation" := CVLedgerEntryBuffer."Document Situation";
          "Applies-to Bill No." := CVLedgerEntryBuffer."Applies-to Bill No.";
          "Document Status" := CVLedgerEntryBuffer."Document Status";

          OnAfterCopyVendLedgerEntryFromCVLedgEntryBuffer(Rec,CVLedgerEntryBuffer);
        end;
    */



    //     procedure RecalculateAmounts (FromCurrencyCode@1001 : Code[10];ToCurrencyCode@1002 : Code[10];PostingDate@1003 :

    /*
    procedure RecalculateAmounts (FromCurrencyCode: Code[10];ToCurrencyCode: Code[10];PostingDate: Date)
        var
    //       CurrExchRate@1004 :
          CurrExchRate: Record 330;
        begin
          if ToCurrencyCode = FromCurrencyCode then
            exit;

          "Remaining Amount" :=
            CurrExchRate.ExchangeAmount("Remaining Amount",FromCurrencyCode,ToCurrencyCode,PostingDate);
          "Remaining Pmt. Disc. Possible" :=
            CurrExchRate.ExchangeAmount("Remaining Pmt. Disc. Possible",FromCurrencyCode,ToCurrencyCode,PostingDate);
          "Accepted Payment Tolerance" :=
            CurrExchRate.ExchangeAmount("Accepted Payment Tolerance",FromCurrencyCode,ToCurrencyCode,PostingDate);
          "Amount to Apply" :=
            CurrExchRate.ExchangeAmount("Amount to Apply",FromCurrencyCode,ToCurrencyCode,PostingDate);
        end;
    */



    /*
    LOCAL procedure ValidatePaymentMethod ()
        var
    //       PaymentMethod@1100000 :
          PaymentMethod: Record 289;
        begin
          PaymentMethod.GET("Payment Method Code");
          if (("Document Type" = "Document Type"::Bill) and (not PaymentMethod."Create Bills")) or
             (("Document Type" = "Document Type"::Invoice) and (not PaymentMethod."Invoices to Cartera")) then
            ERROR(CannotChangePmtMethodErr);
        end;
    */



    //     LOCAL procedure OnAfterCopyVendLedgerEntryFromGenJnlLine (var VendorLedgerEntry@1000 : Record 25;GenJournalLine@1001 :

    /*
    LOCAL procedure OnAfterCopyVendLedgerEntryFromGenJnlLine (var VendorLedgerEntry: Record 25;GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyVendLedgerEntryFromCVLedgEntryBuffer (var VendorLedgerEntry@1000 : Record 25;CVLedgerEntryBuffer@1001 :

    /*
    LOCAL procedure OnAfterCopyVendLedgerEntryFromCVLedgEntryBuffer (var VendorLedgerEntry: Record 25;CVLedgerEntryBuffer: Record 382)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeDrillDownEntries (var VendorLedgerEntry@1000 : Record 25;var DetailedVendorLedgEntry@1001 :

    /*
    LOCAL procedure OnBeforeDrillDownEntries (var VendorLedgerEntry: Record 25;var DetailedVendorLedgEntry: Record 380)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeDrillDownOnOverdueEntries (var VendorLedgerEntry@1000 : Record 25;var DetailedVendorLedgEntry@1001 :

    /*
    LOCAL procedure OnBeforeDrillDownOnOverdueEntries (var VendorLedgerEntry: Record 25;var DetailedVendorLedgEntry: Record 380)
        begin
        end;
    */



    /*
    procedure NumRelEfecto () NumRel : Integer;
        var
    //       EfectoLineas@1100286000 :
          EfectoLineas: Record 7206923;
        begin
          //BS::22353 CSM 22/05/24 � Num Relaci�n Efecto en Mov Proveedor. -
          NumRel := 0;

          CASE "Document Type" OF
            "Document Type"::Invoice :
              begin
                EfectoLineas.SETCURRENTKEY("Relacion No.","Document Type","Document No.","Bill No.");
                EfectoLineas.SETRANGE("Document Type", EfectoLineas."Document Type"::Invoice);
                EfectoLineas.SETRANGE("Document No.", "Document No.");
                if EfectoLineas.FINDLAST then
                  NumRel := EfectoLineas."Relacion No.";
              end;
            "Document Type"::"Credit Memo":
              begin
                EfectoLineas.SETCURRENTKEY("Relacion No.","Document Type","Document No.","Bill No.");
                EfectoLineas.SETRANGE("Document Type", EfectoLineas."Document Type"::"Credit Memo");
                EfectoLineas.SETRANGE("Document No.", "Document No.");
                if EfectoLineas.FINDLAST then
                  NumRel := EfectoLineas."Relacion No.";
              end;
            "Document Type"::Bill :
              begin
                EfectoLineas.SETCURRENTKEY("Relacion No.","Document Type","Document No.","Bill No.");
                EfectoLineas.SETRANGE("Document Type", EfectoLineas."Document Type"::Bill);
                EfectoLineas.SETRANGE("Document No.", "Document No.");
                EfectoLineas.SETRANGE("Bill No.", "Bill No.");
                if EfectoLineas.FINDLAST then
                  NumRel := EfectoLineas."Relacion No.";
              end;
            else
              NumRel := 0;
          end;

          exit(NumRel);
          //BS::22353 CSM 22/05/24 � Num Relaci�n Efecto en Mov Proveedor. +
        end;

        /*begin
        //{
    //          16/08/17: - QuoSII_1.1 Se modifican los campos 7174332 y 7174334. Se elimina el campo 7174333
    //      MCM 21/11/17: - QuoSII_1.3.03.006 Se incluye el campo para importarlo como Fecha de Registro contable
    //      PEL 23/04/18: - QuoSII1.4 A�adido valor LC al campo Purch. Inv Type
    //      PEL 13/06/18: - QB2395 Se crea nuevo campo  --> Eliminado con las nuevas aprobaciones
    //      MCM 18/02/19: - QuoSII_1.4.02.042.13 Se cambia la propiedad CalcFormula de los campos "AEAT Status" y "Ship No."
    //      PGM 21/09/20: - QB 1.06.15 - Creado los campos "To Liquidate" y "Liquidated"
    //      PGM 07/10/20: - QB 1.06.20 - Creado el tipo "Shipment" en el campo "Document Type"
    //      JAV 23/03/22: - QB 1.10.27 Se incluye el campo 7207276 para el nombre
    //      PSM 25/01/23: - Q18765 Crear campo calculado "En una relaci�n de efectos"
    //      PSM 08/05/23: - Q18765 Modificar campo calculado "En una relaci�n de efectos" para que muestre tanto relaciones registradas como no registradas
    //      Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)
    //      BS::19798 CSM 20/10/23  � Campos filtrables �comentarios filtro� y �notas filtro�.
    //      BS::22353 CSM 22/05/24 � Num Relaci�n Efecto en Mov Proveedor.  New function.
    //    }
        end.
      */
}





