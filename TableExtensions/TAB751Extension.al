tableextension 50898 "QBU Standard General Journal LineExt" extends "Standard General Journal Line"
{
  
  
    CaptionML=ENU='Standard General Journal Line',ESP='L¡nea diario general est ndar';
  
  fields
{
    field(7207270;"QBU Piecework Code";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."));
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='No. Job Unit',ESP='N§ unidad de obra';
                                                   Description='Q19273' ;

trigger OnValidate();
    BEGIN 
                                                                //JAV 05/03/21: - QB 1.08.21 Esto revisa las dimensiones
                                                                xRec."Job No." := '';
                                                                VALIDATE("Job No.");
                                                              END;


    }
}
  keys
{
   // key(key1;"Journal Template Name","Standard Journal Code","Line No.")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='%1 or %2 must be G/L Account or Bank Account.',ESP='%1 o %2 deben ser de tipo Cuenta o Banco.';
//       Text001@1002 :
      Text001: TextConst ENU='You cannot rename a %1.',ESP='No se puede cambiar el nombre a %1.';
//       Text002@1018 :
      Text002: TextConst ENU='cannot be specified without %1',ESP='no se puede especificar sin %1';
//       Text006@1001 :
      Text006: TextConst ENU='The %1 option can only be used internally in the system.',ESP='La opci¢n %1 es de uso interno del sistema.';
//       Currency@1004 :
      Currency: Record 4;
//       CurrExchRate@1017 :
      CurrExchRate: Record 330;
//       VATPostingSetup@1016 :
      VATPostingSetup: Record 325;
//       DimMgt@1005 :
      DimMgt: Codeunit 408;
//       SalesTaxCalculate@1015 :
      SalesTaxCalculate: Codeunit 398;
//       CurrencyCode@1003 :
      CurrencyCode: Code[10];
//       Text007@1022 :
      Text007: TextConst ENU='%1 or %2 must be a Bank Account.',ESP='%1 o %2 debe ser de tipo Banco.';
//       Text008@1019 :
      Text008: TextConst ENU=' must be 0 when %1 is %2.',ESP=' debe ser 0 cuando %1 es %2.';
//       Text010@1021 :
      Text010: TextConst ENU='%1 must be %2 or %3.',ESP='%1 debe ser %2 o %3.';
//       Text011@1011 :
      Text011: TextConst ENU='%1 must be negative.',ESP='El %1 debe ser negativo.';
//       Text012@1014 :
      Text012: TextConst ENU='%1 must be positive.',ESP='El %1 debe ser positivo.';
//       Text013@1012 :
      Text013: TextConst ENU='The %1 must not be more than %2.',ESP='%1 no debe ser m s que %2.';
//       Text014@1006 :
      Text014: TextConst ENU='The %1 %2 has a %3 %4.\Do you still want to use %1 %2 in this journal line?',ESP='El %1 %2 tiene un %3 %4.\¨Todav¡a quiere utilizar %1 %2 en esta l¡nea del diario?';

    


/*
trigger OnRename();    begin
               ERROR(Text001,TABLECAPTION);
             end;

*/




/*
LOCAL procedure UpdateLineBalance ()
    begin
      if ((Amount > 0) and (not Correction)) or
         ((Amount < 0) and Correction)
      then begin
        "Debit Amount" := Amount;
        "Credit Amount" := 0
      end else begin
        "Debit Amount" := 0;
        "Credit Amount" := -Amount;
      end;
      if "Currency Code" = '' then
        "Amount (LCY)" := Amount;
    end;
*/


    
//     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    
/*
procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;
*/


    
//     procedure LookupShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    
/*
procedure LookupShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;
*/


    
//     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    
/*
procedure ShowShortcutDimCode (var ShortcutDimCode: ARRAY [8] OF Code[20])
    begin
      DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;
*/


    
    
/*
procedure ShowDimensions ()
    begin
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Standard Journal Code","Line No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;
*/


//     LOCAL procedure CheckGLAcc (GLAcc@1002 :
    
/*
LOCAL procedure CheckGLAcc (GLAcc: Record 15)
    begin
      GLAcc.CheckGLAcc;
      if GLAcc."Direct Posting" or ("Journal Template Name" = '') then
        exit;
      GLAcc.TESTFIELD("Direct Posting",TRUE);
    end;
*/


//     LOCAL procedure CheckAccount (AccountType@1000 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';AccountNo@1001 :
    
/*
LOCAL procedure CheckAccount (AccountType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner";AccountNo: Code[20])
    var
//       GLAcc@1007 :
      GLAcc: Record 15;
//       Cust@1006 :
      Cust: Record 18;
//       Vend@1005 :
      Vend: Record 23;
//       ICPartner@1004 :
      ICPartner: Record 413;
//       BankAcc@1003 :
      BankAcc: Record 270;
//       FA@1002 :
      FA: Record 5600;
    begin
      CASE AccountType OF
        AccountType::"G/L Account":
          begin
            GLAcc.GET(AccountNo);
            CheckGLAcc(GLAcc);
          end;
        AccountType::Customer:
          begin
            Cust.GET(AccountNo);
            Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
          end;
        AccountType::Vendor:
          begin
            Vend.GET(AccountNo);
            Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
          end;
        AccountType::"Bank Account":
          begin
            BankAcc.GET(AccountNo);
            BankAcc.TESTFIELD(Blocked,FALSE);
          end;
        AccountType::"Fixed Asset":
          begin
            FA.GET(AccountNo);
            FA.TESTFIELD(Blocked,FALSE);
            FA.TESTFIELD(Inactive,FALSE);
            FA.TESTFIELD("Budgeted Asset",FALSE);
          end;
        AccountType::"IC Partner":
          begin
            ICPartner.GET(AccountNo);
            ICPartner.CheckICPartner;
          end;
      end;
    end;
*/


//     LOCAL procedure CheckICPartner (ICPartnerCode@1000 : Code[20];AccountType@1001 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';AccountNo@1002 :
    
/*
LOCAL procedure CheckICPartner (ICPartnerCode: Code[20];AccountType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner";AccountNo: Code[20])
    var
//       ICPartner@1003 :
      ICPartner: Record 413;
    begin
      if ICPartnerCode <> '' then
        if (ICPartnerCode <> '') and ICPartner.GET(ICPartnerCode) then begin
          ICPartner.CheckICPartnerIndirect(FORMAT(AccountType),AccountNo);
          "IC Partner Code" := ICPartnerCode;
        end;
    end;
*/


//     LOCAL procedure SetCurrencyCode (AccType2@1000 : 'G/L Account,Customer,Vendor,Bank Account';AccNo2@1001 :
    
/*
LOCAL procedure SetCurrencyCode (AccType2: Option "G/L Account","Customer","Vendor","Bank Account";AccNo2: Code[20]) : Boolean;
    var
//       Cust@1004 :
      Cust: Record 18;
//       Vend@1003 :
      Vend: Record 23;
//       BankAcc@1002 :
      BankAcc: Record 270;
    begin
      "Currency Code" := '';
      if AccNo2 <> '' then
        CASE AccType2 OF
          AccType2::Customer:
            if Cust.GET(AccNo2) then
              "Currency Code" := Cust."Currency Code";
          AccType2::Vendor:
            if Vend.GET(AccNo2) then
              "Currency Code" := Vend."Currency Code";
          AccType2::"Bank Account":
            if BankAcc.GET(AccNo2) then
              "Currency Code" := BankAcc."Currency Code";
        end;
      exit("Currency Code" <> '');
    end;
*/


    
/*
LOCAL procedure GetCurrency ()
    begin
      if CurrencyCode = '' then begin
        CLEAR(Currency);
        Currency.InitRoundingPrecision
      end else
        if CurrencyCode <> Currency.Code then begin
          Currency.GET(CurrencyCode);
          Currency.TESTFIELD("Amount Rounding Precision");
        end;
    end;
*/


    
/*
LOCAL procedure UpdateSource ()
    var
//       SourceExists1@1000 :
      SourceExists1: Boolean;
//       SourceExists2@1001 :
      SourceExists2: Boolean;
    begin
      SourceExists1 := ("Account Type" <> "Account Type"::"G/L Account") and ("Account No." <> '');
      SourceExists2 := ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account") and ("Bal. Account No." <> '');
      CASE TRUE OF
        SourceExists1 and not SourceExists2:
          begin
            "Source Type" := "Account Type";
            "Source No." := "Account No.";
          end;
        SourceExists2 and not SourceExists1:
          begin
            "Source Type" := "Bal. Account Type";
            "Source No." := "Bal. Account No.";
          end;
        else begin
          "Source Type" := "Source Type"::" ";
          "Source No." := '';
        end;
      end;
    end;
*/


    
//     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20];Type4@1006 : Integer;No4@1007 : Code[20];Type5@1008 : Integer;No5@1009 :
    
/*
procedure CreateDim (Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20];Type4: Integer;No4: Code[20];Type5: Integer;No5: Code[20])
    var
//       TableID@1010 :
      TableID: ARRAY [10] OF Integer;
//       No@1011 :
      No: ARRAY [10] OF Code[20];
    begin
      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      TableID[3] := Type3;
      No[3] := No3;
      TableID[4] := Type4;
      No[4] := No4;
      TableID[5] := Type5;
      No[5] := No5;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,"Source Code","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
    end;
*/


    
/*
LOCAL procedure GetDefaultICPartnerGLAccNo () : Code[20];
    var
//       GLAcc@1001 :
      GLAcc: Record 15;
//       GLAccNo@1002 :
      GLAccNo: Code[20];
    begin
      if "IC Partner Code" <> '' then begin
        if "Account Type" = "Account Type"::"G/L Account" then
          GLAccNo := "Account No."
        else
          GLAccNo := "Bal. Account No.";
        if GLAcc.GET(GLAccNo) then
          exit(GLAcc."Default IC Partner G/L Acc. No")
      end;
    end;
*/


    
/*
LOCAL procedure GetGLAccount ()
    var
//       GLAcc@1000 :
      GLAcc: Record 15;
    begin
      GLAcc.GET("Account No.");
      CheckGLAcc(GLAcc);
      if "Bal. Account No." = '' then
        Description := GLAcc.Name;

      if ("Bal. Account No." = '') or
         ("Bal. Account Type" IN
          ["Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account"])
      then begin
        "Posting Group" := '';
        "Salespers./Purch. Code" := '';
        "Payment Terms Code" := '';
        "Payment Method Code" := '';
      end;
      if "Bal. Account No." = '' then
        "Currency Code" := '';
      "Gen. Posting Type" := GLAcc."Gen. Posting Type";
      "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
      "Tax Area Code" := GLAcc."Tax Area Code";
      "Tax Liable" := GLAcc."Tax Liable";
      "Tax Group Code" := GLAcc."Tax Group Code";
      if WORKDATE = CLOSINGDATE(WORKDATE) then begin
        "Gen. Posting Type" := 0;
        "Gen. Bus. Posting Group" := '';
        "Gen. Prod. Posting Group" := '';
        "VAT Bus. Posting Group" := '';
        "VAT Prod. Posting Group" := '';
      end;
    end;
*/


    
/*
LOCAL procedure GetGLBalAccount ()
    var
//       GLAcc@1000 :
      GLAcc: Record 15;
    begin
      GLAcc.GET("Bal. Account No.");
      CheckGLAcc(GLAcc);
      if "Account No." = '' then begin
        Description := GLAcc.Name;
        "Currency Code" := '';
      end;
      if ("Account No." = '') or
         ("Account Type" IN
          ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
      then begin
        "Posting Group" := '';
        "Salespers./Purch. Code" := '';
        "Payment Terms Code" := '';
      end;
      "Bal. Gen. Posting Type" := GLAcc."Gen. Posting Type";
      "Bal. Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
      "Bal. Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
      "Bal. VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
      "Bal. VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
      "Bal. Tax Area Code" := GLAcc."Tax Area Code";
      "Bal. Tax Liable" := GLAcc."Tax Liable";
      "Bal. Tax Group Code" := GLAcc."Tax Group Code";
      if WORKDATE = CLOSINGDATE(WORKDATE) then begin
        "Bal. Gen. Bus. Posting Group" := '';
        "Bal. Gen. Prod. Posting Group" := '';
        "Bal. VAT Bus. Posting Group" := '';
        "Bal. VAT Prod. Posting Group" := '';
        "Bal. Gen. Posting Type" := 0;
      end;
    end;
*/


    
/*
LOCAL procedure GetCustomerAccount ()
    var
//       Cust@1000 :
      Cust: Record 18;
    begin
      Cust.GET("Account No.");
      Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
      CheckICPartner(Cust."IC Partner Code","Account Type","Account No.");
      Description := Cust.Name;
      "Posting Group" := Cust."Customer Posting Group";
      "Salespers./Purch. Code" := Cust."Salesperson Code";
      "Payment Terms Code" := Cust."Payment Terms Code";
      VALIDATE("Bill-to/Pay-to No.","Account No.");
      VALIDATE("Sell-to/Buy-from No.","Account No.");
      if SetCurrencyCode("Bal. Account Type","Bal. Account No.") then
        Cust.TESTFIELD("Currency Code","Currency Code")
      else
        "Currency Code" := Cust."Currency Code";
      "Gen. Posting Type" := 0;
      "Gen. Bus. Posting Group" := '';
      "Gen. Prod. Posting Group" := '';
      "VAT Bus. Posting Group" := '';
      "VAT Prod. Posting Group" := '';
      if "Document Type" = "Document Type"::"Credit Memo" then
        "Payment Method Code" := ''
      else begin
        Cust.TESTFIELD("Payment Method Code");
        "Payment Method Code" := Cust."Payment Method Code";
      end;
      if (Cust."Bill-to Customer No." <> '') and (Cust."Bill-to Customer No." <> "Account No.") then begin
        if not CONFIRM(Text014,FALSE,Cust.TABLECAPTION,Cust."No.",Cust.FIELDCAPTION("Bill-to Customer No."),Cust."Bill-to Customer No.") then
          ERROR('');
      end;
      VALIDATE("Payment Terms Code");
    end;
*/


    
/*
LOCAL procedure GetCustomerBalAccount ()
    var
//       Cust@1000 :
      Cust: Record 18;
    begin
      Cust.GET("Bal. Account No.");
      Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
      CheckICPartner(Cust."IC Partner Code","Bal. Account Type","Bal. Account No.");
      if "Account No." = '' then
        Description := Cust.Name;
      "Posting Group" := Cust."Customer Posting Group";
      "Salespers./Purch. Code" := Cust."Salesperson Code";
      "Payment Terms Code" := Cust."Payment Terms Code";
      VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
      VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
      if ("Account No." = '') or ("Account Type" = "Account Type"::"G/L Account") then
        "Currency Code" := Cust."Currency Code";
      if ("Account Type" = "Account Type"::"Bank Account") and ("Currency Code" = '') then
        "Currency Code" := Cust."Currency Code";
      "Bal. Gen. Posting Type" := 0;
      "Bal. Gen. Bus. Posting Group" := '';
      "Bal. Gen. Prod. Posting Group" := '';
      "Bal. VAT Bus. Posting Group" := '';
      "Bal. VAT Prod. Posting Group" := '';
      if (Cust."Bill-to Customer No." <> '') and (Cust."Bill-to Customer No." <> "Bal. Account No.") then begin
        if not CONFIRM(Text014,FALSE,Cust.TABLECAPTION,Cust."No.",Cust.FIELDCAPTION("Bill-to Customer No."),Cust."Bill-to Customer No.") then
          ERROR('');
      end;
      VALIDATE("Payment Terms Code");
    end;
*/


    
/*
LOCAL procedure GetVendorAccount ()
    var
//       Vend@1000 :
      Vend: Record 23;
    begin
      Vend.GET("Account No.");
      Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
      CheckICPartner(Vend."IC Partner Code","Account Type","Account No.");
      Description := Vend.Name;
      "Posting Group" := Vend."Vendor Posting Group";
      "Salespers./Purch. Code" := Vend."Purchaser Code";
      "Payment Terms Code" := Vend."Payment Terms Code";
      VALIDATE("Bill-to/Pay-to No.","Account No.");
      VALIDATE("Sell-to/Buy-from No.","Account No.");
      if SetCurrencyCode("Bal. Account Type","Bal. Account No.") then
        Vend.TESTFIELD("Currency Code","Currency Code")
      else
        "Currency Code" := Vend."Currency Code";
      "Gen. Posting Type" := 0;
      "Gen. Bus. Posting Group" := '';
      "Gen. Prod. Posting Group" := '';
      "VAT Bus. Posting Group" := '';
      "VAT Prod. Posting Group" := '';
      if "Document Type" = "Document Type"::"Credit Memo" then
        "Payment Method Code" := ''
      else begin
        Vend.TESTFIELD("Payment Method Code");
        "Payment Method Code" := Vend."Payment Method Code";
      end;
      if (Vend."Pay-to Vendor No." <> '') and (Vend."Pay-to Vendor No." <> "Account No.") then begin
        if not CONFIRM(Text014,FALSE,Vend.TABLECAPTION,Vend."No.",Vend.FIELDCAPTION("Pay-to Vendor No."),Vend."Pay-to Vendor No.") then
          ERROR('');
      end;
      VALIDATE("Payment Terms Code");
    end;
*/


    
/*
LOCAL procedure GetVendorBalAccount ()
    var
//       Vend@1000 :
      Vend: Record 23;
    begin
      Vend.GET("Bal. Account No.");
      Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
      CheckICPartner(Vend."IC Partner Code","Bal. Account Type","Bal. Account No.");
      if "Account No." = '' then
        Description := Vend.Name;
      "Posting Group" := Vend."Vendor Posting Group";
      "Salespers./Purch. Code" := Vend."Purchaser Code";
      "Payment Terms Code" := Vend."Payment Terms Code";
      VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
      VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
      if ("Account No." = '') or ("Account Type" = "Account Type"::"G/L Account") then
        "Currency Code" := Vend."Currency Code";
      if ("Account Type" = "Account Type"::"Bank Account") and ("Currency Code" = '') then
        "Currency Code" := Vend."Currency Code";
      "Bal. Gen. Posting Type" := 0;
      "Bal. Gen. Bus. Posting Group" := '';
      "Bal. Gen. Prod. Posting Group" := '';
      "Bal. VAT Bus. Posting Group" := '';
      "Bal. VAT Prod. Posting Group" := '';
      if (Vend."Pay-to Vendor No." <> '') and (Vend."Pay-to Vendor No." <> "Bal. Account No.") then begin
        if not CONFIRM(Text014,FALSE,Vend.TABLECAPTION,Vend."No.",Vend.FIELDCAPTION("Pay-to Vendor No."),Vend."Pay-to Vendor No.") then
          ERROR('');
      end;
      VALIDATE("Payment Terms Code");
    end;
*/


    
/*
LOCAL procedure GetBankAccount ()
    var
//       BankAcc@1000 :
      BankAcc: Record 270;
    begin
      BankAcc.GET("Account No.");
      BankAcc.TESTFIELD(Blocked,FALSE);
      if "Bal. Account No." = '' then
        Description := BankAcc.Name;
      if ("Bal. Account No." = '') or
         ("Bal. Account Type" IN
          ["Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account"])
      then begin
        "Posting Group" := '';
        "Salespers./Purch. Code" := '';
        "Payment Terms Code" := '';
      end;
      if BankAcc."Currency Code" = '' then begin
        if "Bal. Account No." = '' then
          "Currency Code" := '';
      end else
        if SetCurrencyCode("Bal. Account Type","Bal. Account No.") then
          BankAcc.TESTFIELD("Currency Code","Currency Code")
        else
          "Currency Code" := BankAcc."Currency Code";
      "Gen. Posting Type" := 0;
      "Gen. Bus. Posting Group" := '';
      "Gen. Prod. Posting Group" := '';
      "VAT Bus. Posting Group" := '';
      "VAT Prod. Posting Group" := '';
    end;
*/


    
/*
LOCAL procedure GetBankBalAccount ()
    var
//       BankAcc@1000 :
      BankAcc: Record 270;
    begin
      BankAcc.GET("Bal. Account No.");
      BankAcc.TESTFIELD(Blocked,FALSE);
      if "Account No." = '' then
        Description := BankAcc.Name;
      if ("Account No." = '') or
         ("Account Type" IN
          ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
      then begin
        "Posting Group" := '';
        "Salespers./Purch. Code" := '';
        "Payment Terms Code" := '';
      end;
      if BankAcc."Currency Code" = '' then begin
        if "Account No." = '' then
          "Currency Code" := '';
      end else
        if SetCurrencyCode("Bal. Account Type","Bal. Account No.") then
          BankAcc.TESTFIELD("Currency Code","Currency Code")
        else
          "Currency Code" := BankAcc."Currency Code";
      "Bal. Gen. Posting Type" := 0;
      "Bal. Gen. Bus. Posting Group" := '';
      "Bal. Gen. Prod. Posting Group" := '';
      "Bal. VAT Bus. Posting Group" := '';
      "Bal. VAT Prod. Posting Group" := '';
    end;
*/


    
/*
LOCAL procedure GetFAAccount ()
    var
//       FA@1000 :
      FA: Record 5600;
    begin
      FA.GET("Account No.");
      FA.TESTFIELD(Blocked,FALSE);
      FA.TESTFIELD(Inactive,FALSE);
      FA.TESTFIELD("Budgeted Asset",FALSE);
      Description := FA.Description;
    end;
*/


    
/*
LOCAL procedure GetFABalAccount ()
    var
//       FA@1000 :
      FA: Record 5600;
    begin
      FA.GET("Bal. Account No.");
      FA.TESTFIELD(Blocked,FALSE);
      FA.TESTFIELD(Inactive,FALSE);
      FA.TESTFIELD("Budgeted Asset",FALSE);
      if "Account No." = '' then
        Description := FA.Description;
    end;
*/


    
/*
LOCAL procedure GetICPartnerAccount ()
    var
//       ICPartner@1000 :
      ICPartner: Record 413;
    begin
      ICPartner.GET("Account No.");
      ICPartner.CheckICPartner;
      Description := ICPartner.Name;
      if ("Bal. Account No." = '') or ("Bal. Account Type" = "Bal. Account Type"::"G/L Account") then
        "Currency Code" := ICPartner."Currency Code";
      if ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") and ("Currency Code" = '') then
        "Currency Code" := ICPartner."Currency Code";
      "Gen. Posting Type" := 0;
      "Gen. Bus. Posting Group" := '';
      "Gen. Prod. Posting Group" := '';
      "VAT Bus. Posting Group" := '';
      "VAT Prod. Posting Group" := '';
      "IC Partner Code" := "Account No.";
    end;
*/


    
/*
LOCAL procedure GetICPartnerBalAccount ()
    var
//       ICPartner@1000 :
      ICPartner: Record 413;
    begin
      ICPartner.GET("Bal. Account No.");
      if "Account No." = '' then
        Description := ICPartner.Name;

      if ("Account No." = '') or ("Account Type" = "Account Type"::"G/L Account") then
        "Currency Code" := ICPartner."Currency Code";
      if ("Account Type" = "Account Type"::"Bank Account") and ("Currency Code" = '') then
        "Currency Code" := ICPartner."Currency Code";
      "Bal. Gen. Posting Type" := 0;
      "Bal. Gen. Bus. Posting Group" := '';
      "Bal. Gen. Prod. Posting Group" := '';
      "Bal. VAT Bus. Posting Group" := '';
      "Bal. VAT Prod. Posting Group" := '';
      "IC Partner Code" := "Bal. Account No.";
    end;
*/


    
//     LOCAL procedure OnAfterCreateDimTableIDs (var StandardGenJournalLine@1000 : Record 751;FieldNo@1001 : Integer;var TableID@1003 : ARRAY [10] OF Integer;var No@1002 :
    
/*
LOCAL procedure OnAfterCreateDimTableIDs (var StandardGenJournalLine: Record 751;FieldNo: Integer;var TableID: ARRAY [10] OF Integer;var No: ARRAY [10] OF Code[20])
    begin
    end;

    /*begin
    //{
//      PGM 14/04/23: Q19273 Creado el campo "Piecework Code". Lo he creado con la numeraci¢n de QB porque el proceso de crear un diario estandar a partir de uno general lo hace con un transferfield
//    }
    end.
  */
}





