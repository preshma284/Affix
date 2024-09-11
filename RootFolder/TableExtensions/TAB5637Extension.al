tableextension 50199 "MyExtension50199" extends "FA G/L Posting Buffer"
{
  
  /*
ReplicateData=false;
*/
    CaptionML=ENU='FA G/L Posting Buffer',ESP='A/F Mem. int. reg. C/G';
  
  fields
{
    field(7207270;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto';


    }
    field(7207271;"Piecework Code";Text[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."));
                                                   CaptionML=ENU='Cod. unidad de obra',ESP='C¢d. unidad de obra'; ;


    }
}
  keys
{
   // key(key1;"Entry No.")
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




