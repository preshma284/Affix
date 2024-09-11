Codeunit 50211 "CaptionManagement"
{
  
  
    SingleInstance=true;
    trigger OnRun()
BEGIN
          END;
    VAR
      GLSetup : Record 98;
      GlobalSalesHeader : Record 36;
      GlobalPurchaseHeader : Record 38;
      GlobalField : Record 2000000041;
      GLSetupRead : Boolean;
      Text016 : TextConst ENU='Excl. VAT',ESP='excl. IVA';
      Text017 : TextConst ENU='Incl. VAT',ESP='incl. IVA';
      DefaultTxt : TextConst ENU='LCY',ESP='DL';
      DefaultLongTxt : TextConst ENU='Local Currency',ESP='Divisa local';
      CountyTxt : TextConst ENU='County',ESP='Provincia';
      VATECPercTxt : TextConst ENU='VAT+EC %',ESP='IVA+RE %';
      VATECBaseTxt : TextConst ENU='VAT+EC Base',ESP='Base IVA+RE';
      AmountInclVATECTxt : TextConst ENU='Amount Including VAT+EC',ESP='Importe con IVA+RE';

    //[External]
    PROCEDURE CaptionClassTranslate(Language : Integer;CaptionExpr : Text[1024]) : Text[1024];
    VAR
      CaptionArea : Text[80];
      CaptionRef : Text[1024];
      CommaPosition : Integer;
    BEGIN
      // LANGUAGE
      // <DataType>   := [Integer]
      // <DataValue>  := Automatically mentioned by the system

      // CAPTIONEXPR
      // <DataType>   := [String]
      // <Length>     <= 80
      // <DataValue>  := <CAPTIONAREA>,<CAPTIONREF>

      // CAPTIONAREA
      // <DataType>   := [SubString]
      // <Length>     <= 10
      // <DataValue>  := 1..9999999999
      // 1 for Dimension Area
      // 2 for VAT

      // CAPTIONREF
      // <DataType>   := [SubString]
      // <Length>     <= 10
      // <DataValue>  :=
      // IF (<CAPTIONAREA> = 1) <DIMCAPTIONTYPE>,<DIMCAPTIONREF>
      // IF (<CAPTIONAREA> = 2) <VATCAPTIONTYPE>

      CommaPosition := STRPOS(CaptionExpr,',');
      IF (CommaPosition > 0) AND (CommaPosition < 80) THEN BEGIN
        CaptionArea := COPYSTR(CaptionExpr,1,CommaPosition - 1);
        CaptionRef := COPYSTR(CaptionExpr,CommaPosition + 1);
        CASE CaptionArea OF
          '1':
            EXIT(DimCaptionClassTranslate(Language,COPYSTR(CaptionRef,1,80)));
          '2':
            EXIT(VATCaptionClassTranslate(COPYSTR(CaptionRef,1,80)));
          '3':
            EXIT(CaptionRef);
          '5':
            EXIT(CountyClassTranslate(COPYSTR(CaptionRef,1,80)));
          '101':
            EXIT(CurCaptionClassTranslate(CaptionRef));
        END;
      END;
      EXIT(CaptionExpr);
    END;

    LOCAL PROCEDURE DimCaptionClassTranslate(Language : Integer;CaptionExpr : Text[80]) : Text[80];
    VAR
      Dim : Record 348;
      DimCaptionType : Text[80];
      DimCaptionRef : Text[80];
      DimOptionalParam1 : Text[80];
      DimOptionalParam2 : Text[80];
      CommaPosition : Integer;
    BEGIN
      // DIMCAPTIONTYPE
      // <DataType>   := [SubString]
      // <Length>     <= 10
      // <DataValue>  := 1..6
      // 1 to retrieve Code Caption of Global Dimension
      // 2 to retrieve Code Caption of Shortcut Dimension
      // 3 to retrieve Filter Caption of Global Dimension
      // 4 to retrieve Filter Caption of Shortcut Dimension
      // 5 to retrieve Code Caption of any kind of Dimensions
      // 6 to retrieve Filter Caption of any kind of Dimensions

      // DIMCAPTIONREF
      // <DataType>   := [SubString]
      // <Length>     <= 10
      // <DataValue>  :=
      // IF (<DIMCAPTIONTYPE> = 1) 1..2,<DIMOPTIONALPARAM1>,<DIMOPTIONALPARAM2>
      // IF (<DIMCAPTIONTYPE> = 2) 1..8,<DIMOPTIONALPARAM1>,<DIMOPTIONALPARAM2>
      // IF (<DIMCAPTIONTYPE> = 3) 1..2,<DIMOPTIONALPARAM1>,<DIMOPTIONALPARAM2>
      // IF (<DIMCAPTIONTYPE> = 4) 1..8,<DIMOPTIONALPARAM1>,<DIMOPTIONALPARAM2>
      // IF (<DIMCAPTIONTYPE> = 5) [Table]Dimension.[Field]Code,<DIMOPTIONALPARAM1>,<DIMOPTIONALPARAM2>
      // IF (<DIMCAPTIONTYPE> = 6) [Table]Dimension.[Field]Code,<DIMOPTIONALPARAM1>,<DIMOPTIONALPARAM2>

      // DIMOPTIONALPARAM1
      // <DataType>   := [SubString]
      // <Length>     <= 30
      // <DataValue>  := [String]
      // a string added before the dimension name

      // DIMOPTIONALPARAM2
      // <DataType>   := [SubString]
      // <Length>     <= 30
      // <DataValue>  := [String]
      // a string added after the dimension name

      IF NOT GetGLSetup THEN
        EXIT('');

      CommaPosition := STRPOS(CaptionExpr,',');
      IF CommaPosition > 0 THEN BEGIN
        DimCaptionType := COPYSTR(CaptionExpr,1,CommaPosition - 1);
        DimCaptionRef := COPYSTR(CaptionExpr,CommaPosition + 1);
        CommaPosition := STRPOS(DimCaptionRef,',');
        IF CommaPosition > 0 THEN BEGIN
          DimOptionalParam1 := COPYSTR(DimCaptionRef,CommaPosition + 1);
          DimCaptionRef := COPYSTR(DimCaptionRef,1,CommaPosition - 1);
          CommaPosition := STRPOS(DimOptionalParam1,',');
          IF CommaPosition > 0 THEN BEGIN
            DimOptionalParam2 := COPYSTR(DimOptionalParam1,CommaPosition + 1);
            DimOptionalParam1 := COPYSTR(DimOptionalParam1,1,CommaPosition - 1);
          END ELSE
            DimOptionalParam2 := '';
        END ELSE BEGIN
          DimOptionalParam1 := '';
          DimOptionalParam2 := '';
        END;
        CASE DimCaptionType OF
          '1':  // Code Caption - Global Dimension using No. as Reference
            CASE DimCaptionRef OF
              '1':
                EXIT(
                  DimCodeCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Global Dimension 1 Code",
                    GLSetup.FIELDCAPTION("Global Dimension 1 Code")));
              '2':
                EXIT(
                  DimCodeCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Global Dimension 2 Code",
                    GLSetup.FIELDCAPTION("Global Dimension 2 Code")));
            END;
          '2':  // Code Caption - Shortcut Dimension using No. as Reference
            CASE DimCaptionRef OF
              '1':
                EXIT(
                  DimCodeCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 1 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 1 Code")));
              '2':
                EXIT(
                  DimCodeCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 2 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 2 Code")));
              '3':
                EXIT(
                  DimCodeCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 3 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 3 Code")));
              '4':
                EXIT(
                  DimCodeCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 4 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 4 Code")));
              '5':
                EXIT(
                  DimCodeCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 5 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 5 Code")));
              '6':
                EXIT(
                  DimCodeCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 6 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 6 Code")));
              '7':
                EXIT(
                  DimCodeCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 7 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 7 Code")));
              '8':
                EXIT(
                  DimCodeCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 8 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 8 Code")));
            END;
          '3':  // Filter Caption - Global Dimension using No. as Reference
            CASE DimCaptionRef OF
              '1':
                EXIT(
                  DimFilterCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Global Dimension 1 Code",
                    GLSetup.FIELDCAPTION("Global Dimension 1 Code")));
              '2':
                EXIT(
                  DimFilterCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Global Dimension 2 Code",
                    GLSetup.FIELDCAPTION("Global Dimension 2 Code")));
            END;
          '4':  // Filter Caption - Shortcut Dimension using No. as Reference
            CASE DimCaptionRef OF
              '1':
                EXIT(
                  DimFilterCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 1 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 1 Code")));
              '2':
                EXIT(
                  DimFilterCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 2 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 2 Code")));
              '3':
                EXIT(
                  DimFilterCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 3 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 3 Code")));
              '4':
                EXIT(
                  DimFilterCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 4 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 4 Code")));
              '5':
                EXIT(
                  DimFilterCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 5 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 5 Code")));
              '6':
                EXIT(
                  DimFilterCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 6 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 6 Code")));
              '7':
                EXIT(
                  DimFilterCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 7 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 7 Code")));
              '8':
                EXIT(
                  DimFilterCaption(
                    Language,DimOptionalParam1,DimOptionalParam2,
                    GLSetup."Shortcut Dimension 8 Code",
                    GLSetup.FIELDCAPTION("Shortcut Dimension 8 Code")));
            END;
          '5':  // Code Caption - using Dimension Code as Reference
            BEGIN
              IF Dim.GET(DimCaptionRef) THEN
                EXIT(DimOptionalParam1 + Dim.GetMLCodeCaption(Language) + DimOptionalParam2);
              EXIT(DimOptionalParam1);
            END;
          '6':  // Filter Caption - using Dimension Code as Reference
            BEGIN
              IF Dim.GET(DimCaptionRef) THEN
                EXIT(DimOptionalParam1 + Dim.GetMLFilterCaption(Language) + DimOptionalParam2);
              EXIT(DimOptionalParam1);
            END;
        END;
      END;
      EXIT('');
    END;

    LOCAL PROCEDURE DimCodeCaption(Language : Integer;DimOptionalParam1 : Text[80];DimOptionalParam2 : Text[80];DimCode : Code[20];DimFieldCaption : Text[1024]) : Text[80];
    VAR
      Dim : Record 348;
    BEGIN
      IF Dim.GET(DimCode) THEN
        EXIT(DimOptionalParam1 + Dim.GetMLCodeCaption(Language) + DimOptionalParam2);
      EXIT(
        DimOptionalParam1 +
        DimFieldCaption +
        DimOptionalParam2);
    END;

    LOCAL PROCEDURE DimFilterCaption(Language : Integer;DimOptionalParam1 : Text[80];DimOptionalParam2 : Text[80];DimCode : Code[20];DimFieldCaption : Text[1024]) : Text[80];
    VAR
      Dim : Record 348;
    BEGIN
      IF Dim.GET(DimCode) THEN
        EXIT(DimOptionalParam1 + Dim.GetMLFilterCaption(Language) + DimOptionalParam2);
      EXIT(
        DimOptionalParam1 +
        DimFieldCaption +
        DimOptionalParam2);
    END;

    LOCAL PROCEDURE VATCaptionClassTranslate(CaptionExpr : Text[80]) : Text[80];
    VAR
      VATCaptionType : Text[80];
      VATCaptionRef : Text[80];
      CommaPosition : Integer;
    BEGIN
      // VATCAPTIONTYPE
      // <DataType>   := [SubString]
      // <Length>     =  1
      // <DataValue>  :=
      // '0' -> <field caption + 'Excl. VAT'>
      // '1' -> <field caption + 'Incl. VAT'>
      // '2' -> <'VAT+EC %'>
      // '3' -> <'VAT+EC Base'>
      // '4' -> <'Amount Including VAT+EC'>

      CommaPosition := STRPOS(CaptionExpr,',');
      IF CommaPosition > 0 THEN BEGIN
        VATCaptionType := COPYSTR(CaptionExpr,1,CommaPosition - 1);
        VATCaptionRef := COPYSTR(CaptionExpr,CommaPosition + 1);
        CASE VATCaptionType OF
          '0':
            EXIT(COPYSTR(STRSUBSTNO('%1 %2',VATCaptionRef,Text016),1,80));
          '1':
            EXIT(COPYSTR(STRSUBSTNO('%1 %2',VATCaptionRef,Text017),1,80));
          '2':
            EXIT(VATECPercTxt);
          '3':
            EXIT(VATECBaseTxt);
          '4':
            EXIT(AmountInclVATECTxt);
        END;
      END;
      EXIT('');
    END;

    LOCAL PROCEDURE CurCaptionClassTranslate(CaptionExpr : Text) : Text;
    VAR
      Currency : Record 4;
      GLSetupRead : Boolean;
      CurrencyResult : Text[30];
      CommaPosition : Integer;
      CurCaptionType : Text[30];
      CurCaptionRef : Text;
    BEGIN
      // CURCAPTIONTYPE
      // <DataType>   := [SubString]
      // <Length>     =  1
      // <DataValue>  :=
      // '0' -> Currency Result := Local Currency Code
      // '1' -> Currency Result := Local Currency Description
      // '2' -> Currency Result := Additional Reporting Currency Code
      // '3' -> Currency Result := Additional Reporting Currency Description

      // CURCAPTIONREF
      // <DataType>   := [SubString]
      // <Length>     <= 70
      // <DataValue>  := [String]
      // This string is the actual string making up the Caption.
      // It will contain a '%1', and the Currency Result will substitute for it.

      CommaPosition := STRPOS(CaptionExpr,',');
      IF CommaPosition > 0 THEN BEGIN
        CurCaptionType := COPYSTR(CaptionExpr,1,CommaPosition - 1);
        CurCaptionRef := COPYSTR(CaptionExpr,CommaPosition + 1);
        IF NOT GLSetupRead THEN BEGIN
          IF NOT GLSetup.GET THEN
            EXIT(CurCaptionRef);
          GLSetupRead := TRUE;
        END;
        CASE CurCaptionType OF
          '0','1':
            BEGIN
              IF GLSetup."LCY Code" = '' THEN
                IF CurCaptionType = '0' THEN
                  CurrencyResult := DefaultTxt
                ELSE
                  CurrencyResult := DefaultLongTxt
              ELSE
                IF NOT Currency.GET(GLSetup."LCY Code") THEN
                  CurrencyResult := GLSetup."LCY Code"
                ELSE
                  IF CurCaptionType = '0' THEN
                    CurrencyResult := Currency.Code
                  ELSE
                    CurrencyResult := Currency.Description;
              EXIT(COPYSTR(STRSUBSTNO(CurCaptionRef,CurrencyResult),1,MAXSTRLEN(CurCaptionRef)));
            END;
          '2','3':
            BEGIN
              IF GLSetup."Additional Reporting Currency" = '' THEN
                EXIT(CurCaptionRef);
              IF NOT Currency.GET(GLSetup."Additional Reporting Currency") THEN
                CurrencyResult := GLSetup."Additional Reporting Currency"
              ELSE
                IF CurCaptionType = '2' THEN
                  CurrencyResult := Currency.Code
                ELSE
                  CurrencyResult := Currency.Description;
              EXIT(COPYSTR(STRSUBSTNO(CurCaptionRef,CurrencyResult),1,MAXSTRLEN(CurCaptionRef)));
            END;
          ELSE
            EXIT(CurCaptionRef);
        END;
      END;
      EXIT(CaptionExpr);
    END;

    LOCAL PROCEDURE CountyClassTranslate(CaptionExpr : Text[80]) : Text;
    VAR
      CountryRegion : Record 9;
      CommaPosition : Integer;
      CountyCaptionType : Text[30];
      CountyCaptionRef : Text;
    BEGIN
      CommaPosition := STRPOS(CaptionExpr,',');
      IF CommaPosition > 0 THEN BEGIN
        CountyCaptionType := COPYSTR(CaptionExpr,1,CommaPosition - 1);
        CountyCaptionRef := COPYSTR(CaptionExpr,CommaPosition + 1);
        CASE CountyCaptionType OF
          '1':
            BEGIN
              IF CountryRegion.GET(CountyCaptionRef) AND (CountryRegion."County Name" <> '') THEN
                EXIT(CountryRegion."County Name");
              EXIT(CountyTxt);
            END;
          ELSE
            EXIT(CountyTxt);
        END;
      END;
      EXIT(CountyTxt);
    END;

    LOCAL PROCEDURE GetGLSetup() : Boolean;
    BEGIN
      IF NOT GLSetupRead THEN
        GLSetupRead := GLSetup.GET;
      EXIT(GLSetupRead);
    END;

    //[External]
    PROCEDURE GetRecordFiltersWithCaptions(RecVariant : Variant) Filters : Text;
    VAR
      RecRef : RecordRef;
      FieldRef : FieldRef;
      FieldFilter : Text;
      Name : Text;
      Cap : Text;
      Pos : Integer;
      i : Integer;
    BEGIN
      RecRef.GETTABLE(RecVariant);
      Filters := RecRef.GETFILTERS;
      IF Filters = '' THEN
        EXIT;

      FOR i := 1 TO RecRef.FIELDCOUNT DO BEGIN
        FieldRef := RecRef.FIELDINDEX(i);
        FieldFilter := FieldRef.GETFILTER;
        IF FieldFilter <> '' THEN BEGIN
          Name := STRSUBSTNO('%1: ',FieldRef.NAME);
          Cap := STRSUBSTNO('%1: ',FieldRef.CAPTION);
          Pos := STRPOS(Filters,Name);
          IF Pos <> 0 THEN
            Filters := INSSTR(DELSTR(Filters,Pos,STRLEN(Name)),Cap,Pos);
        END;
      END;
    END;

    //[External]
    PROCEDURE GetTranslatedFieldCaption(LanguageCode : Code[10];TableID : Integer;FieldId : Integer) TranslatedText : Text;
    VAR
      Language : Record 8;
      Field : Record 2000000041;
      CurrentLanguageCode : Integer;
    BEGIN
      CurrentLanguageCode := GLOBALLANGUAGE;
      IF (LanguageCode <> '') //AND (Language.GetLanguageID(LanguageCode) <> CurrentLanguageCode)
       THEN BEGIN
        // GLOBALLANGUAGE(Language.GetLanguageID(LanguageCode));
        Field.GET(TableID,FieldId);
        TranslatedText := Field."Field Caption";
        GLOBALLANGUAGE(CurrentLanguageCode);
      END ELSE BEGIN
        Field.GET(TableID,FieldId);
        TranslatedText := Field."Field Caption";
      END;
    END;

    LOCAL PROCEDURE GetFieldCaption(TableNumber : Integer;FieldNumber : Integer) : Text[100];
    BEGIN
      IF (GlobalField.TableNo <> TableNumber) OR (GlobalField."No." <> FieldNumber) THEN
        GlobalField.GET(TableNumber,FieldNumber);
      EXIT(GlobalField."Field Caption");
    END;

    //[External]
    PROCEDURE GetSalesLineCaptionClass(VAR SalesLine : Record 37;FieldNumber : Integer) : Text[80];
    BEGIN
      IF (GlobalSalesHeader."Document Type" <> SalesLine."Document Type") OR (GlobalSalesHeader."No." <> SalesLine."Document No.") THEN
        IF NOT GlobalSalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.") THEN
          CLEAR(GlobalSalesHeader);
      CASE FieldNumber OF
        SalesLine.FIELDNO("No."):
          EXIT(STRSUBSTNO('3,%1',GetFieldCaption(DATABASE::"Sales Line",FieldNumber)));
        ELSE BEGIN
          IF GlobalSalesHeader."Prices Including VAT" THEN
            EXIT('2,1,' + GetFieldCaption(DATABASE::"Sales Line",FieldNumber));
          EXIT('2,0,' + GetFieldCaption(DATABASE::"Sales Line",FieldNumber));
        END;
      END;
    END;

    //[External]
    PROCEDURE GetPurchaseLineCaptionClass(VAR PurchaseLine : Record 39;FieldNumber : Integer) : Text[80];
    BEGIN
      IF (GlobalPurchaseHeader."Document Type" <> PurchaseLine."Document Type") OR
         (GlobalPurchaseHeader."No." <> PurchaseLine."Document No.")
      THEN
        IF NOT GlobalPurchaseHeader.GET(PurchaseLine."Document Type",PurchaseLine."Document No.") THEN
          CLEAR(GlobalPurchaseHeader);
      CASE FieldNumber OF
        PurchaseLine.FIELDNO("No."):
          EXIT(STRSUBSTNO('3,%1',GetFieldCaption(DATABASE::"Purchase Line",FieldNumber)));
        ELSE BEGIN
          IF GlobalPurchaseHeader."Prices Including VAT" THEN
            EXIT('2,1,' + GetFieldCaption(DATABASE::"Purchase Line",FieldNumber));
          EXIT('2,0,' + GetFieldCaption(DATABASE::"Purchase Line",FieldNumber));
        END;
      END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 2000000004, CaptionClassTranslate, '', true, true)]
    LOCAL PROCEDURE DoCaptionClassTranslate(Language : Integer;CaptionExpr : Text[1024];VAR Translation : Text[1024]);
    VAR
      CaptionManagement : Codeunit 42;
      CaptionManagement1 : Codeunit 50211;
    BEGIN
      Translation := CaptionManagement1.CaptionClassTranslate(Language,CaptionExpr);
      OnAfterCaptionClassTranslate(Language,CaptionExpr,Translation);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterChangePricesIncludingVAT, '', true, true)]
    LOCAL PROCEDURE SalesHeaderChangedPricesIncludingVAT(VAR SalesHeader : Record 36);
    BEGIN
      GlobalSalesHeader := SalesHeader;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterSetFieldsBilltoCustomer, '', true, true)]
    LOCAL PROCEDURE UpdateSalesLineFieldsCaptionOnAfterSetFieldsBilltoCustomer(VAR SalesHeader : Record 36;Customer : Record 18);
    BEGIN
      GlobalSalesHeader := SalesHeader;
    END;

    // [EventSubscriber(ObjectType::Table, 36, OnValidateBilltoCustomerTemplateCodeBeforeRecreateSalesLines, '', true, true)]
    LOCAL PROCEDURE UpdateSalesLineFieldsCaptionOnValidateBilltoCustTemplCodeBeforeRecreateSalesLines(VAR SalesHeader : Record 36;FieldNo : Integer);
    BEGIN
      GlobalSalesHeader := SalesHeader;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterChangePricesIncludingVAT, '', true, true)]
    LOCAL PROCEDURE PurchaseHeaderChangedPricesIncludingVAT(VAR PurchaseHeader : Record 38);
    BEGIN
      GlobalPurchaseHeader := PurchaseHeader;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnValidatePurchaseHeaderPayToVendorNo, '', true, true)]
    LOCAL PROCEDURE UpdatePurchLineFieldsCaptionOnValidatePurchaseHeaderPayToVendorNo(VAR Sender : Record 38;Vendor : Record 23);
    BEGIN
      GlobalPurchaseHeader := Sender;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCaptionClassTranslate(Language : Integer;CaptionExpression : Text[1024];VAR Caption : Text[1024]);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}





