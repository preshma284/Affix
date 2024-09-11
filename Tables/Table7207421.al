table 7207421 "QBU Data Other Conditions"
{
  
  
    CaptionML=ENU='Data Other Conditions',ESP='Datos otras condiciones';
    LookupPageID="Other Vendor Conditions List";
    DrillDownPageID="Other Vendor Conditions List";
  
  fields
{
    field(1;"Vendor No.";Code[20])
    {
        TableRelation=Vendor WHERE ("QB Employee"=CONST(false));
                                                   

                                                   CaptionML=ENU='Vendor No.',ESP='N§ Proveedor';

trigger OnValidate();
    BEGIN 
                                                                CheckVendor("Vendor No.");
                                                              END;


    }
    field(2;"Line No.";Integer)
    {
        CaptionML=ENU='Activity Code',ESP='N§ L¡nea';
                                                   NotBlank=true;


    }
    field(3;"Code";Code[20])
    {
        TableRelation="Other Default Vendor Cond.";
                                                   

                                                   CaptionML=ENU='Code',ESP='C¢digo';
                                                   NotBlank=true;

trigger OnValidate();
    VAR
//                                                                 VendorCond@1100286000 :
                                                                VendorCond: Record 7207417;
                                                              BEGIN 
                                                                VendorCond.GET(Code);
                                                                Description := VendorCond.Description;
                                                              END;


    }
    field(10;"Description";Text[50])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(11;"Amount";Decimal)
    {
        CaptionML=ENU='Amount',ESP='Importe';


    }
    field(12;"Sum";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Data Other Conditions"."Amount" WHERE ("Vendor No."=FIELD("Vendor No."),
                                                                                                         "Line No."=FIELD("Line No.")));
                                                   CaptionML=ESP='Total';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Vendor No.","Line No.","Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

//     procedure CheckVendor (VendorNo@1000000000 :
    procedure CheckVendor (VendorNo: Code[20])
    var
//       Text001@1000000002 :
      Text001: TextConst ENU='Vendor is Blocked',ESP='El proveedor est  bloqueado';
//       Text002@1000000003 :
      Text002: TextConst ENU='Vendor is a Employee',ESP='El proveedor no puede ser un empleado';
//       Vendor@1100286000 :
      Vendor: Record 23;
    begin
      if Vendor.GET(VendorNo) then
        begin
          if Vendor.Blocked = Vendor.Blocked::All  then
            ERROR(Text001);
          if Vendor."QB Employee" = TRUE then
            ERROR(Text002);
        end;
    end;

//     procedure GetDescriptionActivityHP (CodeAct@1000000000 :
    procedure GetDescriptionActivityHP (CodeAct: Code[20]) : Text[250];
    var
//       ActivityHP@1100286000 :
      ActivityHP: Record 7207280;
    begin
      if ActivityHP.GET(CodeAct) then
        exit(ActivityHP.Description);
    end;

    /*begin
    end.
  */
}







