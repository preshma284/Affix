tableextension 50168 "QBU Resources SetupExt" extends "Resources Setup"
{
  
  
    CaptionML=ENU='Resources Setup',ESP='Config. recursos';
  
  fields
{
    field(7207270;"QBU OLD_Default Calendar";Code[10])
    {
        TableRelation="Type Calendar";
                                                   CaptionML=ENU='Default Calendar',ESP='Calendario por defecto';
                                                   Description='### ELIMINAR ### no se usa';


    }
    field(7207271;"QBU OLD_No. Serie Sheet";Code[10])
    {
        TableRelation="No. Series";
                                                   CaptionML=ENU='No. Serie Sheet',ESP='N§ serie parte';
                                                   Description='### ELIMINAR ### no se usa';


    }
    field(7207272;"QBU OLD_No. Serie Sheet Post.";Code[10])
    {
        TableRelation="No. Series";
                                                   CaptionML=ENU='No. Serie Sheet Post.',ESP='N§ serie parte registrado';
                                                   Description='### ELIMINAR ### no se usa' ;


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
//       TimeSheetHeader@1002 :
      TimeSheetHeader: Record 950;
//       TimeSheetLine@1000 :
      TimeSheetLine: Record 951;
//       Text001@1001 :
      Text001: TextConst ENU='%1 cannot be changed, because there is at least one submitted time sheet line with Type=Job.',ESP='%1 no se puede cambiar porque existe al menos una l¡nea del parte de horas enviada con Tipo=Proyecto.';
//       Text002@1003 :
      Text002: TextConst ENU='%1 cannot be changed, because there is at least one time sheet.',ESP='%1 no se puede cambiar porque existe al menos un parte de horas.';

    /*begin
    end.
  */
}





