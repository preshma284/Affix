table 7174656 "History Sites SP"
{
  
  
    CaptionML=ENU='History Sites SP',ESP='Hist�rico Sitios SP';
    LookupPageID="History Site SP";
    DrillDownPageID="History Site SP";
  
  fields
{
    field(1;"Metadata Site Definition";Code[20])
    {
        TableRelation="Site Sharepoint Definition"."No.";
                                                   CaptionML=ENU='Metadata Site Header ID',ESP='No. Def. Metadatos';


    }
    field(2;"Line No.";Integer)
    {
        CaptionML=ENU='Id.',ESP='No. l�nea';


    }
    field(3;"IdTable";Integer)
    {
        TableRelation=AllObjWithCaption."Object ID" WHERE ("Object Type"=FILTER("Table"));
                                                   CaptionML=ENU='Id. Table',ESP='Id. tabla';


    }
    field(4;"Value PK";RecordID)
    {
        CaptionML=ESP='Valor registro';


    }
    field(5;"URL";Text[250])
    {
        CaptionML=ESP='Url';


    }
    field(6;"Site Name";Text[250])
    {
        CaptionML=ESP='Nombre sitio';


    }
    field(7;"Value PKv1";Text[50])
    {
        CaptionML=ESP='Valor registro';


    }
    field(499;"Last Date Modified";DateTime)
    {
        CaptionML=ENU='Last User Modified',ESP='Fecha �lt. modificaci�n';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Metadata Site Definition","Line No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      QUONEXT 20.07.17 DRAG&DROP. Hist�rico de los sitios/bibliotecas creados en SP.
    }
    end.
  */
}







