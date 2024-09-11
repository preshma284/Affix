table 7174394 "QM MasterData Companie/Table"
{
  
  
    DataPerCompany=false;
    CaptionML=ENU='MasterData Companie/Table',ESP='MasterData Empresa/Tabla';
  
  fields
{
    field(1;"Company";Text[50])
    {
        TableRelation="Company";
                                                   CaptionML=ENU='Name',ESP='Empresa';


    }
    field(2;"Table No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tabla';


    }
    field(9;"Table Name";Text[250])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Name" WHERE ("Object Type"=CONST("Table"),
                                                                                         "Object ID"=FIELD("Table No.")));
                                                   CaptionML=ESP='Nombre de la Tabla';
                                                   Description='MD 1.00.03 JAV 27/04/22 - Se ampl¡a la longitud para que pueda salir correctamente';
                                                   Editable=false;


    }
    field(10;"Sync";Option)
    {
        OptionMembers=" ","Manual","Automatic";CaptionML=ENU='Display Name',ESP='Sincronizar';
                                                   OptionCaptionML=ENU='" ,Manual,Automatic"',ESP='" ,Manualmente,Autom ticamente"';
                                                   


    }
    field(11;"Is Master";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Master',ESP='Master';
                                                   Description='QM 1.00.01 JAV 22/04/22: - [TT] Este campo indica que la empresa es la marcada como MASTER DATA';


    }
    field(12;"Is Not Master";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   Description='QM 1.00.01 JAV 22/04/22: - Para uso interno, ordenar las empresas' ;


    }
}
  keys
{
    key(key1;"Company","Table No.")
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







