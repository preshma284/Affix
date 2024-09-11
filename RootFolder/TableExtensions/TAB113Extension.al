tableextension 50133 "MyExtension50133" extends "Sales Invoice Line"
{

    /*
  Permissions=TableData 32 r,
                  TableData 5802 r;
  */
    CaptionML = ENU = 'Sales Invoice Line', ESP = 'Hist�rico l�n. factura venta';
    LookupPageID = "Posted Sales Invoice Lines";
    DrillDownPageID = "Posted Sales Invoice Lines";

    fields
    {
        field(50001; "Price review line"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Price review line', ESP = 'Linea revision precio';
            Description = 'Q12733';


        }
        field(50002; "G.E.W. mod."; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'G.E.W. mod.', ESP = 'Ret. B.E. modificada';
            Description = 'BS::20668';
            Editable = false;


        }
        field(50003; "Do not print"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Do not print', ESP = 'No imprimir';
            Description = 'BS::20479';


        }
        field(7174331; "QuoSII Situacion Inmueble"; Code[2])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("PropertyLocation"));
            CaptionML = ENU = 'Property Situation', ESP = 'Situacion Inmueble';
            Description = 'QuoSII.007';


        }
        field(7174332; "QuoSII Referencia Catastral"; Code[25])
        {
            CaptionML = ENU = 'Cadastral Reference', ESP = 'Referencia Catastral';
            Description = 'QuoSII.007';


        }
        field(7207270; "QW % Withholding by GE"; Decimal)
        {
            CaptionML = ENU = '% Withholding by G.E', ESP = '% retenci�n por B.E.';
            Description = 'QB 1.00';
            Editable = false;


        }
        field(7207271; "QW Withholding Amount by GE"; Decimal)
        {
            CaptionML = ENU = 'Wittholding Amount by G.E', ESP = 'Importe retenci�n por B.E.';
            Description = 'QB 1.00';
            Editable = false;


        }
        field(7207272; "QW % Withholding by PIT"; Decimal)
        {
            CaptionML = ENU = '% Withholding PIT', ESP = '% retenci�n IRPF';
            Description = 'QB 1.00';
            Editable = false;


        }
        field(7207273; "QW Withholding Amount by PIT"; Decimal)
        {
            CaptionML = ENU = 'Withholding Amount by PIT', ESP = 'Importe retenci�n por IRPF';
            Description = 'QB 1.00';
            Editable = false;


        }
        field(7207274; "QB Certification code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Certification code', ESP = 'C�d. certificaci�n';
            Description = 'QB 1.00 - QB22111';


        }
        field(7207275; "QB Certification Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Certification Line No.', ESP = 'N§ l¡nea de certificaci¢n';
            Description = 'QB 1.00 - QB22111';


        }

        field(7207278; "Usage Document"; Code[20])
        {
            CaptionML = ENU = 'Usage Document', ESP = 'Documento Utilizaci�n';
            Description = 'QB 1.00 - QB25110';
            Editable = false;


        }
        field(7207279; "Usage Document Line"; Integer)
        {
            CaptionML = ENU = 'Usage Document Line', ESP = 'L�n. Documento Utilizaci�n';
            Description = 'QB 1.00 - QB25110';
            Editable = false;


        }
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
        field(7207282; "QB Prepayment Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'L�nea del anticipo';
            Description = 'QB 1.06 - JAV 28/06/20: - Si esta l�nea se ha creado para descontar el anticipo';


        }
        field(7207283; "QWNot apply Withholding GE"; Boolean)
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
        // key(key2;"Blanket Order No.","Blanket Order Line No.")
        //  {
        /* ;
  */
        // }
        // key(key3;"Sell-to Customer No.")
        //  {
        /* ;
  */
        // }
        // key(No4;"Sell-to Customer No.","Type","Document No.")
        // {
        /* MaintainSQLIndex=false;
  */
        // }
        // key(key5;"Shipment No.","Shipment Line No.")
        //  {
        /* ;
  */
        // }
        // key(key6;"Job Contract Entry No.")
        //  {
        /* ;
  */
        // }
        // key(key7;"Bill-to Customer No.")
        //  {
        /* ;
  */
        // }
        // key(key8;"Order No.","Order Line No.","Posting Date")
        //  {
        /* ;
  */
        // }
        // key(key9;"Document No.","Location Code")
        //  {
        /* //SumIndexFields="Amount","Amount Including VAT"
                                                    MaintainSQLIndex=false;
  */
        // }
    }
    fieldgroups
    {
        // fieldgroup(Brick;"No.","Description","Line Amount","Price description","Quantity","Unit of Measure Code")
        // {
        // 
        // }
    }

    var
        //       SalesInvoiceHeader@1002 :
        SalesInvoiceHeader: Record 112;
        //       Currency@1003 :
        Currency: Record 4;
        //       DimMgt@1001 :
        DimMgt: Codeunit 408;
        //       DeferralUtilities@1000 :
        DeferralUtilities: Codeunit 1720;
        //       PriceDescriptionTxt@1004 :
        PriceDescriptionTxt:
// {Locked}
TextConst ENU = 'x%1 (%2%3/%4)', ESP = 'x%1 (%2%3/%4)';
        //       PriceDescriptionWithLineDiscountTxt@1066 :
        PriceDescriptionWithLineDiscountTxt:
// {Locked}
TextConst ENU = 'x%1 (%2%3/%4) - %5%', ESP = 'x%1 (%2%3/%4) - %5%';





    /*
    trigger OnDelete();    var
    //                SalesDocLineComments@1000 :
                   SalesDocLineComments: Record 44;
    //                PostedDeferralHeader@1001 :
                   PostedDeferralHeader: Record 1704;
                 begin
                   SalesDocLineComments.SETRANGE("Document Type",SalesDocLineComments."Document Type"::"Posted Invoice");
                   SalesDocLineComments.SETRANGE("No.","Document No.");
                   SalesDocLineComments.SETRANGE("Document Line No.","Line No.");
                   if not SalesDocLineComments.ISEMPTY then
                     SalesDocLineComments.DELETEALL;

                   PostedDeferralHeader.DeleteHeader(DeferralUtilities.GetSalesDeferralDocType,'','',
                     SalesDocLineComments."Document Type"::"Posted Invoice","Document No.","Line No.");
                 end;

    */




    /*
    procedure GetCurrencyCode () : Code[10];
        begin
          GetHeader;
          exit(SalesInvoiceHeader."Currency Code");
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
          ItemTrackingDocMgt.ShowItemTrackingForInvoiceLine(RowID1);
        end;
    */



    //     procedure CalcVATAmountLines (SalesInvHeader@1000 : Record 112;var TempVATAmountLine@1001 :

    /*
    procedure CalcVATAmountLines (SalesInvHeader: Record 112;var TempVATAmountLine: Record 290 TEMPORARY)
        begin
          TempVATAmountLine.DELETEALL;
          SETRANGE("Document No.",SalesInvHeader."No.");
          if FIND('-') then
            repeat
              TempVATAmountLine.INIT;
              TempVATAmountLine.CopyFromSalesInvLine(Rec);
              if SalesInvHeader."Prices Including VAT" then
                TempVATAmountLine."Prices Including VAT" := TRUE;
              TempVATAmountLine.InsertLine;
            until NEXT = 0;
        end;
    */




    /*
    procedure GetLineAmountExclVAT () : Decimal;
        begin
          GetHeader;
          if not SalesInvoiceHeader."Prices Including VAT" then
            exit("Line Amount");

          exit(ROUND("Line Amount" / (1 + "VAT %" / 100),Currency."Amount Rounding Precision"));
        end;
    */




    /*
    procedure GetLineAmountInclVAT () : Decimal;
        begin
          GetHeader;
          if SalesInvoiceHeader."Prices Including VAT" then
            exit("Line Amount");

          exit(ROUND("Line Amount" * (1 + "VAT %" / 100),Currency."Amount Rounding Precision"));
        end;
    */



    /*
    LOCAL procedure GetHeader ()
        begin
          if SalesInvoiceHeader."No." = "Document No." then
            exit;
          if not SalesInvoiceHeader.GET("Document No.") then
            SalesInvoiceHeader.INIT;

          if SalesInvoiceHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
          else
            if not Currency.GET(SalesInvoiceHeader."Currency Code") then
              Currency.InitRoundingPrecision;
        end;
    */


    //     LOCAL procedure GetFieldCaption (FieldNumber@1000 :

    /*
    LOCAL procedure GetFieldCaption (FieldNumber: Integer) : Text[100];
        var
    //       Field@1001 :
          Field: Record 2000000041;
        begin
          Field.GET(DATABASE::"Sales Invoice Line",FieldNumber);
          exit(Field."Field Caption");
        end;
    */



    //     procedure GetCaptionClass (FieldNumber@1000 :

    /*
    procedure GetCaptionClass (FieldNumber: Integer) : Text[80];
        begin
          GetHeader;
          CASE FieldNumber OF
            FIELDNO("No."):
              exit(STRSUBSTNO('3,%1',GetFieldCaption(FieldNumber)));
            else begin
              if SalesInvoiceHeader."Prices Including VAT" then
                exit('2,1,' + GetFieldCaption(FieldNumber));
              exit('2,0,' + GetFieldCaption(FieldNumber));
            end
          end;
        end;
    */




    /*
    procedure RowID1 () : Text[250];
        var
    //       ItemTrackingMgt@1000 :
          ItemTrackingMgt: Codeunit 6500;
        begin
          exit(ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Invoice Line",
              0,"Document No.",'',0,"Line No."));
        end;
    */



    //     procedure GetSalesShptLines (var TempSalesShptLine@1000 :

    /*
    procedure GetSalesShptLines (var TempSalesShptLine: Record 111 TEMPORARY)
        var
    //       SalesShptLine@1003 :
          SalesShptLine: Record 111;
    //       ItemLedgEntry@1002 :
          ItemLedgEntry: Record 32;
    //       ValueEntry@1001 :
          ValueEntry: Record 5802;
        begin
          TempSalesShptLine.RESET;
          TempSalesShptLine.DELETEALL;

          if Type <> Type::Item then
            exit;

          FilterPstdDocLineValueEntries(ValueEntry);
          if ValueEntry.FINDSET then
            repeat
              ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
              if ItemLedgEntry."Document Type" = ItemLedgEntry."Document Type"::"Sales Shipment" then
                if SalesShptLine.GET(ItemLedgEntry."Document No.",ItemLedgEntry."Document Line No.") then begin
                  TempSalesShptLine.INIT;
                  TempSalesShptLine := SalesShptLine;
                  if TempSalesShptLine.INSERT then;
                end;
            until ValueEntry.NEXT = 0;
        end;
    */



    //     procedure CalcShippedSaleNotReturned (var ShippedQtyNotReturned@1006 : Decimal;var RevUnitCostLCY@1004 : Decimal;ExactCostReverse@1003 :

    /*
    procedure CalcShippedSaleNotReturned (var ShippedQtyNotReturned: Decimal;var RevUnitCostLCY: Decimal;ExactCostReverse: Boolean)
        var
    //       TempItemLedgEntry@1002 :
          TempItemLedgEntry: Record 32 TEMPORARY;
    //       TotalCostLCY@1009 :
          TotalCostLCY: Decimal;
    //       TotalQtyBase@1007 :
          TotalQtyBase: Decimal;
        begin
          ShippedQtyNotReturned := 0;
          if (Type <> Type::Item) or (Quantity <= 0) then begin
            RevUnitCostLCY := "Unit Cost (LCY)";
            exit;
          end;

          RevUnitCostLCY := 0;
          GetItemLedgEntries(TempItemLedgEntry,FALSE);
          if TempItemLedgEntry.FINDSET then
            repeat
              ShippedQtyNotReturned := ShippedQtyNotReturned - TempItemLedgEntry."Shipped Qty. not Returned";
              if ExactCostReverse then begin
                TempItemLedgEntry.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
                TotalCostLCY :=
                  TotalCostLCY + TempItemLedgEntry."Cost Amount (Expected)" + TempItemLedgEntry."Cost Amount (Actual)";
                TotalQtyBase := TotalQtyBase + TempItemLedgEntry.Quantity;
              end;
            until TempItemLedgEntry.NEXT = 0;

          if ExactCostReverse and (ShippedQtyNotReturned <> 0) and (TotalQtyBase <> 0) then
            RevUnitCostLCY := ABS(TotalCostLCY / TotalQtyBase) * "Qty. per Unit of Measure"
          else
            RevUnitCostLCY := "Unit Cost (LCY)";
          ShippedQtyNotReturned := CalcQty(ShippedQtyNotReturned);

          if ShippedQtyNotReturned > Quantity then
            ShippedQtyNotReturned := Quantity;
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



    //     procedure GetItemLedgEntries (var TempItemLedgEntry@1000 : TEMPORARY Record 32;SetQuantity@1003 :

    /*
    procedure GetItemLedgEntries (var TempItemLedgEntry: Record 32 TEMPORARY;SetQuantity: Boolean)
        var
    //       ItemLedgEntry@1002 :
          ItemLedgEntry: Record 32;
    //       ValueEntry@1001 :
          ValueEntry: Record 5802;
        begin
          if SetQuantity then begin
            TempItemLedgEntry.RESET;
            TempItemLedgEntry.DELETEALL;

            if Type <> Type::Item then
              exit;
          end;

          FilterPstdDocLineValueEntries(ValueEntry);
          ValueEntry.SETFILTER("Invoiced Quantity",'<>0');
          if ValueEntry.FINDSET then
            repeat
              ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
              TempItemLedgEntry := ItemLedgEntry;
              if SetQuantity then begin
                TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";
                if ABS(TempItemLedgEntry."Shipped Qty. not Returned") > ABS(TempItemLedgEntry.Quantity) then
                  TempItemLedgEntry."Shipped Qty. not Returned" := TempItemLedgEntry.Quantity;
              end;
              if TempItemLedgEntry.INSERT then;
            until ValueEntry.NEXT = 0;
        end;
    */



    //     procedure FilterPstdDocLineValueEntries (var ValueEntry@1000 :

    /*
    procedure FilterPstdDocLineValueEntries (var ValueEntry: Record 5802)
        begin
          ValueEntry.RESET;
          ValueEntry.SETCURRENTKEY("Document No.");
          ValueEntry.SETRANGE("Document No.","Document No.");
          ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Invoice");
          ValueEntry.SETRANGE("Document Line No.","Line No.");
        end;
    */




    /*
    procedure ShowItemShipmentLines ()
        var
    //       TempSalesShptLine@1000 :
          TempSalesShptLine: Record 111 TEMPORARY;
        begin
          if Type = Type::Item then begin
            GetSalesShptLines(TempSalesShptLine);
            PAGE.RUNMODAL(0,TempSalesShptLine);
          end;
        end;
    */




    /*
    procedure ShowLineComments ()
        var
    //       SalesCommentLine@1000 :
          SalesCommentLine: Record 44;
        begin
          SalesCommentLine.ShowComments(SalesCommentLine."Document Type"::"Posted Invoice","Document No.","Line No.");
        end;
    */



    //     procedure InitFromSalesLine (SalesInvHeader@1002 : Record 112;SalesLine@1001 :

    /*
    procedure InitFromSalesLine (SalesInvHeader: Record 112;SalesLine: Record 37)
        begin
          INIT;
          TRANSFERFIELDS(SalesLine);
          if ("No." = '') and (Type IN [Type::"G/L Account"..Type::"Charge (Item)"]) then
            Type := Type::" ";
          "Posting Date" := SalesInvHeader."Posting Date";
          "Document No." := SalesInvHeader."No.";
          Quantity := SalesLine."Qty. to Invoice";
          "Quantity (Base)" := SalesLine."Qty. to Invoice (Base)";

          OnAfterInitFromSalesLine(Rec,SalesInvHeader,SalesLine);
        end;
    */




    /*
    procedure ShowDeferrals ()
        begin
          DeferralUtilities.OpenLineScheduleView(
            "Deferral Code",DeferralUtilities.GetSalesDeferralDocType,'','',
            GetDocumentType,"Document No.","Line No.");
        end;
    */




    /*
    procedure UpdatePriceDescription ()
        var
    //       Currency@1000 :
          Currency: Record 4;
        begin
          "Price description" := '';
          if Type IN [Type::"Charge (Item)",Type::"Fixed Asset",Type::Item,Type::Resource] then begin
            if "Line Discount %" = 0 then
              "Price description" := STRSUBSTNO(
                  PriceDescriptionTxt,Quantity,Currency.ResolveGLCurrencySymbol(GetCurrencyCode),
                  "Unit Price","Unit of Measure")
            else
              "Price description" := STRSUBSTNO(
                  PriceDescriptionWithLineDiscountTxt,Quantity,Currency.ResolveGLCurrencySymbol(GetCurrencyCode),
                  "Unit Price","Unit of Measure","Line Discount %")
          end;
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




    /*
    procedure GetDocumentType () : Integer;
        var
    //       SalesCommentLine@1000 :
          SalesCommentLine: Record 44;
        begin
          exit(SalesCommentLine."Document Type"::"Posted Invoice")
        end;
    */



    /*
    procedure HasTypeToFillMandatoryFields () : Boolean;
        begin
          exit(Type <> Type::" ");
        end;
    */



    /*
    procedure IsCancellationSupported () : Boolean;
        begin
          exit(Type IN [Type::" ",Type::Item,Type::"G/L Account",Type::"Charge (Item)"]);
        end;
    */



    //     LOCAL procedure OnAfterInitFromSalesLine (var SalesInvLine@1002 : Record 113;SalesInvHeader@1000 : Record 112;SalesLine@1001 :

    /*
    LOCAL procedure OnAfterInitFromSalesLine (var SalesInvLine: Record 113;SalesInvHeader: Record 112;SalesLine: Record 37)
        begin
        end;

        /*begin
        //{
    //      Q12733 16/02/22 EPV: Added field Price review line
    //      BS::20668 CSM 04/01/24 � VEN027 Modificar importe retenci�n en venta.
    //      BS::20479 CSM 26/01/24 � VEN024 Selecci�n l�neas a imprimir.
    //    }
        end.
      */
}




