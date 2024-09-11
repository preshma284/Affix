table 7206931 "QBU SII Operation Description"
{
  
  
    CaptionML=ENU='SII Operation Description',ESP='Descripci¢n de Operaciones para el SII';
    LookupPageID="QB SII Operations Description";
    DrillDownPageID="QB SII Operations Description";
  
  fields
{
    field(1;"Code";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job No.',ESP='C¢digo';


    }
    field(2;"Description";Text[250])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Currency Code',ESP='Descripci¢n';


    }
    field(3;"Default";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Future Currency',ESP='Por Defecto'; ;

trigger OnValidate();
    BEGIN 
                                                                IF (Default) THEN BEGIN 
                                                                  QBSIIOperationDescription.RESET;
                                                                  QBSIIOperationDescription.SETRANGE(Default, TRUE);
                                                                  QBSIIOperationDescription.SETFILTER(Code, '<>%1', Code);
                                                                  QBSIIOperationDescription.MODIFYALL(Default, FALSE);
                                                                END;
                                                              END;


    }
}
  keys
{
    key(key1;"Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       QBSIIOperationDescription@1100286000 :
      QBSIIOperationDescription: Record 7206931;

    /*begin
    end.
  */
}







