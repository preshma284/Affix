table 7206939 "QB Framework Contr. Company"
{
  
  
    DataPerCompany=false;
    CaptionML=ENU='Blanket Purchase Company',ESP='Empresas Contrato Marco';
  
  fields
{
    field(1;"Document No.";Code[20])
    {
        CaptionML=ENU='Document No.',ESP='N§ documento';


    }
    field(2;"Company Name";Code[20])
    {
        

                                                   CaptionML=ENU='Company Name',ESP='Nombre empresa'; ;

trigger OnValidate();
    VAR
//                                                                 Company@1100286000 :
                                                                Company: Record 2000000006;
                                                              BEGIN 
                                                                //Q12867 -
                                                                IF "Company Name" = '' THEN
                                                                  EXIT;

                                                                Company.GET("Company Name");
                                                                //Q12867 +
                                                              END;

trigger OnLookup();
    VAR
//                                                               Company@1100286000 :
                                                              Company: Record 2000000006;
//                                                               Companies@1100286001 :
                                                              Companies: Page 357;
                                                            BEGIN 
                                                              //Q12867 -
                                                              CLEAR(Companies);
                                                              Company.RESET;
                                                              Companies.SETRECORD(Company);
                                                              Companies.SETTABLEVIEW(Company);
                                                              Companies.LOOKUPMODE(TRUE);
                                                              IF Companies.RUNMODAL = ACTION::LookupOK THEN BEGIN 
                                                                Companies.GETRECORD(Company);
                                                                "Company Name" := UPPERCASE(Company.Name);
                                                              END;
                                                              //Q12867 +
                                                            END;


    }
}
  keys
{
    key(key1;"Document No.","Company Name")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      //Q12867 JDC 25/02/21 - Modified function "Company Name - OnValidate", "Company Name - OnLookup"
    }
    end.
  */
}







