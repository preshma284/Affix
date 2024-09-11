table 7207326 "QBU Daily Book Production"
{
  
  
    CaptionML=ENU='Daily Book Production',ESP='Libro diario producci¢n';
    LookupPageID="Production Daily Book";
    DrillDownPageID="Production Daily Book";
  
  fields
{
    field(1;"Name";Code[20])
    {
        CaptionML=ENU='Name',ESP='Nombre';
                                                   NotBlank=true;


    }
    field(2;"Description";Text[80])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(7;"Source Code";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Source Code',ESP='Cod. origen';


    }
    field(8;"Reason Code";Code[20])
    {
        TableRelation="Reason Code";
                                                   CaptionML=ENU='Reason Code',ESP='Cod. auditor¡a';


    }
    field(13;"Serie No.";Code[20])
    {
        TableRelation="No. Series";
                                                   

                                                   CaptionML=ENU='Serie No.',ESP='No. serie';

trigger OnValidate();
    BEGIN 
                                                                IF "Serie No." = "Posting Serie No." THEN
                                                                  "Posting Serie No." := '';
                                                              END;


    }
    field(14;"Posting Serie No.";Code[20])
    {
        TableRelation="No. Series";
                                                   

                                                   CaptionML=ENU='Posting Serie No.',ESP='No. serie registro'; ;

trigger OnValidate();
    BEGIN 
                                                                IF ("Posting Serie No." = "Serie No.") AND ("Posting Serie No." <> '') THEN
                                                                  FIELDERROR("Posting Serie No.",STRSUBSTNO(Text001,"Posting Serie No."));
                                                              END;


    }
}
  keys
{
    key(key1;"Name")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       ProductionDailyLine@7001100 :
      ProductionDailyLine: Record 7207327;
//       Text001@7001104 :
      Text001: TextConst ENU='must not be %1',ESP='No puede ser %1.';

    

trigger OnModify();    begin
               ProductionDailyLine.RESET;
               ProductionDailyLine.SETRANGE("Daily Book Name",Name);
               ProductionDailyLine.MODIFYALL("Source Code", "Source Code");
               ProductionDailyLine.MODIFYALL("Reason Code", "Reason Code");
             end;

trigger OnDelete();    begin
               ProductionDailyLine.RESET;
               ProductionDailyLine.SETRANGE("Daily Book Name",Name);
               ProductionDailyLine.DELETEALL(TRUE);
             end;



/*begin
    end.
  */
}







