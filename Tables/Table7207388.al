table 7207388 "QBU Expected Time Unit Data"
{
  
  
    CaptionML=ENU='Expected Time Unit Data',ESP='Datos previsi¢n unid. tiempo';
    LookupPageID="Estimate";
    DrillDownPageID="Estimate";
  
  fields
{
    field(1;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto';


    }
    field(2;"Expected Date";Date)
    {
        CaptionML=ENU='Expected Date',ESP='Fecha prevista';


    }
    field(3;"Expected Measured Amount";Decimal)
    {
        CaptionML=ENU='Expected Measured Amount',ESP='Cantidad medici¢n prevista';


    }
    field(4;"Budget Code";Code[20])
    {
        TableRelation="Job Budget"."Cod. Budget" WHERE ("Job No."=FIELD("Job No."));
                                                   ValidateTableRelation=false;
                                                   CaptionML=ENU='Budget Code',ESP='C¢d. Presupuesto';


    }
    field(5;"Piecework Code";Text[20])
    {
        CaptionML=ENU='Piecework Code',ESP='C¢d. unidad de obra';


    }
    field(6;"Entry No.";Integer)
    {
        CaptionML=ENU='Entry No.',ESP='N§ Mov';


    }
    field(7;"Unit Type";Option)
    {
        OptionMembers="Piecework","Cost Unit","Investment Unit","Certification";CaptionML=ENU='Unit Type',ESP='Tipo unidad';
                                                   OptionCaptionML=ENU='Piecework,Cost Unit,Investment Unit,Certification',ESP='Unidad de obra,Unidad de coste,Unidad de inversi¢n,Certificaci¢n';
                                                   


    }
    field(8;"Incluided In Dispatch";Boolean)
    {
        CaptionML=ENU='Incluided In Dispatch',ESP='Incluido en parte';


    }
    field(9;"Doc. Dispatch No.";Code[20])
    {
        CaptionML=ENU='Doc. Dispatch No.',ESP='N§ doc. parte';


    }
    field(10;"Description";Text[50])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(11;"Cost Database Code";Code[20])
    {
        CaptionML=ENU='Cost Database Code',ESP='C¢d. preciario';


    }
    field(12;"Unique Code";Code[30])
    {
        CaptionML=ENU='Unique Code',ESP='C¢digo £nico';
                                                   Description='QB- Ampliado para importar m s niveles en BC3';


    }
    field(13;"Performed";Boolean)
    {
        CaptionML=ENU='Performed',ESP='Realizado';


    }
    field(14;"Record No.";Code[20])
    {
        CaptionML=ENU='Record No.',ESP='N§ Expediente';


    }
    field(15;"U. Posting Code";Code[20])
    {
        CaptionML=ENU='U. Posting Code',ESP='Cod. U. Auxiliar'; ;


    }
}
  keys
{
    key(key1;"Entry No.")
    {
        Clustered=true;
    }
    key(key2;"Job No.","Piecework Code","Budget Code")
    {
        SumIndexFields="Expected Measured Amount";
    }
    key(key3;"Job No.","Piecework Code","Budget Code","Expected Date")
    {
        SumIndexFields="Expected Measured Amount";
    }
    key(key4;"Job No.","Piecework Code","Budget Code","Expected Date","Performed")
    {
        SumIndexFields="Expected Measured Amount";
    }
    key(key5;"Job No.","Piecework Code","Expected Date")
    {
        SumIndexFields="Expected Measured Amount";
    }
    key(key6;"Job No.","Piecework Code","Expected Date","Budget Code","U. Posting Code")
    {
        SumIndexFields="Expected Measured Amount";
    }
    key(key7;"Job No.","Piecework Code","Budget Code","Performed")
    {
        ;
    }
}
  fieldgroups
{
}
  
    var
//       DataPieceworkForProduction@7001100 :
      DataPieceworkForProduction: Record 7207386;

    

trigger OnInsert();    var
//                Fecha@1100286000 :
               Fecha: Date;
//                JobBudget@1100286001 :
               JobBudget: Record 7207407;
//                Fecha2@1100286002 :
               Fecha2: Date;
             begin

               //-Q19564
               //if "Expected Date"=0D then
               //  "Expected Date":=WORKDATE;   //AML 02/06/22: - QB 1.10.49 Se cambia TODAY por WorkDate que es mas apropiado para los nuevos registros
               if "Expected Date"=0D then begin
                  if DataPieceworkForProduction.GET("Job No.","Piecework Code") then begin
                     JobBudget.GET("Job No.","Budget Code");
                     if DataPieceworkForProduction."Date init" <> 0D then begin
                       Fecha := CALCDATE('PM',DataPieceworkForProduction."Date init");
                       if DataPieceworkForProduction."Date end" <> 0D then Fecha2 := CALCDATE('PM',DataPieceworkForProduction."Date end") else Fecha2 := Fecha;
                       if Fecha < JobBudget."Budget Date" then
                       repeat
                         Fecha := CALCDATE('1M',Fecha);
                       until (Fecha >= JobBudget."Budget Date") or (Fecha > Fecha2);
                       "Expected Date" := Fecha;
                     end
                     else "Expected Date" := WORKDATE;
                  end;
               end;
               //-Q19564
             end;



// procedure CostAmountBudget (var LOCExpectedTimeUnitData@1000 :
procedure CostAmountBudget (var LOCExpectedTimeUnitData: Record 7207388) : Decimal;
    begin
      DataPieceworkForProduction.RESET;
      DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.",DataPieceworkForProduction."Job No.");
      DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Piecework Code",LOCExpectedTimeUnitData."Piecework Code");
      if DataPieceworkForProduction.FINDFIRST then
        DataPieceworkForProduction.CALCFIELDS(DataPieceworkForProduction."Aver. Cost Price Pend. Budget");
      exit("Expected Measured Amount" * DataPieceworkForProduction."Aver. Cost Price Pend. Budget");
    end;

    /*begin
    //{
//      CPA 29/03/22: - 1.10.35 (Q16867) Mejora de rendimiento. Nueva clave: Job No.,Piecework Code,Expected Date,Budget Code,U. Posting Code
//      CPA 20/04/22: - 1.10.37 (Q17004) Mejora del rendimiento del proceso de reestimaciones. Nueva clave: Job No.,Piecework Code,Budget Code,Expected Date
//      JAV 25/05/22: - QB 1.10.43 Mejora del rendimiento, se a¤aden keys
//                            Job No.,Piecework Code,Budget Code,Performed
//                            Job No.,Budget Code
//      AML 02/06/22: - QB 1.10.49 Se cambia TODAY por WorkDate que es mas apropiado para los nuevos registros
//      AML 18/07/23: - Q19564 Buscar la fecha correctamente.
//    }
    end.
  */
}







