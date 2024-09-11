tableextension 50182 "MyExtension50182" extends "Cash Flow Forecast Entry"
{


    CaptionML = ENU = 'Cash Flow Forecast Entry', ESP = 'Mov. previsi�n flujos efectivo';
    LookupPageID = "Cash Flow Forecast Entries";
    DrillDownPageID = "Cash Flow Forecast Entries";

    fields
    {
        field(50010; "OLD_Job No."; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';
            Description = '### ELIMINAR ###';


        }
        field(50011; "OLD_Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment Method Code', ESP = 'C�d. forma pago';
            Description = '### ELIMINAR ###';

            trigger OnValidate();
            VAR
                //                                                                 PaymentMethod@1000 :
                PaymentMethod: Record 289;
            BEGIN
            END;


        }
        field(50012; "OLD_Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Description = '### ELIMINAR ###';
            Editable = false;


        }
        field(50013; "OLD_Piecework Code"; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Piecework Code', ESP = 'C�d. unidad de obra';
            Description = '### ELIMINAR ###';


        }

        field(7000001; "Document Situation"; Option)
        {
            OptionMembers = " ","Posted BG/PO","Closed BG/PO","BG/PO","Cartera","Closed Documents";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Situation', ESP = 'Situaciï¿½n documento';
            OptionCaptionML = ENU = '" ,Posted BG/PO,Closed BG/PO,BG/PO,Cartera,Closed Documents"', ESP = '" ,Rem./Ord. pago regis.,Rem./Ord. pago cerrada,Rem./Ord. pago,Cartera,Docs. cerrados"';



        }

        field(7207270; "QB Job No."; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';


        }
        field(7207271; "QB Payment Method Code"; Code[10])
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
        field(7207272; "QB Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(7207273; "QB Piecework Code"; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Piecework Code', ESP = 'C�d. unidad de obra';


        }
        field(7207274; "QB Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Banco';
            Description = 'QB 1.09.22 JAV 06/10/21 Banco asociado al registro (si lo tiene)';


        }
        field(7207275; "QB Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe';
            Description = 'QB 1.09.22 JAV 06/10/21 Importe en la divisa del movimiento (si la tiene)';


        }
    }
    keys
    {
        // key(key1;"Entry No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Cash Flow Account No.","Cash Flow Date","Cash Flow Forecast No.")
        //  {
        /* SumIndexFields="Amount (LCY)";
  */
        // }
        // key(key3;"Cash Flow Forecast No.","Cash Flow Account No.","Source Type","Cash Flow Date","Positive")
        //  {
        /* SumIndexFields="Amount (LCY)","Payment Discount";
  */
        // }
        // key(key4;"Cash Flow Account No.","Cash Flow Forecast No.","Global Dimension 1 Code","Global Dimension 2 Code","Cash Flow Date")
        //  {
        /* SumIndexFields="Amount (LCY)","Payment Discount";
  */
        // }
    }
    fieldgroups
    {
        // fieldgroup(DropDown;"Entry No.","Description","Cash Flow Account No.","Cash Flow Date","Source Type")
        // {
        // 
        // }
    }




    /*
    procedure ShowDimensions ()
        var
    //       DimMgt@1000 :
          DimMgt: Codeunit 408;
        begin
          DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
        end;
    */



    //     procedure DrillDownOnEntries (var CashFlowForecast@1000 :

    /*
    procedure DrillDownOnEntries (var CashFlowForecast: Record 840)
        var
    //       CFForecastEntry@1002 :
          CFForecastEntry: Record 847;
        begin
          CFForecastEntry.SETRANGE("Cash Flow Forecast No.",CashFlowForecast."No.");
          CashFlowForecast.COPYFILTER("Cash Flow Date Filter",CFForecastEntry."Cash Flow Date");
          CashFlowForecast.COPYFILTER("Source Type Filter",CFForecastEntry."Source Type");
          CashFlowForecast.COPYFILTER("Account No. Filter",CFForecastEntry."Cash Flow Account No.");
          CashFlowForecast.COPYFILTER("Positive Filter",CFForecastEntry.Positive);
          PAGE.RUN(0,CFForecastEntry);
        end;
    */


    //     procedure ShowSource (ShowDocument@1001 :

    /*
    procedure ShowSource (ShowDocument: Boolean)
        var
    //       CFManagement@1000 :
          CFManagement: Codeunit 841;
        begin
          if ShowDocument then
            CFManagement.ShowSourceDocument(Rec)
          else
            CFManagement.ShowSource(Rec);
        end;

        /*begin
        //{
    //      JAV 24/11/21: - QB 1.10.01 Se cambian variables 50000 al rango de QB
    //    }
        end.
      */
}




