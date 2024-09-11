tableextension 50158 "QBU VAT EntryExt" extends "VAT Entry"
{


    CaptionML = ENU = 'VAT Entry', ESP = 'Mov. IVA';
    LookupPageID = "VAT Entries";

    fields
    {
        field(50000; "Several Cust/Vend. Name"; Text[50])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Several Cust/Vend. Name', ESP = 'Nombre clientes/prov. varios';
            Description = 'Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)';


        }
        field(50001; "Several Cust/Vend VAT Reg. No."; Text[20])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Several Cust/Vend VAT Reg. No.', ESP = 'CIF/NIF clientes/prov. varios';
            Description = 'Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)';


        }
        field(50002; "Unrealized Document No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("VAT Entry"."Document No." WHERE("Entry No." = FIELD("Unrealized VAT Entry No.")));
            CaptionML = ENU = 'Unrealized Document No.', ESP = 'N� documento No Realizado';
            Description = 'BS::22419';
            Editable = false;


        }
        field(50003; "Unrealized External Doc. No."; Code[35])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("VAT Entry"."External Document No." WHERE("Entry No." = FIELD("Unrealized VAT Entry No.")));
            CaptionML = ENU = 'Unrealized External Document No.', ESP = 'N� documento externo No Realizado';
            Description = 'BS::22419';
            Editable = false;


        }
        field(7174331; "QuoSII Exported"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'SII Exported', ESP = 'SII Exportado';
            Description = 'QuoSII 1.5r';


        }
        field(7174332; "QuoSII Cancel Unrealized VAT"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'SII Exported', ESP = 'SII cancelar IVA no realizado';
            Description = 'QuoSII 1.5r';


        }
        field(7174334; "QFA Code Tax Type"; Option)
        {
            OptionMembers = " ","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Code Tax Type', ESP = '"C�d. Tipo Impuesto "';
            OptionCaptionML = ENU = '" ,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29"', ESP = '" ,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29"';

            Description = 'QFA 0.1,QFA_2413';


        }
        field(7174390; "DP Original VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Original VAT Amount', ESP = 'Importe IVA Original';
            Description = 'DP 1.00.00 JAV 23/06/22 y DP 1.00.04 JAV 14/07/22';
            AutoFormatType = 1;


        }
        field(7174391; "DP Non Deductible %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '% IVA no deducible';
            Description = 'DP 1.00.04 JAV 14/07/22';


        }
        field(7174392; "DP Non Deductible Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe IVA no deducible';
            Description = 'DP 1.00.04 JAV 14/07/22';


        }
        field(7174393; "DP Prorrata Type"; Option)
        {
            OptionMembers = " ","Provisional","Definitiva";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prorrated Type', ESP = 'Prorrata Tipo';
            OptionCaptionML = ENU = '" ,Provisional,Definitiva"', ESP = '" ,Provisional,Definitiva"';

            Description = 'DP04a';
            Editable = false;


        }
        field(7174394; "DP Prov. Prorrata %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prov. Prorrata %', ESP = 'Prorrata % Provisional';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            MaxValue = 100;
            BlankZero = true;
            Description = 'DP04a - Porcentage prorrata provisional';
            Editable = false;


        }
        field(7174395; "DP Def. Prorrata %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Def. Prorrata %', ESP = 'Prorrata % definitiva';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            MaxValue = 100;
            BlankZero = true;
            Description = 'DP04a - Porcentage prorrata definitiva';
            Editable = false;


        }
        field(7174396; "DP Prorrata Def. VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prorrata Def. VAT Amount', ESP = 'Prorrata Importe IVA Definitivo';
            BlankZero = true;
            Description = 'DP04a - Importe deducible de IVA con prorrata definitiva. Sustituye a Amount';
            Editable = false;
            AutoFormatType = 1;


        }
        field(7174397; "DP Original Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cuenta de gasto original';
            Description = 'DP 1.00.05 JAV 22/07/22 Indica desde que cuenta de gasto se cre� el registro de IVA';


        }
    }
    keys
    {
        // key(key1;"Entry No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Type","Closed","VAT Bus. Posting Group","VAT Prod. Posting Group","Posting Date")
        //  {
        /* SumIndexFields="Base","Amount","Additional-Currency Base","Additional-Currency Amount","Remaining Unrealized Amount","Remaining Unrealized Base","Add.-Curr. Rem. Unreal. Amount","Add.-Curr. Rem. Unreal. Base";
  */
        // }
        // key(key3;"Type","Closed","Tax Jurisdiction Code","Use Tax","Posting Date")
        //  {
        /* SumIndexFields="Base","Amount","Unrealized Amount","Unrealized Base","Remaining Unrealized Amount";
  */
        // }
        // key(key4;"Type","Country/Region Code","VAT Registration No.","VAT Bus. Posting Group","VAT Prod. Posting Group","Posting Date")
        //  {
        /* SumIndexFields="Base","Additional-Currency Base";
  */
        // }
        // key(key5;"Document No.","Posting Date")
        //  {
        /* ;
  */
        // }
        // key(key6;"Transaction No.")
        //  {
        /* ;
  */
        // }
        // key(key7;"Tax Jurisdiction Code","Tax Group Used","Tax Type","Use Tax","Posting Date")
        //  {
        /* ;
  */
        // }
        // key(key8;"Type","Bill-to/Pay-to No.","Transaction No.")
        //  {
        /* MaintainSQLIndex=false;
  */
        // }
        // key(key9;"Type","Posting Date","Document Type","Document No.","Bill-to/Pay-to No.")
        //  {
        /* ;
  */
        // }
        // key(key10;"Type","Closed","Gen. Bus. Posting Group","Gen. Prod. Posting Group","Posting Date")
        //  {
        /* SumIndexFields="Base","Amount","Unrealized Amount","Unrealized Base";
  */
        // }
        // key(key11;"Document Type","No. Series","Posting Date")
        //  {
        /* ;
  */
        // }
        // key(key12;"No. Series","Posting Date","Document No.")
        //  {
        /* ;
  */
        // }
        // key(key13;"Type","Posting Date","Document No.","Country/Region Code")
        //  {
        /* ;
  */
        // }
        // key(key14;"Document Type","Posting Date","Document No.")
        //  {
        /* ;
  */
        // }
        // key(key15;"Document No.","Document Type","Gen. Prod. Posting Group","VAT Prod. Posting Group","Type")
        //  {
        /* SumIndexFields="Amount";
  */
        // }
        // key(key16;"VAT %","EC %")
        //  {
        /* ;
  */
        // }
        // key(key17;"Type","Document Type","Bill-to/Pay-to No.","Posting Date","EU 3-Party Trade","EU Service","Delivery Operation Code")
        //  {
        /* SumIndexFields="Base";
  */
        // }
        // key(key18;"Type","Closed","VAT Bus. Posting Group","VAT Prod. Posting Group","Tax Jurisdiction Code","Use Tax","Posting Date")
        //  {
        /* SumIndexFields="Base","Amount","Unrealized Amount","Unrealized Base","Additional-Currency Base","Additional-Currency Amount","Add.-Currency Unrealized Amt.","Add.-Currency Unrealized Base","Remaining Unrealized Amount";
  */
        // }
        // key(key19;"Posting Date","Type","Closed","VAT Bus. Posting Group","VAT Prod. Posting Group","Reversed")
        //  {
        /* SumIndexFields="Base","Amount","Unrealized Amount","Unrealized Base","Additional-Currency Base","Additional-Currency Amount","Add.-Currency Unrealized Amt.","Add.-Currency Unrealized Base","Remaining Unrealized Amount";
  */
        // }
    }
    fieldgroups
    {
        // fieldgroup(DropDown;"Entry No.","Posting Date","Document Type","Document No.","Posting Date")
        // {
        // 
        // }
    }

    var
        //       Text000@1000 :
        Text000: TextConst ENU = 'You cannot change the contents of this field when %1 is %2.', ESP = 'No se puede modificar el contenido de este campo cuando %1 tenga el valor %2.';
        //       Cust@1001 :
        Cust: Record 18;
        //       Vend@1002 :
        Vend: Record 23;
        //       GLSetup@1003 :
        GLSetup: Record 98;
        //       GLSetupRead@1004 :
        GLSetupRead: Boolean;
        //       IsBillDoc@1100001 :
        IsBillDoc: Boolean;


    /*
    LOCAL procedure GetCurrencyCode () : Code[10];
        begin
          if not GLSetupRead then begin
            GLSetup.GET;
            GLSetupRead := TRUE;
          end;
          exit(GLSetup."Additional Reporting Currency");
        end;
    */



    //     procedure GetUnrealizedVATPart (SettledAmount@1003 : Decimal;Paid@1005 : Decimal;Full@1001 : Decimal;TotalUnrealVATAmountFirst@1006 : Decimal;TotalUnrealVATAmountLast@1007 :
    procedure GetUnrealizedVATPart(SettledAmount: Decimal; Paid: Decimal; Full: Decimal; TotalUnrealVATAmountFirst: Decimal; TotalUnrealVATAmountLast: Decimal): Decimal;
    var
        //       UnrealizedVATType@1000 :
        UnrealizedVATType: Option " ","Percentage","First","Last","First (Fully Paid)","Last (Fully Paid)";
    begin
        if (Type <> 0) and
           (Amount = 0) and
           (Base = 0)
        then begin
            UnrealizedVATType := GetUnrealizedVATType;
            if (UnrealizedVATType = UnrealizedVATType::" ") or
               (("Remaining Unrealized Amount" = 0) and
                ("Remaining Unrealized Base" = 0))
            then
                exit(0);

            if ABS(Paid) = ABS(Full) then
                exit(1);

            CASE UnrealizedVATType OF
                UnrealizedVATType::Percentage:
                    begin
                        if IsBillDoc then
                            exit(ABS(SettledAmount) / ABS(Full));
                        if Full = 0 then
                            exit(ABS(SettledAmount) / (ABS(Paid) + ABS(SettledAmount)));
                        exit(ABS(SettledAmount) / (ABS(Full) - (ABS(Paid) - ABS(SettledAmount))));
                    end;
                UnrealizedVATType::First:
                    begin
                        if "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" then
                            exit(1);
                        if ABS(Paid) < ABS(TotalUnrealVATAmountFirst) then
                            exit(ABS(SettledAmount) / ABS(TotalUnrealVATAmountFirst));
                        exit(1);
                    end;
                UnrealizedVATType::"First (Fully Paid)":
                    begin
                        if "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" then
                            exit(1);
                        if ABS(Paid) < ABS(TotalUnrealVATAmountFirst) then
                            exit(0);
                        exit(1);
                    end;
                UnrealizedVATType::"Last (Fully Paid)":
                    exit(0);
                UnrealizedVATType::Last:
                    begin
                        if "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" then
                            exit(0);
                        if ABS(Paid) > ABS(Full) - ABS(TotalUnrealVATAmountLast) then
                            exit((ABS(Paid) - (ABS(Full) - ABS(TotalUnrealVATAmountLast))) / ABS(TotalUnrealVATAmountLast));
                        exit(0);
                    end;
            end;
        end else
            exit(0);
    end;

    LOCAL procedure GetUnrealizedVATType() UnrealizedVATType: Integer;
    var
        //       VATPostingSetup@1001 :
        VATPostingSetup: Record 325;
        //       TaxJurisdiction@1000 :
        TaxJurisdiction: Record 320;
    begin
        if "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" then begin
            TaxJurisdiction.GET("Tax Jurisdiction Code");
            UnrealizedVATType := TaxJurisdiction."Unrealized VAT Type";
        end else begin
            VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group");
            UnrealizedVATType := VATPostingSetup."Unrealized VAT Type";
        end;
    end;


    //     procedure UpdateRates (VATPostingSetup@1100000 :
    procedure UpdateRates(VATPostingSetup: Record 325)
    begin
        if (VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT") and
           (Type = Type::Sale)
        then begin
            "VAT %" := 0;
            "EC %" := 0;
        end else begin
            "VAT %" := VATPostingSetup."VAT %";
            "EC %" := VATPostingSetup."EC %";
        end;
    end;


    //     procedure SetBillDoc (NewIsBillDoc@1100000 :

    /*
    procedure SetBillDoc (NewIsBillDoc: Boolean)
        begin
          IsBillDoc := NewIsBillDoc;
        end;
    */



    //     procedure CopyFromGenJnlLine (GenJnlLine@1000 :

    /*
    procedure CopyFromGenJnlLine (GenJnlLine: Record 81)
        begin
          CopyPostingGroupsFromGenJnlLine(GenJnlLine);
          "Posting Date" := GenJnlLine."Posting Date";
          "Document Date" := GenJnlLine."Document Date";
          "Document No." := GenJnlLine."Document No.";
          "External Document No." := GenJnlLine."External Document No.";
          "Document Type" := GenJnlLine."Document Type";
          Type := GenJnlLine."Gen. Posting Type";
          "VAT Calculation Type" := GenJnlLine."VAT Calculation Type";
          "Source Code" := GenJnlLine."Source Code";
          "Reason Code" := GenJnlLine."Reason Code";
          "Ship-to/Order Address Code" := GenJnlLine."Ship-to/Order Address Code";
          "EU 3-Party Trade" := GenJnlLine."EU 3-Party Trade";
          "User ID" := USERID;
          "No. Series" := GenJnlLine."Posting No. Series";
          "VAT Base Discount %" := GenJnlLine."VAT Base Discount %";
          "Bill-to/Pay-to No." := GenJnlLine."Bill-to/Pay-to No.";
          "Country/Region Code" := GenJnlLine."Country/Region Code";
          "VAT Registration No." := GenJnlLine."VAT Registration No.";
          "Generated Autodocument" := GenJnlLine."Generate AutoInvoices";

          OnAfterCopyFromGenJnlLine(Rec,GenJnlLine);
        end;
    */



    //     procedure SetVATCashRegime (VATPostingSetup@1100002 : Record 325;GenPostingType@1100000 :
    procedure SetVATCashRegime(VATPostingSetup: Record 325; GenPostingType: Option " ","Purchase","Sale","Settlemen")
    var
        //       GeneralLedgerSetup@1100001 :
        GeneralLedgerSetup: Record 98;
    begin
        if GenPostingType = GenPostingType::Sale then begin
            GeneralLedgerSetup.GET;
            "VAT Cash Regime" := GeneralLedgerSetup."VAT Cash Regime";
            exit;
        end;

        if GenPostingType = GenPostingType::Purchase then
            "VAT Cash Regime" := VATPostingSetup."VAT Cash Regime";
    end;

    //     LOCAL procedure CopyPostingGroupsFromGenJnlLine (GenJnlLine@1000 :

    /*
    LOCAL procedure CopyPostingGroupsFromGenJnlLine (GenJnlLine: Record 81)
        begin
          "Gen. Bus. Posting Group" := GenJnlLine."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := GenJnlLine."Gen. Prod. Posting Group";
          "VAT Bus. Posting Group" := GenJnlLine."VAT Bus. Posting Group";
          "VAT Prod. Posting Group" := GenJnlLine."VAT Prod. Posting Group";
          "Tax Area Code" := GenJnlLine."Tax Area Code";
          "Tax Liable" := GenJnlLine."Tax Liable";
          "Tax Group Code" := GenJnlLine."Tax Group Code";
          "Use Tax" := GenJnlLine."Use Tax";
        end;
    */



    //     procedure CopyAmountsFromVATEntry (VATEntry@1000 : Record 254;WithOppositeSign@1001 :
    procedure CopyAmountsFromVATEntry(VATEntry: Record 254; WithOppositeSign: Boolean)
    var
        //       Sign@1002 :
        Sign: Decimal;
    begin
        if WithOppositeSign then
            Sign := -1
        else
            Sign := 1;
        Base := Sign * VATEntry.Base;
        Amount := Sign * VATEntry.Amount;
        "Unrealized Amount" := Sign * VATEntry."Unrealized Amount";
        "Unrealized Base" := Sign * VATEntry."Unrealized Base";
        "Remaining Unrealized Amount" := Sign * VATEntry."Remaining Unrealized Amount";
        "Remaining Unrealized Base" := Sign * VATEntry."Remaining Unrealized Base";
        "Additional-Currency Amount" := Sign * VATEntry."Additional-Currency Amount";
        "Additional-Currency Base" := Sign * VATEntry."Additional-Currency Base";
        "Add.-Currency Unrealized Amt." := Sign * VATEntry."Add.-Currency Unrealized Amt.";
        "Add.-Currency Unrealized Base" := Sign * VATEntry."Add.-Currency Unrealized Base";
        "Add.-Curr. Rem. Unreal. Amount" := Sign * VATEntry."Add.-Curr. Rem. Unreal. Amount";
        "Add.-Curr. Rem. Unreal. Base" := Sign * VATEntry."Add.-Curr. Rem. Unreal. Base";
        "VAT Difference" := Sign * VATEntry."VAT Difference";
        "Add.-Curr. VAT Difference" := Sign * VATEntry."Add.-Curr. VAT Difference";
        "Realized Amount" := Sign * "Realized Amount";
        "Realized Base" := Sign * "Realized Base";
        "Add.-Curr. Realized Amount" := Sign * "Add.-Curr. Realized Amount";
        "Add.-Curr. Realized Base" := Sign * "Add.-Curr. Realized Base";
    end;



    /*
    procedure SetUnrealAmountsToZero ()
        begin
          "Unrealized Amount" := 0;
          "Unrealized Base" := 0;
          "Remaining Unrealized Amount" := 0;
          "Remaining Unrealized Base" := 0;
          "Add.-Currency Unrealized Amt." := 0;
          "Add.-Currency Unrealized Base" := 0;
          "Add.-Curr. Rem. Unreal. Amount" := 0;
          "Add.-Curr. Rem. Unreal. Base" := 0;
          "Realized Amount" := 0;
          "Realized Base" := 0;
          "Add.-Curr. Realized Amount" := 0;
          "Add.-Curr. Realized Base" := 0;
        end;
    */



    procedure GetTotalAmount(): Decimal;
    begin
        if "VAT Cash Regime" then
            exit(Amount + "Unrealized Amount")
        else
            exit(Amount);
    end;


    procedure GetTotalBase(): Decimal;
    begin
        if "VAT Cash Regime" then
            exit(Base + "Unrealized Base")
        else
            exit(Base);
    end;

    //     procedure IsCorrectiveCrMemoDiffPeriod (StartDateFormula@1100002 : DateFormula;EndDateFormula@1100000 :
    procedure IsCorrectiveCrMemoDiffPeriod(StartDateFormula: DateFormula; EndDateFormula: DateFormula): Boolean;
    var
        //       SalesCrMemoHeader@1100001 :
        SalesCrMemoHeader: Record 114;
    begin
        if "Document Type" <> "Document Type"::"Credit Memo" then
            exit(FALSE);

        CASE Type OF
            Type::Sale:
                begin
                    if SalesCrMemoHeader.GET("Document No.") then
                        exit(IsCorrectiveSalesCrMemoDiffPeriod(SalesCrMemoHeader, StartDateFormula, EndDateFormula));
                    exit(IsCorrectiveServiceCrMemoDiffPeriod("Document No.", StartDateFormula, EndDateFormula));
                end;
            Type::Purchase:
                exit(IsCorrectivePurchCrMemoDiffPeriod("Document No.", StartDateFormula, EndDateFormula));
        end;
    end;

    //     LOCAL procedure IsCorrectiveSalesCrMemoDiffPeriod (var SalesCrMemoHeader@1100000 : Record 114;StartDateFormula@1100001 : DateFormula;EndDateFormula@1100003 :


    LOCAL procedure IsCorrectiveSalesCrMemoDiffPeriod(var SalesCrMemoHeader: Record 114; StartDateFormula: DateFormula; EndDateFormula: DateFormula): Boolean;
    var
        //       SalesInvoiceHeader@1100002 :
        SalesInvoiceHeader: Record 112;
    begin
        if SalesCrMemoHeader."Corrected Invoice No." = '' then
            exit(FALSE);
        SalesInvoiceHeader.GET(SalesCrMemoHeader."Corrected Invoice No.");
        exit(not (SalesInvoiceHeader."Posting Date" IN [CALCDATE(StartDateFormula, SalesCrMemoHeader."Posting Date") ..
                                                        CALCDATE(EndDateFormula, SalesCrMemoHeader."Posting Date")]));
    end;



    //     LOCAL procedure IsCorrectiveServiceCrMemoDiffPeriod (DocNo@1100000 : Code[20];StartDateFormula@1100004 : DateFormula;EndDateFormula@1100003 :


    LOCAL procedure IsCorrectiveServiceCrMemoDiffPeriod(DocNo: Code[20]; StartDateFormula: DateFormula; EndDateFormula: DateFormula): Boolean;
    var
        //       ServiceCrMemoHeader@1100001 :
        ServiceCrMemoHeader: Record 5994;
        //       ServiceInvoiceHeader@1100002 :
        ServiceInvoiceHeader: Record 5992;
    begin
        ServiceCrMemoHeader.GET(DocNo);
        if ServiceCrMemoHeader."Corrected Invoice No." = '' then
            exit(FALSE);
        ServiceInvoiceHeader.GET(ServiceCrMemoHeader."Corrected Invoice No.");
        exit(not (ServiceInvoiceHeader."Posting Date" IN [CALCDATE(StartDateFormula, ServiceCrMemoHeader."Posting Date") ..
                                                          CALCDATE(EndDateFormula, ServiceCrMemoHeader."Posting Date")]));
    end;



    //     LOCAL procedure IsCorrectivePurchCrMemoDiffPeriod (DocNo@1100000 : Code[20];StartDateFormula@1100004 : DateFormula;EndDateFormula@1100003 :


    LOCAL procedure IsCorrectivePurchCrMemoDiffPeriod(DocNo: Code[20]; StartDateFormula: DateFormula; EndDateFormula: DateFormula): Boolean;
    var
        //       PurchCrMemoHdr@1100002 :
        PurchCrMemoHdr: Record 124;
        //       PurchInvHeader@1100001 :
        PurchInvHeader: Record 122;
    begin
        PurchCrMemoHdr.GET(DocNo);
        if PurchCrMemoHdr."Corrected Invoice No." = '' then
            exit(FALSE);
        PurchInvHeader.GET(PurchCrMemoHdr."Corrected Invoice No.");
        exit(not (PurchInvHeader."Posting Date" IN [CALCDATE(StartDateFormula, PurchCrMemoHdr."Posting Date") ..
                                                    CALCDATE(EndDateFormula, PurchCrMemoHdr."Posting Date")]));
    end;




    //     procedure OnAfterCopyFromGenJnlLine (var VATEntry@1000 : Record 254;GenJournalLine@1001 :

    /*
    procedure OnAfterCopyFromGenJnlLine (var VATEntry: Record 254;GenJournalLine: Record 81)
        begin
        end;

        /*begin
        //{
    //      JAV 21/06/22: - DP 1.00.00 Se a�aden los campos para el manejo de la prorrata. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
    //                                    7174390 "DP Prorrata"Prorrata Tipo"
    //                                    7174391 "DP Prov. Prorrata %"
    //                                    7174392 "DP Prorrata Orig. VAT Amount"
    //                                    7174393 "DP Def. Prorrata %"
    //                                    7174394 "DP Prorrata Def. VAT Amount"
    //      JAV 14/07/22: - DP 1.00.04 Se cambia el caption del campo 7174392 por "DP Orig. VAT Amount" para que sea com�n a Prorrata y No deducible
    //                                 Se a�aden los campos 7174395 y 7174396
    //      Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)
    //      BS::22419 CSM 31/05/24 � IMP022
    //    }
        end.
      */
}





