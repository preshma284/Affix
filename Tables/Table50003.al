table 50003 "QBU QuoSync Tables"
{
  
  
    CaptionML=ENU='Sync Setup',ESP='Conf. Tablas para Sincronizaci¢n';
  
  fields
{
    field(1;"Table";Integer)
    {
        TableRelation=AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST("Table"));
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Table',ESP='Tabla';

trigger OnValidate();
    BEGIN 
                                                                CALCFIELDS("Table Name");
                                                              END;


    }
    field(2;"Field";Integer)
    {
        TableRelation=Field."No." WHERE ("TableNo"=FIELD("Table"));
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Field',ESP='Campo';

trigger OnValidate();
    BEGIN 
                                                                CALCFIELDS(Caption);
                                                              END;


    }
    field(10;"Table Name";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Name" WHERE ("Object Type"=CONST("TableData"),
                                                                                         "Object ID"=FIELD("Table")));
                                                   CaptionML=ENU='Table Name',ESP='Nombre';
                                                   Editable=false;


    }
    field(11;"Caption";Text[80])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Field"."Field Caption" WHERE ("TableNo"=FIELD("Table"),
                                                                                                   "No."=FIELD("Field")));
                                                   CaptionML=ENU='Caption',ESP='Descripci¢n';
                                                   Editable=false;


    }
    field(12;"Direction";Option)
    {
        OptionMembers="Booth","Master","Sync";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Direction',ESP='Direcci¢n';
                                                   OptionCaptionML=ENU='Booth,Master to Sync,Sync to Master',ESP='Ambos,Master a Sincronizada,Sincronizada a Master';
                                                   


    }
    field(20;"Not Sync";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Not Sync',ESP='No Sincronizar'; ;


    }
}
  keys
{
    key(key1;"Table","Field")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       rRef@1100286000 :
      rRef: RecordRef;
//       fRef@1100286001 :
      fRef: FieldRef;

    /*begin
    end.
  */
}







