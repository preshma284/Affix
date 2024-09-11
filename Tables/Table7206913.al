table 7206913 "QBU External intervenors"
{
  
  
    CaptionML=ENU='External intervenors',ESP='Intervinientes Externos';
  
  fields
{
    field(1;"Job No.";Code[20])
    {
        TableRelation="Job"."No.";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job No.',ESP='N§ proyecto';


    }
    field(2;"Contact No.";Code[20])
    {
        TableRelation="Contact"."No.";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Contact No.',ESP='N§ contacto';

trigger OnValidate();
    BEGIN 
                                                                IF Contact.GET("Contact No.") THEN BEGIN 
                                                                  Name:= Contact.Name;
                                                                  "Phone No." := Contact."Phone No.";
                                                                  Email := Contact."E-Mail";
                                                                END;
                                                              END;


    }
    field(3;"Name";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Name',ESP='Nombre';


    }
    field(4;"Phone No.";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Phone No.',ESP='N§ tel‚fono';


    }
    field(5;"Email";Text[80])
    {
        DataClassification=ToBeClassified;


    }
    field(6;"Description";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Description',ESP='Descripci¢n'; ;


    }
}
  keys
{
    key(key1;"Job No.","Contact No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Contact@1100286000 :
      Contact: Record 5050;

    /*begin
    end.
  */
}







