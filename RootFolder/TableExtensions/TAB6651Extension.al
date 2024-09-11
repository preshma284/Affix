tableextension 50204 "MyExtension50204" extends "Return Shipment Line"
{

    /*
  Permissions=TableData 32 r,
                  TableData 5802 r;
  */
    CaptionML = ENU = 'Return Shipment Line', ESP = 'L�n. env�o devoluci�n';
    LookupPageID = "Posted Return Shipment Lines";

    fields
    {
        field(50004; "Cod. Contrato"; Code[20])
        {


            DataClassification = ToBeClassified;
            Description = 'BS::20484,20789';

            trigger OnLookup();
            VAR
                //                                                               ContractsControl@1100286000 :
                ContractsControl: Record 7206912;
                //                                                               ContractsControlList@1100286001 :
                ContractsControlList: Page 7206922;
            BEGIN
            END;


        }
        field(7207270; "QW % Withholding by GE"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% Withholding by G.E', ESP = '% retenci�n por B.E.';
            Description = 'QB 1.00 - QB22111';


        }
        field(7207271; "QW Withholding Amount by GE"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Withholding Amount by G.E', ESP = 'Importe retenci�n por B.E.';
            Description = 'QB 1.00 - QB22111';
            AutoFormatType = 1;


        }
        field(7207272; "QW % Withholding by PIT"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% Withholding by PIT', ESP = '% retenci�n IRPF';
            Description = 'QB 1.00 - QB22111';


        }
        field(7207273; "QW Withholding Amount by PIT"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Withholding Amount by PIT', ESP = 'Importe retenci�n por IRPF';
            Description = 'QB 1.00 - QB22111';
            AutoFormatType = 1;


        }
        field(7207274; "Piecework NÂº"; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Piecework N�', ESP = 'N� unidad de obra';
            Description = 'QB 1.00 - QB2516';


        }
        field(7207275; "Qty. Received Origin"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Qty. to Receive Origin', ESP = 'Cantidad recibida a origen';
            DecimalPlaces = 0 : 5;
            Description = 'QB 1.00 - QB2517';


        }
        field(7207276; "Accounted"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Accounted', ESP = 'Contabilizado';
            Description = 'QB 1.00 - QB2516';


        }
        field(7207278; "Updated budget"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Updated budget', ESP = 'Presupuesto actualizado';
            Description = 'QB 1.00 - QB2516';


        }
        field(7207283; "QW Not apply Withholding GE"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. Withholding by G.E', ESP = 'Aplicar retenci�n por B.E.';
            Description = 'QB 1.00 - JAV 11/08/19: - Si no se aplica la retenci�n por Buena Ejecuci�n a la linea';


        }
        field(7207284; "QW Not apply Withholding PIT"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. Withholding by PIT', ESP = 'Aplicar retenci�n por IRPF';
            Description = 'QB 1.00 - JAV 11/08/19: - Si no se aplica la retenci�n por IRPF a la l�nea';


        }
        field(7207285; "QW Base Withholding by GE"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% Withholding by G.E', ESP = 'Base ret. B.E.';
            Description = 'QB 1.00 - JAV 11/08/19: - Base de c�lculo de la retenci�n por B.E.';
            Editable = false;


        }
        field(7207286; "QW Base Withholding by PIT"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% Withholding by PIT', ESP = 'Base ret. IRPF';
            Description = 'QB 1.00 - JAV 11/08/19: - Base de c�lculo de la retenci�n por IRPF';
            Editable = false;


        }
        field(7207287; "QW Withholding by GE Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. Withholding by G.E', ESP = 'L�nea de retenci�n de B.E.';
            Description = 'QB 1.00 - JAV 18/08/19: - Si es la l�nea donde se calcula la retenci�n por Buena Ejecuci�n';


        }
        field(7207290; "Received on FRI�S"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Rcpt. Header"."Receive in FRIS" WHERE("No." = FIELD("Document No.")));
            CaptionML = ENU = 'Received on FRI�S', ESP = 'Recibido en FRI�S';
            Description = 'QB 1.00 - QB2411';
            Editable = false;


        }
        field(7207291; "Cancelled"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Anulada';
            Description = 'QB 1.00 - JAV  06/07/19: - Si se ha cancelado la l�nea';


        }
        field(7207296; "Job Currency Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Currency Amount', ESP = 'Importe divisa proyecto';
            Description = 'QB 1.00 - GEN005-02';


        }
        field(7207297; "Job Currency Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Currency Exchange Rate', ESP = 'Tipo cambio divisa proyecto';
            Description = 'QB 1.00 - GEN005-02';


        }
        field(7207298; "Aditional Currency Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Aditional Currency Amount', ESP = 'Importe divisa adicional';
            Description = 'QB 1.00 - GEN005-02';


        }
        field(7207299; "Aditional Curr. Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Aditional Currency Exchange Rate', ESP = 'Tipo cambio divisa adicional';
            Description = 'QB 1.00 - GEN005-02';


        }
        field(7207321; "QB Qty Provisioned"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Qty Provisioned', ESP = 'Cantidad Provisionada';
            Description = 'QB 1.09.22 Cantidad actual provisionada en abonos pendientes de contabilizar';
            Editable = false;


        }
        field(7207322; "QB Amount Provisioned"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Qty Provisioned Caceled', ESP = 'Importe Provisionado';
            Description = 'QB 1.09.22 Importe actual provisionado en abonos pendientes de contabilizar';
            Editable = false;


        }
    }
    keys
    {
        // key(key1;"Document No.","Line No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Return Order No.","Return Order Line No.")
        //  {
        /* ;
  */
        // }
        // key(key3;"Blanket Order No.","Blanket Order Line No.")
        //  {
        /* ;
  */
        // }
        // key(key4;"Pay-to Vendor No.")
        //  {
        /* ;
  */
        // }
    }
    fieldgroups
    {
    }

    var
        //       Currency@1004 :
        Currency: Record 4;
        //       ReturnShptHeader@1000 :
        ReturnShptHeader: Record 6650;
        //       Text000@1003 :
        Text000: TextConst ENU = 'Return Shipment No. %1:', ESP = 'N� env�o dev. %1:';
        //       Text001@1002 :
        Text001: TextConst ENU = 'The program cannot find this purchase line.', ESP = 'El prog. no puede encontrar esta l�n. compra.';
        //       CurrencyRead@1005 :
        CurrencyRead: Boolean;





    /*
    trigger OnDelete();    var
    //                PurchDocLineComments@1000 :
                   PurchDocLineComments: Record 43;
                 begin
                   PurchDocLineComments.SETRANGE("Document Type",PurchDocLineComments."Document Type"::"Posted Return Shipment");
                   PurchDocLineComments.SETRANGE("No.","Document No.");
                   PurchDocLineComments.SETRANGE("Document Line No.","Line No.");
                   if not PurchDocLineComments.ISEMPTY then
                     PurchDocLineComments.DELETEALL;
                 end;

    */




    /*
    procedure GetCurrencyCode () : Code[10];
        begin
          if "Document No." = ReturnShptHeader."No." then
            exit(ReturnShptHeader."Currency Code");
          if ReturnShptHeader.GET("Document No.") then
            exit(ReturnShptHeader."Currency Code");
          exit('');
        end;
    */




    /*
    procedure ShowDimensions ()
        var
    //       DimMgt@1002 :
          DimMgt: Codeunit 408;
        begin
          DimMgt.ShowDimensionSet("Dimension Set ID",
            STRSUBSTNO('%1 %2 %3',TABLECAPTION,"Document No.","Line No."));
        end;
    */




    /*
    procedure ShowItemTrackingLines ()
        var
    //       ItemTrackingDocMgt@1000 :
          ItemTrackingDocMgt: Codeunit 6503;
        begin
          ItemTrackingDocMgt.ShowItemTrackingForShptRcptLine(DATABASE::"Return Shipment Line",0,"Document No.",'',0,"Line No.");
        end;
    */



    //     procedure InsertInvLineFromRetShptLine (var PurchLine@1000 :

    /*
    procedure InsertInvLineFromRetShptLine (var PurchLine: Record 39)
        var
    //       PurchHeader@1007 :
          PurchHeader: Record 38;
    //       PurchHeader2@1008 :
          PurchHeader2: Record 38;
    //       PurchOrderLine@1005 :
          PurchOrderLine: Record 39;
    //       TempPurchLine@1003 :
          TempPurchLine: Record 39 TEMPORARY;
    //       PurchSetup@1020 :
          PurchSetup: Record 312;
    //       TransferOldExtLines@1002 :
          TransferOldExtLines: Codeunit 379;
    //       ItemTrackingMgt@1004 :
          ItemTrackingMgt: Codeunit 6500;
    //       NextLineNo@1001 :
          NextLineNo: Integer;
    //       ExtTextLine@1006 :
          ExtTextLine: Boolean;
        begin
          SETRANGE("Document No.","Document No.");

          TempPurchLine := PurchLine;
          if PurchLine.FIND('+') then
            NextLineNo := PurchLine."Line No." + 10000
          else
            NextLineNo := 10000;

          if PurchHeader."No." <> TempPurchLine."Document No." then
            PurchHeader.GET(TempPurchLine."Document Type",TempPurchLine."Document No.");

          if PurchLine."Return Shipment No." <> "Document No." then begin
            PurchLine.INIT;
            PurchLine."Line No." := NextLineNo;
            PurchLine."Document Type" := TempPurchLine."Document Type";
            PurchLine."Document No." := TempPurchLine."Document No.";
            PurchLine.Description := STRSUBSTNO(Text000,"Document No.");
            PurchLine.INSERT;
            NextLineNo := NextLineNo + 10000;
          end;

          TransferOldExtLines.ClearLineNumbers;
          PurchSetup.GET;
          repeat
            ExtTextLine := (TransferOldExtLines.GetNewLineNumber("Attached to Line No.") <> 0);

            if not PurchOrderLine.GET(
                 PurchOrderLine."Document Type"::"Return Order","Return Order No.","Return Order Line No.")
            then begin
              if ExtTextLine then begin
                PurchOrderLine.INIT;
                PurchOrderLine."Line No." := "Return Order Line No.";
                PurchOrderLine.Description := Description;
                PurchOrderLine."Description 2" := "Description 2";
              end else
                ERROR(Text001);
            end else begin
              if (PurchHeader2."Document Type" <> PurchOrderLine."Document Type"::"Return Order") or
                 (PurchHeader2."No." <> PurchOrderLine."Document No.")
              then
                PurchHeader2.GET(PurchOrderLine."Document Type"::"Return Order","Return Order No.");

              InitCurrency("Currency Code");

              if PurchHeader."Prices Including VAT" then begin
                if not PurchHeader2."Prices Including VAT" then
                  PurchOrderLine."Direct Unit Cost" :=
                    ROUND(
                      PurchOrderLine."Direct Unit Cost" * (1 + PurchOrderLine."VAT %" / 100),
                      Currency."Unit-Amount Rounding Precision");
              end else begin
                if PurchHeader2."Prices Including VAT" then
                  PurchOrderLine."Direct Unit Cost" :=
                    ROUND(
                      PurchOrderLine."Direct Unit Cost" / (1 + PurchOrderLine."VAT %" / 100),
                      Currency."Unit-Amount Rounding Precision");
              end;
            end;
            PurchLine := PurchOrderLine;
            PurchLine."Line No." := NextLineNo;
            PurchLine."Document Type" := TempPurchLine."Document Type";
            PurchLine."Document No." := TempPurchLine."Document No.";
            PurchLine."Variant Code" := "Variant Code";
            PurchLine."Location Code" := "Location Code";
            PurchLine."Return Reason Code" := "Return Reason Code";
            PurchLine."Quantity (Base)" := 0;
            PurchLine.Quantity := 0;
            PurchLine."Outstanding Qty. (Base)" := 0;
            PurchLine."Outstanding Quantity" := 0;
            PurchLine."Return Qty. Shipped" := 0;
            PurchLine."Return Qty. Shipped (Base)" := 0;
            PurchLine."Quantity Invoiced" := 0;
            PurchLine."Qty. Invoiced (Base)" := 0;
            PurchLine."Sales Order No." := '';
            PurchLine."Sales Order Line No." := 0;
            PurchLine."Drop Shipment" := FALSE;
            PurchLine."Return Shipment No." := "Document No.";
            PurchLine."Return Shipment Line No." := "Line No.";
            PurchLine."Appl.-to Item Entry" := 0;

            if not ExtTextLine then begin
              PurchLine.VALIDATE(Quantity,Quantity - "Quantity Invoiced");
              PurchLine.VALIDATE("Direct Unit Cost",PurchOrderLine."Direct Unit Cost");
              PurchLine.VALIDATE("Line Discount %",PurchOrderLine."Line Discount %");
              if PurchOrderLine.Quantity = 0 then
                PurchLine.VALIDATE("Inv. Discount Amount",0)
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
            PurchLine."Shortcut Dimension 1 Code" := PurchOrderLine."Shortcut Dimension 1 Code";
            PurchLine."Shortcut Dimension 2 Code" := PurchOrderLine."Shortcut Dimension 2 Code";
            PurchLine."Dimension Set ID" := PurchOrderLine."Dimension Set ID";

            OnBeforeInsertInvLineFromRetShptLine(PurchLine,PurchOrderLine);
            PurchLine.INSERT;
            OnAfterInsertInvLineFromRetShptLine(PurchLine);

            ItemTrackingMgt.CopyHandledItemTrkgToInvLine2(PurchOrderLine,PurchLine);

            NextLineNo := NextLineNo + 10000;
            if "Attached to Line No." = 0 then
              SETRANGE("Attached to Line No.","Line No.");
          until (NEXT = 0) or ("Attached to Line No." = 0);
        end;
    */


    //     LOCAL procedure GetPurchCrMemoLines (var TempPurchCrMemoLine@1000 :

    /*
    LOCAL procedure GetPurchCrMemoLines (var TempPurchCrMemoLine: Record 125 TEMPORARY)
        var
    //       PurchCrMemoLine@1003 :
          PurchCrMemoLine: Record 125;
    //       ItemLedgEntry@1002 :
          ItemLedgEntry: Record 32;
    //       ValueEntry@1001 :
          ValueEntry: Record 5802;
        begin
          TempPurchCrMemoLine.RESET;
          TempPurchCrMemoLine.DELETEALL;

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
                  if ValueEntry."Document Type" = ValueEntry."Document Type"::"Purchase Credit Memo" then
                    if PurchCrMemoLine.GET(ValueEntry."Document No.",ValueEntry."Document Line No.") then begin
                      TempPurchCrMemoLine.INIT;
                      TempPurchCrMemoLine := PurchCrMemoLine;
                      if TempPurchCrMemoLine.INSERT then;
                    end;
                until ValueEntry.NEXT = 0;
            until ItemLedgEntry.NEXT = 0;
          end;
        end;
    */



    //     procedure FilterPstdDocLnItemLedgEntries (var ItemLedgEntry@1000 :

    /*
    procedure FilterPstdDocLnItemLedgEntries (var ItemLedgEntry: Record 32)
        begin
          ItemLedgEntry.RESET;
          ItemLedgEntry.SETCURRENTKEY("Document No.");
          ItemLedgEntry.SETRANGE("Document No.","Document No.");
          ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Purchase Return Shipment");
          ItemLedgEntry.SETRANGE("Document Line No.","Line No.");
        end;
    */




    /*
    procedure ShowItemPurchCrMemoLines ()
        var
    //       TempPurchCrMemoLine@1000 :
          TempPurchCrMemoLine: Record 125 TEMPORARY;
        begin
          if Type = Type::Item then begin
            GetPurchCrMemoLines(TempPurchCrMemoLine);
            PAGE.RUNMODAL(0,TempPurchCrMemoLine);
          end;
        end;
    */


    //     LOCAL procedure InitCurrency (CurrencyCode@1001 :

    /*
    LOCAL procedure InitCurrency (CurrencyCode: Code[10])
        begin
          if (Currency.Code = CurrencyCode) and CurrencyRead then
            exit;

          if CurrencyCode <> '' then
            Currency.GET(CurrencyCode)
          else
            Currency.InitRoundingPrecision;
          CurrencyRead := TRUE;
        end;
    */




    /*
    procedure ShowLineComments ()
        var
    //       PurchCommentLine@1000 :
          PurchCommentLine: Record 43;
        begin
          PurchCommentLine.ShowComments(PurchCommentLine."Document Type"::"Posted Return Shipment","Document No.","Line No.");
        end;
    */



    //     procedure InitFromPurchLine (ReturnShptHeader@1001 : Record 6650;PurchLine@1002 :

    /*
    procedure InitFromPurchLine (ReturnShptHeader: Record 6650;PurchLine: Record 39)
        begin
          INIT;
          TRANSFERFIELDS(PurchLine);
          if ("No." = '') and (Type IN [Type::"G/L Account"..Type::"Charge (Item)"]) then
            Type := Type::" ";
          "Posting Date" := ReturnShptHeader."Posting Date";
          "Document No." := ReturnShptHeader."No.";
          Quantity := PurchLine."Return Qty. to Ship";
          "Quantity (Base)" := PurchLine."Return Qty. to Ship (Base)";
          if ABS(PurchLine."Qty. to Invoice") > ABS(PurchLine."Return Qty. to Ship") then begin
            "Quantity Invoiced" := PurchLine."Return Qty. to Ship";
            "Qty. Invoiced (Base)" := PurchLine."Return Qty. to Ship (Base)";
          end else begin
            "Quantity Invoiced" := PurchLine."Qty. to Invoice";
            "Qty. Invoiced (Base)" := PurchLine."Qty. to Invoice (Base)";
          end;
          "Return Qty. Shipped not Invd." := Quantity - "Quantity Invoiced";
          if PurchLine."Document Type" = PurchLine."Document Type"::"Return Order" then begin
            "Return Order No." := PurchLine."Document No.";
            "Return Order Line No." := PurchLine."Line No.";
          end;

          OnAfterInitFromPurchLine(ReturnShptHeader,PurchLine,Rec);
        end;
    */



    //     LOCAL procedure OnAfterInitFromPurchLine (ReturnShptHeader@1000 : Record 6650;PurchLine@1001 : Record 39;var ReturnShptLine@1002 :

    /*
    LOCAL procedure OnAfterInitFromPurchLine (ReturnShptHeader: Record 6650;PurchLine: Record 39;var ReturnShptLine: Record 6651)
        begin
        end;
    */



    //     LOCAL procedure OnAfterInsertInvLineFromRetShptLine (var PurchLine@1000 :

    /*
    LOCAL procedure OnAfterInsertInvLineFromRetShptLine (var PurchLine: Record 39)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeInsertInvLineFromRetShptLine (var PurchLine@1000 : Record 39;var PurchOrderLine@1001 :

    /*
    LOCAL procedure OnBeforeInsertInvLineFromRetShptLine (var PurchLine: Record 39;var PurchOrderLine: Record 39)
        begin
        end;

        /*begin
        //{
    //      CPA 03/03/22: - QB 1.10.23 (Q15921). Errores detectados en almacenes de obras. Nuevos campos "QB Qty Provissioned" y "QB Amount Provissioned"
    //      BS::20789 AML 22/1/24 Control de contratos
    //    }
        end.
      */
}




