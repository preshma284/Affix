table 7207375 "QBU Job Planning Milestones"
{
  
  
    CaptionML=ENU='Job Planning Milestones',ESP='Hitos planificaci¢n proyectos';
    LookupPageID="Job Planning Milestones";
    DrillDownPageID="Job Planning Milestones";
  
  fields
{
    field(1;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='No. proyectos';


    }
    field(2;"Planning Milestone Code";Code[10])
    {
        CaptionML=ENU='Planning Milestone Code',ESP='Cod. hito planificaci¢n';


    }
    field(3;"Description";Text[30])
    {
        CaptionML=ESP='Descripci¢n';


    }
    field(4;"Estimated Date";Date)
    {
        CaptionML=ENU='Estimated Date',ESP='Fecha estimada';


    }
    field(5;"Account Schedule Code";Code[10])
    {
        TableRelation="Acc. Schedule Name";
                                                   CaptionML=ENU='Account Schedule Code',ESP='Cod. esquema de cuentad';


    }
}
  keys
{
    key(key1;"Job No.","Account Schedule Code","Planning Milestone Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    end.
  */
}







