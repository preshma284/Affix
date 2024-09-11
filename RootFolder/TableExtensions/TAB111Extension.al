tableextension 50131 "MyExtension50131" extends "Sales Shipment Line"
{

    /*
  Permissions=TableData 32 r,
                  TableData 5802 r;
  */
    CaptionML = ENU = 'Sales Shipment Line', ESP = 'Hist�rico l�n. albar�n venta';
    LookupPageID = "Posted Sales Shipment Lines";
    DrillDownPageID = "Posted Sales Shipment Lines";

    fields
    {
        field(7207280; "Temp Job No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1,04 - JAV 12/05/20: Guardo temporalemente el proyecto para poder eliminarlo y volverlo a recuperar tras un proceso';


        }
        field(7207281; "Temp Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimension Set ID';
            Description = 'QB 1,04 - JAV 12/05/20: Guardo temporalemente el ID para poderlo recuperar tras un proceso';
            Editable = false;

            trigger OnValidate();
            BEGIN
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            END;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(7238177; "QB_Piecework No."; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Piecework No.', ESP = 'Partida presupuestaria';
            Description = 'QPR 0.00.02.15431';

            trigger OnValidate();
            VAR
                //                                                                 Job@1100286000 :
                Job: Record 167;
                //                                                                 Item@1100286001 :
                Item: Record 27;
                //                                                                 txtQB000@1100286002 :
                txtQB000: TextConst ESP = 'No ha seleccionado un proyecto';
                //                                                                 txtQB001@1100286003 :
                txtQB001: TextConst ESP = 'Solo puede comprar contra almac�mn productos';
                //                                                                 txtQB002@1100286004 :
                txtQB002: TextConst ESP = 'No existe el producto';
                //                                                                 txtQB003@1100286005 :
                txtQB003: TextConst ESP = 'Solo puede comprar contra almac�n productos de tipo inventario';
                //                                                                 InventoryPostingSetup@1100286006 :
                InventoryPostingSetup: Record 5813;
            BEGIN
            END;


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
        // key(key4;"Item Shpt. Entry No.")
        //  {
        /* ;
  */
        // }
        // key(key5;"Sell-to Customer No.")
        //  {
        /* ;
  */
        // }
    }
    fieldgroups
    {
        // fieldgroup(DropDown;"Document No.","Line No.","Sell-to Customer No.","Type","No.","Shipment Date")
        // {
        // 
        // }
    }

    var
        //       Text000@1000 :
        Text000: TextConst ENU = 'Shipment No. %1:', ESP = 'N� albar�n %1:';
        //       Text001@1001 :
        Text001: TextConst ENU = 'The program cannot find this Sales line.', ESP = 'El prog. no puede encontrar esta l�n. vta.';
        //       Currency@1002 :
        Currency: Record 4;
        //       SalesShptHeader@1005 :
        SalesShptHeader: Record 110;
        //       PostedATOLink@1006 :
        PostedATOLink: Record 914;
        //       DimMgt@1003 :
        DimMgt: Codeunit 408;
        //       CurrencyRead@1004 :
        CurrencyRead: Boolean;
        //       "------------------ QB"@1100286000 :
        "------------------ QB": TextConst;
        //       QB001@1100286001 :
        QB001: TextConst ESP = 'de fecha %1:Option ';





    /*
    trigger OnDelete();    var
    //                ServItem@1000 :
                   ServItem: Record 5940;
    //                SalesDocLineComments@1001 :
                   SalesDocLineComments: Record 44;
                 begin
                   ServItem.RESET;
                   ServItem.SETCURRENTKEY("Sales/Serv. Shpt. Document No."",""Sales/Serv. Shpt. Line No.");
                   ServItem.SETRANGE("Sales/Serv. Shpt. Document No."",""Document No.");
                   ServItem.SETRANGE("Sales/Serv. Shpt. Line No."",""Line No.");
                   ServItem.SETRANGE("Shipment Type"","ServItem."Shipment Type"::Sales);
                   if ServItem.FIND"-') then
                     repeat
                       ServItem.VALIDATE("Sales/Serv. Shpt. Document No.",'');
                       ServItem.VALIDATE("Sales/Serv. Shpt. Line No.",0);
                       ServItem.MODIFY(TRUE);
                     until ServItem.NEXT = 0;

                   SalesDocLineComments.SETRANGE("Document Type",SalesDocLineComments."Document Type"::Shipment);
                   SalesDocLineComments.SETRANGE("No.","Document No.");
                   SalesDocLineComments.SETRANGE("Document Line No.","Line No.");
                   if not SalesDocLineComments.ISEMPTY then
                     SalesDocLineComments.DELETEALL;

                   PostedATOLink.DeleteAsmFromSalesShptLine(Rec);
                 end;

    */




    /*
    procedure GetCurrencyCode () : Code[10];
        begin
          if "Document No." = SalesShptHeader."No." then
            exit(SalesShptHeader."Currency Code");
          if SalesShptHeader.GET("Document No.") then
            exit(SalesShptHeader."Currency Code");
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
          ItemTrackingDocMgt.ShowItemTrackingForShptRcptLine(DATABASE::"Sales Shipment Line",0,"Document No.",'',0,"Line No.");
        end;
    */



    //     procedure InsertInvLineFromShptLine (var SalesLine@1000 :
    procedure InsertInvLineFromShptLine(var SalesLine: Record 37)
    var
        //       SalesInvHeader@1011 :
        SalesInvHeader: Record 36;
        //       SalesOrderHeader@1008 :
        SalesOrderHeader: Record 36;
        //       SalesOrderLine@1005 :
        SalesOrderLine: Record 37;
        //       TempSalesLine@1002 :
        TempSalesLine: Record 37 TEMPORARY;
        //       TransferOldExtLines@1007 :
        TransferOldExtLines: Codeunit 379;
        //       ItemTrackingMgt@1009 :
        ItemTrackingMgt: Codeunit 6500;
        //       LanguageManagement@1010 :
        LanguageManagement: Codeunit 43;
        LanguageManagement1: Codeunit "LanguageManagement 1";
        //       ExtTextLine@1006 :
        ExtTextLine: Boolean;
        //       NextLineNo@1001 :
        NextLineNo: Integer;
        //       IsHandled@1003 :
        IsHandled: Boolean;
    begin
        IsHandled := FALSE;
        OnBeforeCodeInsertInvLineFromShptLine(Rec, SalesLine, IsHandled);
        if IsHandled then
            exit;

        SETRANGE("Document No.", "Document No.");

        TempSalesLine := SalesLine;
        if SalesLine.FIND('+') then
            NextLineNo := SalesLine."Line No." + 10000
        else
            NextLineNo := 10000;

        if SalesInvHeader."No." <> TempSalesLine."Document No." then
            SalesInvHeader.GET(TempSalesLine."Document Type", TempSalesLine."Document No.");

        if SalesLine."Shipment No." <> "Document No." then begin
            SalesLine.INIT;
            SalesLine."Line No." := NextLineNo;
            SalesLine."Document Type" := TempSalesLine."Document Type";
            SalesLine."Document No." := TempSalesLine."Document No.";
            LanguageManagement1.SetGlobalLanguageByCode(SalesInvHeader."Language Code");
            SalesLine.Description := STRSUBSTNO(Text000, "Document No.");

            //JAV 28/10/21: - DynPlus A�adir la fecha del albar�n, le quito los : al final para a�adirlo
            SalesLine.Description := COPYSTR(SalesLine.Description, 1, STRLEN(SalesLine.Description) - 1) + ' de fecha ' + FORMAT(Rec."Posting Date") + ':';

            LanguageManagement1.RestoreGlobalLanguage;
            IsHandled := FALSE;
            OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(Rec, SalesLine, NextLineNo, IsHandled);
            if not IsHandled then begin
                SalesLine.INSERT;
                NextLineNo := NextLineNo + 10000;
            end;
        end;

        TransferOldExtLines.ClearLineNumbers;

        repeat
            ExtTextLine := (TransferOldExtLines.GetNewLineNumber("Attached to Line No.") <> 0);

            if (Type <> Type::" ") and SalesOrderLine.GET(SalesOrderLine."Document Type"::Order, "Order No.", "Order Line No.")
            then begin
                if (SalesOrderHeader."Document Type" <> SalesOrderLine."Document Type"::Order) or
                   (SalesOrderHeader."No." <> SalesOrderLine."Document No.")
                then
                    SalesOrderHeader.GET(SalesOrderLine."Document Type"::Order, "Order No.");

                InitCurrency("Currency Code");

                if SalesInvHeader."Prices Including VAT" then begin
                    if not SalesOrderHeader."Prices Including VAT" then
                        SalesOrderLine."Unit Price" :=
                          ROUND(
                            SalesOrderLine."Unit Price" * (1 + SalesOrderLine."VAT %" / 100),
                            Currency."Unit-Amount Rounding Precision");
                end else begin
                    if SalesOrderHeader."Prices Including VAT" then
                        SalesOrderLine."Unit Price" :=
                          ROUND(
                            SalesOrderLine."Unit Price" / (1 + SalesOrderLine."VAT %" / 100),
                            Currency."Unit-Amount Rounding Precision");
                end;
            end else begin
                SalesOrderHeader.INIT;
                if ExtTextLine or (Type = Type::" ") then begin
                    SalesOrderLine.INIT;
                    SalesOrderLine."Line No." := "Order Line No.";
                    SalesOrderLine.Description := Description;
                    SalesOrderLine."Description 2" := "Description 2";
                end else
                    ERROR(Text001);
            end;

            SalesLine := SalesOrderLine;
            SalesLine."Line No." := NextLineNo;
            SalesLine."Document Type" := TempSalesLine."Document Type";
            SalesLine."Document No." := TempSalesLine."Document No.";
            SalesLine."Variant Code" := "Variant Code";
            SalesLine."Location Code" := "Location Code";
            SalesLine."Drop Shipment" := "Drop Shipment";
            SalesLine."Shipment No." := "Document No.";
            SalesLine."Shipment Line No." := "Line No.";
            ClearSalesLineValues(SalesLine);
            if not ExtTextLine and (SalesLine.Type <> 0) then begin
                SalesLine.VALIDATE(Quantity, Quantity - "Quantity Invoiced");
                CalcBaseQuantities(SalesLine, "Quantity (Base)" / Quantity);
                SalesLine.VALIDATE("Unit Price", SalesOrderLine."Unit Price");
                SalesLine."Allow Line Disc." := SalesOrderLine."Allow Line Disc.";
                SalesLine."Allow Invoice Disc." := SalesOrderLine."Allow Invoice Disc.";
                SalesOrderLine."Line Discount Amount" :=
                  ROUND(
                    SalesOrderLine."Line Discount Amount" * SalesLine.Quantity / SalesOrderLine.Quantity,
                    Currency."Amount Rounding Precision");
                if SalesInvHeader."Prices Including VAT" then begin
                    if not SalesOrderHeader."Prices Including VAT" then
                        SalesOrderLine."Line Discount Amount" :=
                          ROUND(
                            SalesOrderLine."Line Discount Amount" *
                            (1 + SalesOrderLine."VAT %" / 100), Currency."Amount Rounding Precision");
                end else begin
                    if SalesOrderHeader."Prices Including VAT" then
                        SalesOrderLine."Line Discount Amount" :=
                          ROUND(
                            SalesOrderLine."Line Discount Amount" /
                            (1 + SalesOrderLine."VAT %" / 100), Currency."Amount Rounding Precision");
                end;
                SalesLine.VALIDATE("Line Discount Amount", SalesOrderLine."Line Discount Amount");
                SalesLine."Line Discount %" := SalesOrderLine."Line Discount %";
                SalesLine.UpdatePrePaymentAmounts;
                OnInsertInvLineFromShptLineOnAfterUpdatePrepaymentsAmounts(SalesLine, SalesOrderLine, Rec);

                if SalesOrderLine.Quantity = 0 then
                    SalesLine.VALIDATE("Inv. Discount Amount", 0)
                else
                    SalesLine.VALIDATE(
                      "Inv. Discount Amount",
                      ROUND(
                        SalesOrderLine."Inv. Discount Amount" * SalesLine.Quantity / SalesOrderLine.Quantity,
                        Currency."Amount Rounding Precision"));
            end;

            SalesLine."Attached to Line No." :=
              TransferOldExtLines.TransferExtendedText(
                SalesOrderLine."Line No.",
                NextLineNo,
                "Attached to Line No.");
            SalesLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            SalesLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            SalesLine."Dimension Set ID" := "Dimension Set ID";
            OnBeforeInsertInvLineFromShptLine(Rec, SalesLine, SalesOrderLine);
            SalesLine.INSERT;
            OnAfterInsertInvLineFromShptLine(SalesLine, SalesOrderLine, NextLineNo);

            ItemTrackingMgt.CopyHandledItemTrkgToInvLine(SalesOrderLine, SalesLine);

            NextLineNo := NextLineNo + 10000;
            if "Attached to Line No." = 0 then
                SETRANGE("Attached to Line No.", "Line No.");
        until (NEXT = 0) or ("Attached to Line No." = 0);

        if SalesOrderHeader.GET(SalesOrderHeader."Document Type"::Order, "Order No.") then begin
            SalesOrderHeader."Get Shipment Used" := TRUE;
            SalesOrderHeader.MODIFY;
        end;
    end;

    //     LOCAL procedure GetSalesInvLines (var TempSalesInvLine@1000 :

    /*
    LOCAL procedure GetSalesInvLines (var TempSalesInvLine: Record 113 TEMPORARY)
        var
    //       SalesInvLine@1003 :
          SalesInvLine: Record 113;
    //       ItemLedgEntry@1002 :
          ItemLedgEntry: Record 32;
    //       ValueEntry@1001 :
          ValueEntry: Record 5802;
        begin
          TempSalesInvLine.RESET;
          TempSalesInvLine.DELETEALL;

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
                  if ValueEntry."Document Type" = ValueEntry."Document Type"::"Sales Invoice" then
                    if SalesInvLine.GET(ValueEntry."Document No.",ValueEntry."Document Line No.") then begin
                      TempSalesInvLine.INIT;
                      TempSalesInvLine := SalesInvLine;
                      if TempSalesInvLine.INSERT then;
                    end;
                until ValueEntry.NEXT = 0;
            until ItemLedgEntry.NEXT = 0;
          end;
        end;
    */



    //     procedure CalcShippedSaleNotReturned (var ShippedQtyNotReturned@1003 : Decimal;var RevUnitCostLCY@1005 : Decimal;ExactCostReverse@1006 :

    /*
    procedure CalcShippedSaleNotReturned (var ShippedQtyNotReturned: Decimal;var RevUnitCostLCY: Decimal;ExactCostReverse: Boolean)
        var
    //       ItemLedgEntry@1000 :
          ItemLedgEntry: Record 32;
    //       TotalCostLCY@1007 :
          TotalCostLCY: Decimal;
    //       TotalQtyBase@1002 :
          TotalQtyBase: Decimal;
        begin
          ShippedQtyNotReturned := 0;
          if (Type <> Type::Item) or (Quantity <= 0) then begin
            RevUnitCostLCY := "Unit Cost (LCY)";
            exit;
          end;

          RevUnitCostLCY := 0;
          FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
          if ItemLedgEntry.FINDSET then
            repeat
              ShippedQtyNotReturned := ShippedQtyNotReturned - ItemLedgEntry."Shipped Qty. not Returned";
              if ExactCostReverse then begin
                ItemLedgEntry.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
                TotalCostLCY :=
                  TotalCostLCY + ItemLedgEntry."Cost Amount (Expected)" + ItemLedgEntry."Cost Amount (Actual)";
                TotalQtyBase := TotalQtyBase + ItemLedgEntry.Quantity;
              end;
            until ItemLedgEntry.NEXT = 0;

          if ExactCostReverse and (ShippedQtyNotReturned <> 0) and (TotalQtyBase <> 0) then
            RevUnitCostLCY := ABS(TotalCostLCY / TotalQtyBase) * "Qty. per Unit of Measure"
          else
            RevUnitCostLCY := "Unit Cost (LCY)";

          ShippedQtyNotReturned := CalcQty(ShippedQtyNotReturned);
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
          ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Sales Shipment");
          ItemLedgEntry.SETRANGE("Document Line No.","Line No.");
        end;
    */




    /*
    procedure ShowItemSalesInvLines ()
        var
    //       TempSalesInvLine@1001 :
          TempSalesInvLine: Record 113 TEMPORARY;
        begin
          if Type = Type::Item then begin
            GetSalesInvLines(TempSalesInvLine);
            PAGE.RUNMODAL(PAGE::"Posted Sales Invoice Lines",TempSalesInvLine);
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
    //       SalesCommentLine@1000 :
          SalesCommentLine: Record 44;
        begin
          SalesCommentLine.ShowComments(SalesCommentLine."Document Type"::Shipment,"Document No.","Line No.");
        end;
    */




    /*
    procedure ShowAsmToOrder ()
        begin
          PostedATOLink.ShowPostedAsm(Rec);
        end;
    */



    //     procedure AsmToShipmentExists (var PostedAsmHeader@1000 :

    /*
    procedure AsmToShipmentExists (var PostedAsmHeader: Record 910) : Boolean;
        var
    //       PostedAssembleToOrderLink@1001 :
          PostedAssembleToOrderLink: Record 914;
        begin
          if not PostedAssembleToOrderLink.AsmExistsForPostedShipmentLine(Rec) then
            exit(FALSE);
          exit(PostedAsmHeader.GET(PostedAssembleToOrderLink."Assembly Document No."));
        end;
    */



    //     procedure InitFromSalesLine (SalesShptHeader@1001 : Record 110;SalesLine@1002 :

    /*
    procedure InitFromSalesLine (SalesShptHeader: Record 110;SalesLine: Record 37)
        begin
          INIT;
          TRANSFERFIELDS(SalesLine);
          if ("No." = '') and (Type IN [Type::"G/L Account"..Type::"Charge (Item)"]) then
            Type := Type::" ";
          "Posting Date" := SalesShptHeader."Posting Date";
          "Document No." := SalesShptHeader."No.";
          Quantity := SalesLine."Qty. to Ship";
          "Quantity (Base)" := SalesLine."Qty. to Ship (Base)";
          if ABS(SalesLine."Qty. to Invoice") > ABS(SalesLine."Qty. to Ship") then begin
            "Quantity Invoiced" := SalesLine."Qty. to Ship";
            "Qty. Invoiced (Base)" := SalesLine."Qty. to Ship (Base)";
          end else begin
            "Quantity Invoiced" := SalesLine."Qty. to Invoice";
            "Qty. Invoiced (Base)" := SalesLine."Qty. to Invoice (Base)";
          end;
          "Qty. Shipped not Invoiced" := Quantity - "Quantity Invoiced";
          if SalesLine."Document Type" = SalesLine."Document Type"::Order then begin
            "Order No." := SalesLine."Document No.";
            "Order Line No." := SalesLine."Line No.";
          end;

          OnAfterInitFromSalesLine(SalesShptHeader,SalesLine,Rec);
        end;
    */


    //     LOCAL procedure ClearSalesLineValues (var SalesLine@1000 :

    /*
    LOCAL procedure ClearSalesLineValues (var SalesLine: Record 37)
        begin
          SalesLine."Quantity (Base)" := 0;
          SalesLine.Quantity := 0;
          SalesLine."Outstanding Qty. (Base)" := 0;
          SalesLine."Outstanding Quantity" := 0;
          SalesLine."Quantity Shipped" := 0;
          SalesLine."Qty. Shipped (Base)" := 0;
          SalesLine."Quantity Invoiced" := 0;
          SalesLine."Qty. Invoiced (Base)" := 0;
          SalesLine.Amount := 0;
          SalesLine."Amount Including VAT" := 0;
          SalesLine."Purchase Order No." := '';
          SalesLine."Purch. Order Line No." := 0;
          SalesLine."Special Order Purchase No." := '';
          SalesLine."Special Order Purch. Line No." := 0;
          SalesLine."Special Order" := FALSE;
          SalesLine."Appl.-to Item Entry" := 0;
          SalesLine."Appl.-from Item Entry" := 0;

          OnAfterClearSalesLineValues(Rec,SalesLine);
        end;
    */




    /*
    procedure FormatType () : Text;
        var
    //       SalesLine@1000 :
          SalesLine: Record 37;
        begin
          if Type = Type::" " then
            exit(SalesLine.FormatType);

          exit(FORMAT(Type));
        end;
    */


    //     LOCAL procedure CalcBaseQuantities (var SalesLine@1000 : Record 37;QtyFactor@1001 :

    /*
    LOCAL procedure CalcBaseQuantities (var SalesLine: Record 37;QtyFactor: Decimal)
        begin
          SalesLine."Quantity (Base)" := ROUND(SalesLine.Quantity * QtyFactor,0.00001);
          SalesLine."Qty. to Asm. to Order (Base)" := ROUND(SalesLine."Qty. to Assemble to Order" * QtyFactor,0.00001);
          SalesLine."Outstanding Qty. (Base)" := ROUND(SalesLine."Outstanding Quantity" * QtyFactor,0.00001);
          SalesLine."Qty. to Ship (Base)" := ROUND(SalesLine."Qty. to Ship" * QtyFactor,0.00001);
          SalesLine."Qty. Shipped (Base)" := ROUND(SalesLine."Quantity Shipped" * QtyFactor,0.00001);
          SalesLine."Qty. Shipped not Invd. (Base)" := ROUND(SalesLine."Qty. Shipped not Invoiced" * QtyFactor,0.00001);
          SalesLine."Qty. to Invoice (Base)" := ROUND(SalesLine."Qty. to Invoice" * QtyFactor,0.00001);
          SalesLine."Qty. Invoiced (Base)" := ROUND(SalesLine."Quantity Invoiced" * QtyFactor,0.00001);
          SalesLine."Return Qty. to Receive (Base)" := ROUND(SalesLine."Return Qty. to Receive" * QtyFactor,0.00001);
          SalesLine."Return Qty. Received (Base)" := ROUND(SalesLine."Return Qty. Received" * QtyFactor,0.00001);
          SalesLine."Ret. Qty. Rcd. not Invd.(Base)" := ROUND(SalesLine."Return Qty. Rcd. not Invd." * QtyFactor,0.00001);
        end;
    */


    //     LOCAL procedure GetFieldCaption (FieldNumber@1000 :

    /*
    LOCAL procedure GetFieldCaption (FieldNumber: Integer) : Text[100];
        var
    //       Field@1001 :
          Field: Record 2000000041;
        begin
          Field.GET(DATABASE::"Sales Shipment Line",FieldNumber);
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



    //     LOCAL procedure OnAfterClearSalesLineValues (var SalesShipmentLine@1000 : Record 111;var SalesLine@1001 :

    /*
    LOCAL procedure OnAfterClearSalesLineValues (var SalesShipmentLine: Record 111;var SalesLine: Record 37)
        begin
        end;
    */



    //     LOCAL procedure OnAfterInitFromSalesLine (SalesShptHeader@1000 : Record 110;SalesLine@1001 : Record 37;var SalesShptLine@1002 :

    /*
    LOCAL procedure OnAfterInitFromSalesLine (SalesShptHeader: Record 110;SalesLine: Record 37;var SalesShptLine: Record 111)
        begin
        end;
    */



    //     LOCAL procedure OnAfterInsertInvLineFromShptLine (var SalesLine@1000 : Record 37;SalesOrderLine@1001 : Record 37;NextLineNo@1002 :


    LOCAL procedure OnAfterInsertInvLineFromShptLine(var SalesLine: Record 37; SalesOrderLine: Record 37; NextLineNo: Integer)
    begin
    end;




    //     LOCAL procedure OnBeforeInsertInvLineFromShptLine (var SalesShptLine@1000 : Record 111;var SalesLine@1001 : Record 37;SalesOrderLine@1002 :


    LOCAL procedure OnBeforeInsertInvLineFromShptLine(var SalesShptLine: Record 111; var SalesLine: Record 37; SalesOrderLine: Record 37)
    begin
    end;



    //     LOCAL procedure OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine (var SalesShptLine@1000 : Record 111;var SalesLine@1001 : Record 37;var NextLineNo@1002 : Integer;var Handled@1003 :


    LOCAL procedure OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(var SalesShptLine: Record 111; var SalesLine: Record 37; var NextLineNo: Integer; var Handled: Boolean)
    begin
    end;




    //     LOCAL procedure OnBeforeCodeInsertInvLineFromShptLine (var SalesShipmentLine@1000 : Record 111;var SalesLine@1001 : Record 37;var IsHandled@1002 :


    LOCAL procedure OnBeforeCodeInsertInvLineFromShptLine(var SalesShipmentLine: Record 111; var SalesLine: Record 37; var IsHandled: Boolean)
    begin
    end;




    //     LOCAL procedure OnInsertInvLineFromShptLineOnAfterUpdatePrepaymentsAmounts (var SalesLine@1000 : Record 37;var SalesOrderLine@1001 : Record 37;var SalesShipmentLine@1002 :


    LOCAL procedure OnInsertInvLineFromShptLineOnAfterUpdatePrepaymentsAmounts(var SalesLine: Record 37; var SalesOrderLine: Record 37; var SalesShipmentLine: Record 111)
    begin
    end;

    /*begin
    end.
  */
}




