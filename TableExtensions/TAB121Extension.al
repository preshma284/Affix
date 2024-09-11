tableextension 50137 "QBU Purch. Rcpt. LineExt" extends "Purch. Rcpt. Line"
{

    /*
  Permissions=TableData 32 r,
                  TableData 5802 r;
  */
    CaptionML = ENU = 'Purch. Rcpt. Line', ESP = 'Hist�rico l�n. albar�n compra';
    LookupPageID = "Posted Purchase Receipt Lines";
    DrillDownPageID = "Posted Purchase Receipt Lines";

    fields
    {
        field(50000; "Prod. Measure Header No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prob. Measure Header No.', ESP = 'N� Cab. Relaci�n Valorada';
            Description = 'BS18286';


        }
        field(50001; "Prod. Measure Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prod. Measure Line No.', ESP = 'N� l�nea Relaci�n Valorada';
            Description = 'BS18286';


        }
        field(50002; "From Measure"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Viene de la medici�n';
            Description = 'BS18286';


        }
        field(50003; "Measure Source"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Origin Measure', ESP = 'Medici�n origen';
            DecimalPlaces = 2 : 4;
            Description = 'BS18286';

            trigger OnValidate();
            VAR
                //                                                                 RelCertificationProduct@1100286004 :
                RelCertificationProduct: Record 7207397;
                //                                                                 ProcessOk@1100286000 :
                ProcessOk: Boolean;
                //                                                                 txtAux@1100286001 :
                txtAux: Text;
                //                                                                 incCost@1100286002 :
                incCost: Decimal;
                //                                                                 incSale@1100286003 :
                incSale: Decimal;
                //                                                                 recJob@1100286005 :
                recJob: Record 167;
            BEGIN
            END;


        }
        field(50004; "Cod. Contrato"; Code[20])
        {


            DataClassification = ToBeClassified;
            Description = 'BS::20484';

            trigger OnLookup();
            VAR
                //                                                               ContractsControl@1100286000 :
                ContractsControl: Record 7206912;
                //                                                               ContractsControlList@1100286001 :
                ContractsControlList: Page 7206922;
            BEGIN
                //-BS::20484
                ContractsControl.SETRANGE(Proyecto, "Job No.");
                ContractsControl.SETRANGE("Tipo Movimiento", ContractsControl."Tipo Movimiento"::IniProyecto);
                IF ContractsControl.FINDFIRST THEN BEGIN
                    ContractsControlList.SETTABLEVIEW(ContractsControl);
                    ContractsControlList.LOOKUPMODE(TRUE);
                    IF ACTION::LookupOK = ContractsControlList.RUNMODAL THEN BEGIN
                        ContractsControlList.GETRECORD(ContractsControl);
                        Rec."Cod. Contrato" := ContractsControl.Contrato;
                    END;
                END;
                //+BS::20484
            END;


        }
        field(50010; "Proform No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� proforma';
            Description = 'BS18286';


        }
        field(50011; "Receipt Open Qty. Prof."; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cantidad alb. pendiente proformar';
            Description = 'BS::18286';


        }
        field(7207274; "Piecework NÂº"; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework N�', ESP = 'N� unidad de obra';
            Description = 'QB 1.00 - QB2516';


        }
        field(7207275; "Qty. Received Origin"; Decimal)
        {
            CaptionML = ENU = 'Qty. to Receive Origin', ESP = 'Cantidad recibida a origen';
            DecimalPlaces = 0 : 5;
            Description = 'QB 1.00 - QB2517';


        }
        field(7207276; "Accounted"; Boolean)
        {
            CaptionML = ENU = 'Accounted', ESP = 'Contabilizado';
            Description = 'QB 1.00 - QB2516';


        }
        field(7207278; "Updated budget"; Boolean)
        {
            CaptionML = ENU = 'Updated budget', ESP = 'Presupuesto actualizado';
            Description = 'QB 1.00 - QB2516';


        }
        field(7207290; "Received on FRI"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Rcpt. Header"."Receive in FRIS" WHERE("No." = FIELD("Document No.")));
            CaptionML = ENU = 'Received on FRI�S', ESP = 'Recibido en FRI';
            Description = 'QB 1.06 - JAV 05/07/20: - Se elimina acento raro en el name y el caption';
            Editable = false;


        }
        field(7207291; "Cancelled"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Anulada';
            Description = 'QB 1.00 - JAV 06/07/19: - Si se ha cancelado la l�nea';


        }
        field(7207292; "Header Cacelled"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Rcpt. Header"."Cancelled" WHERE("No." = FIELD("Document No.")));


        }
        field(7207300; "Qty. Origin"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Rcpt. Line"."Quantity" WHERE("Order No." = FIELD("Order No."),
                                                                                                       "Order Line No." = FIELD("Order Line No."),
                                                                                                       "Quantity" = FILTER(<> 0),
                                                                                                       "Cancelled" = CONST(false),
                                                                                                       "Document No." = FIELD(FILTER("Filter Document No.")),
                                                                                                       "Header Cacelled" = CONST(false)));
            CaptionML = ESP = 'Cantidad a Origen';


        }
        field(7207301; "Filter Document No."; Code[20])
        {
            FieldClass = FlowFilter;
            CaptionML = ESP = 'Filtro N�. Documento';


        }
        field(7207313; "QB Framework Contr. No."; Code[20])
        {
            TableRelation = "QB Framework Contr. Header"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order No.', ESP = 'N� Contrato Marco';
            Description = 'QB 1.06.20 - N� Contrato Marco';
            Editable = false;


        }
        field(7207314; "QB Framework Contr. Line"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order No.', ESP = 'N� L�nea del Contrato Marco';
            Description = 'QB 1.08.18 - N� de l�nea del Contrato Marco';
            Editable = false;


        }
        field(7207317; "QB Posting Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Rcpt. Header"."Posting Date" WHERE("No." = FIELD("Document No.")));
            CaptionML = ENU = 'Blanket Order No.', ESP = 'Fecha del albar�n';
            Description = 'QB 1.08.43 - JAV 18/05/21 Fecha de la cabecera';
            Editable = false;


        }
        field(7207318; "QB Vendor Shipment No."; Code[35])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Rcpt. Header"."Vendor Shipment No." WHERE("No." = FIELD("Document No.")));
            CaptionML = ENU = 'Blanket Order No.', ESP = 'N� Albar�n Proveedor';
            Description = 'QB 1.08.43 - JAV 18/05/21 Nro albar�n';
            Editable = false;


        }
        field(7207319; "QB Have Proforms"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Proform Header" WHERE("Order No." = FIELD("Order No.")));
            CaptionML = ESP = 'Tiene proformas';
            Description = 'QB 1.08.48 - JAV 06/06/21 Si el documento tiene proformas generadas';
            Editable = false;


        }
        field(7207321; "QB Qty Provisioned"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Qty Provisioned', ESP = 'Cantidad Provisionada';
            Description = 'QB 1.09.22 Cantidad actual provisionada en facturas pendientes de contabilizar';
            Editable = false;


        }
        field(7207322; "QB Amount Provisioned"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Qty Provisioned Caceled', ESP = 'Importe Provisionado';
            Description = 'QB 1.09.22 Importe actual provisionado en facturas pendientes de contabilizar';
            Editable = false;


        }
        field(7207330; "QB Amount Invoiced"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Facturado';
            Description = 'QB 1.09.25 - JAV 28/10/21 Importe facturado del albar�n';


        }
        field(7207331; "QB Amount Invoiced (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Facturado (DL)';
            Description = 'QB 1.09.25 - JAV 28/10/21 Importe facturado del albar�n';


        }
        field(7207332; "QB Amount Invoiced (JC)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Currency Amount', ESP = 'Importe Facturado (DC)';
            Description = 'QB 1.09.25 - JAV 28/10/21 Importe facturado del albar�n';


        }
        field(7207333; "QB Amount Invoiced (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Aditional Currency Amount', ESP = 'Importe Facturado (DA)';
            Description = 'QB 1.09.25 - JAV 28/10/21 Importe facturado del albar�n';


        }
        field(7207334; "QB Amount Not Invoiced"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Pte. Facturar';
            Description = 'QB 1.09.25 - JAV 28/10/21 Importe pendiente de facturar del albar�n, si est� cancelado ser� cero';


        }
        field(7207335; "QB Amount Not Invoiced (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Pte. Facturar (DL)';
            Description = 'QB 1.09.25 - JAV 28/10/21 Importe pendiente de facturar del albar�n, si est� cancelado ser� cero';


        }
        field(7207336; "QB Amount Not Invoiced (JC)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Pte. Facturar (DC)';
            Description = 'QB 1.09.25 - JAV 28/10/21 Importe pendiente de facturar del albar�n, si est� cancelado ser� cero';


        }
        field(7207337; "QB Amount Not Invoiced (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Pte. Facturar (DA)';
            Description = 'QB 1.09.25 - JAV 28/10/21 Importe pendiente de facturar del albar�n, si est� cancelado ser� cero';


        }
        field(7207340; "QB Receipt Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Receipt Amount', ESP = 'Importe albar�n';
            Description = 'QRE16076, BS::19641, BS::19970';


        }
        field(7207341; "QB Receipt Amount Incl. VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Receipt Amount Incl. VAT', ESP = 'Importe albar�n IVA inclu�do';
            Description = 'QRE16076, BS::19641, BS::19970';


        }
        field(7207351; "Comparative Quote No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative Quote No.', ESP = 'N� comparativo';
            Description = 'BS::18294 CSM 10/02/23 - Incorporar en est�ndar QB.';


        }
        field(7207352; "Comparative Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative Line No.', ESP = 'N� l�nea comparativo';
            Description = 'BS::18294 CSM 10/02/23 - Incorporar en est�ndar QB.';


        }
    }
    keys
    {
        // key(key1;"Document No.","Line No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Order No.","Order Line No.","Posting Date")
        //  {
        /* ;
  */
        // }
        // key(key3;"Blanket Order No.","Blanket Order Line No.")
        //  {
        /* ;
  */
        // }
        // key(key4;"Item Rcpt. Entry No.")
        //  {
        /* ;
  */
        // }
        // key(key5;"Pay-to Vendor No.")
        //  {
        /* ;
  */
        // }
        // key(key6;"Buy-from Vendor No.")
        //  {
        /* ;
  */
        // }
        key(Extkey7; "Job No.", "Document No.")
        {
            ;
        }
        //key(Extkey8;"Document No.","Piecework N�")
        // {
        /*  ;
 */
        // }
        //key(Extkey9;"Job No.","Piecework N�","Type","No.","Order Date")
        // {
        /*  SumIndexFields="Quantity";
 */
        // }
    }
    fieldgroups
    {
    }

    var
        //       Text000@1000 :
        Text000: TextConst ENU = 'Receipt No. %1:', ESP = 'N� albar�n %1:';
        //       Text001@1001 :
        Text001: TextConst ENU = 'The program cannot find this purchase line.', ESP = 'El prog. no puede encontrar esta l�n. compra.';
        //       Currency@1005 :
        Currency: Record 4;
        //       PurchRcptHeader@1004 :
        PurchRcptHeader: Record 120;
        //       DimMgt@1003 :
        DimMgt: Codeunit 408;
        //       CurrencyRead@1002 :
        CurrencyRead: Boolean;





    /*
    trigger OnDelete();    var
    //                PurchDocLineComments@1000 :
                   PurchDocLineComments: Record 43;
                 begin
                   PurchDocLineComments.SETRANGE("Document Type",PurchDocLineComments."Document Type"::Receipt);
                   PurchDocLineComments.SETRANGE("No.","Document No.");
                   PurchDocLineComments.SETRANGE("Document Line No.","Line No.");
                   if not PurchDocLineComments.ISEMPTY then
                     PurchDocLineComments.DELETEALL;
                 end;

    */




    /*
    procedure GetCurrencyCodeFromHeader () : Code[10];
        begin
          if "Document No." = PurchRcptHeader."No." then
            exit(PurchRcptHeader."Currency Code");
          if PurchRcptHeader.GET("Document No.") then
            exit(PurchRcptHeader."Currency Code");
          exit('');
        end;
    */




    /*
    procedure ShowDimensions ()
        begin
          DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',TABLECAPTION,"Document No.","Line No."));
        end;
    */




    /*
    procedure ShowItemTrackingLines ()
        var
    //       ItemTrackingDocMgt@1000 :
          ItemTrackingDocMgt: Codeunit 6503;
        begin
          ItemTrackingDocMgt.ShowItemTrackingForShptRcptLine(DATABASE::"Purch. Rcpt. Line",0,"Document No.",'',0,"Line No.");
        end;
    */



    //     procedure InsertInvLineFromRcptLine (var PurchLine@1000 :
    procedure InsertInvLineFromRcptLine(var PurchLine: Record 39)
    var
        //       PurchInvHeader@1010 :
        PurchInvHeader: Record 38;
        //       PurchOrderHeader@1007 :
        PurchOrderHeader: Record 38;
        //       PurchOrderLine@1005 :
        PurchOrderLine: Record 39;
        //       TempPurchLine@1003 :
        TempPurchLine: Record 39 TEMPORARY;
        //       TransferOldExtLines@1002 :
        TransferOldExtLines: Codeunit 379;
        //       ItemTrackingMgt@1004 :
        ItemTrackingMgt: Codeunit 6500;
        ItemTrackingMgt1: Codeunit "Item Tracking Management 1";
        //       LanguageManagement@1008 :
        LanguageManagement: Codeunit 43;
        LanguageManagement1: Codeunit "LanguageManagement 1";
        //       NextLineNo@1001 :
        NextLineNo: Integer;
        //       ExtTextLine@1006 :
        ExtTextLine: Boolean;
        //       Handled@1009 :
        Handled: Boolean;
    begin
        SETRANGE("Document No.", "Document No.");

        TempPurchLine := PurchLine;
        if PurchLine.FIND('+') then
            NextLineNo := PurchLine."Line No." + 10000
        else
            NextLineNo := 10000;

        if PurchInvHeader."No." <> TempPurchLine."Document No." then
            PurchInvHeader.GET(TempPurchLine."Document Type", TempPurchLine."Document No.");

        if PurchLine."Receipt No." <> "Document No." then begin
            PurchLine.INIT;
            PurchLine."Line No." := NextLineNo;
            PurchLine."Document Type" := TempPurchLine."Document Type";
            PurchLine."Document No." := TempPurchLine."Document No.";
            LanguageManagement1.SetGlobalLanguageByCode(PurchInvHeader."Language Code");
            PurchLine.Description := STRSUBSTNO(Text000, "Document No.");
            LanguageManagement1.RestoreGlobalLanguage;
            OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine(Rec, PurchLine, NextLineNo, Handled);
            if not Handled then begin
                PurchLine.INSERT;
                NextLineNo := NextLineNo + 10000;
            end;
        end;

        TransferOldExtLines.ClearLineNumbers;

        repeat
            ExtTextLine := (TransferOldExtLines.GetNewLineNumber("Attached to Line No.") <> 0);

            if PurchOrderLine.GET(
                  PurchOrderLine."Document Type"::Order, "Order No.", "Order Line No.") and
                not ExtTextLine
            then begin
                if (PurchOrderHeader."Document Type" <> PurchOrderLine."Document Type"::Order) or
                   (PurchOrderHeader."No." <> PurchOrderLine."Document No.")
                then
                    PurchOrderHeader.GET(PurchOrderLine."Document Type"::Order, "Order No.");

                InitCurrency("Currency Code");

                if PurchInvHeader."Prices Including VAT" then begin
                    if not PurchOrderHeader."Prices Including VAT" then
                        PurchOrderLine."Direct Unit Cost" :=
                          ROUND(
                            PurchOrderLine."Direct Unit Cost" * (1 + PurchOrderLine."VAT %" / 100),
                            Currency."Unit-Amount Rounding Precision");
                end else begin
                    if PurchOrderHeader."Prices Including VAT" then
                        PurchOrderLine."Direct Unit Cost" :=
                          ROUND(
                            PurchOrderLine."Direct Unit Cost" / (1 + PurchOrderLine."VAT %" / 100),
                            Currency."Unit-Amount Rounding Precision");
                end;
            end else begin
                if ExtTextLine then begin
                    PurchOrderLine.INIT;
                    PurchOrderLine."Line No." := "Order Line No.";
                    PurchOrderLine.Description := Description;
                    PurchOrderLine."Description 2" := "Description 2";
                end else
                    ERROR(Text001);
            end;
            PurchLine := PurchOrderLine;
            PurchLine."Line No." := NextLineNo;
            PurchLine."Document Type" := TempPurchLine."Document Type";
            PurchLine."Document No." := TempPurchLine."Document No.";
            PurchLine."Variant Code" := "Variant Code";
            PurchLine."Location Code" := "Location Code";
            PurchLine."Quantity (Base)" := 0;
            PurchLine.Quantity := 0;
            PurchLine."Outstanding Qty. (Base)" := 0;
            PurchLine."Outstanding Quantity" := 0;
            PurchLine."Quantity Received" := 0;
            PurchLine."Qty. Received (Base)" := 0;
            PurchLine."Quantity Invoiced" := 0;
            PurchLine."Qty. Invoiced (Base)" := 0;
            PurchLine.Amount := 0;
            PurchLine."Amount Including VAT" := 0;
            PurchLine."Sales Order No." := '';
            PurchLine."Sales Order Line No." := 0;
            PurchLine."Drop Shipment" := FALSE;
            PurchLine."Special Order Sales No." := '';
            PurchLine."Special Order Sales Line No." := 0;
            PurchLine."Special Order" := FALSE;
            PurchLine."Receipt No." := "Document No.";
            PurchLine."Receipt Line No." := "Line No.";
            PurchLine."Appl.-to Item Entry" := 0;
            if not ExtTextLine then begin
                PurchLine.VALIDATE(Quantity, Quantity - "Quantity Invoiced");
                PurchLine.VALIDATE("Direct Unit Cost", PurchOrderLine."Direct Unit Cost");
                PurchOrderLine."Line Discount Amount" :=
                  ROUND(
                    PurchOrderLine."Line Discount Amount" * PurchLine.Quantity / PurchOrderLine.Quantity,
                    Currency."Amount Rounding Precision");
                if PurchInvHeader."Prices Including VAT" then begin
                    if not PurchOrderHeader."Prices Including VAT" then
                        PurchOrderLine."Line Discount Amount" :=
                          ROUND(
                            PurchOrderLine."Line Discount Amount" *
                            (1 + PurchOrderLine."VAT %" / 100), Currency."Amount Rounding Precision");
                end else
                    if PurchOrderHeader."Prices Including VAT" then
                        PurchOrderLine."Line Discount Amount" :=
                          ROUND(
                            PurchOrderLine."Line Discount Amount" /
                            (1 + PurchOrderLine."VAT %" / 100), Currency."Amount Rounding Precision");
                PurchLine.VALIDATE("Line Discount Amount", PurchOrderLine."Line Discount Amount");
                PurchLine."Line Discount %" := PurchOrderLine."Line Discount %";
                PurchLine.UpdatePrePaymentAmounts;
                if PurchOrderLine.Quantity = 0 then
                    PurchLine.VALIDATE("Inv. Discount Amount", 0)
                else
                    PurchLine.VALIDATE(
                      "Inv. Discount Amount",
                      ROUND(
                        PurchOrderLine."Inv. Discount Amount" * PurchLine.Quantity / PurchOrderLine.Quantity,
                        Currency."Amount Rounding Precision"));
            end;

            PurchLine."Attached to Line No." :=
              TransferOldExtLines.TransferExtendedText(
                "Line No.",
                NextLineNo,
                "Attached to Line No.");
            PurchLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            PurchLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            PurchLine."Dimension Set ID" := "Dimension Set ID";

            if "Sales Order No." = '' then
                PurchLine."Drop Shipment" := FALSE
            else
                PurchLine."Drop Shipment" := TRUE;

            //JAV 23/10/19: - Se eliminan llamandas a c�lculos de retenciones que ya no se usan
            //QBTablePublisher.InsertInvLineFromRcptLineTPurchRcptLine(Rec);   //QB

            OnBeforeInsertInvLineFromRcptLine(Rec, PurchLine, PurchOrderLine);

            PurchLine.INSERT;
            OnAfterInsertInvLineFromRcptLine(PurchLine, PurchOrderLine, NextLineNo);

            ItemTrackingMgt1.CopyHandledItemTrkgToInvLine2(PurchOrderLine, PurchLine);

            NextLineNo := NextLineNo + 10000;
            if "Attached to Line No." = 0 then
                SETRANGE("Attached to Line No.", "Line No.");
        until (NEXT = 0) or ("Attached to Line No." = 0);
    end;

    //     LOCAL procedure GetPurchInvLines (var TempPurchInvLine@1000 :

    /*
    LOCAL procedure GetPurchInvLines (var TempPurchInvLine: Record 123 TEMPORARY)
        var
    //       PurchInvLine@1003 :
          PurchInvLine: Record 123;
    //       ItemLedgEntry@1002 :
          ItemLedgEntry: Record 32;
    //       ValueEntry@1001 :
          ValueEntry: Record 5802;
        begin
          TempPurchInvLine.RESET;
          TempPurchInvLine.DELETEALL;

          if Type <> Type::Item then
            exit;

          FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
          ItemLedgEntry.SETFILTER("Invoiced Quantity",'<>0');
          if ItemLedgEntry.FINDSET then begin
            ValueEntry.SETCURRENTKEY("Item Ledger Entry No.","Entry Type");
            ValueEntry.SETRANGE("Entry Type",ValueEntry."Entry Type"::"Direct Cost");
            ValueEntry.SETFILTER("Invoiced Quantity",'<>0');
            repeat
              ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
              if ValueEntry.FINDSET then
                repeat
                  if ValueEntry."Document Type" = ValueEntry."Document Type"::"Purchase Invoice" then
                    if PurchInvLine.GET(ValueEntry."Document No.",ValueEntry."Document Line No.") then begin
                      TempPurchInvLine.INIT;
                      TempPurchInvLine := PurchInvLine;
                      if TempPurchInvLine.INSERT then;
                    end;
                until ValueEntry.NEXT = 0;
            until ItemLedgEntry.NEXT = 0;
          end;
        end;
    */



    //     procedure CalcReceivedPurchNotReturned (var RemainingQty@1003 : Decimal;var RevUnitCostLCY@1005 : Decimal;ExactCostReverse@1006 :

    /*
    procedure CalcReceivedPurchNotReturned (var RemainingQty: Decimal;var RevUnitCostLCY: Decimal;ExactCostReverse: Boolean)
        var
    //       ItemLedgEntry@1000 :
          ItemLedgEntry: Record 32;
    //       TotalCostLCY@1007 :
          TotalCostLCY: Decimal;
    //       TotalQtyBase@1002 :
          TotalQtyBase: Decimal;
        begin
          RemainingQty := 0;
          if (Type <> Type::Item) or (Quantity <= 0) then begin
            RevUnitCostLCY := "Unit Cost (LCY)";
            exit;
          end;

          RevUnitCostLCY := 0;
          FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
          if ItemLedgEntry.FINDSET then
            repeat
              RemainingQty := RemainingQty + ItemLedgEntry."Remaining Quantity";
              if ExactCostReverse then begin
                ItemLedgEntry.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
                TotalCostLCY :=
                  TotalCostLCY + ItemLedgEntry."Cost Amount (Expected)" + ItemLedgEntry."Cost Amount (Actual)";
                TotalQtyBase := TotalQtyBase + ItemLedgEntry.Quantity;
              end;
            until ItemLedgEntry.NEXT = 0;

          if ExactCostReverse and (RemainingQty <> 0) and (TotalQtyBase <> 0) then
            RevUnitCostLCY := ABS(TotalCostLCY / TotalQtyBase) * "Qty. per Unit of Measure"
          else
            RevUnitCostLCY := "Unit Cost (LCY)";

          RemainingQty := CalcQty(RemainingQty);
        end;
    */


    //     LOCAL procedure CalcQty (QtyBase@1000 :

    /*
    LOCAL procedure CalcQty (QtyBase: Decimal) : Decimal;
        begin
          if "Qty. per Unit of Measure" = 0 then
            exit(QtyBase);
          exit(ROUND(QtyBase / "Qty. per Unit of Measure",0.00001));
        end;
    */



    //     procedure FilterPstdDocLnItemLedgEntries (var ItemLedgEntry@1000 :

    /*
    procedure FilterPstdDocLnItemLedgEntries (var ItemLedgEntry: Record 32)
        begin
          ItemLedgEntry.RESET;
          ItemLedgEntry.SETCURRENTKEY("Document No.");
          ItemLedgEntry.SETRANGE("Document No.","Document No.");
          ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Purchase Receipt");
          ItemLedgEntry.SETRANGE("Document Line No.","Line No.");
        end;
    */




    /*
    procedure ShowItemPurchInvLines ()
        var
    //       TempPurchInvLine@1001 :
          TempPurchInvLine: Record 123 TEMPORARY;
        begin
          if Type = Type::Item then begin
            GetPurchInvLines(TempPurchInvLine);
            PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice Lines",TempPurchInvLine);
          end;
        end;
    */


    //     LOCAL procedure InitCurrency (CurrencyCode@1001 :


    LOCAL procedure InitCurrency(CurrencyCode: Code[10])
    begin
        if (Currency.Code = CurrencyCode) and CurrencyRead then
            exit;

        if CurrencyCode <> '' then
            Currency.GET(CurrencyCode)
        else
            Currency.InitRoundingPrecision;
        CurrencyRead := TRUE;
    end;





    /*
    procedure ShowLineComments ()
        var
    //       PurchCommentLine@1002 :
          PurchCommentLine: Record 43;
        begin
          PurchCommentLine.ShowComments(PurchCommentLine."Document Type"::Receipt,"Document No.","Line No.");
        end;
    */



    //     procedure InitFromPurchLine (PurchRcptHeader@1001 : Record 120;PurchLine@1002 :

    /*
    procedure InitFromPurchLine (PurchRcptHeader: Record 120;PurchLine: Record 39)
        var
    //       Factor@1000 :
          Factor: Decimal;
        begin
          INIT;
          TRANSFERFIELDS(PurchLine);
          if ("No." = '') and (Type IN [Type::"G/L Account"..Type::"Charge (Item)"]) then
            Type := Type::" ";
          "Posting Date" := PurchRcptHeader."Posting Date";
          "Document No." := PurchRcptHeader."No.";
          Quantity := PurchLine."Qty. to Receive";
          "Quantity (Base)" := PurchLine."Qty. to Receive (Base)";
          if ABS(PurchLine."Qty. to Invoice") > ABS(PurchLine."Qty. to Receive") then begin
            "Quantity Invoiced" := PurchLine."Qty. to Receive";
            "Qty. Invoiced (Base)" := PurchLine."Qty. to Receive (Base)";
          end else begin
            "Quantity Invoiced" := PurchLine."Qty. to Invoice";
            "Qty. Invoiced (Base)" := PurchLine."Qty. to Invoice (Base)";
          end;
          "Qty. Rcd. not Invoiced" := Quantity - "Quantity Invoiced";
          if PurchLine."Document Type" = PurchLine."Document Type"::Order then begin
            "Order No." := PurchLine."Document No.";
            "Order Line No." := PurchLine."Line No.";
          end;
          if (PurchLine.Quantity <> 0) and ("Job No." <> '') then begin
            Factor := PurchLine."Qty. to Receive" / PurchLine.Quantity;
            if Factor <> 1 then
              UpdateJobPrices(Factor);
          end;

          OnAfterInitFromPurchLine(PurchRcptHeader,PurchLine,Rec);
        end;
    */




    /*
    procedure FormatType () : Text;
        var
    //       PurchaseLine@1000 :
          PurchaseLine: Record 39;
        begin
          if Type = Type::" " then
            exit(PurchaseLine.FormatType);

          exit(FORMAT(Type));
        end;
    */


    //     LOCAL procedure UpdateJobPrices (Factor@1000 :

    /*
    LOCAL procedure UpdateJobPrices (Factor: Decimal)
        begin
          "Job Total Price" :=
            ROUND("Job Total Price" * Factor,Currency."Amount Rounding Precision");
          "Job Total Price (LCY)" :=
            ROUND("Job Total Price (LCY)" * Factor,Currency."Amount Rounding Precision");
          "Job Line Amount" :=
            ROUND("Job Line Amount" * Factor,Currency."Amount Rounding Precision");
          "Job Line Amount (LCY)" :=
            ROUND("Job Line Amount (LCY)" * Factor,Currency."Amount Rounding Precision");
          "Job Line Discount Amount" :=
            ROUND("Job Line Discount Amount" * Factor,Currency."Amount Rounding Precision");
          "Job Line Disc. Amount (LCY)" :=
            ROUND("Job Line Disc. Amount (LCY)" * Factor,Currency."Amount Rounding Precision");
        end;
    */


    //     LOCAL procedure GetFieldCaption (FieldNumber@1000 :

    /*
    LOCAL procedure GetFieldCaption (FieldNumber: Integer) : Text[100];
        var
    //       Field@1001 :
          Field: Record 2000000041;
        begin
          Field.GET(DATABASE::"Purch. Rcpt. Line",FieldNumber);
          exit(Field."Field Caption");
        end;
    */



    //     procedure GetCaptionClass (FieldNumber@1000 :

    /*
    procedure GetCaptionClass (FieldNumber: Integer) : Text[80];
        begin
          CASE FieldNumber OF
            FIELDNO("No."):
              exit(STRSUBSTNO('3,%1',GetFieldCaption(FieldNumber)));
          end;
        end;
    */



    //     LOCAL procedure OnAfterInitFromPurchLine (PurchRcptHeader@1000 : Record 120;PurchLine@1001 : Record 39;var PurchRcptLine@1002 :


    LOCAL procedure OnAfterInitFromPurchLine(PurchRcptHeader: Record 120; PurchLine: Record 39; var PurchRcptLine: Record 121)
    begin
    end;




    //     LOCAL procedure OnAfterInsertInvLineFromRcptLine (var PurchLine@1000 : Record 39;PurchOrderLine@1001 : Record 39;NextLineNo@1002 :


    LOCAL procedure OnAfterInsertInvLineFromRcptLine(var PurchLine: Record 39; PurchOrderLine: Record 39; NextLineNo: Integer)
    begin
    end;




    //     LOCAL procedure OnBeforeInsertInvLineFromRcptLine (var PurchRcptLine@1000 : Record 121;var PurchLine@1001 : Record 39;PurchOrderLine@1002 :


    LOCAL procedure OnBeforeInsertInvLineFromRcptLine(var PurchRcptLine: Record 121; var PurchLine: Record 39; PurchOrderLine: Record 39)
    begin
    end;




    //     LOCAL procedure OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine (var PurchRcptLine@1000 : Record 121;var PurchLine@1001 : Record 39;var NextLineNo@1002 : Integer;var Handled@1003 :


    LOCAL procedure OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine(var PurchRcptLine: Record 121; var PurchLine: Record 39; var NextLineNo: Integer; var Handled: Boolean)
    begin
    end;



    LOCAL procedure "----------------------------------------------------------------------- QB"()
    begin
    end;



    procedure SetAmounts()
    var
        //       PurchRcptHeader@1100286004 :
        PurchRcptHeader: Record 120;
        //       Job@1100286001 :
        Job: Record 167;
        //       JobCurrencyExchangeFunction@1100286000 :
        JobCurrencyExchangeFunction: Codeunit 7207332;
        //       AssignedAmount@1100286002 :
        AssignedAmount: Decimal;
        //       CurrencyFactor@1100286003 :
        CurrencyFactor: Decimal;
    begin
        //JAV 28/10/21: - QB 1.09.26 Poner los importes facturado y pendiente del albar�n para acelerar los c�lculos
        Rec."QB Amount not Invoiced" := 0;
        Rec."QB Amount not Invoiced (LCY)" := 0;
        Rec."QB Amount Invoiced (JC)" := 0;
        Rec."QB Amount Invoiced (ACY)" := 0;
        Rec."QB Amount not Invoiced (JC)" := 0;
        Rec."QB Amount not Invoiced (ACY)" := 0;

        if (not Rec.Cancelled) then begin
            Rec."QB Amount Invoiced" := Rec."Quantity Invoiced" * Rec."Direct Unit Cost";
            Rec."QB Amount Invoiced (LCY)" := Rec."Quantity Invoiced" * Rec."Unit Cost (LCY)";
            Rec."QB Amount not Invoiced" := Rec."Qty. Rcd. not Invoiced" * Rec."Direct Unit Cost";
            Rec."QB Amount not Invoiced (LCY)" := Rec."Qty. Rcd. not Invoiced" * Rec."Unit Cost (LCY)";

            if PurchRcptHeader.GET(Rec."Document No.") then begin
                if Job.GET(Rec."Job No.") then begin
                    JobCurrencyExchangeFunction.CalculateCurrencyValue(Rec."Job No.", Rec."QB Amount Invoiced", PurchRcptHeader."Currency Code", Job."Currency Code",
                                                                       PurchRcptHeader."Posting Date", 0, AssignedAmount, CurrencyFactor);
                    Rec."QB Amount Invoiced (JC)" := AssignedAmount;

                    JobCurrencyExchangeFunction.CalculateCurrencyValue(Rec."Job No.", Rec."QB Amount Invoiced", PurchRcptHeader."Currency Code", Job."Aditional Currency",
                                                                       PurchRcptHeader."Posting Date", 0, AssignedAmount, CurrencyFactor);
                    Rec."QB Amount Invoiced (ACY)" := AssignedAmount;

                    JobCurrencyExchangeFunction.CalculateCurrencyValue(Rec."Job No.", Rec."QB Amount not Invoiced", PurchRcptHeader."Currency Code", Job."Currency Code",
                                                                       PurchRcptHeader."Posting Date", 0, AssignedAmount, CurrencyFactor);
                    Rec."QB Amount not Invoiced (JC)" := AssignedAmount;

                    JobCurrencyExchangeFunction.CalculateCurrencyValue(Rec."Job No.", Rec."QB Amount not Invoiced", PurchRcptHeader."Currency Code", Job."Aditional Currency",
                                                                       PurchRcptHeader."Posting Date", 0, AssignedAmount, CurrencyFactor);
                    Rec."QB Amount not Invoiced (ACY)" := AssignedAmount;
                end;
            end;
        end;
    end;

    /*begin
    //{
//      JAV 06/07/19: - Se a�ade el campo 7207291"Canceled" que indica si se ha cancelado la l�nea
//      JAV 23/10/19: - Se eliminan llamandas a c�lculos de retenciones que ya no se usan
//      JAV 29/10/21: - Se eliminan las funciones que ya no se usan: CalAmountPendingPurchaseInterim, CalAmountPendingPurchaese y CalAmountPurcharse
//
//      CPA 29/03/22: Q16867 - Mejora de rendimiento
//          - Nueva clave: Job No.,Piecework N�,Type,No.,Order Date
//
//      OJO EN MERGE QB. --------- BS::18286 CSM 30/01/23 - Fri y proforma por l�neas de medici�n.  Nuevos campos Bonif.Sol.:
//                                            50000 Prod. Measure Header No.      (N� Cab. Relaci�n Valorada)
//                                            50001 Prod. Measure Header Line No. (N� l�nea Relaci�n Valorada)
//                                            50002From Measure(Viene de la medici�n)
//                                            50003Measure Source(Medici�n origen)
//
//      18294 CSM 10/02/23 � Incorporar en est�ndar QB.  Modificada CALCFORMULA in Field: 7207293.   New Fields:
//                                50090Comparative Quote No.(N� comparativo)
//                                50091Comparative Line No.(N� l�nea comparativo)
//      BS::19641 CSM 25/07/23 � Campos totalizadores.
//      BS::19970 CSM 31/07/23 � Campos 7207340 y 7207341.
//      BS::20484 AML 15/11/23 - Contratos para facturas libres.
//    }
    end.
  */
}





