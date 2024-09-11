tableextension 50180 "QBU Cash Flow SetupExt" extends "Cash Flow Setup"
{

    /*
  Permissions=TableData 1261 rimd;
  */
    CaptionML = ENU = 'Cash Flow Setup', ESP = 'Configuraci�n flujos efectivo';

    fields
    {
        field(7207270; "WorkShoop CF Account No."; Code[20])
        {
            TableRelation = "Cash Flow Account";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Receivables CF Account No.', ESP = 'N� cta. flujos efectivo Partes Trabajo';
            Description = 'QB 1.09.22 - JAV 25/10/21 Cuenta para Partes de trabajo';

            trigger OnValidate();
            BEGIN
                //To be REfactored by EU TEam
                CheckAccType2("WorkShoop CF Account No.");
            END;


        }
        field(7207271; "Paysheet CF Account No."; Code[20])
        {
            TableRelation = "Cash Flow Account";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Receivables CF Account No.', ESP = 'N� cta. flujos efectivo N�minas';
            Description = 'QB 1.09.22 - JAV 25/10/21 Cuenta para N�minas';

            trigger OnValidate();
            BEGIN
                //To be refactored by EU TEam
                CheckAccType2("Paysheet CF Account No.");
            END;


        }
    }
    keys
    {
        // key(key1;"Primary Key")
        //  {
        /* Clustered=true;
  */
        // }
    }
    fieldgroups
    {
    }

    var
        //       Text001@1000 :
        Text001:
// Cash Flow <No.> <Description> is shown in the chart on the Role Center.
TextConst ENU = 'Cash Flow Forecast %1 %2 is shown in the chart on the Role Center. Do you want to show this Cash Flow Forecast instead?', ESP = 'La previsi�n de flujo de efectivo %1 %2 se muestra en el gr�fico del �rea de trabajo. �Desea ver la previsi�n de flujo de efectivo en su lugar?';
        //       AzureKeyVaultManagement@1001 :
        AzureKeyVaultManagement: Codeunit 2200;

    //     LOCAL procedure CheckAccType (Code@1000 :


    LOCAL procedure CheckAccType2(Code: Code[20])
    var
        //       CFAccount@1001 :
        CFAccount: Record 841;
    begin
        if Code <> '' then begin
            CFAccount.GET(Code);
            CFAccount.TESTFIELD("Account Type", CFAccount."Account Type"::Entry);
        end;
    end;




    //     procedure SetChartRoleCenterCFNo (CashFlowNo@1000 :

    /*
    procedure SetChartRoleCenterCFNo (CashFlowNo: Code[20])
        begin
          GET;
          "CF No. on Chart in Role Center" := CashFlowNo;
          MODIFY;
        end;
    */




    /*
    procedure GetChartRoleCenterCFNo () : Code[20];
        begin
          GET;
          exit("CF No. on Chart in Role Center");
        end;
    */


    //     LOCAL procedure ConfirmedChartRoleCenterCFNo (NewCashFlowNo@1000 :

    /*
    LOCAL procedure ConfirmedChartRoleCenterCFNo (NewCashFlowNo: Code[20]) : Boolean;
        var
    //       CashFlowForecast@1001 :
          CashFlowForecast: Record 840;
        begin
          if NewCashFlowNo = '' then
            exit(TRUE);

          if not (xRec."CF No. on Chart in Role Center" IN ['',NewCashFlowNo]) then begin
            CashFlowForecast.GET(xRec."CF No. on Chart in Role Center");
            exit(CONFIRM(STRSUBSTNO(Text001,CashFlowForecast."No.",CashFlowForecast.Description),TRUE));
          end;
          exit(TRUE);
        end;
    */



    //     procedure GetTaxPaymentDueDate (ReferenceDate@1000 :

    /*
    procedure GetTaxPaymentDueDate (ReferenceDate: Date) : Date;
        var
    //       EndOfTaxPeriod@1002 :
          EndOfTaxPeriod: Date;
        begin
          GET;
          EndOfTaxPeriod := CalculateTaxableDate(ReferenceDate,TRUE);
          exit(CALCDATE("Tax Payment Window",EndOfTaxPeriod));
        end;
    */



    //     procedure GetTaxPeriodStartEndDates (TaxDueDate@1000 : Date;var StartDate@1001 : Date;var EndDate@1002 :

    /*
    procedure GetTaxPeriodStartEndDates (TaxDueDate: Date;var StartDate: Date;var EndDate: Date)
        begin
          GET;
          EndDate := GetTaxPeriodEndDate(TaxDueDate);
          StartDate := CalculateTaxableDate(EndDate,FALSE);
        end;
    */



    //     procedure GetTaxPaymentStartDate (TaxDueDate@1000 :

    /*
    procedure GetTaxPaymentStartDate (TaxDueDate: Date) : Date;
        begin
          GET;
          exit(CALCDATE('<1D>',GetTaxPeriodEndDate(TaxDueDate)));
        end;
    */



    //     procedure GetTaxPeriodEndDate (TaxDueDate@1000 :

    /*
    procedure GetTaxPeriodEndDate (TaxDueDate: Date) : Date;
        var
    //       ReverseDateFormula@1001 :
          ReverseDateFormula: DateFormula;
        begin
          GET;
          EVALUATE(ReverseDateFormula,ReverseDateFormulaAsText);
          exit(CALCDATE(ReverseDateFormula,TaxDueDate));
        end;
    */




    /*
    procedure GetCurrentPeriodStartDate () : Date;
        begin
          GET;
          exit(CalculateTaxableDate(WORKDATE,FALSE));
        end;
    */




    /*
    procedure GetCurrentPeriodEndDate () : Date;
        begin
          GET;
          exit(CalculateTaxableDate(WORKDATE,TRUE));
        end;
    */



    //     procedure UpdateTaxPaymentInfo (NewTaxablePeriod@1002 : Option;NewPaymentWindow@1000 : DateFormula;NewTaxBalAccountType@1004 : Option;NewTaxBalAccountNum@1001 :

    /*
    procedure UpdateTaxPaymentInfo (NewTaxablePeriod: Option;NewPaymentWindow: DateFormula;NewTaxBalAccountType: Option;NewTaxBalAccountNum: Code[20])
        var
    //       Modified@1003 :
          Modified: Boolean;
        begin
          GET;
          if "Taxable Period" <> NewTaxablePeriod then begin
            "Taxable Period" := NewTaxablePeriod;
            Modified := TRUE;
          end;

          if "Tax Payment Window" <> NewPaymentWindow then begin
            "Tax Payment Window" := NewPaymentWindow;
            Modified := TRUE;
          end;

          if "Tax Bal. Account Type" <> NewTaxBalAccountType then begin
            "Tax Bal. Account Type" := NewTaxBalAccountType;
            Modified := TRUE;
          end;

          if "Tax Bal. Account No." <> NewTaxBalAccountNum then begin
            "Tax Bal. Account No." := NewTaxBalAccountNum;
            Modified := TRUE;
          end;

          if Modified then
            MODIFY;
        end;
    */


    //     LOCAL procedure CalculateTaxableDate (ReferenceDate@1000 : Date;FindLast@1001 :

    /*
    LOCAL procedure CalculateTaxableDate (ReferenceDate: Date;FindLast: Boolean) Result : Date;
        var
    //       AccountingPeriod@1003 :
          AccountingPeriod: Record 50;
        begin
          CASE "Taxable Period" OF
            "Taxable Period"::Monthly:
              if FindLast then
                Result := CALCDATE('<CM>',ReferenceDate)
              else
                Result := CALCDATE('<-CM>',ReferenceDate);
            "Taxable Period"::Quarterly:
              if FindLast then
                Result := CALCDATE('<CQ>',ReferenceDate)
              else
                Result := CALCDATE('<-CQ>',ReferenceDate);
            "Taxable Period"::"Accounting Period":
              if FindLast then begin
                // The end of the current accounting period is the start of the next acc. period - 1 day
                AccountingPeriod.SETFILTER("Starting Date",'>%1',ReferenceDate);
                AccountingPeriod.FINDFIRST;
                Result := AccountingPeriod."Starting Date" - 1;
              end else begin
                // The end of the current accounting period is the start of the next acc. period - 1 day
                AccountingPeriod.SETFILTER("Starting Date",'<=%1',ReferenceDate);
                AccountingPeriod.FINDFIRST;
                Result := AccountingPeriod."Starting Date";
              end;
            "Taxable Period"::Yearly:
              if FindLast then
                Result := CALCDATE('<CY>',ReferenceDate)
              else
                Result := CALCDATE('<-CY>',ReferenceDate);
          end;
        end;
    */



    /*
    LOCAL procedure ReverseDateFormulaAsText () Result : Text;
        var
    //       TempChar@1000 :
          TempChar: Char;
        begin
          Result := FORMAT("Tax Payment Window");
          if Result = '' then
            exit('');

          if not (COPYSTR(Result,1,1) IN ['+','-']) then
            Result := '+' + Result;

          TempChar := '#';
          Result := ReplaceCharInString(Result,'+',TempChar);
          Result := ReplaceCharInString(Result,'-','+');
          Result := ReplaceCharInString(Result,TempChar,'-');
        end;
    */


    //     LOCAL procedure ReplaceCharInString (StringToReplace@1000 : Text;OldChar@1001 : Char;NewChar@1002 :

    /*
    LOCAL procedure ReplaceCharInString (StringToReplace: Text;OldChar: Char;NewChar: Char) Result : Text;
        var
    //       Index@1005 :
          Index: Integer;
    //       FirstPart@1003 :
          FirstPart: Text;
    //       LastPart@1004 :
          LastPart: Text;
        begin
          Index := STRPOS(StringToReplace,FORMAT(OldChar));
          Result := StringToReplace;
          WHILE Index > 0 DO begin
            if Index > 1 then
              FirstPart := COPYSTR(Result,1,Index - 1);
            if Index < STRLEN(Result) then
              LastPart := COPYSTR(Result,Index + 1);
            Result := FirstPart + FORMAT(NewChar) + LastPart;
            Index := STRPOS(Result,FORMAT(OldChar));
          end;
        end;
    */




    /*
    procedure HasValidTaxAccountInfo () : Boolean;
        begin
          exit("Tax Bal. Account Type" <> "Tax Bal. Account Type"::" ");
        end;
    */



    //     procedure EmptyTaxBalAccountIfTypeChanged (OldTypeValue@1000 :

    /*
    procedure EmptyTaxBalAccountIfTypeChanged (OldTypeValue: Option)
        begin
          if "Tax Bal. Account Type" <> OldTypeValue then
            "Tax Bal. Account No." := '';
        end;
    */



    //     procedure SaveUserDefinedAPIKey (APIKeyValue@1000 :

    /*
    procedure SaveUserDefinedAPIKey (APIKeyValue: Text[250])
        var
    //       ServicePassword@1002 :
          ServicePassword: Record 1261;
        begin
          if ISNULLGUID("Service Pass API Key ID") or not ServicePassword.GET("Service Pass API Key ID") then begin
            ServicePassword.SavePassword(APIKeyValue);
            ServicePassword.INSERT(TRUE);
            "Service Pass API Key ID" := ServicePassword.Key;
          end else begin
            ServicePassword.SavePassword(APIKeyValue);
            ServicePassword.MODIFY;
          end;
        end;
    */



    //     procedure GetMLCredentials (var APIURL@1003 : Text[250];var APIKey@1002 : Text[200];var LimitValue@1001 : Decimal;var UsingStandardCredentials@1005 :

    /*
    procedure GetMLCredentials (var APIURL: Text[250];var APIKey: Text[200];var LimitValue: Decimal;var UsingStandardCredentials: Boolean) : Boolean;
        var
    //       ServicePassword@1000 :
          ServicePassword: Record 1261;
    //       PermissionManager@1004 :
          PermissionManager: Codeunit 9002;
        begin
          // user-defined credentials
          if IsAPIUserDefined then begin
            ServicePassword.GET("Service Pass API Key ID");
            APIKey := COPYSTR(ServicePassword.GetPassword,1,200);
            if (APIKey = '') or ("API URL" = '') then
              exit(FALSE);
            APIURL := "API URL";
            UsingStandardCredentials := FALSE;
            exit(TRUE);
          end;

          UsingStandardCredentials := TRUE;
          // if credentials not user-defined retrieve it from Azure Key Vault
          if PermissionManager.SoftwareAsAService then
            exit(RetrieveSaaSMLCredentials(APIURL,APIKey,LimitValue));
        end;
    */


    //     LOCAL procedure RetrieveSaaSMLCredentials (var APIURL@1003 : Text[250];var APIKey@1002 : Text[200];var LimitValue@1001 :

    /*
    LOCAL procedure RetrieveSaaSMLCredentials (var APIURL: Text[250];var APIKey: Text[200];var LimitValue: Decimal) : Boolean;
        var
    //       LimitType@1000 :
          LimitType: Option;
        begin
          if not AzureKeyVaultManagement.GetMLForecastCredentials(APIURL,APIKey,LimitType,LimitValue) then
            exit(FALSE);
          APIURL := APIURL + '/execute?api-version=2.0&details=true';
          exit(TRUE);
        end;
    */



    /*
    LOCAL procedure EnableEncryption ()
        var
    //       EncryptionManagement@1000 :
          EncryptionManagement: Codeunit 1266;
        begin
          if not EncryptionManagement.IsEncryptionEnabled then
            EncryptionManagement.EnableEncryption;
        end;
    */




    /*
    procedure GetUserDefinedAPIKey () : Text[200];
        var
    //       ServicePassword@1000 :
          ServicePassword: Record 1261;
        begin
          // user-defined credentials
          if not ISNULLGUID("Service Pass API Key ID") then begin
            ServicePassword.GET("Service Pass API Key ID");
            exit(COPYSTR(ServicePassword.GetPassword,1,200));
          end;
        end;
    */




    /*
    procedure IsAPIUserDefined () : Boolean;
        begin
          exit(not (ISNULLGUID("Service Pass API Key ID") or ("API URL" = '')));
        end;

        /*begin
        end.
      */
}





