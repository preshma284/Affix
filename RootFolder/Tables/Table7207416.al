table 7207416 "Other Vendor Conditions"
{
  
  
    CaptionML=ENU='Other Vendor Conditions',ESP='Otras condiciones proveedor';
  
  fields
{
    field(1;"Quote Code";Code[20])
    {
        CaptionML=ENU='Quote Code',ESP='C¢d. Oferta';


    }
    field(2;"Vendor No.";Code[20])
    {
        TableRelation="Vendor";
                                                   CaptionML=ENU='Vendor No.',ESP='N§ Proveedor';
                                                   Editable=false;


    }
    field(3;"Contact No.";Code[20])
    {
        TableRelation=Contact."No." WHERE ("Type"=CONST("Company"));
                                                   CaptionML=ENU='Contact No.',ESP='N§ contacto';
                                                   Editable=false;


    }
    field(4;"Code";Code[20])
    {
        TableRelation="Other Default Vendor Cond.";
                                                   

                                                   CaptionML=ENU='Code',ESP='C¢digo';

trigger OnValidate();
    VAR
//                                                                 VendorCond@7001100 :
                                                                VendorCond: Record 7207417;
                                                              BEGIN 
                                                                VendorCond.GET(Code);
                                                                Description := VendorCond.Description;
                                                              END;


    }
    field(5;"Description";Text[50])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(6;"Amount";Decimal)
    {
        

                                                   CaptionML=ENU='Amount',ESP='Importe';

trigger OnValidate();
    BEGIN 
                                                                CALCFIELDS("Total Amount");
                                                              END;


    }
    field(7;"Total Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Other Vendor Conditions"."Amount" WHERE ("Quote Code"=FIELD("Quote Code"),
                                                                                                           "Vendor No."=FIELD("Vendor No."),
                                                                                                           "Contact No."=FIELD("Contact No.")));
                                                   CaptionML=ESP='Suma';
                                                   Editable=false;


    }
    field(8;"Version No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Version No.',ESP='N§ versi¢n';
                                                   Description='Q13150' ;


    }
}
  keys
{
}
  fieldgroups
{
}
  

    /*begin
    {
      JAV 26/03/19: - Se pone table relation en el proveedor y se hacen no editables proveedor y contacto
      Q13150 JDC 06/04/21 - Added field 8 "Version"
    }
    end.
  */
}







