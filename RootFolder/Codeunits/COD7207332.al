Codeunit 7207332 "Job Currency Exchange Function"
{


    trigger OnRun()
    BEGIN
    END;

    PROCEDURE SetPageCurrencies(VAR UseCurrencies: Boolean; Type: Option "Job","Budget","RE");
    VAR
        FunctionQB: Codeunit 7207272;
        DataPieceworkForProduction: Record 7207386;
        JobLedgerEntry: Record 169;
    BEGIN
        // Funci�n que retorna si se pueden usar divisas en los estudios y proyectos al abrir la p�gina
        //   UseCurrencies : (VAR) Si se usan divisas en los proyectos

        UseCurrencies := (FunctionQB.UseCurrenciesInJobs(Type));
    END;

    PROCEDURE SetRecordCurrencies(Rec: Record 167; VAR edCurrencies: Boolean; VAR canEditJobsCurrencies: Boolean; VAR canChangeFactboxCurrency: Boolean; VAR edCurrencyCode: Boolean; VAR edInvoiceCurrencyCode: Boolean);
    VAR
        DataPieceworkForProduction: Record 7207386;
        JobLedgerEntry: Record 169;
        UseCurrencies: Boolean;
    BEGIN
        // Funci�n que retorna variables sobre el uso de divisas en los proyectos tras leer el registro
        //   Rec                      : Ficha del Proyecto
        //   edCurrencies             : (VAR) Si el campo de Divisa del proyecto es editable
        //   canEditJobsCurrencies    : (VAR) Si puede ver las divisas del proyecto
        //   canChangeFactboxCurrency : (VAR) Si puede cambiar las divisas de los factbox
        //   edCurrencyCode           : (VAR) Si puede editar el campo de la divisa del proyecto
        //   edInvoiceCurrencyCode    : (VAR) Si puede editar el campo de la divisa de facturaci�n del proyecto

        CASE Rec."Card Type" OF
            Rec."Card Type"::Estudio, Rec."Card Type"::"Proyecto operativo":
                SetPageCurrencies(UseCurrencies, 0);
            Rec."Card Type"::Presupuesto:
                SetPageCurrencies(UseCurrencies, 1);
            Rec."Card Type"::Promocion:
                SetPageCurrencies(UseCurrencies, 2);
        END;

        IF (Rec."Card Type" = Rec."Card Type"::Estudio) AND (Rec."Original Quote Code" <> '') THEN
            edCurrencies := FALSE
        ELSE BEGIN
            edCurrencies := UseCurrencies;

            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.SETRANGE("Job No.", Rec."No.");
            edCurrencies := DataPieceworkForProduction.ISEMPTY;

            JobLedgerEntry.RESET;
            JobLedgerEntry.SETRANGE("Job No.", Rec."No.");
            edCurrencies := JobLedgerEntry.ISEMPTY;
        END;

        canEditJobsCurrencies := (UseCurrencies) AND (NOT Rec."General Currencies");
        canChangeFactboxCurrency := (UseCurrencies) AND ((Rec."Currency Code" <> '') OR (Rec."Aditional Currency" <> ''));
        edCurrencyCode := (edCurrencies) AND (Rec."Invoice Currency Code" = '');
        edInvoiceCurrencyCode := (edCurrencies) AND (Rec."Invoice Currency Code" <> '');
    END;

    PROCEDURE CalculateCurrencyValue(JobNo: Code[20]; Amount: Decimal; SourceCurrencyCode: Code[10]; TargetCurrencyCode: Code[10]; Date: Date; CostSalesType: Option "Cost","Sale","General"; VAR ExchangedAmount: Decimal; VAR ExchangeType: Decimal);
    VAR
        GeneralLedgerSetup: Record 98;
        Job: Record 167;
        SourceExchangeType: Decimal;
        TargetExchangeType: Decimal;
    BEGIN
        // Funci�n que retorna un importe en un proyecto convertido a una divisa y su factor de conversi�n
        //   JobNo              : Proyecto
        //   Amount             : Importe a convertir
        //   SourceCurrencyCode : Divisa de origen, si es '' ser� la divisa local
        //   TargetCurrencyCode : Divisa de destino, si es '' ser� la divisa local
        //   Date               : Fecha a considerar para el cambio, si es 0D usa la divisa a futuro
        //   CostSalesType      : Tipo de cambio a usar, 0 = Coste, 1 = Venta, 2 = Usar directamente el cambio general y no el del proyecto
        //   ExchangedAmount    : (VAR) Importe convertido
        //   ExchangeType       : (VAR) Tipo de cambio usado en la conversion, si es cero no se ha podido realizar la conversi�n por no encontrar cambios adecuados

        //Si origen y destino es la misma divisa, no hay cambios //Q7634 se a�ade si el importe es cero
        GeneralLedgerSetup.GET;
        IF (SourceCurrencyCode = GeneralLedgerSetup."LCY Code") THEN
            SourceCurrencyCode := '';
        IF (TargetCurrencyCode = GeneralLedgerSetup."LCY Code") THEN
            TargetCurrencyCode := '';

        IF (Amount = 0) OR (SourceCurrencyCode = TargetCurrencyCode) THEN BEGIN
            ExchangeType := 1;
            ExchangedAmount := Amount;
        END ELSE BEGIN
            ExchangeType := 0;
            ExchangedAmount := 0;

            Job.GET(JobNo);
            //Si est� marcado usar divisas generales, forzarlo
            IF (Job."General Currencies") THEN
                CostSalesType := CostSalesType::General;
            //Si es una versi�n se usa la divisa del estudio
            IF (Job."Card Type" = Job."Card Type"::Estudio) AND (Job."Original Quote Code" <> '') THEN
                JobNo := Job."Original Quote Code";


            SourceExchangeType := GetCurrencyExchange(JobNo, SourceCurrencyCode, Date, CostSalesType);
            TargetExchangeType := GetCurrencyExchange(JobNo, TargetCurrencyCode, Date, CostSalesType);

            //Q7634, Q7539, Q7374
            IF (SourceCurrencyCode = '') THEN
                ExchangeType := TargetExchangeType
            ELSE
                ExchangeType := TargetExchangeType / SourceExchangeType;

            ExchangedAmount := ROUND(Amount * ExchangeType, GeneralLedgerSetup."Amount Rounding Precision", '=');
        END;
    END;

    PROCEDURE GetCurrencyExchange(JobNo: Code[20]; VAR CurrencyCode: Code[10]; Date: Date; Type: Option "Cost","Sale","General"): Decimal;
    VAR
        GeneralLedgerSetup: Record 98;
        QuoBuildingSetup: Record 7207278;
        Job: Record 167;
        JobCurrencyExchange: Record 7206917;
        CurrencyExchangeRate: Record 330;
        ExchangeType: Decimal;
    BEGIN
        // Funci�n que retorna el factor de conversi�n a usar para una divisa en un proyecto o la general si no hay divisas del proyecto
        //   JobNo              : Proyecto
        //   CurrencyCode       : Divisa de origen, si es '' ser� la divisa local
        //   Date               : Fecha a considerar para el cambio, si es 0D usa la divisa a futuro
        //   CostSalesType      : Tipo de cambio a usar, 0 = Coste, 1 = Venta, 2 = Usar directamente el cambio general y no el del proyecto
        //   RETORNA            : Tipo de cambio de la divisa

        GeneralLedgerSetup.GET();
        QuoBuildingSetup.GET();
        IF Job.GET(JobNo) THEN;

        //Q7374 -
        IF (CurrencyCode = '') OR (CurrencyCode = GeneralLedgerSetup."LCY Code") THEN BEGIN
            CurrencyCode := '';
            ExchangeType := 1
        END ELSE BEGIN
            ExchangeType := 0;

            //Lo busco en el proyecto, considera valor actual o a futuro dependiendo de la fecha
            IF (Type <> Type::General) AND (NOT Job."General Currencies") AND (QuoBuildingSetup."Use Currency in Jobs") THEN
                ExchangeType := GetJobCurrencyExchange(JobNo, CurrencyCode, Date, Type);

            //Si no tengo un cambio de la divisa todav�a lo busco en los cambios generales de NAV
            IF ExchangeType = 0 THEN BEGIN
                IF (Date = 0D) THEN
                    Date := WORKDATE;
                CurrencyExchangeRate.RESET;
                CurrencyExchangeRate.SETRANGE("Currency Code", CurrencyCode);
                CurrencyExchangeRate.SETFILTER("Starting Date", '<=%1', Date);
                IF CurrencyExchangeRate.FINDLAST THEN
                    //JMMA, Q7634, Q7473
                    //JAV 27/11/20: - QB 1.07.08 El valor del cambio es la divisi�n entre cuantas unidades en divisa/cuantas unidades en local
                    //ExchangeType := CurrencyExchangeRate."Adjustment Exch. Rate Amount";
                    IF (CurrencyExchangeRate."Relational Adjmt Exch Rate Amt" <> 0) THEN
                        ExchangeType := CurrencyExchangeRate."Adjustment Exch. Rate Amount" / CurrencyExchangeRate."Relational Adjmt Exch Rate Amt"
                    ELSE
                        ExchangeType := 1;
            END;

            //Si no tengo un cambio todav�a, como �ltimo recurso busco el �ltimo cambio de la divisa
            IF ExchangeType = 0 THEN
                ExchangeType := CurrencyExchangeRate.GetCurrentCurrencyFactor(CurrencyCode);
        END;

        EXIT(ExchangeType);
    END;

    PROCEDURE GetJobCurrencyExchange(JobNo: Code[20]; CurrencyCode: Code[10]; Date: Date; Type: Option "Cost","Sale","General"): Decimal;
    VAR
        JobCurrencyExchange: Record 7206917;
        Job: Record 167;
    BEGIN
        // Funci�n que retorna el factor de conversi�n a usar para una divisa especificada entre las del proyecto, considera valor actual o a futuro dependiendo de la fecha
        //   JobNo              : Proyecto
        //   CurrencyCode       : Divisa de origen, si es '' ser� la divisa local
        //   Date               : Fecha a considerar para el cambio, si es 0D usa la divisa a futuro
        //   CostSalesType      : Tipo de cambio a usar, 0 = Coste, 1 = Venta, 2 = Usar directamente el cambio general y no el del proyecto
        //   RETORNA            : Tipo de cambio de la divisa en el proyecto

        IF (Type <> Type::General) THEN BEGIN
            JobCurrencyExchange.RESET;
            JobCurrencyExchange.SETRANGE("Job No.", JobNo);
            JobCurrencyExchange.SETRANGE("Currency Code", CurrencyCode);
            IF (Date = 0D) THEN
                JobCurrencyExchange.SETRANGE("Future Currency", TRUE)
            ELSE BEGIN
                JobCurrencyExchange.SETRANGE("Future Currency", FALSE);
                JobCurrencyExchange.SETFILTER(Date, '<=%1', Date);
            END;
            IF (JobCurrencyExchange.FINDLAST) THEN  //Si hay un registro, retornamos el valor
                IF (Type = Type::Cost) THEN //coste
                    EXIT(JobCurrencyExchange."Cost Amount")
                ELSE                       //venta
                    EXIT(JobCurrencyExchange."Sales Amount");

            //Esto de momento no veo que se deba usar as�, lo dejor por si mas adelante se decide usarlo
            //IF (Date <> 0D) THEN  //Si no hay un registro y no es a futuro, lo intento con la fecha a futuro (uso recursivo de la funci�n)
            //  EXIT(GetJobCurrencyExchange(JobNo, CurrencyCode, 0D, Type));
        END;

        //Si no hay nada hasta ahora, retorna cero
        EXIT(0);
    END;

    LOCAL PROCEDURE "-------------------------------------------------- Diferencias cambio al Proyecto"();
    BEGIN
    END;

    PROCEDURE AddJobLedgerEntryByCustomer(DetailedCustLedgEntry: Record 379);
    VAR
        Job: Record 167;
        Txt01: TextConst ESP = 'No ha definido la undiad de obra para ajustes de cambios de divisas en el proyecto %1';
        DataPieceworkForProduction: Record 7207386;
        Currency: Record 4;
        CustLedgerEntry: Record 21;
        Account: Code[20];
    BEGIN
        //Crea movimientos de proyecto para imputar los ajustes de cambio de divisas desde el WIP del cliente

        //Leo divisa y cuenta
        IF (DetailedCustLedgEntry."Currency Code" = '') THEN
            EXIT;
        Currency.GET(DetailedCustLedgEntry."Currency Code");
        CASE DetailedCustLedgEntry."Entry Type" OF
            DetailedCustLedgEntry."Entry Type"::"Unrealized Gain":
                Account := Currency."Unrealized Gains Acc.";
            DetailedCustLedgEntry."Entry Type"::"Unrealized Loss":
                Account := Currency."Unrealized Losses Acc.";
            DetailedCustLedgEntry."Entry Type"::"Realized Gain":
                Account := Currency."Realized Gains Acc.";
            DetailedCustLedgEntry."Entry Type"::"Realized Loss":
                Account := Currency."Realized Losses Acc.";
        END;

        //Leo el proyecto y la U.O. a la que imputar
        CustLedgerEntry.GET(DetailedCustLedgEntry."Cust. Ledger Entry No.");
        IF (CustLedgerEntry."QB Job No." = '') THEN
            EXIT;
        Job.GET(CustLedgerEntry."QB Job No.");
        IF (Job."Adjust Exchange Rate Piecework" = '') THEN
            ERROR(Txt01, Job."No.");

        //Si no existe la U.O. la creo como unidad de indirectos
        IF NOT DataPieceworkForProduction.GET(Job."No.", Job."Adjust Exchange Rate Piecework") THEN BEGIN
            DataPieceworkForProduction.INIT;
            DataPieceworkForProduction."Job No." := Job."No.";
            DataPieceworkForProduction."Piecework Code" := Job."Adjust Exchange Rate Piecework";
            DataPieceworkForProduction."Account Type" := DataPieceworkForProduction."Account Type"::Unit;
            DataPieceworkForProduction.Description := 'Ajustes por diferencias de cambio en el proyecto';
            DataPieceworkForProduction.Type := DataPieceworkForProduction.Type::"Cost Unit";
            DataPieceworkForProduction."Production Unit" := TRUE;
            DataPieceworkForProduction.INSERT(TRUE);
        END;

        CreateCustomerJobJournalLine(DetailedCustLedgEntry, Account, Job."Adjust Exchange Rate Piecework");
    END;

    LOCAL PROCEDURE CreateCustomerJobJournalLine(DetailedCustLedgEntry: Record 379; AccountNo: Code[20]; Piecework: Code[20]);
    VAR
        JobJournalLine: Record 210;
        Job: Record 167;
        CustLedgerEntry: Record 21;
        SourceCodeSetup: Record 242;
        JobJnlPostLine: Codeunit 1012;
        FunctionQB: Codeunit 7207272;
        Customer: Record 18;
    BEGIN
        CustLedgerEntry.GET(DetailedCustLedgEntry."Cust. Ledger Entry No.");
        Job.GET(DetailedCustLedgEntry."QB Job No.");
        //C�digo de origen del movimiento
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD(SourceCodeSetup."Exchange Rate Adjmt.");

        JobJournalLine.INIT;
        JobJournalLine.VALIDATE("Job No.", CustLedgerEntry."QB Job No.");                  //Proyecto y u.o.
        JobJournalLine."Piecework Code" := Piecework;
        JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Sale;               //Tipo Venta para WIP
        JobJournalLine.VALIDATE("Posting Date", DetailedCustLedgEntry."Posting Date");
        JobJournalLine.VALIDATE("Document No.", DetailedCustLedgEntry."Document No.");
        JobJournalLine.VALIDATE(Type, JobJournalLine.Type::"G/L Account");
        JobJournalLine.VALIDATE("No.", AccountNo);
        JobJournalLine.Description := 'Ajuste por ' + FORMAT(DetailedCustLedgEntry."Entry Type");

        //Precios e importes de venta van siempre sobre cantidad uno
        JobJournalLine.VALIDATE("Transaction Currency", DetailedCustLedgEntry."Currency Code");
        JobJournalLine.VALIDATE(Quantity, -1);
        JobJournalLine."Unit Price" := DetailedCustLedgEntry.Amount;                                           //Realmente ser� cero siempre, pero lo pongo de todas formas
        JobJournalLine."Unit Price (LCY)" := DetailedCustLedgEntry."Amount (LCY)";
        JobJournalLine."Total Price" := JobJournalLine.Quantity * JobJournalLine."Unit Price";
        JobJournalLine."Total Price (LCY)" := JobJournalLine.Quantity * JobJournalLine."Unit Price (LCY)";
        JobJournalLine."Line Amount" := JobJournalLine.Quantity * JobJournalLine."Unit Price";
        JobJournalLine."Line Amount (LCY)" := JobJournalLine.Quantity * JobJournalLine."Unit Price (LCY)";

        JobJournalLine."Line Type" := JobJournalLine."Line Type"::"Both Budget and Billable";           //QMD
        JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Shipping;       //Movimiento es de tipo albar�n
        JobJournalLine.Provision := TRUE;                                                               //Es un ajuste sobre una provisi�n
        JobJournalLine."Source Type" := JobJournalLine."Source Type"::Customer;
        JobJournalLine."Source No." := DetailedCustLedgEntry."Customer No.";

        //JAV 04/07/22: - QB 1.10.58 A�adir en el registro del movimiento del proyecto el nombre del cliente
        IF Customer.GET(DetailedCustLedgEntry."Customer No.") THEN
            JobJournalLine."Source Name" := Customer.Name;

        JobJournalLine."Gen. Bus. Posting Group" := DetailedCustLedgEntry."Gen. Bus. Posting Group";
        JobJournalLine."Gen. Prod. Posting Group" := DetailedCustLedgEntry."Gen. Prod. Posting Group";
        JobJournalLine."Post Job Entry Only" := TRUE;
        JobJournalLine."Job Posting Only" := TRUE;
        JobJournalLine."Activation Entry" := TRUE;
        JobJournalLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
        JobJournalLine."Currency Adjust" := TRUE;                                               //JAV 03/12/20: - QB 1.07.10 Marco que es por un ajuste de divisas
        JobJournalLine."Related G/L Entry" := DetailedCustLedgEntry."Cust. Ledger Entry No.";   //JAV 03/12/20: - QB 1.07.10 Le indico sobre que l�nea debe hacer el ajuste

        //Las dimensiones van sobre el movimiento original
        JobJournalLine."Shortcut Dimension 1 Code" := CustLedgerEntry."Global Dimension 1 Code";
        JobJournalLine."Shortcut Dimension 2 Code" := CustLedgerEntry."Global Dimension 2 Code";
        JobJournalLine.VALIDATE("Dimension Set ID", CustLedgerEntry."Dimension Set ID");
        //Ajutar el C.A. del movimiento
        IF (FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1) THEN
            JobJournalLine.VALIDATE("Shortcut Dimension 1 Code", Job."Adjust Exchange Rate A.C.")
        ELSE IF (FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2) THEN
            JobJournalLine.VALIDATE("Shortcut Dimension 2 Code", Job."Adjust Exchange Rate A.C.");

        JobJnlPostLine.RunWithCheck(JobJournalLine);
    END;

    PROCEDURE AddJobLedgerEntryByVendor(DetailedVendorLedgEntry: Record 380);
    VAR
        Job: Record 167;
        Txt01: TextConst ESP = 'No ha definido la undiad de obra para ajustes de cambios de divisas en el proyecto %1';
        DataPieceworkForProduction: Record 7207386;
        Currency: Record 4;
        VendorLedgerEntry: Record 25;
        Account: Code[20];
    BEGIN
        //Crea movimientos de proyecto para imputar los ajustes de cambio de divisas desde el albar�n del proveedor

        //Leo divisa y cuenta
        IF (DetailedVendorLedgEntry."Currency Code" = '') THEN
            EXIT;
        Currency.GET(DetailedVendorLedgEntry."Currency Code");
        CASE DetailedVendorLedgEntry."Entry Type" OF
            DetailedVendorLedgEntry."Entry Type"::"Unrealized Gain":
                Account := Currency."Unrealized Gains Acc.";
            DetailedVendorLedgEntry."Entry Type"::"Unrealized Loss":
                Account := Currency."Unrealized Losses Acc.";
            DetailedVendorLedgEntry."Entry Type"::"Realized Gain":
                Account := Currency."Realized Gains Acc.";
            DetailedVendorLedgEntry."Entry Type"::"Realized Loss":
                Account := Currency."Realized Losses Acc.";
        END;

        //Leo el proyecto y la U.O. a la que imputar
        VendorLedgerEntry.GET(DetailedVendorLedgEntry."Vendor Ledger Entry No.");
        IF (VendorLedgerEntry."QB Job No." = '') THEN
            EXIT;
        Job.GET(VendorLedgerEntry."QB Job No.");
        IF (Job."Adjust Exchange Rate Piecework" = '') THEN
            ERROR(Txt01, Job."No.");

        //Si no existe la U.O. la creo como unidad de indirectos
        IF NOT DataPieceworkForProduction.GET(Job."No.", Job."Adjust Exchange Rate Piecework") THEN BEGIN
            DataPieceworkForProduction.INIT;
            DataPieceworkForProduction."Job No." := Job."No.";
            DataPieceworkForProduction."Piecework Code" := Job."Adjust Exchange Rate Piecework";
            DataPieceworkForProduction."Account Type" := DataPieceworkForProduction."Account Type"::Unit;
            DataPieceworkForProduction.Description := 'Ajustes por diferencias de cambio en el proyecto';
            DataPieceworkForProduction.Type := DataPieceworkForProduction.Type::"Cost Unit";
            DataPieceworkForProduction."Production Unit" := TRUE;
            DataPieceworkForProduction.INSERT(TRUE);
        END;

        CreateVendorJobJournalLine(DetailedVendorLedgEntry, Account, Job."Adjust Exchange Rate Piecework");
    END;

    LOCAL PROCEDURE CreateVendorJobJournalLine(DetailedVendorLedgEntry: Record 380; AccountNo: Code[20]; Piecework: Code[20]);
    VAR
        JobJournalLine: Record 210;
        Job: Record 167;
        VendorLedgerEntry: Record 25;
        SourceCodeSetup: Record 242;
        JobJnlPostLine: Codeunit 1012;
        FunctionQB: Codeunit 7207272;
        Vendor: Record 23;
    BEGIN
        VendorLedgerEntry.GET(DetailedVendorLedgEntry."Vendor Ledger Entry No.");
        Job.GET(DetailedVendorLedgEntry."QB Job No.");

        JobJournalLine.INIT;

        //Proyecto y u.o.
        JobJournalLine.VALIDATE("Job No.", VendorLedgerEntry."QB Job No.");
        JobJournalLine."Piecework Code" := Piecework;

        JobJournalLine.VALIDATE("Posting Date", DetailedVendorLedgEntry."Posting Date");
        JobJournalLine.VALIDATE("Document No.", DetailedVendorLedgEntry."Document No.");
        JobJournalLine.VALIDATE(Type, JobJournalLine.Type::"G/L Account");
        JobJournalLine.VALIDATE("No.", AccountNo);

        JobJournalLine.Description := 'Ajuste por ' + FORMAT(DetailedVendorLedgEntry."Entry Type");
        JobJournalLine."Line Type" := JobJournalLine."Line Type"::"Both Budget and Billable"; //QMD
        JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Shipping;       //Movimiento es de tipo albar�n
        JobJournalLine.Provision := TRUE;                                                               //Es un ajuste sobre una provisi�n
        JobJournalLine."Source Type" := JobJournalLine."Source Type"::Vendor;
        JobJournalLine."Source No." := DetailedVendorLedgEntry."Vendor No.";

        //JAV 04/07/22: - QB 1.10.58 A�adir en el registro del movimiento del proyecto el nombre del proveedor
        IF Vendor.GET(DetailedVendorLedgEntry."Vendor No.") THEN
            JobJournalLine."Source Name" := Vendor.Name;

        JobJournalLine."Gen. Bus. Posting Group" := DetailedVendorLedgEntry."Gen. Bus. Posting Group";
        JobJournalLine."Gen. Prod. Posting Group" := DetailedVendorLedgEntry."Gen. Prod. Posting Group";
        JobJournalLine."Post Job Entry Only" := TRUE;
        JobJournalLine."Job Posting Only" := TRUE;
        JobJournalLine."Activation Entry" := TRUE;

        //Las dimensiones van sobre el movimiento original
        JobJournalLine."Shortcut Dimension 1 Code" := VendorLedgerEntry."Global Dimension 1 Code";
        JobJournalLine."Shortcut Dimension 2 Code" := VendorLedgerEntry."Global Dimension 2 Code";
        JobJournalLine.VALIDATE("Dimension Set ID", VendorLedgerEntry."Dimension Set ID");
        //Ajutar el C.A. del movimiento
        IF (FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1) THEN
            JobJournalLine.VALIDATE("Shortcut Dimension 1 Code", Job."Adjust Exchange Rate A.C.")
        ELSE IF (FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2) THEN
            JobJournalLine.VALIDATE("Shortcut Dimension 2 Code", Job."Adjust Exchange Rate A.C.");

        //C�digo de origen del movimiento
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD(SourceCodeSetup."Exchange Rate Adjmt.");
        JobJournalLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";

        //Precios e importes, van siempre sobre cantidad uno, pero cambio el signo para que si es un gasto sea positivo y si es un ingreso sea negativo
        JobJournalLine.VALIDATE("Transaction Currency", DetailedVendorLedgEntry."Currency Code");
        JobJournalLine.VALIDATE(Quantity, 1);
        JobJournalLine."Unit Cost (LCY)" := -DetailedVendorLedgEntry."Amount (LCY)";
        JobJournalLine."Total Cost (LCY)" := -DetailedVendorLedgEntry."Amount (LCY)";
        JobJournalLine."Unit Cost" := -DetailedVendorLedgEntry.Amount;                   //Realmente ser� cero siempre, pero lo pongo de todas formas
        JobJournalLine."Total Cost" := -DetailedVendorLedgEntry.Amount;                  //Realmente ser� cero siempre, pero lo pongo de todas formas
        JobJournalLine."Total Cost (TC)" := -DetailedVendorLedgEntry.Amount;             //Realmente ser� cero siempre, pero lo pongo de todas formas

        JobJnlPostLine.RunWithCheck(JobJournalLine);
    END;

    LOCAL PROCEDURE "----------------------------------------------- Funciones auxiliares"();
    BEGIN
    END;

    PROCEDURE GetCurrencyValues(cName: Code[20]; VAR CurrencysName: Text; VAR CurrencyName: Text; VAR FractionsName: Text; VAR FractionName: Text; VAR FractionWCurrency: Boolean; VAR Female: Boolean; VAR Decimals: Integer): Text;
    VAR
        Currency: Record 4;
        GeneralLedgerSetup: Record 98;
        txt: Text;
    BEGIN
        IF (cName = '') THEN BEGIN
            GeneralLedgerSetup.GET();
            cName := GeneralLedgerSetup."LCY Code";
            IF (NOT Currency.GET(cName)) THEN BEGIN
                Currency.InitRoundingPrecision;

                CurrencysName := 'Euros';
                CurrencyName := 'Euro';
                FractionsName := 'C�ntimos';
                FractionName := 'C�ntimo';
                FractionWCurrency := FALSE;
                Female := FALSE;
                txt := FORMAT(Currency."Amount Rounding Precision", 0, '<Decimals>');
                txt := DELCHR(txt, '<', '0');
                txt := DELCHR(txt, '<', '.');
                txt := DELCHR(txt, '<', ',');
                Decimals := STRLEN(txt);
                EXIT;
            END;
        END;

        IF (Currency.GET(cName)) THEN BEGIN
            CurrencysName := Currency."QB_Currencys name";
            CurrencyName := Currency."QB_Currency name";
            FractionsName := Currency."QB_Fractions name";
            FractionName := Currency."QB_Fraction name";
            FractionWCurrency := Currency."QB_Fraction W Currency";
            Female := (Currency.QB_Gendre = Currency.QB_Gendre::Female);
            txt := FORMAT(Currency."Amount Rounding Precision", 0, '<Decimals>');
            txt := DELCHR(txt, '<', '0');
            txt := DELCHR(txt, '<', '.');
            txt := DELCHR(txt, '<', ',');
            Decimals := STRLEN(txt);
        END ELSE BEGIN
            CurrencysName := '';
            CurrencyName := '';
            FractionsName := '';
            FractionName := '';
            FractionWCurrency := FALSE;
            Female := FALSE;
            Decimals := 2;
        END;
    END;

    /*BEGIN
/*{
      PEL 05/04/19: - GEN003-01 Cambios de divisas
      PEL 10/04/19: - GEN005-01 Cambios de divisas
      JAV 16/04/19: - GEN003-01 Se unifican las funciones para que sean mas sencillas de usar
      JDC 08/08/19: - Q7634 Modified functions "GetCurrencyExchange" and "CalculateCurrencyValue" to fix exchangeRate calculation
      JDC 30/09/19: - Q7539 Modified function "CalculateCurrencyValue" to fix exchange rate calculatio to LCY
      JDC 02/10/19: - Q7374 Modified function "CalculateCurrencyValue" and "GetCurrencyExchange"
      JAV 12/10/20: - QB 1.06.20 Se a�aden funciones para crear movimientos de proyecto de tipo ajustes de cambio de divisa
      JAV 27/11/20: - QB 1.07.08 El valor del cambio es la divisi�n entre cuantas unidades en divisa/cuantas unidades en local
      JAV 30/11/20: - QB 1.07.08 Mejoras en las funciones al abrir la p�gina y al leer el registro
      JAV 04/07/22: - QB 1.10.58 A�adir en el registro del movimiento del proyecto el nombre del cliente o del proveedor
    }
END.*/
}







