table 7206942 "QPR TMP Amounts"
{
  
  
    CaptionML=ENU='Budget Amounts',ESP='Importes Presupuesto';
    LookupPageID="QPR TMP Budget Data Amounts";
    DrillDownPageID="QPR TMP Budget Data Amounts";
  
  fields
{
    field(1;"Entry No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ Registro';


    }
    field(2;"Expected Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Expected Date',ESP='Fecha prevista';
                                                   Description='QR15703';


    }
    field(10;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto';


    }
    field(11;"Budget Code";Code[20])
    {
        CaptionML=ENU='Line No.',ESP='N§ Presupuesto';


    }
    field(12;"Piecework code";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."));
                                                   CaptionML=ENU='Cod. unidad de obra',ESP='C¢d. unidad de obra';


    }
    field(13;"Type";Option)
    {
        OptionMembers="Cost","Sales";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo';
                                                   OptionCaptionML=ENU='Cost,Sales',ESP='Gastos,Ingresos';
                                                   


    }
    field(20;"Cost Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Coste';


    }
    field(21;"Sale Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Venta';


    }
}
  keys
{
    key(key1;"Entry No.")
    {
        Clustered=true;
    }
    key(key2;"Job No.","Budget Code","Piecework code","Type")
    {
        ;
    }
}
  fieldgroups
{
}
  
    var
//       TMPExpectedTimeUnitData@1100286000 :
      TMPExpectedTimeUnitData: Record 7206942;
//       DataPieceworkForProduction@1100286001 :
      DataPieceworkForProduction: Record 7207386;

    

trigger OnInsert();    begin
               //if "Expected Date"=0D then
               //  "Expected Date":=TODAY;
             end;



procedure SetData ()
    begin
      //Decimales := 0.0001;


        if (Rec."Entry No." = 0) then begin
          TMPExpectedTimeUnitData.RESET;
          if TMPExpectedTimeUnitData.FINDLAST then
            Rec."Entry No." := TMPExpectedTimeUnitData."Entry No." + 1
          else
            Rec."Entry No." := 1;
        end;

        DataPieceworkForProduction.GET("Job No.", "Piecework code");
        if (DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Heading) then begin
          //Rec."Budget Measure"     := 0;
          //Rec."Budget Sale Amount" := 0;
          //Rec."Budget Cost Amount" := 0;
          Rec."Cost Amount" := 0;
          Rec."Sale Amount" := 0;
        end else begin
          DataPieceworkForProduction.SETFILTER("Budget Filter","Budget Code");
          DataPieceworkForProduction.CALCFIELDS("Budget Measure","Amount Production Budget","Amount Cost Budget (JC)");
          //Rec."Budget Measure"     := DataPieceworkForProduction."Budget Measure";
          //Rec."Budget Sale Amount" := DataPieceworkForProduction."Amount Production Budget";
          //Rec."Budget Cost Amount" := DataPieceworkForProduction."Amount Cost Budget (JC)";
          //Rec."Cost Amount" := DataPieceworkForProduction."QPR Cost Amount";
          //Rec."Sale Amount" := DataPieceworkForProduction."QPR Sale Amount";
        end;
        //{
//        if (Rec."Budget Measure" <> 0) then begin
//          Rec."Expected Cost Amount"       := ROUND(Rec."Budget Cost Amount" * Rec."Expected Measured Amount" / Rec."Budget Measure",Decimales);
//          Rec."Expected Production Amount" := ROUND(Rec."Budget Sale Amount" * Rec."Expected Measured Amount" / Rec."Budget Measure",Decimales);
//          Rec."Expected Percentage"        := ROUND(100                      * Rec."Expected Measured Amount" / Rec."Budget Measure",Decimales);
//        end else begin
//          Rec."Expected Cost Amount" := 0;
//          Rec."Expected Production Amount" := 0;
//          Rec."Expected Percentage" := 0;
//        end;
//        }
    end;

    /*begin
    end.
  */
}







