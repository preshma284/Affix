table 7207295 "Allocation Term - Days"
{
  
  
    CaptionML=ENU='Allocatiom Term - Days',ESP='Per. imputaci¢n - d¡as';
    LookupPageID="Allocation Term - Day List";
    DrillDownPageID="Allocation Term - Day List";
  
  fields
{
    field(1;"Allocation Term";Code[10])
    {
        TableRelation="Allocation Term"."Code";
                                                   

                                                   CaptionML=ENU='Allocation Term',ESP='Periodo de imputaci¢n';
                                                   Editable=true;

trigger OnValidate();
    BEGIN 
                                                                IF AllocationTerm.GET("Allocation Term") THEN
                                                                  Workday := AllocationTerm."Period Type";
                                                              END;


    }
    field(2;"Day";Date)
    {
        

                                                   CaptionML=ENU='Day',ESP='D¡a';
                                                   NotBlank=true;

trigger OnValidate();
    BEGIN 
                                                                IF AllocationTerm.GET("Allocation Term") THEN
                                                                  IF Day IN [AllocationTerm."Initial Date".. AllocationTerm."Final Date"] THEN BEGIN 
                                                                  END ELSE BEGIN 
                                                                    ERROR(Text001,Day,"Allocation Term");
                                                                END ELSE
                                                                  ERROR(Text002,"Allocation Term");
                                                              END;


    }
    field(3;"Workday";Option)
    {
        OptionMembers="Winter","Summer";InitValue="Winter";
                                                   CaptionML=ENU='Workday',ESP='Jornada laboral';
                                                   OptionCaptionML=ENU='Winter,Summer',ESP='Invierno,Verano';
                                                   


    }
    field(4;"Holiday";Boolean)
    {
        

                                                   CaptionML=ENU='Holiday',ESP='Festivo';

trigger OnValidate();
    BEGIN 
                                                                IF Holiday AND "Long Weekend" THEN
                                                                  ERROR(Text003);
                                                              END;


    }
    field(5;"Long Weekend";Boolean)
    {
        

                                                   CaptionML=ENU='Long Weekend',ESP='Puente';

trigger OnValidate();
    BEGIN 
                                                                IF Holiday AND "Long Weekend" THEN
                                                                  ERROR(Text003);
                                                              END;


    }
    field(6;"Calendar";Code[10])
    {
        TableRelation="Type Calendar";
                                                   CaptionML=ENU='Calendar',ESP='Calendario';
                                                   Editable=false;


    }
    field(7;"Hours to work";Decimal)
    {
        CaptionML=ENU='Hours to work',ESP='Horas a trabajar'; ;


    }
}
  keys
{
    key(key1;"Calendar","Allocation Term","Day")
    {
        Clustered=true;
    }
    key(key2;"Calendar","Allocation Term","Holiday","Long Weekend")
    {
        ;
    }
}
  fieldgroups
{
}
  
    var
//       AllocationTerm@7001100 :
      AllocationTerm: Record 7207297;
//       Text001@7001101 :
      Text001: TextConst ENU='Day %1 does not belong to allocation term %2',ESP='El D¡a %1 no pertenece al periodo de imputaci¢n %2';
//       Text002@7001102 :
      Text002: TextConst ENU='There isnït allocation term %1',ESP='No exite el periodo de imputaci¢n %1';
//       Text003@7001103 :
      Text003: TextConst ENU='One day cannït be festive and long weekend at the same time',ESP='Un d¡ no puede ser festivo y puente al mismo tiempo.';

    /*begin
    end.
  */
}







