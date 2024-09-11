tableextension 50169 "QBU Jobs SetupExt" extends "Jobs Setup"
{
  
  
    CaptionML=ENU='Jobs Setup',ESP='Config. proyectos';
  
  fields
{
    field(7207270;"QBU OLD_No. Serie Posting Car/Des";Code[10])
    {
        TableRelation="No. Series";
                                                   CaptionML=ENU='No. Serie Posting Car/Des',ESP='No. serie registro Traspasos';
                                                   Description='### ELIMINAR ### no se usa';


    }
    field(7207272;"QBU OLD_No. Serie car/des";Code[10])
    {
        TableRelation="No. Series";
                                                   CaptionML=ENU='No. Serie car/des',ESP='No. serie  Traspasos';
                                                   Description='### ELIMINAR ### no se usa';


    }
    field(7207274;"QBU OLD_Allocation Acc Car/Des Def";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Allocation Account Car/Des Def',ESP='Cta. traspaso Gasto por defecto';
                                                   Description='### ELIMINAR ### no se usa';


    }
    field(7207275;"QBU OLD_Transfer Acc Invoice Defau";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Transfer Account Invoice Defau',ESP='Cta. traspaso Venta por defecto';
                                                   Description='### ELIMINAR ### no se usa';


    }
    field(7207276;"QBU OLD_Unitary Cost Km";Decimal)
    {
        CaptionML=ENU='Unitary Cost Km',ESP='Coste unitario Km';
                                                   Description='### ELIMINAR ### no se usa';
                                                   AutoFormatType=2;


    }
    field(7207279;"QBU OLD_Serie for Offers";Code[20])
    {
        TableRelation="No. Series";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Serie Offers No.',ESP='N§ serie Estudios';
                                                   Description='### ELIMINAR ### no se usa';


    }
    field(7207280;"QBU OLD_Serie for Jobs";Code[20])
    {
        TableRelation="No. Series";
                                                   CaptionML=ENU='Job Nos.',ESP='N§ serie Obras';
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
  

    /*begin
    end.
  */
}





