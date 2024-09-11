tableextension 50181 "QBU Cash Flow Worksheet LineExt" extends "Cash Flow Worksheet Line"
{


    CaptionML = ENU = 'Cash Flow Worksheet Line', ESP = 'L�nea de hoja flujos efectivo';

    fields
    {
        field(7000001; "Document Situation"; Option)
        {
            OptionMembers = " ","Posted BG/PO","Closed BG/PO","BG/PO","Cartera","Closed Documents";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Situation', ESP = 'Situaciï¿½n documento';
            OptionCaptionML = ENU = '" ,Posted BG/PO,Closed BG/PO,BG/PO,Cartera,Closed Documents"', ESP = '" ,Rem./Ord. pago regis.,Rem./Ord. pago cerrada,Rem./Ord. pago,Cartera,Docs. cerrados"';



        }
        field(7207270; "Job No."; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';


        }
        field(7207271; "Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment Method Code', ESP = 'C�d. forma pago';

            trigger OnValidate();
            VAR
                //                                                                 PaymentMethod@1000 :
                PaymentMethod: Record 289;
            BEGIN
            END;


        }
        field(7207272; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(7207273; "Piecework Code"; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Piecework Code', ESP = 'C�d. unidad de obra';


        }
        field(7207274; "Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Banco';
            Description = 'QB 1.09.22 JAV 06/10/21 Banco asociado al registro (si lo tiene)';


        }
        field(7207275; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe';
            Description = 'QB 1.09.22 JAV 06/10/21 Importe en la divisa del movimiento (si la tiene)';


        }
    }
    keys
    {
        // key(key1;"Line No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Cash Flow Forecast No.","Document No.")
        //  {
        /* SumIndexFields="Amount (LCY)";
  */
        // }
    }
    fieldgroups
    {
    }

    var
        //       DimMgt@1001 :
        DimMgt: Codeunit 408;





    /*
    trigger OnInsert();    begin
                   LOCKTABLE;
                   ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                   ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                 end;

    */




    /*
    procedure EmptyLine () : Boolean;
        begin
          exit(("Cash Flow Forecast No." = '') and ("Cash Flow Account No." = ''));
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
              "Dimension Set ID",STRSUBSTNO('%1',"Line No."),
              "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        end;
    */



    //     procedure MoveDefualtDimToJnlLineDim (TableID@1004 : Integer;No@1005 : Code[20];var DimensionSetID@1003 :

    /*
    procedure MoveDefualtDimToJnlLineDim (TableID: Integer;No: Code[20];var DimensionSetID: Integer)
        var
    //       TableID2@1000 :
          TableID2: ARRAY [10] OF Integer;
    //       No2@1002 :
          No2: ARRAY [10] OF Code[20];
    //       Dimension@1001 :
          Dimension: Code[10];
        begin
          TableID2[1] := TableID;
          No2[1] := No;
          Dimension := '';
          DimensionSetID :=
            DimMgt.GetRecDefaultDimID(
              Rec,CurrFieldNo,TableID2,No2,'',Dimension,Dimension,0,0);
        end;
    */




    /*
    procedure CalculateCFAmountAndCFDate ()
        var
    //       GeneralLedgerSetup@1004 :
          GeneralLedgerSetup: Record 98;
    //       PaymentTerms@1001 :
          PaymentTerms: Record 3;
    //       CashFlowForecast@1006 :
          CashFlowForecast: Record 840;
    //       PaymentTermsToApply@1000 :
          PaymentTermsToApply: Code[10];
    //       CFDiscountDate@1002 :
          CFDiscountDate: Date;
    //       CheckCrMemo@1003 :
          CheckCrMemo: Boolean;
    //       ApplyCFPaymentTerm@1007 :
          ApplyCFPaymentTerm: Boolean;
    //       DiscountDateCalculation@1005 :
          DiscountDateCalculation: DateFormula;
        begin
          if "Document Date" = 0D then
            "Document Date" := WORKDATE;
          if "Cash Flow Date" = 0D then
            "Cash Flow Date" := "Document Date";
          if "Amount (LCY)" = 0 then
            exit;

          CASE "Document Type" OF
            "Document Type"::Invoice:
              CheckCrMemo := FALSE;
            "Document Type"::"Credit Memo":
              CheckCrMemo := TRUE;
            else
              exit;
          end;

          if not CashFlowForecast.GET("Cash Flow Forecast No.") then
            exit;

          PaymentTermsToApply := "Payment Terms Code";
          ApplyCFPaymentTerm := CashFlowForecast."Consider CF Payment Terms" and PaymentTerms.GET(PaymentTermsToApply);
          if "Source Type" IN ["Source Type"::"Sales Orders","Source Type"::"Purchase Orders","Source Type"::"Service Orders",
                               "Source Type"::Job]
          then
            ApplyCFPaymentTerm := TRUE;

          if not ApplyCFPaymentTerm then begin
            if not CashFlowForecast."Consider Discount" then
              exit;

            if CashFlowForecast."Consider Pmt. Disc. Tol. Date" then
              CFDiscountDate := "Pmt. Disc. Tolerance Date"
            else
              CFDiscountDate := "Pmt. Discount Date";

            if CFDiscountDate <> 0D then begin
              if CFDiscountDate >= WORKDATE then begin
                "Cash Flow Date" := CFDiscountDate;
                "Amount (LCY)" := "Amount (LCY)" - "Payment Discount";
              end else
                "Payment Discount" := 0;
            end;

            exit;
          end;

          if not PaymentTerms.GET(PaymentTermsToApply) then
            exit;

          if CheckCrMemo and not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" then
            exit;

          if CashFlowForecast."Consider Discount" then begin
            GeneralLedgerSetup.GET;

            DiscountDateCalculation := PaymentTerms."Discount Date Calculation";
            if FORMAT(DiscountDateCalculation) = '' then
              DiscountDateCalculation := PaymentTerms."Due Date Calculation";
            CFDiscountDate := CALCDATE(DiscountDateCalculation,"Document Date");
            if CashFlowForecast."Consider Pmt. Disc. Tol. Date" then
              CFDiscountDate := CALCDATE(GeneralLedgerSetup."Payment Discount Grace Period",CFDiscountDate);

            if CFDiscountDate >= WORKDATE then begin
              "Cash Flow Date" := CFDiscountDate;
              "Payment Discount" := ROUND("Amount (LCY)" * PaymentTerms."Discount %" / 100);
              "Amount (LCY)" := "Amount (LCY)" - "Payment Discount";
            end else begin
              "Cash Flow Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
              "Payment Discount" := 0;
            end;
          end else
            "Cash Flow Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
        end;
    */



    /*
    procedure ShowSource ()
        var
    //       CFManagement@1000 :
          CFManagement: Codeunit 841;
        begin
          CFManagement.ShowSource(Rec);
        end;
    */




    /*
    procedure GetNumberOfSourceTypes () : Integer;
        begin
          exit(16);
        end;

        /*begin
        //{
    //      Se cambia la numeraci�n de campos 50000 al rango de QuoBuilding
    //    }
        end.
      */
}





