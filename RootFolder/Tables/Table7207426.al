table 7207426 "Vendor Certificates History"
{
  
  
    CaptionML=ENU='Vendor Certificates History',ESP='Movimientos Certificados Proveedor';
    LookupPageID="Vendor Certificates Hist. List";
    DrillDownPageID="Vendor Certificates Hist. List";
  
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
        TableRelation="Vendor Certificates"."Certificate Line No." WHERE ("Vendor No."=FIELD("Vendor No."));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ Certificado';


    }
    field(3;"Line No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ de l¡nea';


    }
    field(10;"Reception date";Date)
    {
        CaptionML=ENU='Activity Code',ESP='Fecha Recepci¢n';


    }
    field(11;"Start Date";Date)
    {
        

                                                   CaptionML=ESP='Fecha de inicio';

trigger OnValidate();
    BEGIN 
                                                                IF ("End Date" <> 0D) THEN
                                                                  CalcValidity
                                                                ELSE
                                                                  CalcEndDate;
                                                              END;


    }
    field(12;"Validity Period";DateFormula)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Certificate',ESP='Periodo de Validez';

trigger OnValidate();
    BEGIN 
                                                                CalcEndDate;
                                                              END;


    }
    field(13;"End Date";Date)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha de fin';

trigger OnValidate();
    BEGIN 
                                                                CalcValidity
                                                              END;


    }
}
  keys
{
    key(key1;"Vendor No.","Certificate Line No.","Line No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       VendorCertificatesHistory@1100286000 :
      VendorCertificatesHistory: Record 7207426;

    

trigger OnInsert();    begin
               VendorCertificatesHistory.RESET;
               VendorCertificatesHistory.SETRANGE("Vendor No.", "Vendor No.");
               VendorCertificatesHistory.SETRANGE("Certificate Line No.", "Certificate Line No.");
               if (VendorCertificatesHistory.FINDLAST) then
                 "Line No." := VendorCertificatesHistory."Line No." + 1
               else
                 "Line No." := 1;

               if ("Reception date" = 0D) then
                 "Reception date" := TODAY;
             end;



// procedure CheckVendor (VendorNo@1000000000 :
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

    LOCAL procedure CalcValidity ()
    var
//       fecha@1100286003 :
      fecha: Date;
//       cadena@1100286004 :
      cadena: Text;
//       A@1100286002 :
      A: Integer;
//       M@1100286001 :
      M: Integer;
//       D@1100286000 :
      D: Integer;
    begin
      A:=0;
      M:=0;
      D:=0;
      repeat
        fecha := CALCDATE(FORMAT(A+1) + 'A', "Start Date");
        if (fecha <= "end Date") then
          A+=1;
      until (fecha >= "end Date");
      if (A <> 0) then
        cadena := '+' + FORMAT(A) + 'A';

      repeat
        fecha := CALCDATE(cadena + '+' + FORMAT(M+1) + 'M', "Start Date");
        if (fecha <= "end Date") then
          M+=1;
      until (fecha >= "end Date");
      if (M <> 0) then
        cadena += '+' + FORMAT(M) + 'M';

      repeat
        fecha := CALCDATE(cadena + '+' + FORMAT(D+1)+ 'D', "Start Date");
        if (fecha <= "end Date") then
          D+=1;
      until (fecha >= "end Date");
      if (D <> 0) then
        cadena += '+' + FORMAT(D+1) + 'D'; // El primer d¡a est  incluido en el periodo

      EVALUATE("Validity Period", COPYSTR(cadena,2));
    end;

    LOCAL procedure CalcEndDate ()
    begin
      if ("Start Date" <> 0D) then begin
        "end Date" := CALCDATE("Validity Period", "Start Date");
        "end Date" := CALCDATE('-1D', "end Date"); // NAV calcula desde el d¡a siguiente al de inicio, no desde el propio inicio
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







