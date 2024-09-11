table 7207297 "QBU Allocation Term"
{
  
  
    CaptionML=ENU='Allocation Term',ESP='Periodo de imputaci¢n';
    LookupPageID="Allocation Term List";
    DrillDownPageID="Allocation Term List";
  
  fields
{
    field(1;"Code";Code[10])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[30])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(3;"Initial Date";Date)
    {
        CaptionML=ENU='Initial Date',ESP='Fecha inicial';


    }
    field(4;"Final Date";Date)
    {
        

                                                   CaptionML=ENU='Final Date',ESP='Fecha final';

trigger OnValidate();
    BEGIN 
                                                                AllocationTerm := Rec;
                                                                IF AllocationTerm.NEXT() <> 0 THEN
                                                                  IF AllocationTerm."Initial Date" <= "Final Date" THEN
                                                                    ERROR(Text003);
                                                              END;


    }
    field(5;"Period Type";Option)
    {
        OptionMembers="Winter","Summer";CaptionML=ENU='Period Type',ESP='Tipo periodo';
                                                   


    }
}
  keys
{
    key(key1;"Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       AllocationTerm@7001100 :
      AllocationTerm: Record 7207297;
//       JobLedgerEntry@7001101 :
      JobLedgerEntry: Record 169;
//       AllocationTermDays@7001102 :
      AllocationTermDays: Record 7207295;
//       Text001@7001103 :
      Text001: TextConst ENU='You can not delete the imputation period because there are movements',ESP='No se puede eliminar el periodo de imputaci¢n por que existen movimientos';
//       Text003@7001104 :
      Text003: TextConst ENU='Final date overlaps with next record',ESP='La fecha final se solapa con el registro siguiente';

    

trigger OnDelete();    begin
               JobLedgerEntry.RESET;
               JobLedgerEntry.SETRANGE("Posting Date","Initial Date","Final Date");
               if JobLedgerEntry.FINDFIRST then
                 ERROR(Text001);

               // Borro la tabla de los d¡as que tienen un periodo.
               AllocationTermDays.SETRANGE(AllocationTermDays."Allocation Term",AllocationTerm.Code);
               AllocationTermDays.DELETEALL(TRUE);
             end;



/*begin
    end.
  */
}







