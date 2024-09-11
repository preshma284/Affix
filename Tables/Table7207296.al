table 7207296 "QBU Type Calendar"
{
  
  
    CaptionML=ENU='Type Calendar',ESP='Calendario tipo';
    LookupPageID="Type Calendar List";
    DrillDownPageID="Type Calendar List";
  
  fields
{
    field(1;"Code";Code[10])
    {
        CaptionML=ENU='Code',ESP='C¢digo';
                                                   NotBlank=true;


    }
    field(2;"Description";Text[30])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n'; ;


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
//       Resource@60000 :
      Resource: Record 156;
//       Hourstoperform@7001100 :
      Hourstoperform: Record 7207298;
//       Text001@7001101 :
      Text001: TextConst ENU='Can not delete calendar because it is assigned to resource% 1',ESP='No se puede eliminar el calendario porque est  asignado al recurso %1';

    

trigger OnDelete();    begin
               Resource.RESET;
               Resource.SETRANGE("Type Calendar",Code);
               if not Resource.ISEMPTY then
                 ERROR(Text001,Resource.Name);

               Hourstoperform.RESET;
               Hourstoperform.SETRANGE(Calendar,Code);
               Hourstoperform.DELETEALL(TRUE);
             end;



/*begin
    end.
  */
}







