Codeunit 50021 "Sales Price Calc. Mgt. 1"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      GLSetup : Record 98;
      Item : Record 27;
      ResPrice : Record 201;
      Res : Record 156;
      Currency : Record 4;
      Text000 : TextConst ENU='%1 is less than %2 in the %3.',ESP='%1 es menor que %2 en el %3.';
      Text010 : TextConst ENU='Prices including VAT cannot be calculated when %1 is %2.',ESP='No se pueden calcular precios IVA incluido cuando %1 es %2.';
      TempSalesPrice : Record 7002 TEMPORARY;
      TempSalesLineDisc : Record 7004 TEMPORARY;
      LineDiscPerCent : Decimal;
      Qty : Decimal;
      AllowLineDisc : Boolean;
      AllowInvDisc : Boolean;
      VATPerCent : Decimal;
      PricesInclVAT : Boolean;
      VATCalcType: Enum "Tax Calculation Type";
      VATBusPostingGr : Code[20];
      QtyPerUOM : Decimal;
      PricesInCurrency : Boolean;
      CurrencyFactor : Decimal;
      ExchRateDate : Date;
      Text018 : TextConst ENU='%1 %2 is greater than %3 and was adjusted to %4.',ESP='%1 %2 es mayor que %3 y fue ajustado a %4.';
      FoundSalesPrice : Boolean;
      Text001 : TextConst ENU='The %1 in the %2 must be same as in the %3.',ESP='El %1 en el %2 debe ser el mismo que en el %3.';
      TempTableErr : TextConst ENU='The table passed as a parameter must be temporary.',ESP='La tabla pasada como un par�metro debe ser temporal.';
      HideResUnitPriceMessage : Boolean;
      DateCaption : Text[30];
      QBCodeunitPublisher : Codeunit 7207352;

    //[External]
    PROCEDURE FindSalesLinePrice(SalesHeader : Record 36;VAR SalesLine : Record 37;CalledByFieldNo : Integer);
    BEGIN
      WITH SalesLine DO BEGIN
        SetCurrency(
          SalesHeader."Currency Code",SalesHeader."Currency Factor",SalesHeaderExchDate(SalesHeader));
        SetVAT(SalesHeader."Prices Including VAT","VAT %" + "EC %","VAT Calculation Type","VAT Bus. Posting Group"); //enum to option
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
        SetLineDisc("Line Discount %","Allow Line Disc.","Allow Invoice Disc.");

        TESTFIELD("Qty. per Unit of Measure");
        IF PricesInCurrency THEN
          SalesHeader.TESTFIELD("Currency Factor");

        CASE Type OF
          Type::Item:
            BEGIN
              Item.GET("No.");
              SalesLinePriceExists(SalesHeader,SalesLine,FALSE);
              CalcBestUnitPrice(TempSalesPrice);
              IF FoundSalesPrice OR
                 NOT ((CalledByFieldNo = FIELDNO(Quantity)) OR
                      (CalledByFieldNo = FIELDNO("Variant Code")))
              THEN BEGIN
                "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                "Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
                "Unit Price" := TempSalesPrice."Unit Price";
              END;
              IF NOT "Allow Line Disc." THEN
                "Line Discount %" := 0;
            END;
          Type::Resource:
            BEGIN
              SetResPrice("No.","Work Type Code","Currency Code");
              QBCodeunitPublisher.FindSalesLinePriceCUSalesPriceCalcMgt(SalesHeader,SalesLine);   // QB  TO-DO Capturar el evento en lugar de llamar a la funci�n de QB
              CODEUNIT.RUN(CODEUNIT::"Resource-Find Price",ResPrice);
              OnAfterFindSalesLineResPrice(SalesLine,ResPrice);
              ConvertPriceToVAT(FALSE,'','',ResPrice."Unit Price");
              ConvertPriceLCYToFCY(ResPrice."Currency Code",ResPrice."Unit Price");
              "Unit Price" := ResPrice."Unit Price" * "Qty. per Unit of Measure";
            END;
        END;
        OnAfterFindSalesLinePrice(SalesLine,SalesHeader,TempSalesPrice,ResPrice,CalledByFieldNo);
      END;
    END;

    //[External]
    PROCEDURE FindItemJnlLinePrice(VAR ItemJnlLine : Record 83;CalledByFieldNo : Integer);
    BEGIN
      OnBeforeFindItemJnlLinePrice(ItemJnlLine);

      WITH ItemJnlLine DO BEGIN
        SetCurrency('',0,0D);
        SetVAT(FALSE,0,Enum::"Tax Calculation Type".FromInteger(0),'');
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
        TESTFIELD("Qty. per Unit of Measure");
        Item.GET("Item No.");

        FindSalesPrice(
          TempSalesPrice,'','','','',"Item No.","Variant Code",
          "Unit of Measure Code",'',"Posting Date",FALSE);
        CalcBestUnitPrice(TempSalesPrice);
        IF FoundSalesPrice OR
           NOT ((CalledByFieldNo = FIELDNO(Quantity)) OR
                (CalledByFieldNo = FIELDNO("Variant Code")))
        THEN
          VALIDATE("Unit Amount",TempSalesPrice."Unit Price");
        OnAfterFindItemJnlLinePrice(ItemJnlLine,TempSalesPrice,CalledByFieldNo);
      END;
    END;

    //[External]
    PROCEDURE FindServLinePrice(ServHeader : Record 5900;VAR ServLine : Record 5902;CalledByFieldNo : Integer);
    VAR
      ServCost : Record 5905;
      Res : Record 156;
    BEGIN
      WITH ServLine DO BEGIN
        ServHeader.GET("Document Type","Document No.");
        IF Type <> Type::" " THEN BEGIN
          SetCurrency(
            ServHeader."Currency Code",ServHeader."Currency Factor",ServHeaderExchDate(ServHeader));
          SetVAT(ServHeader."Prices Including VAT","VAT %","VAT Calculation Type","VAT Bus. Posting Group");//enum to option
          SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
          SetLineDisc("Line Discount %","Allow Line Disc.",FALSE);

          TESTFIELD("Qty. per Unit of Measure");
          IF PricesInCurrency THEN
            ServHeader.TESTFIELD("Currency Factor");
        END;

        CASE Type OF
          Type::Item:
            BEGIN
              ServLinePriceExists(ServHeader,ServLine,FALSE);
              CalcBestUnitPrice(TempSalesPrice);
              IF FoundSalesPrice OR
                 NOT ((CalledByFieldNo = FIELDNO(Quantity)) OR
                      (CalledByFieldNo = FIELDNO("Variant Code")))
              THEN BEGIN
                IF "Line Discount Type" = "Line Discount Type"::"Line Disc." THEN
                  "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                "Unit Price" := TempSalesPrice."Unit Price";
              END;
              IF NOT "Allow Line Disc." AND ("Line Discount Type" = "Line Discount Type"::"Line Disc.") THEN
                "Line Discount %" := 0;
            END;
          Type::Resource:
            BEGIN
              SetResPrice("No.","Work Type Code","Currency Code");
              QBCodeunitPublisher.FindServLinePriceCUSalesPriceCalcMgt(ServHeader,ServLine);   // QB  TO-DO Capturar el evento en lugar de llamar a la funci�n de QB
              CODEUNIT.RUN(CODEUNIT::"Resource-Find Price",ResPrice);
              OnAfterFindServLineResPrice(ServLine,ResPrice);
              ConvertPriceToVAT(FALSE,'','',ResPrice."Unit Price");
              ResPrice."Unit Price" := ResPrice."Unit Price" * "Qty. per Unit of Measure";
              ConvertPriceLCYToFCY(ResPrice."Currency Code",ResPrice."Unit Price");
              IF (ResPrice."Unit Price" > ServHeader."Max. Labor Unit Price") AND
                 (ServHeader."Max. Labor Unit Price" <> 0)
              THEN BEGIN
                Res.GET("No.");
                "Unit Price" := ServHeader."Max. Labor Unit Price";
                IF (HideResUnitPriceMessage = FALSE) AND
                   (CalledByFieldNo <> FIELDNO(Quantity))
                THEN
                  MESSAGE(
                    STRSUBSTNO(
                      Text018,
                      Res.TABLECAPTION,FIELDCAPTION("Unit Price"),
                      ServHeader.FIELDCAPTION("Max. Labor Unit Price"),
                      ServHeader."Max. Labor Unit Price"));
                HideResUnitPriceMessage := TRUE;
              END ELSE
                "Unit Price" := ResPrice."Unit Price";
            END;
          Type::Cost:
            BEGIN
              ServCost.GET("No.");

              ConvertPriceToVAT(FALSE,'','',ServCost."Default Unit Price");
              ConvertPriceLCYToFCY('',ServCost."Default Unit Price");
              "Unit Price" := ServCost."Default Unit Price";
            END;
        END;
        OnAfterFindServLinePrice(ServLine,ServHeader,TempSalesPrice,ResPrice,ServCost,CalledByFieldNo);
      END;
    END;

    //[External]
    PROCEDURE FindSalesLineLineDisc(SalesHeader : Record 36;VAR SalesLine : Record 37);
    BEGIN
      WITH SalesLine DO BEGIN
        SetCurrency(SalesHeader."Currency Code",0,0D);
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");

        TESTFIELD("Qty. per Unit of Measure");

        IF Type = Type::Item THEN BEGIN
          SalesLineLineDiscExists(SalesHeader,SalesLine,FALSE);
          CalcBestLineDisc(TempSalesLineDisc);

          "Line Discount %" := TempSalesLineDisc."Line Discount %";
        END;
        OnAfterFindSalesLineLineDisc(SalesLine,SalesHeader,TempSalesLineDisc);
      END;
    END;

    //[External]
    PROCEDURE FindServLineDisc(ServHeader : Record 5900;VAR ServLine : Record 5902);
    BEGIN
      OnBeforeFindServLineDisc(ServHeader,ServLine);

      WITH ServLine DO BEGIN
        SetCurrency(ServHeader."Currency Code",0,0D);
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");

        TESTFIELD("Qty. per Unit of Measure");

        IF Type = Type::Item THEN BEGIN
          Item.GET("No.");
          FindSalesLineDisc(
            TempSalesLineDisc,"Bill-to Customer No.",ServHeader."Contact No.",
            "Customer Disc. Group",'',"No.",Item."Item Disc. Group","Variant Code",
            "Unit of Measure Code",ServHeader."Currency Code",ServHeader."Order Date",FALSE);
          CalcBestLineDisc(TempSalesLineDisc);
          "Line Discount %" := TempSalesLineDisc."Line Discount %";
        END;
        IF Type IN [Type::Resource,Type::Cost,Type::"G/L Account"] THEN BEGIN
          "Line Discount %" := 0;
          "Line Discount Amount" :=
            ROUND(
              ROUND(CalcChargeableQty * "Unit Price",Currency."Amount Rounding Precision") *
              "Line Discount %" / 100,Currency."Amount Rounding Precision");
          "Inv. Discount Amount" := 0;
          "Inv. Disc. Amount to Invoice" := 0;
        END;
        OnAfterFindServLineDisc(ServLine,ServHeader,TempSalesLineDisc);
      END;
    END;

    //[External]
    PROCEDURE FindStdItemJnlLinePrice(VAR StdItemJnlLine : Record 753;CalledByFieldNo : Integer);
    BEGIN
      OnBeforeFindStdItemJnlLinePrice(StdItemJnlLine);

      WITH StdItemJnlLine DO BEGIN
        SetCurrency('',0,0D);
        SetVAT(FALSE,0,Enum::"Tax Calculation Type".FromInteger(0),'');
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
        TESTFIELD("Qty. per Unit of Measure");
        Item.GET("Item No.");

        FindSalesPrice(
          TempSalesPrice,'','','','',"Item No.","Variant Code",
          "Unit of Measure Code",'',WORKDATE,FALSE);
        CalcBestUnitPrice(TempSalesPrice);
        IF FoundSalesPrice OR
           NOT ((CalledByFieldNo = FIELDNO(Quantity)) OR
                (CalledByFieldNo = FIELDNO("Variant Code")))
        THEN
          VALIDATE("Unit Amount",TempSalesPrice."Unit Price");
        OnAfterFindStdItemJnlLinePrice(StdItemJnlLine,TempSalesPrice,CalledByFieldNo);
      END;
    END;

    //[External]
    PROCEDURE FindAnalysisReportPrice(ItemNo : Code[20];Date : Date) : Decimal;
    BEGIN
      OnBeforeFindAnalysisReportPrice(ItemNo,Date);

      SetCurrency('',0,0D);
      SetVAT(FALSE,0,Enum::"Tax Calculation Type".FromInteger(0),'');
      SetUoM(0,1);
      Item.GET(ItemNo);

      FindSalesPrice(TempSalesPrice,'','','','',ItemNo,'','','',Date,FALSE);
      CalcBestUnitPrice(TempSalesPrice);
      IF FoundSalesPrice THEN
        EXIT(TempSalesPrice."Unit Price");
      EXIT(Item."Unit Price");
    END;

    //[External]
    PROCEDURE CalcBestUnitPrice(VAR SalesPrice : Record 7002);
    VAR
      BestSalesPrice : Record 7002;
      BestSalesPriceFound : Boolean;
    BEGIN
      WITH SalesPrice DO BEGIN
        FoundSalesPrice := FINDSET;
        IF FoundSalesPrice THEN
          REPEAT
            IF IsInMinQty("Unit of Measure Code","Minimum Quantity") THEN BEGIN
              ConvertPriceToVAT(
                "Price Includes VAT",Item."VAT Prod. Posting Group",
                "VAT Bus. Posting Gr. (Price)","Unit Price");
              ConvertPriceToUoM("Unit of Measure Code","Unit Price");
              ConvertPriceLCYToFCY("Currency Code","Unit Price");

              CASE TRUE OF
                ((BestSalesPrice."Currency Code" = '') AND ("Currency Code" <> '')) OR
                ((BestSalesPrice."Variant Code" = '') AND ("Variant Code" <> '')):
                  BEGIN
                    BestSalesPrice := SalesPrice;
                    BestSalesPriceFound := TRUE;
                  END;
                ((BestSalesPrice."Currency Code" = '') OR ("Currency Code" <> '')) AND
                ((BestSalesPrice."Variant Code" = '') OR ("Variant Code" <> '')):
                  IF (BestSalesPrice."Unit Price" = 0) OR
                     (CalcLineAmount(BestSalesPrice) > CalcLineAmount(SalesPrice))
                  THEN BEGIN
                    BestSalesPrice := SalesPrice;
                    BestSalesPriceFound := TRUE;
                  END;
              END;
            END;
          UNTIL NEXT = 0;
      END;

      // No price found in agreement
      IF NOT BestSalesPriceFound THEN BEGIN
        ConvertPriceToVAT(
          Item."Price Includes VAT",Item."VAT Prod. Posting Group",
          Item."VAT Bus. Posting Gr. (Price)",Item."Unit Price");
        ConvertPriceToUoM('',Item."Unit Price");
        ConvertPriceLCYToFCY('',Item."Unit Price");

        CLEAR(BestSalesPrice);
        BestSalesPrice."Unit Price" := Item."Unit Price";
        BestSalesPrice."Allow Line Disc." := AllowLineDisc;
        BestSalesPrice."Allow Invoice Disc." := AllowInvDisc;
        OnAfterCalcBestUnitPriceAsItemUnitPrice(BestSalesPrice,Item);
      END;

      SalesPrice := BestSalesPrice;
    END;

    //[External]
    PROCEDURE CalcBestLineDisc(VAR SalesLineDisc : Record 7004);
    VAR
      BestSalesLineDisc : Record 7004;
    BEGIN
      WITH SalesLineDisc DO BEGIN
        IF FINDSET THEN
          REPEAT
            IF IsInMinQty("Unit of Measure Code","Minimum Quantity") THEN
              CASE TRUE OF
                ((BestSalesLineDisc."Currency Code" = '') AND ("Currency Code" <> '')) OR
                ((BestSalesLineDisc."Variant Code" = '') AND ("Variant Code" <> '')):
                  BestSalesLineDisc := SalesLineDisc;
                ((BestSalesLineDisc."Currency Code" = '') OR ("Currency Code" <> '')) AND
                ((BestSalesLineDisc."Variant Code" = '') OR ("Variant Code" <> '')):
                  IF BestSalesLineDisc."Line Discount %" < "Line Discount %" THEN
                    BestSalesLineDisc := SalesLineDisc;
              END;
          UNTIL NEXT = 0;
      END;

      SalesLineDisc := BestSalesLineDisc;
    END;

    //[External]
    PROCEDURE FindSalesPrice(VAR ToSalesPrice : Record 7002;CustNo : Code[20];ContNo : Code[20];CustPriceGrCode : Code[10];CampaignNo : Code[20];ItemNo : Code[20];VariantCode : Code[10];UOM : Code[10];CurrencyCode : Code[10];StartingDate : Date;ShowAll : Boolean);
    VAR
      FromSalesPrice : Record 7002;
      TempTargetCampaignGr : Record 7030 TEMPORARY;
    BEGIN
      IF NOT ToSalesPrice.ISTEMPORARY THEN
        ERROR(TempTableErr);

      OnBeforeFindSalesPrice(
        ToSalesPrice,FromSalesPrice,QtyPerUOM,Qty,CustNo,ContNo,CustPriceGrCode,CampaignNo,
        ItemNo,VariantCode,UOM,CurrencyCode,StartingDate,ShowAll);

      WITH FromSalesPrice DO BEGIN
        SETRANGE("Item No.",ItemNo);
        SETFILTER("Variant Code",'%1|%2',VariantCode,'');
        SETFILTER("Ending Date",'%1|>=%2',0D,StartingDate);
        IF NOT ShowAll THEN BEGIN
          SETFILTER("Currency Code",'%1|%2',CurrencyCode,'');
          IF UOM <> '' THEN
            SETFILTER("Unit of Measure Code",'%1|%2',UOM,'');
          SETRANGE("Starting Date",0D,StartingDate);
        END;

        ToSalesPrice.RESET;
        ToSalesPrice.DELETEALL;

        SETRANGE("Sales Type","Sales Type"::"All Customers");
        SETRANGE("Sales Code");
        CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);

        IF CustNo <> '' THEN BEGIN
          SETRANGE("Sales Type","Sales Type"::Customer);
          SETRANGE("Sales Code",CustNo);
          CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);
        END;

        IF CustPriceGrCode <> '' THEN BEGIN
          SETRANGE("Sales Type","Sales Type"::"Customer Price Group");
          SETRANGE("Sales Code",CustPriceGrCode);
          CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);
        END;

        IF NOT ((CustNo = '') AND (ContNo = '') AND (CampaignNo = '')) THEN BEGIN
          SETRANGE("Sales Type","Sales Type"::Campaign);
          IF ActivatedCampaignExists(TempTargetCampaignGr,CustNo,ContNo,CampaignNo) THEN
            REPEAT
              SETRANGE("Sales Code",TempTargetCampaignGr."Campaign No.");
              CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);
            UNTIL TempTargetCampaignGr.NEXT = 0;
        END;
        OnAfterFindSalesPrice(
          ToSalesPrice,FromSalesPrice,QtyPerUOM,Qty,CustNo,ContNo,CustPriceGrCode,CampaignNo,
          ItemNo,VariantCode,UOM,CurrencyCode,StartingDate,ShowAll);
      END;
    END;

    //[External]
    PROCEDURE FindSalesLineDisc(VAR ToSalesLineDisc : Record 7004;CustNo : Code[20];ContNo : Code[20];CustDiscGrCode : Code[20];CampaignNo : Code[20];ItemNo : Code[20];ItemDiscGrCode : Code[20];VariantCode : Code[10];UOM : Code[10];CurrencyCode : Code[10];StartingDate : Date;ShowAll : Boolean);
    VAR
      FromSalesLineDisc : Record 7004;
      TempCampaignTargetGr : Record 7030 TEMPORARY;
      InclCampaigns : Boolean;
    BEGIN
      OnBeforeFindSalesLineDisc(
        ToSalesLineDisc,CustNo,ContNo,CustDiscGrCode,CampaignNo,ItemNo,ItemDiscGrCode,VariantCode,UOM,
        CurrencyCode,StartingDate,ShowAll);

      WITH FromSalesLineDisc DO BEGIN
        SETFILTER("Ending Date",'%1|>=%2',0D,StartingDate);
        SETFILTER("Variant Code",'%1|%2',VariantCode,'');
        OnFindSalesLineDiscOnAfterSetFilters(FromSalesLineDisc);
        IF NOT ShowAll THEN BEGIN
          SETRANGE("Starting Date",0D,StartingDate);
          SETFILTER("Currency Code",'%1|%2',CurrencyCode,'');
          IF UOM <> '' THEN
            SETFILTER("Unit of Measure Code",'%1|%2',UOM,'');
        END;

        ToSalesLineDisc.RESET;
        ToSalesLineDisc.DELETEALL;
        FOR "Sales Type" := "Sales Type"::Customer TO "Sales Type"::Campaign DO
          IF ("Sales Type" = "Sales Type"::"All Customers") OR
             (("Sales Type" = "Sales Type"::Customer) AND (CustNo <> '')) OR
             (("Sales Type" = "Sales Type"::"Customer Disc. Group") AND (CustDiscGrCode <> '')) OR
             (("Sales Type" = "Sales Type"::Campaign) AND
              NOT ((CustNo = '') AND (ContNo = '') AND (CampaignNo = '')))
          THEN BEGIN
            InclCampaigns := FALSE;

            SETRANGE("Sales Type","Sales Type");
            CASE "Sales Type" OF
              "Sales Type"::"All Customers":
                SETRANGE("Sales Code");
              "Sales Type"::Customer:
                SETRANGE("Sales Code",CustNo);
              "Sales Type"::"Customer Disc. Group":
                SETRANGE("Sales Code",CustDiscGrCode);
              "Sales Type"::Campaign:
                BEGIN
                  InclCampaigns := ActivatedCampaignExists(TempCampaignTargetGr,CustNo,ContNo,CampaignNo);
                  SETRANGE("Sales Code",TempCampaignTargetGr."Campaign No.");
                END;
            END;

            REPEAT
              SETRANGE(Type,Type::Item);
              SETRANGE(Code,ItemNo);
              CopySalesDiscToSalesDisc(FromSalesLineDisc,ToSalesLineDisc);

              IF ItemDiscGrCode <> '' THEN BEGIN
                SETRANGE(Type,Type::"Item Disc. Group");
                SETRANGE(Code,ItemDiscGrCode);
                CopySalesDiscToSalesDisc(FromSalesLineDisc,ToSalesLineDisc);
              END;

              IF InclCampaigns THEN BEGIN
                InclCampaigns := TempCampaignTargetGr.NEXT <> 0;
                SETRANGE("Sales Code",TempCampaignTargetGr."Campaign No.");
              END;
            UNTIL NOT InclCampaigns;
          END;
      END;

      OnAfterFindSalesLineDisc(
        ToSalesLineDisc,CustNo,ContNo,CustDiscGrCode,CampaignNo,ItemNo,ItemDiscGrCode,VariantCode,UOM,
        CurrencyCode,StartingDate,ShowAll);
    END;

    LOCAL PROCEDURE CopySalesPriceToSalesPrice(VAR FromSalesPrice : Record 7002;VAR ToSalesPrice : Record 7002);
    BEGIN
      WITH ToSalesPrice DO BEGIN
        IF FromSalesPrice.FINDSET THEN
          REPEAT
            ToSalesPrice := FromSalesPrice;
            INSERT;
          UNTIL FromSalesPrice.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CopySalesDiscToSalesDisc(VAR FromSalesLineDisc : Record 7004;VAR ToSalesLineDisc : Record 7004);
    BEGIN
      WITH ToSalesLineDisc DO BEGIN
        IF FromSalesLineDisc.FINDSET THEN
          REPEAT
            ToSalesLineDisc := FromSalesLineDisc;
            INSERT;
          UNTIL FromSalesLineDisc.NEXT = 0;
      END;
    END;

    //[External]
    PROCEDURE SetResPrice(Code2 : Code[20];WorkTypeCode : Code[10];CurrencyCode : Code[10]);
    BEGIN
      WITH ResPrice DO BEGIN
        INIT;
        Code := Code2;
        "Work Type Code" := WorkTypeCode;
        "Currency Code" := CurrencyCode;
      END;
    END;

    LOCAL PROCEDURE SetCurrency(CurrencyCode2 : Code[10];CurrencyFactor2 : Decimal;ExchRateDate2 : Date);
    BEGIN
      PricesInCurrency := CurrencyCode2 <> '';
      IF PricesInCurrency THEN BEGIN
        Currency.GET(CurrencyCode2);
        Currency.TESTFIELD("Unit-Amount Rounding Precision");
        CurrencyFactor := CurrencyFactor2;
        ExchRateDate := ExchRateDate2;
      END ELSE
        GLSetup.GET;
    END;

    LOCAL PROCEDURE SetVAT(PriceInclVAT2 : Boolean;VATPerCent2 : Decimal;VATCalcType2 : Enum "Tax Calculation Type";VATBusPostingGr2 : Code[20]);
    BEGIN
      PricesInclVAT := PriceInclVAT2;
      VATPerCent := VATPerCent2;
      VATCalcType := VATCalcType2;
      VATBusPostingGr := VATBusPostingGr2;
    END;

    LOCAL PROCEDURE SetUoM(Qty2 : Decimal;QtyPerUoM2 : Decimal);
    BEGIN
      Qty := Qty2;
      QtyPerUOM := QtyPerUoM2;
    END;

    LOCAL PROCEDURE SetLineDisc(LineDiscPerCent2 : Decimal;AllowLineDisc2 : Boolean;AllowInvDisc2 : Boolean);
    BEGIN
      LineDiscPerCent := LineDiscPerCent2;
      AllowLineDisc := AllowLineDisc2;
      AllowInvDisc := AllowInvDisc2;
    END;

    LOCAL PROCEDURE IsInMinQty(UnitofMeasureCode : Code[10];MinQty : Decimal) : Boolean;
    BEGIN
      IF UnitofMeasureCode = '' THEN
        EXIT(MinQty <= QtyPerUOM * Qty);
      EXIT(MinQty <= Qty);
    END;

    LOCAL PROCEDURE ConvertPriceToVAT(FromPricesInclVAT : Boolean;FromVATProdPostingGr : Code[20];FromVATBusPostingGr : Code[20];VAR UnitPrice : Decimal);
    VAR
      VATPostingSetup : Record 325;
    BEGIN
      IF FromPricesInclVAT THEN BEGIN
        VATPostingSetup.GET(FromVATBusPostingGr,FromVATProdPostingGr);

        CASE VATPostingSetup."VAT Calculation Type" OF
          VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
            VATPostingSetup."VAT %" := 0;
          VATPostingSetup."VAT Calculation Type"::"Sales Tax":
            ERROR(
              Text010,
              VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
              VATPostingSetup."VAT Calculation Type");
        END;

        CASE VATCalcType OF
          VATCalcType::"Normal VAT",
          VATCalcType::"Full VAT",
          VATCalcType::"Sales Tax":
            BEGIN
              IF PricesInclVAT THEN BEGIN
                IF VATBusPostingGr <> FromVATBusPostingGr THEN
                  UnitPrice := UnitPrice * (100 + VATPerCent) / (100 + VATPostingSetup."VAT %");
              END ELSE
                UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
            END;
          VATCalcType::"Reverse Charge VAT":
            UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
        END;
      END ELSE
        IF PricesInclVAT THEN
          UnitPrice := UnitPrice * (1 + VATPerCent / 100);
    END;

    LOCAL PROCEDURE ConvertPriceToUoM(UnitOfMeasureCode : Code[10];VAR UnitPrice : Decimal);
    BEGIN
      IF UnitOfMeasureCode = '' THEN
        UnitPrice := UnitPrice * QtyPerUOM;
    END;

    LOCAL PROCEDURE ConvertPriceLCYToFCY(CurrencyCode : Code[10];VAR UnitPrice : Decimal);
    VAR
      CurrExchRate : Record 330;
    BEGIN
      IF PricesInCurrency THEN BEGIN
        IF CurrencyCode = '' THEN
          UnitPrice :=
            CurrExchRate.ExchangeAmtLCYToFCY(ExchRateDate,Currency.Code,UnitPrice,CurrencyFactor);
        UnitPrice := ROUND(UnitPrice,Currency."Unit-Amount Rounding Precision");
      END ELSE
        UnitPrice := ROUND(UnitPrice,GLSetup."Unit-Amount Rounding Precision");
    END;

    LOCAL PROCEDURE CalcLineAmount(SalesPrice : Record 7002) : Decimal;
    BEGIN
      WITH SalesPrice DO BEGIN
        IF "Allow Line Disc." THEN
          EXIT("Unit Price" * (1 - LineDiscPerCent / 100));
        EXIT("Unit Price");
      END;
    END;

    //[External]
    PROCEDURE GetSalesLinePrice(SalesHeader : Record 36;VAR SalesLine : Record 37);
    BEGIN
      SalesLinePriceExists(SalesHeader,SalesLine,TRUE);

      WITH SalesLine DO
        IF PAGE.RUNMODAL(PAGE::"Get Sales Price",TempSalesPrice) = ACTION::LookupOK THEN BEGIN
          SetVAT(
            SalesHeader."Prices Including VAT","VAT %","VAT Calculation Type","VAT Bus. Posting Group");//enum to option
          SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
          SetCurrency(
            SalesHeader."Currency Code",SalesHeader."Currency Factor",SalesHeaderExchDate(SalesHeader));

          IF NOT IsInMinQty(TempSalesPrice."Unit of Measure Code",TempSalesPrice."Minimum Quantity") THEN
            ERROR(
              Text000,
              FIELDCAPTION(Quantity),
              TempSalesPrice.FIELDCAPTION("Minimum Quantity"),
              TempSalesPrice.TABLECAPTION);
          IF NOT (TempSalesPrice."Currency Code" IN ["Currency Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Currency Code"),
              TABLECAPTION,
              TempSalesPrice.TABLECAPTION);
          IF NOT (TempSalesPrice."Unit of Measure Code" IN ["Unit of Measure Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Unit of Measure Code"),
              TABLECAPTION,
              TempSalesPrice.TABLECAPTION);
          IF TempSalesPrice."Starting Date" > SalesHeaderStartDate(SalesHeader,DateCaption) THEN
            ERROR(
              Text000,
              DateCaption,
              TempSalesPrice.FIELDCAPTION("Starting Date"),
              TempSalesPrice.TABLECAPTION);

          ConvertPriceToVAT(
            TempSalesPrice."Price Includes VAT",Item."VAT Prod. Posting Group",
            TempSalesPrice."VAT Bus. Posting Gr. (Price)",TempSalesPrice."Unit Price");
          ConvertPriceToUoM(TempSalesPrice."Unit of Measure Code",TempSalesPrice."Unit Price");
          ConvertPriceLCYToFCY(TempSalesPrice."Currency Code",TempSalesPrice."Unit Price");

          "Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
          "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
          IF NOT "Allow Line Disc." THEN
            "Line Discount %" := 0;

          VALIDATE("Unit Price",TempSalesPrice."Unit Price");
        END;

      OnAfterGetSalesLinePrice(SalesHeader,SalesLine,TempSalesPrice);
    END;

    //[External]
    PROCEDURE GetSalesLineLineDisc(SalesHeader : Record 36;VAR SalesLine : Record 37);
    BEGIN
      OnBeforeGetSalesLineLineDisc(SalesHeader,SalesLine);

      SalesLineLineDiscExists(SalesHeader,SalesLine,TRUE);

      WITH SalesLine DO
        IF PAGE.RUNMODAL(PAGE::"Get Sales Line Disc.",TempSalesLineDisc) = ACTION::LookupOK THEN
          BEGIN
          SetCurrency(SalesHeader."Currency Code",0,0D);
          SetUoM(ABS(Quantity),"Qty. per Unit of Measure");

          IF NOT IsInMinQty(TempSalesLineDisc."Unit of Measure Code",TempSalesLineDisc."Minimum Quantity")
          THEN
            ERROR(
              Text000,FIELDCAPTION(Quantity),
              TempSalesLineDisc.FIELDCAPTION("Minimum Quantity"),
              TempSalesLineDisc.TABLECAPTION);
          IF NOT (TempSalesLineDisc."Currency Code" IN ["Currency Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Currency Code"),
              TABLECAPTION,
              TempSalesLineDisc.TABLECAPTION);
          IF NOT (TempSalesLineDisc."Unit of Measure Code" IN ["Unit of Measure Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Unit of Measure Code"),
              TABLECAPTION,
              TempSalesLineDisc.TABLECAPTION);
          IF TempSalesLineDisc."Starting Date" > SalesHeaderStartDate(SalesHeader,DateCaption) THEN
            ERROR(
              Text000,
              DateCaption,
              TempSalesLineDisc.FIELDCAPTION("Starting Date"),
              TempSalesLineDisc.TABLECAPTION);

          TESTFIELD("Allow Line Disc.");
          VALIDATE("Line Discount %",TempSalesLineDisc."Line Discount %");
        END;

      OnAfterGetSalesLineLineDisc(SalesLine,TempSalesLineDisc);
    END;

    //[External]
    PROCEDURE SalesLinePriceExists(VAR SalesHeader : Record 36;VAR SalesLine : Record 37;ShowAll : Boolean) : Boolean;
    VAR
      IsHandled : Boolean;
    BEGIN
      WITH SalesLine DO
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
          IsHandled := FALSE;
          OnBeforeSalesLinePriceExists(
            SalesLine,SalesHeader,TempSalesPrice,Currency,CurrencyFactor,
            SalesHeaderStartDate(SalesHeader,DateCaption),Qty,QtyPerUOM,ShowAll,IsHandled);
          IF NOT IsHandled THEN BEGIN
            FindSalesPrice(
              TempSalesPrice,GetCustNoForSalesHeader(SalesHeader),SalesHeader."Bill-to Contact No.",
              "Customer Price Group",'',"No.","Variant Code","Unit of Measure Code",
              SalesHeader."Currency Code",SalesHeaderStartDate(SalesHeader,DateCaption),ShowAll);
            OnAfterSalesLinePriceExists(SalesLine,SalesHeader,TempSalesPrice,ShowAll);
          END;
          EXIT(TempSalesPrice.FINDFIRST);
        END;
      EXIT(FALSE);
    END;

    //[External]
    PROCEDURE SalesLineLineDiscExists(VAR SalesHeader : Record 36;VAR SalesLine : Record 37;ShowAll : Boolean) : Boolean;
    VAR
      IsHandled : Boolean;
    BEGIN
      WITH SalesLine DO
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
          IsHandled := FALSE;
          OnBeforeSalesLineLineDiscExists(
            SalesLine,SalesHeader,TempSalesLineDisc,SalesHeaderStartDate(SalesHeader,DateCaption),
            Qty,QtyPerUOM,ShowAll,IsHandled);
          IF NOT IsHandled THEN BEGIN
            FindSalesLineDisc(
              TempSalesLineDisc,GetCustNoForSalesHeader(SalesHeader),SalesHeader."Bill-to Contact No.",
              "Customer Disc. Group",'',"No.",Item."Item Disc. Group","Variant Code","Unit of Measure Code",
              SalesHeader."Currency Code",SalesHeaderStartDate(SalesHeader,DateCaption),ShowAll);
            OnAfterSalesLineLineDiscExists(SalesLine,SalesHeader,TempSalesLineDisc,ShowAll);
          END;
          EXIT(TempSalesLineDisc.FINDFIRST);
        END;
      EXIT(FALSE);
    END;

    //[External]
    PROCEDURE GetServLinePrice(ServHeader : Record 5900;VAR ServLine : Record 5902);
    BEGIN
      ServLinePriceExists(ServHeader,ServLine,TRUE);

      WITH ServLine DO
        IF PAGE.RUNMODAL(PAGE::"Get Sales Price",TempSalesPrice) = ACTION::LookupOK THEN BEGIN
          SetVAT(
            ServHeader."Prices Including VAT","VAT %","VAT Calculation Type","VAT Bus. Posting Group");//enum to option
          SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
          SetCurrency(
            ServHeader."Currency Code",ServHeader."Currency Factor",ServHeaderExchDate(ServHeader));

          IF NOT IsInMinQty(TempSalesPrice."Unit of Measure Code",TempSalesPrice."Minimum Quantity") THEN
            ERROR(
              Text000,
              FIELDCAPTION(Quantity),
              TempSalesPrice.FIELDCAPTION("Minimum Quantity"),
              TempSalesPrice.TABLECAPTION);
          IF NOT (TempSalesPrice."Currency Code" IN ["Currency Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Currency Code"),
              TABLECAPTION,
              TempSalesPrice.TABLECAPTION);
          IF NOT (TempSalesPrice."Unit of Measure Code" IN ["Unit of Measure Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Unit of Measure Code"),
              TABLECAPTION,
              TempSalesPrice.TABLECAPTION);
          IF TempSalesPrice."Starting Date" > ServHeaderStartDate(ServHeader,DateCaption) THEN
            ERROR(
              Text000,
              DateCaption,
              TempSalesPrice.FIELDCAPTION("Starting Date"),
              TempSalesPrice.TABLECAPTION);

          ConvertPriceToVAT(
            TempSalesPrice."Price Includes VAT",Item."VAT Prod. Posting Group",
            TempSalesPrice."VAT Bus. Posting Gr. (Price)",TempSalesPrice."Unit Price");
          ConvertPriceToUoM(TempSalesPrice."Unit of Measure Code",TempSalesPrice."Unit Price");
          ConvertPriceLCYToFCY(TempSalesPrice."Currency Code",TempSalesPrice."Unit Price");

          "Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
          "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
          IF NOT "Allow Line Disc." THEN
            "Line Discount %" := 0;

          VALIDATE("Unit Price",TempSalesPrice."Unit Price");
          ConfirmAdjPriceLineChange;
        END;
    END;

    //[External]
    PROCEDURE GetServLineLineDisc(ServHeader : Record 5900;VAR ServLine : Record 5902);
    BEGIN
      ServLineLineDiscExists(ServHeader,ServLine,TRUE);

      WITH ServLine DO
        IF PAGE.RUNMODAL(PAGE::"Get Sales Line Disc.",TempSalesLineDisc) = ACTION::LookupOK THEN BEGIN
          SetCurrency(ServHeader."Currency Code",0,0D);
          SetUoM(ABS(Quantity),"Qty. per Unit of Measure");

          IF NOT IsInMinQty(TempSalesLineDisc."Unit of Measure Code",TempSalesLineDisc."Minimum Quantity")
          THEN
            ERROR(
              Text000,FIELDCAPTION(Quantity),
              TempSalesLineDisc.FIELDCAPTION("Minimum Quantity"),
              TempSalesLineDisc.TABLECAPTION);
          IF NOT (TempSalesLineDisc."Currency Code" IN ["Currency Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Currency Code"),
              TABLECAPTION,
              TempSalesLineDisc.TABLECAPTION);
          IF NOT (TempSalesLineDisc."Unit of Measure Code" IN ["Unit of Measure Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Unit of Measure Code"),
              TABLECAPTION,
              TempSalesLineDisc.TABLECAPTION);
          IF TempSalesLineDisc."Starting Date" > ServHeaderStartDate(ServHeader,DateCaption) THEN
            ERROR(
              Text000,
              DateCaption,
              TempSalesLineDisc.FIELDCAPTION("Starting Date"),
              TempSalesLineDisc.TABLECAPTION);

          TESTFIELD("Allow Line Disc.");
          CheckLineDiscount(TempSalesLineDisc."Line Discount %");
          VALIDATE("Line Discount %",TempSalesLineDisc."Line Discount %");
          ConfirmAdjPriceLineChange;
        END;
    END;

    LOCAL PROCEDURE GetCustNoForSalesHeader(SalesHeader : Record 36) : Code[20];
    VAR
      CustNo : Code[20];
    BEGIN
      CustNo := SalesHeader."Bill-to Customer No.";
      OnGetCustNoForSalesHeader(SalesHeader,CustNo);
      EXIT(CustNo);
    END;

    LOCAL PROCEDURE ServLinePriceExists(ServHeader : Record 5900;VAR ServLine : Record 5902;ShowAll : Boolean) : Boolean;
    VAR
      IsHandled : Boolean;
    BEGIN
      WITH ServLine DO
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
          IsHandled := FALSE;
          OnBeforeServLinePriceExists(ServLine,ServHeader,TempSalesPrice,ShowAll,IsHandled);
          IF NOT IsHandled THEN
            FindSalesPrice(
              TempSalesPrice,"Bill-to Customer No.",ServHeader."Bill-to Contact No.",
              "Customer Price Group",'',"No.","Variant Code","Unit of Measure Code",
              ServHeader."Currency Code",ServHeaderStartDate(ServHeader,DateCaption),ShowAll);
          OnAfterServLinePriceExists(ServLine);
          EXIT(TempSalesPrice.FIND('-'));
        END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ServLineLineDiscExists(ServHeader : Record 5900;VAR ServLine : Record 5902;ShowAll : Boolean) : Boolean;
    BEGIN
      WITH ServLine DO
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
          OnBeforeServLineLineDiscExists(ServLine,ServHeader);
          FindSalesLineDisc(
            TempSalesLineDisc,"Bill-to Customer No.",ServHeader."Bill-to Contact No.",
            "Customer Disc. Group",'',"No.",Item."Item Disc. Group","Variant Code","Unit of Measure Code",
            ServHeader."Currency Code",ServHeaderStartDate(ServHeader,DateCaption),ShowAll);
          OnAfterServLineLineDiscExists(ServLine);
          EXIT(TempSalesLineDisc.FIND('-'));
        END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ActivatedCampaignExists(VAR ToCampaignTargetGr : Record 7030;CustNo : Code[20];ContNo : Code[20];CampaignNo : Code[20]) : Boolean;
    VAR
      FromCampaignTargetGr : Record 7030;
      Cont : Record 5050;
    BEGIN
      WITH FromCampaignTargetGr DO BEGIN
        ToCampaignTargetGr.RESET;
        ToCampaignTargetGr.DELETEALL;

        IF CampaignNo <> '' THEN BEGIN
          ToCampaignTargetGr."Campaign No." := CampaignNo;
          ToCampaignTargetGr.INSERT;
        END ELSE BEGIN
          SETRANGE(Type,Type::Customer);
          SETRANGE("No.",CustNo);
          IF FINDSET THEN
            REPEAT
              ToCampaignTargetGr := FromCampaignTargetGr;
              ToCampaignTargetGr.INSERT;
            UNTIL NEXT = 0
          ELSE BEGIN
            IF Cont.GET(ContNo) THEN BEGIN
              SETRANGE(Type,Type::Contact);
              SETRANGE("No.",Cont."Company No.");
              IF FINDSET THEN
                REPEAT
                  ToCampaignTargetGr := FromCampaignTargetGr;
                  ToCampaignTargetGr.INSERT;
                UNTIL NEXT = 0;
            END;
          END;
        END;
        EXIT(ToCampaignTargetGr.FINDFIRST);
      END;
    END;

    LOCAL PROCEDURE SalesHeaderExchDate(SalesHeader : Record 36) : Date;
    BEGIN
      WITH SalesHeader DO BEGIN
        IF "Posting Date" <> 0D THEN
          EXIT("Posting Date");
        EXIT(WORKDATE);
      END;
    END;

    LOCAL PROCEDURE SalesHeaderStartDate(VAR SalesHeader : Record 36;VAR DateCaption : Text[30]) : Date;
    BEGIN
      WITH SalesHeader DO
        IF "Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"] THEN BEGIN
          DateCaption := FIELDCAPTION("Posting Date");
          EXIT("Posting Date")
        END ELSE BEGIN
          DateCaption := FIELDCAPTION("Order Date");
          EXIT("Order Date");
        END;
    END;

    LOCAL PROCEDURE ServHeaderExchDate(ServHeader : Record 5900) : Date;
    BEGIN
      WITH ServHeader DO BEGIN
        IF ("Document Type" = "Document Type"::Quote) AND
           ("Posting Date" = 0D)
        THEN
          EXIT(WORKDATE);
        EXIT("Posting Date");
      END;
    END;

    LOCAL PROCEDURE ServHeaderStartDate(ServHeader : Record 5900;VAR DateCaption : Text[30]) : Date;
    BEGIN
      WITH ServHeader DO
        IF "Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"] THEN BEGIN
          DateCaption := FIELDCAPTION("Posting Date");
          EXIT("Posting Date")
        END ELSE BEGIN
          DateCaption := FIELDCAPTION("Order Date");
          EXIT("Order Date");
        END;
    END;

    //[External]
    PROCEDURE NoOfSalesLinePrice(VAR SalesHeader : Record 36;VAR SalesLine : Record 37;ShowAll : Boolean) : Integer;
    BEGIN
      IF SalesLinePriceExists(SalesHeader,SalesLine,ShowAll) THEN
        EXIT(TempSalesPrice.COUNT);
    END;

    //[External]
    PROCEDURE NoOfSalesLineLineDisc(VAR SalesHeader : Record 36;VAR SalesLine : Record 37;ShowAll : Boolean) : Integer;
    BEGIN
      IF SalesLineLineDiscExists(SalesHeader,SalesLine,ShowAll) THEN
        EXIT(TempSalesLineDisc.COUNT);
    END;

    //[External]
    PROCEDURE NoOfServLinePrice(ServHeader : Record 5900;VAR ServLine : Record 5902;ShowAll : Boolean) : Integer;
    BEGIN
      IF ServLinePriceExists(ServHeader,ServLine,ShowAll) THEN
        EXIT(TempSalesPrice.COUNT);
    END;

    //[External]
    PROCEDURE NoOfServLineLineDisc(ServHeader : Record 5900;VAR ServLine : Record 5902;ShowAll : Boolean) : Integer;
    BEGIN
      IF ServLineLineDiscExists(ServHeader,ServLine,ShowAll) THEN
        EXIT(TempSalesLineDisc.COUNT);
    END;

    //[External]
    PROCEDURE FindJobPlanningLinePrice(VAR JobPlanningLine : Record 1003;CalledByFieldNo : Integer);
    VAR
      Job : Record 167;
    BEGIN
      OnBeforeFindJobPlanningLinePrice(JobPlanningLine);

      WITH JobPlanningLine DO BEGIN
        SetCurrency("Currency Code","Currency Factor","Planning Date");
        SetVAT(FALSE,0,Enum::"Tax Calculation Type".FromInteger(0),'');
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
        SetLineDisc(0,TRUE,TRUE);

        CASE Type OF
          Type::Item:
            BEGIN
              Job.GET("Job No.");
              Item.GET("No.");
              TESTFIELD("Qty. per Unit of Measure");
              FindSalesPrice(
                TempSalesPrice,Job."Bill-to Customer No.",Job."Bill-to Contact No.",
                Job."Customer Price Group",'',"No.","Variant Code","Unit of Measure Code",
                Job."Currency Code","Planning Date",FALSE);
              CalcBestUnitPrice(TempSalesPrice);
              IF FoundSalesPrice OR
                 NOT ((CalledByFieldNo = FIELDNO(Quantity)) OR
                      (CalledByFieldNo = FIELDNO("Location Code")) OR
                      (CalledByFieldNo = FIELDNO("Variant Code")))
              THEN BEGIN
                "Unit Price" := TempSalesPrice."Unit Price";
                AllowLineDisc := TempSalesPrice."Allow Line Disc.";
              END;
            END;
          Type::Resource:
            BEGIN
              Job.GET("Job No.");
              SetResPrice("No.","Work Type Code","Currency Code");
              QBCodeunitPublisher.FindJobPlanningLinePriceCUSalesPriceCalcMgt(JobPlanningLine,CalledByFieldNo);   // QB  TO-DO Capturar el evento en lugar de llamar a la funci�n de QB
              CODEUNIT.RUN(CODEUNIT::"Resource-Find Price",ResPrice);
              OnAfterFindJobPlanningLineResPrice(JobPlanningLine,ResPrice);
              ConvertPriceLCYToFCY(ResPrice."Currency Code",ResPrice."Unit Price");
              "Unit Price" := ResPrice."Unit Price" * "Qty. per Unit of Measure";
            END;
        END;
      END;
      JobPlanningLineFindJTPrice(JobPlanningLine);
    END;

    //[External]
    PROCEDURE JobPlanningLineFindJTPrice(VAR JobPlanningLine : Record 1003);
    VAR
      JobItemPrice : Record 1013;
      JobResPrice : Record 1012;
      JobGLAccPrice : Record 1014;
    BEGIN
      WITH JobPlanningLine DO
        CASE Type OF
          Type::Item:
            BEGIN
              JobItemPrice.SETRANGE("Job No.","Job No.");
              JobItemPrice.SETRANGE("Item No.","No.");
              JobItemPrice.SETRANGE("Variant Code","Variant Code");
              JobItemPrice.SETRANGE("Unit of Measure Code","Unit of Measure Code");
              JobItemPrice.SETRANGE("Currency Code","Currency Code");
              JobItemPrice.SETRANGE("Job Task No.","Job Task No.");
              IF JobItemPrice.FINDFIRST THEN
                CopyJobItemPriceToJobPlanLine(JobPlanningLine,JobItemPrice)
              ELSE BEGIN
                JobItemPrice.SETRANGE("Job Task No.",' ');
                IF JobItemPrice.FINDFIRST THEN
                  CopyJobItemPriceToJobPlanLine(JobPlanningLine,JobItemPrice);
              END;

              IF JobItemPrice.ISEMPTY OR (NOT JobItemPrice."Apply Job Discount") THEN
                FindJobPlanningLineLineDisc(JobPlanningLine);
            END;
          Type::Resource:
            BEGIN
              Res.GET("No.");
              JobResPrice.SETRANGE("Job No.","Job No.");
              JobResPrice.SETRANGE("Currency Code","Currency Code");
              JobResPrice.SETRANGE("Job Task No.","Job Task No.");
              CASE TRUE OF
                JobPlanningLineFindJobResPrice(JobPlanningLine,JobResPrice,JobResPrice.Type::Resource):
                  CopyJobResPriceToJobPlanLine(JobPlanningLine,JobResPrice);
                JobPlanningLineFindJobResPrice(JobPlanningLine,JobResPrice,JobResPrice.Type::"Group(Resource)"):
                  CopyJobResPriceToJobPlanLine(JobPlanningLine,JobResPrice);
                JobPlanningLineFindJobResPrice(JobPlanningLine,JobResPrice,JobResPrice.Type::All):
                  CopyJobResPriceToJobPlanLine(JobPlanningLine,JobResPrice);
                ELSE
                  BEGIN
                  JobResPrice.SETRANGE("Job Task No.",'');
                  CASE TRUE OF
                    JobPlanningLineFindJobResPrice(JobPlanningLine,JobResPrice,JobResPrice.Type::Resource):
                      CopyJobResPriceToJobPlanLine(JobPlanningLine,JobResPrice);
                    JobPlanningLineFindJobResPrice(JobPlanningLine,JobResPrice,JobResPrice.Type::"Group(Resource)"):
                      CopyJobResPriceToJobPlanLine(JobPlanningLine,JobResPrice);
                    JobPlanningLineFindJobResPrice(JobPlanningLine,JobResPrice,JobResPrice.Type::All):
                      CopyJobResPriceToJobPlanLine(JobPlanningLine,JobResPrice);
                  END;
                END;
              END;
            END;
          Type::"G/L Account":
            BEGIN
              JobGLAccPrice.SETRANGE("Job No.","Job No.");
              JobGLAccPrice.SETRANGE("G/L Account No.","No.");
              JobGLAccPrice.SETRANGE("Currency Code","Currency Code");
              JobGLAccPrice.SETRANGE("Job Task No.","Job Task No.");
              IF JobGLAccPrice.FINDFIRST THEN
                CopyJobGLAccPriceToJobPlanLine(JobPlanningLine,JobGLAccPrice)
              ELSE BEGIN
                JobGLAccPrice.SETRANGE("Job Task No.",'');
                IF JobGLAccPrice.FINDFIRST THEN;
                CopyJobGLAccPriceToJobPlanLine(JobPlanningLine,JobGLAccPrice);
              END;
            END;
        END;
    END;

    LOCAL PROCEDURE CopyJobItemPriceToJobPlanLine(VAR JobPlanningLine : Record 1003;JobItemPrice : Record 1013);
    BEGIN
      WITH JobPlanningLine DO BEGIN
        IF JobItemPrice."Apply Job Price" THEN BEGIN
          "Unit Price" := JobItemPrice."Unit Price";
          "Cost Factor" := JobItemPrice."Unit Cost Factor";
        END;
        IF JobItemPrice."Apply Job Discount" THEN
          "Line Discount %" := JobItemPrice."Line Discount %";
      END;
    END;

    LOCAL PROCEDURE CopyJobResPriceToJobPlanLine(VAR JobPlanningLine : Record 1003;JobResPrice : Record 1012);
    BEGIN
      WITH JobPlanningLine DO BEGIN
        IF JobResPrice."Apply Job Price" THEN BEGIN
          "Unit Price" := JobResPrice."Unit Price" * "Qty. per Unit of Measure";
          "Cost Factor" := JobResPrice."Unit Cost Factor";
        END;
        IF JobResPrice."Apply Job Discount" THEN
          "Line Discount %" := JobResPrice."Line Discount %";
      END;
    END;

    LOCAL PROCEDURE JobPlanningLineFindJobResPrice(VAR JobPlanningLine : Record 1003;VAR JobResPrice : Record 1012;PriceType: Option "Resource","Group(Resource)","All") : Boolean;
    BEGIN
      CASE PriceType OF
        PriceType::Resource:
          BEGIN
            JobResPrice.SETRANGE(Type,JobResPrice.Type::Resource);
            JobResPrice.SETRANGE("Work Type Code",JobPlanningLine."Work Type Code");
            JobResPrice.SETRANGE(Code,JobPlanningLine."No.");
            EXIT(JobResPrice.FIND('-'));
          END;
        PriceType::"Group(Resource)":
          BEGIN
            JobResPrice.SETRANGE(Type,JobResPrice.Type::"Group(Resource)");
            JobResPrice.SETRANGE(Code,Res."Resource Group No.");
            EXIT(FindJobResPrice(JobResPrice,JobPlanningLine."Work Type Code"));
          END;
        PriceType::All:
          BEGIN
            JobResPrice.SETRANGE(Type,JobResPrice.Type::All);
            JobResPrice.SETRANGE(Code);
            EXIT(FindJobResPrice(JobResPrice,JobPlanningLine."Work Type Code"));
          END;
      END;
    END;

    LOCAL PROCEDURE CopyJobGLAccPriceToJobPlanLine(VAR JobPlanningLine : Record 1003;JobGLAccPrice : Record 1014);
    BEGIN
      WITH JobPlanningLine DO BEGIN
        "Unit Cost" := JobGLAccPrice."Unit Cost";
        "Unit Price" := JobGLAccPrice."Unit Price" * "Qty. per Unit of Measure";
        "Cost Factor" := JobGLAccPrice."Unit Cost Factor";
        "Line Discount %" := JobGLAccPrice."Line Discount %";
      END;
    END;

    //[External]
    PROCEDURE FindJobJnlLinePrice(VAR JobJnlLine : Record 210;CalledByFieldNo : Integer);
    VAR
      Job : Record 167;
    BEGIN
      OnBeforeFindJobJnlLinePrice(JobJnlLine);

      WITH JobJnlLine DO BEGIN
        SetCurrency("Currency Code","Currency Factor","Posting Date");
        SetVAT(FALSE,0,Enum::"Tax Calculation Type".FromInteger(0),'');
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");

        CASE Type OF
          Type::Item:
            BEGIN
              Item.GET("No.");
              TESTFIELD("Qty. per Unit of Measure");
              Job.GET("Job No.");

              FindSalesPrice(
                TempSalesPrice,Job."Bill-to Customer No.",Job."Bill-to Contact No.",
                "Customer Price Group",'',"No.","Variant Code","Unit of Measure Code",
                "Currency Code","Posting Date",FALSE);
              CalcBestUnitPrice(TempSalesPrice);
              IF FoundSalesPrice OR
                 NOT ((CalledByFieldNo = FIELDNO(Quantity)) OR
                      (CalledByFieldNo = FIELDNO("Variant Code")))
              THEN
                "Unit Price" := TempSalesPrice."Unit Price";
            END;
          Type::Resource:
            BEGIN
              Job.GET("Job No.");
              SetResPrice("No.","Work Type Code","Currency Code");
              QBCodeunitPublisher.FindJobJbLinePriceCUSalesPriceCalcMgt(JobJnlLine,CalledByFieldNo);   // QB  TO-DO Capturar el evento en lugar de llamar a la funci�n de QB
              CODEUNIT.RUN(CODEUNIT::"Resource-Find Price",ResPrice);
              OnAfterFindJobJnlLineResPrice(JobJnlLine,ResPrice);
              ConvertPriceLCYToFCY(ResPrice."Currency Code",ResPrice."Unit Price");
              "Unit Price" := ResPrice."Unit Price" * "Qty. per Unit of Measure";
            END;
        END;
      END;
      JobJnlLineFindJTPrice(JobJnlLine);
    END;

    LOCAL PROCEDURE JobJnlLineFindJobResPrice(VAR JobJnlLine : Record 210;VAR JobResPrice : Record 1012;PriceType: Option "Resource","Group(Resource)","All") : Boolean;
    BEGIN
      CASE PriceType OF
        PriceType::Resource:
          BEGIN
            JobResPrice.SETRANGE(Type,JobResPrice.Type::Resource);
            JobResPrice.SETRANGE("Work Type Code",JobJnlLine."Work Type Code");
            JobResPrice.SETRANGE(Code,JobJnlLine."No.");
            EXIT(JobResPrice.FIND('-'));
          END;
        PriceType::"Group(Resource)":
          BEGIN
            JobResPrice.SETRANGE(Type,JobResPrice.Type::"Group(Resource)");
            JobResPrice.SETRANGE(Code,Res."Resource Group No.");
            EXIT(FindJobResPrice(JobResPrice,JobJnlLine."Work Type Code"));
          END;
        PriceType::All:
          BEGIN
            JobResPrice.SETRANGE(Type,JobResPrice.Type::All);
            JobResPrice.SETRANGE(Code);
            EXIT(FindJobResPrice(JobResPrice,JobJnlLine."Work Type Code"));
          END;
      END;
    END;

    LOCAL PROCEDURE CopyJobResPriceToJobJnlLine(VAR JobJnlLine : Record 210;JobResPrice : Record 1012);
    BEGIN
      WITH JobJnlLine DO BEGIN
        IF JobResPrice."Apply Job Price" THEN BEGIN
          "Unit Price" := JobResPrice."Unit Price" * "Qty. per Unit of Measure";
          "Cost Factor" := JobResPrice."Unit Cost Factor";
        END;
        IF JobResPrice."Apply Job Discount" THEN
          "Line Discount %" := JobResPrice."Line Discount %";
      END;
    END;

    LOCAL PROCEDURE CopyJobGLAccPriceToJobJnlLine(VAR JobJnlLine : Record 210;JobGLAccPrice : Record 1014);
    BEGIN
      WITH JobJnlLine DO BEGIN
        "Unit Cost" := JobGLAccPrice."Unit Cost";
        "Unit Price" := JobGLAccPrice."Unit Price" * "Qty. per Unit of Measure";
        "Cost Factor" := JobGLAccPrice."Unit Cost Factor";
        "Line Discount %" := JobGLAccPrice."Line Discount %";
      END;
    END;

    LOCAL PROCEDURE JobJnlLineFindJTPrice(VAR JobJnlLine : Record 210);
    VAR
      JobItemPrice : Record 1013;
      JobResPrice : Record 1012;
      JobGLAccPrice : Record 1014;
    BEGIN
      WITH JobJnlLine DO
        CASE Type OF
          Type::Item:
            BEGIN
              JobItemPrice.SETRANGE("Job No.","Job No.");
              JobItemPrice.SETRANGE("Item No.","No.");
              JobItemPrice.SETRANGE("Variant Code","Variant Code");
              JobItemPrice.SETRANGE("Unit of Measure Code","Unit of Measure Code");
              JobItemPrice.SETRANGE("Currency Code","Currency Code");
              JobItemPrice.SETRANGE("Job Task No.","Job Task No.");
              IF JobItemPrice.FINDFIRST THEN
                CopyJobItemPriceToJobJnlLine(JobJnlLine,JobItemPrice)
              ELSE BEGIN
                JobItemPrice.SETRANGE("Job Task No.",' ');
                IF JobItemPrice.FINDFIRST THEN
                  CopyJobItemPriceToJobJnlLine(JobJnlLine,JobItemPrice);
              END;
              IF JobItemPrice.ISEMPTY OR (NOT JobItemPrice."Apply Job Discount") THEN
                FindJobJnlLineLineDisc(JobJnlLine);
              OnAfterJobJnlLineFindJTPriceItem(JobJnlLine);
            END;
          Type::Resource:
            BEGIN
              Res.GET("No.");
              JobResPrice.SETRANGE("Job No.","Job No.");
              JobResPrice.SETRANGE("Currency Code","Currency Code");
              JobResPrice.SETRANGE("Job Task No.","Job Task No.");
              CASE TRUE OF
                JobJnlLineFindJobResPrice(JobJnlLine,JobResPrice,JobResPrice.Type::Resource):
                  CopyJobResPriceToJobJnlLine(JobJnlLine,JobResPrice);
                JobJnlLineFindJobResPrice(JobJnlLine,JobResPrice,JobResPrice.Type::"Group(Resource)"):
                  CopyJobResPriceToJobJnlLine(JobJnlLine,JobResPrice);
                JobJnlLineFindJobResPrice(JobJnlLine,JobResPrice,JobResPrice.Type::All):
                  CopyJobResPriceToJobJnlLine(JobJnlLine,JobResPrice);
                ELSE
                  BEGIN
                  JobResPrice.SETRANGE("Job Task No.",'');
                  CASE TRUE OF
                    JobJnlLineFindJobResPrice(JobJnlLine,JobResPrice,JobResPrice.Type::Resource):
                      CopyJobResPriceToJobJnlLine(JobJnlLine,JobResPrice);
                    JobJnlLineFindJobResPrice(JobJnlLine,JobResPrice,JobResPrice.Type::"Group(Resource)"):
                      CopyJobResPriceToJobJnlLine(JobJnlLine,JobResPrice);
                    JobJnlLineFindJobResPrice(JobJnlLine,JobResPrice,JobResPrice.Type::All):
                      CopyJobResPriceToJobJnlLine(JobJnlLine,JobResPrice);
                  END;
                END;
              END;
              OnAfterJobJnlLineFindJTPriceResource(JobJnlLine);
            END;
          Type::"G/L Account":
            BEGIN
              JobGLAccPrice.SETRANGE("Job No.","Job No.");
              JobGLAccPrice.SETRANGE("G/L Account No.","No.");
              JobGLAccPrice.SETRANGE("Currency Code","Currency Code");
              JobGLAccPrice.SETRANGE("Job Task No.","Job Task No.");
              IF JobGLAccPrice.FINDFIRST THEN
                CopyJobGLAccPriceToJobJnlLine(JobJnlLine,JobGLAccPrice)
              ELSE BEGIN
                JobGLAccPrice.SETRANGE("Job Task No.",'');
                IF JobGLAccPrice.FINDFIRST THEN;
                CopyJobGLAccPriceToJobJnlLine(JobJnlLine,JobGLAccPrice);
              END;
              OnAfterJobJnlLineFindJTPriceGLAccount(JobJnlLine);
            END;
        END;
    END;

    LOCAL PROCEDURE CopyJobItemPriceToJobJnlLine(VAR JobJnlLine : Record 210;JobItemPrice : Record 1013);
    BEGIN
      WITH JobJnlLine DO BEGIN
        IF JobItemPrice."Apply Job Price" THEN BEGIN
          "Unit Price" := JobItemPrice."Unit Price";
          "Cost Factor" := JobItemPrice."Unit Cost Factor";
        END;
        IF JobItemPrice."Apply Job Discount" THEN
          "Line Discount %" := JobItemPrice."Line Discount %";
      END;
    END;

    LOCAL PROCEDURE FindJobPlanningLineLineDisc(VAR JobPlanningLine : Record 1003);
    BEGIN
      WITH JobPlanningLine DO BEGIN
        SetCurrency("Currency Code","Currency Factor","Planning Date");
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
        TESTFIELD("Qty. per Unit of Measure");
        IF Type = Type::Item THEN BEGIN
          JobPlanningLineLineDiscExists(JobPlanningLine,FALSE);
          CalcBestLineDisc(TempSalesLineDisc);
          IF AllowLineDisc THEN
            "Line Discount %" := TempSalesLineDisc."Line Discount %"
          ELSE
            "Line Discount %" := 0;
        END;
      END;

      OnAfterFindJobPlanningLineLineDisc(JobPlanningLine,TempSalesLineDisc);
    END;

    LOCAL PROCEDURE JobPlanningLineLineDiscExists(VAR JobPlanningLine : Record 1003;ShowAll : Boolean) : Boolean;
    VAR
      Job : Record 167;
    BEGIN
      WITH JobPlanningLine DO
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
          Job.GET("Job No.");
          OnBeforeJobPlanningLineLineDiscExists(JobPlanningLine);
          FindSalesLineDisc(
            TempSalesLineDisc,Job."Bill-to Customer No.",Job."Bill-to Contact No.",
            Job."Customer Disc. Group",'',"No.",Item."Item Disc. Group","Variant Code","Unit of Measure Code",
            "Currency Code",JobPlanningLineStartDate(JobPlanningLine,DateCaption),ShowAll);
          OnAfterJobPlanningLineLineDiscExists(JobPlanningLine);
          EXIT(TempSalesLineDisc.FIND('-'));
        END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE JobPlanningLineStartDate(JobPlanningLine : Record 1003;VAR DateCaption : Text[30]) : Date;
    BEGIN
      DateCaption := JobPlanningLine.FIELDCAPTION("Planning Date");
      EXIT(JobPlanningLine."Planning Date");
    END;

    LOCAL PROCEDURE FindJobJnlLineLineDisc(VAR JobJnlLine : Record 210);
    BEGIN
      WITH JobJnlLine DO BEGIN
        SetCurrency("Currency Code","Currency Factor","Posting Date");
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
        TESTFIELD("Qty. per Unit of Measure");
        IF Type = Type::Item THEN BEGIN
          JobJnlLineLineDiscExists(JobJnlLine,FALSE);
          CalcBestLineDisc(TempSalesLineDisc);
          "Line Discount %" := TempSalesLineDisc."Line Discount %";
        END;
      END;

      OnAfterFindJobJnlLineLineDisc(JobJnlLine,TempSalesLineDisc);
    END;

    LOCAL PROCEDURE JobJnlLineLineDiscExists(VAR JobJnlLine : Record 210;ShowAll : Boolean) : Boolean;
    VAR
      Job : Record 167;
    BEGIN
      WITH JobJnlLine DO
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
          Job.GET("Job No.");
          OnBeforeJobJnlLineLineDiscExists(JobJnlLine);
          FindSalesLineDisc(
            TempSalesLineDisc,Job."Bill-to Customer No.",Job."Bill-to Contact No.",
            Job."Customer Disc. Group",'',"No.",Item."Item Disc. Group","Variant Code","Unit of Measure Code",
            "Currency Code",JobJnlLineStartDate(JobJnlLine,DateCaption),ShowAll);
          OnAfterJobJnlLineLineDiscExists(JobJnlLine);
          EXIT(TempSalesLineDisc.FIND('-'));
        END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE JobJnlLineStartDate(JobJnlLine : Record 210;VAR DateCaption : Text[30]) : Date;
    BEGIN
      DateCaption := JobJnlLine.FIELDCAPTION("Posting Date");
      EXIT(JobJnlLine."Posting Date");
    END;

    LOCAL PROCEDURE FindJobResPrice(VAR JobResPrice : Record 1012;WorkTypeCode : Code[10]) : Boolean;
    BEGIN
      JobResPrice.SETRANGE("Work Type Code",WorkTypeCode);
      IF JobResPrice.FINDFIRST THEN
        EXIT(TRUE);
      JobResPrice.SETRANGE("Work Type Code",'');
      EXIT(JobResPrice.FINDFIRST);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalcBestUnitPriceAsItemUnitPrice(VAR SalesPrice : Record 7002;VAR Item : Record 27);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindItemJnlLinePrice(VAR ItemJournalLine : Record 83;VAR SalesPrice : Record 7002;CalledByFieldNo : Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindJobJnlLineResPrice(VAR JobJournalLine : Record 210;VAR ResourcePrice : Record 201);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindJobJnlLineLineDisc(VAR JobJournalLine : Record 210;VAR TempSalesLineDisc : Record 7004 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindJobPlanningLineLineDisc(VAR JobPlanningLine : Record 1003;VAR TempSalesLineDisc : Record 7004 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindJobPlanningLineResPrice(VAR JobPlanningLine : Record 1003;VAR ResourcePrice : Record 201);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindStdItemJnlLinePrice(VAR StdItemJnlLine : Record 753;VAR SalesPrice : Record 7002;CalledByFieldNo : Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindSalesLinePrice(VAR SalesLine : Record 37;VAR SalesHeader : Record 36;VAR SalesPrice : Record 7002;VAR ResourcePrice : Record 201;CalledByFieldNo : Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindSalesLineLineDisc(VAR SalesLine : Record 37;VAR SalesHeader : Record 36;VAR SalesLineDiscount : Record 7004);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindSalesPrice(VAR ToSalesPrice : Record 7002;VAR FromSalesPrice : Record 7002;QtyPerUOM : Decimal;Qty : Decimal;CustNo : Code[20];ContNo : Code[20];CustPriceGrCode : Code[10];CampaignNo : Code[20];ItemNo : Code[20];VariantCode : Code[10];UOM : Code[10];CurrencyCode : Code[10];StartingDate : Date;ShowAll : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindSalesLineResPrice(VAR SalesLine : Record 37;VAR ResPrice : Record 201);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindSalesLineDisc(VAR ToSalesLineDisc : Record 7004;CustNo : Code[20];ContNo : Code[20];CustDiscGrCode : Code[20];CampaignNo : Code[20];ItemNo : Code[20];ItemDiscGrCode : Code[20];VariantCode : Code[10];UOM : Code[10];CurrencyCode : Code[10];StartingDate : Date;ShowAll : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindServLinePrice(VAR ServiceLine : Record 5902;VAR ServiceHeader : Record 5900;VAR SalesPrice : Record 7002;VAR ResourcePrice : Record 201;VAR ServiceCost : Record 5905;CalledByFieldNo : Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindServLineResPrice(VAR ServiceLine : Record 5902;VAR ResPrice : Record 201);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindServLineDisc(VAR ServiceLine : Record 5902;VAR ServiceHeader : Record 5900;VAR SalesLineDiscount : Record 7004);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterGetSalesLinePrice(VAR SalesHeader : Record 36;VAR SalesLine : Record 37;VAR TempSalesPrice : Record 7002 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterGetSalesLineLineDisc(VAR SalesLine : Record 37;VAR SalesLineDiscount : Record 7004);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterJobJnlLineFindJTPriceGLAccount(VAR JobJournalLine : Record 210);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterJobJnlLineFindJTPriceItem(VAR JobJournalLine : Record 210);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterJobJnlLineFindJTPriceResource(VAR JobJournalLine : Record 210);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterJobJnlLineLineDiscExists(VAR JobJournalLine : Record 210);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterJobPlanningLineLineDiscExists(VAR JobPlanningLine : Record 1003);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSalesLineLineDiscExists(VAR SalesLine : Record 37;VAR SalesHeader : Record 36;VAR TempSalesLineDisc : Record 7004 TEMPORARY;ShowAll : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSalesLinePriceExists(VAR SalesLine : Record 37;VAR SalesHeader : Record 36;VAR TempSalesPrice : Record 7002 TEMPORARY;ShowAll : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterServLinePriceExists(VAR ServiceLine : Record 5902);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterServLineLineDiscExists(VAR ServiceLine : Record 5902);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFindAnalysisReportPrice(ItemNo : Code[20];Date : Date);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFindItemJnlLinePrice(VAR ItemJournalLine : Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFindJobJnlLinePrice(VAR JobJournalLine : Record 210);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFindJobPlanningLinePrice(VAR JobPlanningLine : Record 1003);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFindSalesPrice(VAR ToSalesPrice : Record 7002;VAR FromSalesPrice : Record 7002;VAR QtyPerUOM : Decimal;VAR Qty : Decimal;VAR CustNo : Code[20];VAR ContNo : Code[20];VAR CustPriceGrCode : Code[10];VAR CampaignNo : Code[20];VAR ItemNo : Code[20];VAR VariantCode : Code[10];VAR UOM : Code[10];VAR CurrencyCode : Code[10];VAR StartingDate : Date;VAR ShowAll : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFindSalesLineDisc(VAR ToSalesLineDisc : Record 7004;CustNo : Code[20];ContNo : Code[20];CustDiscGrCode : Code[20];CampaignNo : Code[20];ItemNo : Code[20];ItemDiscGrCode : Code[20];VariantCode : Code[10];UOM : Code[10];CurrencyCode : Code[10];StartingDate : Date;ShowAll : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFindServLineDisc(VAR ServiceHeader : Record 5900;VAR ServiceLine : Record 5902);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFindStdItemJnlLinePrice(VAR StandardItemJournalLine : Record 753);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeGetSalesLineLineDisc(VAR SalesHeader : Record 36;VAR SalesLine : Record 37);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeJobJnlLineLineDiscExists(VAR JobJournalLine : Record 210);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeJobPlanningLineLineDiscExists(VAR JobPlanningLine : Record 1003);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesLineLineDiscExists(VAR SalesLine : Record 37;VAR SalesHeader : Record 36;VAR TempSalesLineDisc : Record 7004 TEMPORARY;StartingDate : Date;Qty : Decimal;QtyPerUOM : Decimal;ShowAll : Boolean;VAR IsHandled : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesLinePriceExists(VAR SalesLine : Record 37;VAR SalesHeader : Record 36;VAR TempSalesPrice : Record 7002 TEMPORARY;Currency : Record 4;CurrencyFactor : Decimal;StartingDate : Date;Qty : Decimal;QtyPerUOM : Decimal;ShowAll : Boolean;VAR InHandled : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeServLinePriceExists(VAR ServiceLine : Record 5902;VAR ServiceHeader : Record 5900;VAR TempSalesPrice : Record 7002 TEMPORARY;ShowAll : Boolean;VAR IsHandled : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeServLineLineDiscExists(VAR ServiceLine : Record 5902;VAR ServiceHeader : Record 5900);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetCustNoForSalesHeader(VAR SalesHeader : Record 36;VAR CustomerNo : Code[20]);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnFindSalesLineDiscOnAfterSetFilters(VAR SalesLineDiscount : Record 7004);
    BEGIN
    END;

    LOCAL PROCEDURE "---------------------------------------------------- QB"();
    BEGIN
    END;

    PROCEDURE QB_SetResPrice(Code2 : Code[20];WorkTypeCode : Code[10];CurrencyCode : Code[10];JobNo : Code[20]);
    BEGIN
      //QB  TO-DO Eliminar esta funci�n
      SetResPrice(Code2, WorkTypeCode, CurrencyCode);
      ResPrice."Job No." := JobNo;
    END;


    /*BEGIN
/*{
      JAV 04/07/22: - QB 1.10.58 Se eliminan variables no usadas. Se descomentan l�neas que no hacia falta comentar para asemejarse mas al est�ndar
                                 Se eliminan las llamadas a funciones ConvertPriceToVAT1CUSalesPriceCalcMgt, ConvertPriceToVAT2CUSalesPriceCalcMgt, ConvertPriceToVAT3CUSalesPriceCalcMgt no tienen sentido
      TO-DO Capturar el evento en lugar de llamar a la funci�n de QB
    }
END.*/
}









