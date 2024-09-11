table 7207445 "Jobs Changes Log"
{
  
  
    CaptionML=ENU='Jobs Changes Log',ESP='Registro de cambios en Proyectos';
  
  fields
{
    field(1;"Reg No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ Registro';


    }
    field(10;"Job";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Proyecto o Estudio';


    }
    field(11;"Version";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Versi¢n';


    }
    field(12;"Date";DateTime)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha';


    }
    field(13;"User";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Usuario';


    }
    field(20;"Operation Code";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='C¢digo de Operaci¢n';


    }
    field(21;"Description";Text[60])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Descripci¢n';
                                                   Description='Q20442 se amplia de 50 a 60.';


    }
    field(22;"Parameter 1";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Par metro 1';


    }
    field(23;"Parameter 2";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Par metro 2';


    }
    field(24;"Parameter 3";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Par metro 3';


    }
    field(25;"Parameter 4";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Par metro 4';


    }
    field(26;"Parameter 5";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Par metro 5';


    }
}
  keys
{
    key(key1;"Reg No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       JobsChangesLog@1100286000 :
      JobsChangesLog: Record 7207445;

    

trigger OnInsert();    begin
               JobsChangesLog.RESET;
               if (JobsChangesLog.FINDLAST) then
                 "Reg No." := JobsChangesLog."Reg No." + 1
               else
                 "Reg No." := 1;

               Date := CURRENTDATETIME;
               User := USERID;
             end;



/*begin
    {
      Q20442 CSM 08/11/23.
    }
    end.
  */
}







