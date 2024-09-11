table 7207419 "Vendor Certificates"
{
  
  
    CaptionML=ENU='Vendor Certificates',ESP='Certificados del proveedor';
    LookupPageID="Vendor Certificates List";
    DrillDownPageID="Vendor Certificates List";
  
  fields
{
    field(1;"Vendor No.";Code[20])
    {
        TableRelation=Vendor WHERE ("QB Employee"=CONST(false));
                                                   

                                                   CaptionML=ENU='Vendor No.',ESP='N§ proveedor';

trigger OnValidate();
    BEGIN 
                                                                CheckVendor("Vendor No.");
                                                              END;


    }
    field(2;"Certificate Line No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ L¡nea';
                                                   Description='JAV 05/11/19: - Nueva campo autoincrementado, nueva clave Proveedor+L¡nea, pueden existir as¡ muchos certificados del proveedor y algunos sin actividad como los de corriente de pago';
                                                   Editable=false;


    }
    field(10;"Activity Code";Code[20])
    {
        TableRelation="Activity QB";
                                                   CaptionML=ENU='Activity Code',ESP='C¢d. actividad';


    }
    field(11;"Activity Description";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Activity QB"."Description" WHERE ("Activity Code"=FIELD("Activity Code")));
                                                   CaptionML=ESP='Descripci¢n Actividad';
                                                   Editable=false;


    }
    field(12;"Certificate Code";Code[10])
    {
        TableRelation="Vendor Certificates Types";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Certificate',ESP='Cod.Certificado';


    }
    field(13;"Lines No.";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("Vendor Certificates History" WHERE ("Vendor No."=FIELD("Vendor No."),
                                                                                                          "Certificate Line No."=FIELD("Certificate Line No.")));
                                                   CaptionML=ESP='N§ L¡neas';
                                                   Editable=false;


    }
    field(14;"Required";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Obligatorio';


    }
    field(15;"Job No.";Code[20])
    {
        TableRelation=Job WHERE ("Card Type"=CONST("Proyecto operativo"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Proyecto';
                                                   Description='JAV 14/11/19: De que proyecto es la certificaci¢n';


    }
    field(16;"Active From";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Activo Desde';
                                                   Description='JAV 20/11/19: - Si el certificado est  activo, desde cuando se debe controlas';


    }
    field(17;"Active To";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Activo Hasta';
                                                   Description='JAV 20/11/19: - Si el certificado est  activo, hasta  cuando se debe controlar';


    }
    field(20;"Entity Certification";Text[30])
    {
        CaptionML=ENU='Entity Certification',ESP='Entidad certificaci¢n';


    }
    field(21;"Certificate No.";Code[10])
    {
        CaptionML=ENU='Certificate No.',ESP='N§ certificado';


    }
    field(22;"Level of Implementation";Decimal)
    {
        CaptionML=ENU='Level of Implementation',ESP='Grado de implantaci¢n';


    }
    field(23;"Reference Standard";Code[20])
    {
        CaptionML=ENU='Reference Standard',ESP='Norma de referencia';


    }
    field(24;"Other Reference Standards";Text[30])
    {
        CaptionML=ENU='Other Reference Standards',ESP='Otras normas de referencia'; ;


    }
}
  keys
{
    key(key1;"Vendor No.","Certificate Line No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       VendorQualityCertificates@1100286000 :
      VendorQualityCertificates: Record 7207419;

    

trigger OnInsert();    begin
               VendorQualityCertificates.RESET;
               VendorQualityCertificates.SETRANGE("Vendor No.", "Vendor No.");
               if (VendorQualityCertificates.FINDLAST) then
                 "Certificate Line No." := VendorQualityCertificates."Certificate Line No." + 1
               else
                 "Certificate Line No." := 1;
             end;



// procedure IsValid (pDate@1100286000 : Date;var pIni@1100286001 : Date;var pEnd@1100286003 :
procedure IsValid (pDate: Date;var pIni: Date;var pEnd: Date) : Boolean;
    var
//       VendorCertificatesHistory@1100286002 :
      VendorCertificatesHistory: Record 7207426;
//       valid@1100286004 :
      valid: Boolean;
    begin
      pIni := 0D;
      pEnd := 0D;
      valid := FALSE;

      VendorCertificatesHistory.RESET;
      VendorCertificatesHistory.SETRANGE("Vendor No.", "Vendor No.");
      VendorCertificatesHistory.SETRANGE("Certificate Line No.", "Certificate Line No.");
      VendorCertificatesHistory.SETFILTER("Start Date", '<=%1', pDate);
      VendorCertificatesHistory.SETFILTER("end Date", '=%1 | >=%2', 0D, pDate);
      if VendorCertificatesHistory.FINDSET(FALSE) then
        repeat
          if (VendorCertificatesHistory."Start Date" <> 0D) or (VendorCertificatesHistory."end Date" <> 0D) then begin
            if (pIni = 0D) or (pIni > VendorCertificatesHistory."Start Date") then
              pIni := VendorCertificatesHistory."Start Date";
            if (pEnd = 0D) or (pEnd < VendorCertificatesHistory."end Date") then
              pEnd := VendorCertificatesHistory."end Date";
            valid := TRUE;
          end;
        until VendorCertificatesHistory.NEXT = 0;

      exit(valid);
    end;

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

    /*begin
    //{
//      JDC 22/07/19: - GAP002 Added fields 50000"Requirement Code" and 50001"Requirement Mandatory"
//      PGM 12/08/19: - GAP019 A¤adido el campo "Certificate" y modificado el campo "Type Certificate" (Text -> Option)
//      JAV 05/11/19: - Nuevo campo autoincrementado N§ de l¡nea, junto a la nueva clave Proveedor+L¡nea, as¡ pueden existir muchos certificados
//                      del proveedor y algunos sin actividad como los de corriente de pago que ser n comunes a todas.
//    }
    end.
  */
}







