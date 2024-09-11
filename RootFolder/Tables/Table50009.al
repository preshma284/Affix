table 50009 "Vendor Objective"
{
  
  
    CaptionML=ENU='Vendors Objective',ESP='Objetivos de comerciales';
  
  fields
{
    field(1;"Vendor No.";Code[20])
    {
        TableRelation="Salesperson/Purchaser"."Code";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Vendor No.',ESP='No. Comercial';

trigger OnValidate();
    VAR
//                                                                 SalespersonPurchaser@1100286000 :
                                                                SalespersonPurchaser: Record 13;
                                                              BEGIN 
                                                                SalespersonPurchaser.GET("Vendor No.");
                                                                "Vendor Name" := SalespersonPurchaser.Name;
                                                              END;


    }
    field(2;"Vendor Name";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Vendor Name',ESP='Nombre comercial';


    }
    field(3;"Start Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Start Date',ESP='Fecha inicio';


    }
    field(4;"CIBI Objective";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='CIBI Objevtive',ESP='CIBI objetivo';


    }
    field(5;"Month Salary";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Month Salary',ESP='Sueldo mes'; ;


    }
}
  keys
{
    key(key1;"Vendor No.","Start Date")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Text001@1100286000 :
      Text001: TextConst ENU='The Start Date field must be filled.',ESP='El campo Fecha de Inicio debe estar relleno.';

    

trigger OnInsert();    begin
               if "Start Date" = 0D then
                 ERROR(Text001);
             end;



/*begin
    end.
  */
}







