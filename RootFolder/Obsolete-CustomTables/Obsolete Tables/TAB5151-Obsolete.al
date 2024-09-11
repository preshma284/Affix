table 51251 "Integration Record 1"
{
  
  
    CaptionML=ENU='Integration Record',ESP='Registro integraci¢n';
  
  fields
{
    field(1;"Table ID";Integer)
    {
        CaptionML=ENU='Table ID',ESP='Id. tabla';


    }
    field(2;"Page ID";Integer)
    {
        CaptionML=ENU='Page ID',ESP='Id. p gina';


    }
    field(3;"Record ID";RecordID)
    {
        DataClassification=SystemMetadata;
                                                   CaptionML=ENU='Record ID',ESP='Id. del registro';


    }
    field(5150;"Integration ID";GUID)
    {
        CaptionML=ENU='Integration ID',ESP='Id. de integraci¢n';


    }
    field(5151;"Deleted On";DateTime)
    {
        CaptionML=ENU='Deleted On',ESP='Eliminado el';


    }
    field(5152;"Modified On";DateTime)
    {
        CaptionML=ENU='Modified On',ESP='Fecha modificaci¢n'; ;


    }
}
  keys
{
    key(key1;"Integration ID")
    {
        Clustered=true;
    }
    key(key2;"Record ID")
    {
        ;
    }
    key(key3;"Page ID","Deleted On")
    {
        ;
    }
    key(key4;"Page ID","Modified On")
    {
        ;
    }
}
  fieldgroups
{
}
  

    
    

trigger OnInsert();    begin
               if ISNULLGUID("Integration ID") then
                 "Integration ID" := CREATEGUID;

               "Modified On" := CURRENTDATETIME;
             end;

trigger OnModify();    begin
               "Modified On" := CURRENTDATETIME;
             end;



// procedure FindByIntegrationId (IntegrationId@1000 :
procedure FindByIntegrationId (IntegrationId: GUID) : Boolean;
    begin
      if ISNULLGUID(IntegrationId) then
        exit(FALSE);

      exit(GET(IntegrationId));
    end;

    
//     procedure FindByRecordId (FindRecordId@1000 :
    procedure FindByRecordId (FindRecordId: RecordID) : Boolean;
    begin
      if FindRecordId.TABLENO = 0 then
        exit(FALSE);

      RESET;
      SETCURRENTKEY("Table ID","Record ID");
      SETRANGE("Table ID",FindRecordId.TABLENO);
      SETRANGE("Record ID",FindRecordId);
      exit(FINDFIRST);
    end;

    /*begin
    end.
  */
}



