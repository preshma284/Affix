table 7206971 "QB Receipt/Transfer Line"
{
  
  
    CaptionML=ENU='"Receipt Transfer Line Inesco "',ESP='"L¡n. Recepci¢n Traspaso "';
  
  fields
{
    field(1;"Document No.";Code[20])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document No.',ESP='N§ documento';

trigger OnValidate();
    BEGIN 
                                                                IF ReceiptTransferHeaderInesco.GET("Document No.") THEN BEGIN 
                                                                  VALIDATE("Document Type", ReceiptTransferHeaderInesco.Type);
                                                                  VALIDATE("Document Job No.", ReceiptTransferHeaderInesco."Job No.");
                                                                END;
                                                              END;


    }
    field(2;"Line No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Line No.',ESP='N§ Linea';


    }
    field(3;"Item No.";Code[20])
    {
        TableRelation="Item";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Item No.',ESP='N§ producto';
                                                   NotBlank=true;

trigger OnValidate();
    VAR
//                                                                 Item@1100286000 :
                                                                Item: Record 27;
//                                                                 cduReceipt@1100286001 :
                                                                cduReceipt: Codeunit 7206909;
                                                              BEGIN 

                                                                ReceiptTransferHeaderInesco.GET("Document No.");
                                                                cduReceipt.CheckType(ReceiptTransferHeaderInesco);
                                                                "Origin Location" := ReceiptTransferHeaderInesco.Location;
                                                                "Destination Location" := ReceiptTransferHeaderInesco."Destination Location";

                                                                Item.GET("Item No.");
                                                                IF Item.Blocked THEN
                                                                  ERROR(Error001)
                                                                ELSE BEGIN 
                                                                  VALIDATE(Description,Item.Description);
                                                                  VALIDATE("Unit Cost",Item."Unit Cost");
                                                                  VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");
                                                                  //SE COMENTA campos no existen en tabla estandard
                                                                  //IF ReceiptTransferHeaderInesco."Allow Ceded" THEN
                                                                    //Item.TESTFIELD(Item."Allow Ceded",TRUE);
                                                                  //IF ReceiptTransferHeaderInesco."Allow Deposit" THEN
                                                                    //Item.TESTFIELD(Item."Allows Deposit",TRUE);
                                                                  IF CheckLocationUnitCost THEN
                                                                    VALIDATE("Unit Cost",0);
                                                                END;

                                                                //pgm
                                                                IF ReceiptTransferHeaderInesco.Type = ReceiptTransferHeaderInesco.Type::Transfer THEN
                                                                  VALIDATE("Unit Cost",0);
                                                                //pgm
                                                              END;


    }
    field(4;"Description";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(5;"Unit of Measure Code";Code[10])
    {
        TableRelation="Unit of Measure"."Code";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unit of Measure Code',ESP='C¢d. unidad medida';


    }
    field(6;"Quantity";Decimal)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Quantity',ESP='Cantidad';

trigger OnValidate();
    BEGIN 
                                                                IF ("Unit Cost" <> 0) OR (Quantity <> 0) THEN
                                                                  VALIDATE("Total Cost",Quantity * "Unit Cost");

                                                                IF Quantity < 0 THEN BEGIN 
                                                                  ReceiptTransferHeaderInesco.RESET;
                                                                  ReceiptTransferHeaderInesco.SETRANGE("No.","Document No.");
                                                                  IF ReceiptTransferHeaderInesco.FINDFIRST THEN
                                                                    IF (ReceiptTransferHeaderInesco.Type = ReceiptTransferHeaderInesco.Type::Receipt) OR (ReceiptTransferHeaderInesco.Type = ReceiptTransferHeaderInesco.Type::Transfer) THEN
                                                                      ERROR(Error003);
                                                                END;
                                                              END;


    }
    field(7;"Unit Cost";Decimal)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unit Cost',ESP='Coste unitario';

trigger OnValidate();
    BEGIN 
                                                                IF ("Unit Cost" <> 0) OR (Quantity <> 0) THEN
                                                                  VALIDATE("Total Cost",Quantity * "Unit Cost");
                                                              END;


    }
    field(8;"Total Cost";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Total Cost',ESP='Coste total';
                                                   Editable=false;


    }
    field(9;"Service Order No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Service Order No.',ESP='N§ pedido servicio';


    }
    field(10;"Origin Location";Code[10])
    {
        TableRelation="Location";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Origin Location',ESP='Almac‚n origen';


    }
    field(11;"Destination Location";Code[10])
    {
        TableRelation="Location";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Destination Location',ESP='Almac‚n destino';


    }
    field(50;"Document Type";Option)
    {
        OptionMembers=" ","Receipt","Transfer","Setting";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Type',ESP='Tipo';
                                                   OptionCaptionML=ENU='" ,Receipt,Transfer,Setting"',ESP='" ,Recepci¢n,Traspaso,Ajustes"';
                                                   


    }
    field(51;"Document Job No.";Code[20])
    {
        TableRelation="Job";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job No.',ESP='N§ proyecto'; ;


    }
}
  keys
{
    key(key1;"Document No.","Line No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       ReceiptTransferLineInesco@1100286000 :
      ReceiptTransferLineInesco: Record 7206971;
//       ReceiptTransferHeaderInesco@1100286001 :
      ReceiptTransferHeaderInesco: Record 7206970;
//       Error001@1100286002 :
      Error001: TextConst ENU='The selected product is blocked.',ESP='El producto seleccionado est  bloqueado.';
//       Error002@1100286003 :
      Error002: TextConst ENU='The type field of the header must be filled.',ESP='El campo tipo de la cabecera debe estar relleno.';
//       Error003@1100286004 :
      Error003: TextConst ENU='The quantity can not be negative if the type is reception or transfer.',ESP='La cantidad no puede ser negativa si el tipo es recepci¢n o traspaso.';

    

trigger OnInsert();    begin
               ReceiptTransferLineInesco.RESET;
               ReceiptTransferLineInesco.SETRANGE("Document No.","Document No.");
               if ReceiptTransferLineInesco.FINDLAST then
                 "Line No." := ReceiptTransferLineInesco."Line No." + 10000
               else
                 "Line No." := 10000;

               ReceiptTransferHeaderInesco.RESET;
               ReceiptTransferHeaderInesco.SETRANGE("No.","Document No.");
               if ReceiptTransferHeaderInesco.FINDFIRST then begin
                 "Origin Location" := ReceiptTransferHeaderInesco.Location;
                 "Destination Location" := ReceiptTransferHeaderInesco."Destination Location";
                 VALIDATE("Document Type", ReceiptTransferHeaderInesco.Type);
                 VALIDATE("Document Job No.", ReceiptTransferHeaderInesco."Job No.");
               end;
             end;



LOCAL procedure CheckLocationUnitCost () : Boolean;
    var
//       Location@1100286000 :
      Location: Record 14;
    begin
      Location.GET("Origin Location");
      //SE COMENTA campos no existen en la tabla estandar.
      //if (Location."Allow Ceded") or
      // (Location."Allow Deposit") then
      //   exit(TRUE);
    end;

    /*begin
    end.
  */
}







