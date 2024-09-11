tableextension 50148 "MyExtension50148" extends "Acc. Sched. KPI Buffer"
{
  
  /*
ReplicateData=false;
*/
    CaptionML=ENU='Acc. Sched. KPI Buffer',ESP='B£fer de KPI de esquema de cuentas';
  
  fields
{
    field(7207270;"QB Line No.";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Acc. Schedule Line"."Line No." WHERE ("Schedule Name"=FIELD("Account Schedule Name"),
                                                                                                             "Row No."=FIELD("KPI Code")));
                                                   CaptionML=ESP='N§ L¡nea';


    }
}
  keys
{
   // key(key1;"No.")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  

    
    // procedure AddColumnValue (ColumnLayout@1000 : Record 334;Value@1001 :

/*
procedure AddColumnValue (ColumnLayout: Record 334;Value: Decimal)
    var
//       PreviousFiscalYearFormula@1002 :
      PreviousFiscalYearFormula: DateFormula;
    begin
      EVALUATE(PreviousFiscalYearFormula,'<-1Y>');
      if ColumnLayout."Column Type" = ColumnLayout."Column Type"::"Net Change" then
        if ColumnLayout."Ledger Entry Type" = ColumnLayout."Ledger Entry Type"::Entries then
          if FORMAT(ColumnLayout."Comparison Date Formula") = FORMAT(PreviousFiscalYearFormula) then
            "Net Change Actual Last Year" += Value
          else
            "Net Change Actual" += Value
        else
          if FORMAT(ColumnLayout."Comparison Date Formula") = FORMAT(PreviousFiscalYearFormula) then
            "Net Change Budget Last Year" += Value
          else
            "Net Change Budget" += Value
      else
        if ColumnLayout."Ledger Entry Type" = ColumnLayout."Ledger Entry Type"::Entries then
          if FORMAT(ColumnLayout."Comparison Date Formula") = FORMAT(PreviousFiscalYearFormula) then
            "Balance at Date Act. Last Year" += Value
          else
            "Balance at Date Actual" += Value
        else
          if FORMAT(ColumnLayout."Comparison Date Formula") = FORMAT(PreviousFiscalYearFormula) then
            "Balance at Date Bud. Last Year" += Value
          else
            "Balance at Date Budget" += Value;
    end;
*/


    
//     procedure GetColumnValue (ColumnLayout@1000 :
    
/*
procedure GetColumnValue (ColumnLayout: Record 334) Result : Decimal;
    var
//       PreviousFiscalYearFormula@1001 :
      PreviousFiscalYearFormula: DateFormula;
    begin
      EVALUATE(PreviousFiscalYearFormula,'<-1Y>');
      if ColumnLayout."Column Type" = ColumnLayout."Column Type"::"Net Change" then
        if ColumnLayout."Ledger Entry Type" = ColumnLayout."Ledger Entry Type"::Entries then
          if FORMAT(ColumnLayout."Comparison Date Formula") = FORMAT(PreviousFiscalYearFormula) then
            Result := "Net Change Actual Last Year"
          else
            Result := "Net Change Actual"
        else
          if FORMAT(ColumnLayout."Comparison Date Formula") = FORMAT(PreviousFiscalYearFormula) then
            Result := "Net Change Budget Last Year"
          else
            Result := "Net Change Budget"
      else
        if ColumnLayout."Ledger Entry Type" = ColumnLayout."Ledger Entry Type"::Entries then
          if FORMAT(ColumnLayout."Comparison Date Formula") = FORMAT(PreviousFiscalYearFormula) then
            Result := "Balance at Date Act. Last Year"
          else
            Result := "Balance at Date Actual"
        else
          if FORMAT(ColumnLayout."Comparison Date Formula") = FORMAT(PreviousFiscalYearFormula) then
            Result := "Balance at Date Bud. Last Year"
          else
            Result := "Balance at Date Budget";
      exit(Result)
    end;

    /*begin
    //{
//      JAV 10/06/21: - QB 1.09.17 Se a¤ade el campo 7207270 "QB Line No." para poder ordenar correctamente las l¡neas
//    }
    end.
  */
}




