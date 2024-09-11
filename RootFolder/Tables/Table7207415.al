table 7207415 "Data Prices Vendor"
{


    CaptionML = ENU = 'Data Prices Vendor', ESP = 'Datos precios proveedor';

    fields
    {
        field(1; "Quote Code"; Code[20])
        {
            CaptionML = ENU = 'Quote Code', ESP = 'C�d. Oferta';
            Editable = false;


        }
        field(2; "Vendor No."; Code[20])
        {
            CaptionML = ENU = 'Vendor No.', ESP = 'N� Proveedor';
            Editable = false;


        }
        field(3; "Type"; Enum "Purchase Line Type")
        {
            // OptionMembers="Item","Resource";
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            // OptionCaptionML=ENU='Item,Resource',ESP='Producto,Recurso';

            Editable = false;


        }
        field(4; "No."; Code[20])
        {
            TableRelation = IF ("Type" = CONST("Item")) "Item" ELSE IF ("Type" = CONST("Resource")) "Resource";
            CaptionML = ENU = 'No.', ESP = 'N�';
            Editable = false;


        }
        field(5; "Quantity"; Decimal)
        {
            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';
            Editable = false;


        }
        field(6; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';
            Editable = false;


        }
        field(7; "Location Code"; Code[10])
        {
            TableRelation = "Location";
            CaptionML = ENU = 'Location Code', ESP = 'C�d. Almac�n';
            Editable = false;


        }
        field(8; "Vendor Price"; Decimal)
        {


            CaptionML = ENU = 'Vendor Price', ESP = 'Precio proveedor';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                "Purchase Amount" := "Vendor Price" * Quantity;
            END;


        }
        field(9; "Purchase Amount"; Decimal)
        {
            CaptionML = ENU = 'Purchase Amount', ESP = 'Importe compra';
            Editable = false;
            AutoFormatType = 1;


        }
        field(10; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(11; "Estimated Price"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Comparative Quote Lines"."Estimated Price" WHERE("Quote No." = FIELD("Quote Code"),
                                                                                                                         "Line No." = FIELD("Line No.")));
            CaptionML = ENU = 'Estimated Price', ESP = 'Precio previsto';
            Editable = false;
            AutoFormatType = 2;


        }
        field(12; "Target Price"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Comparative Quote Lines"."Target Price" WHERE("Quote No." = FIELD("Quote Code"),
                                                                                                                      "Line No." = FIELD("Line No.")));
            CaptionML = ENU = 'Target Price', ESP = 'Precio objetivo';
            Editable = false;
            AutoFormatType = 2;


        }
        field(13; "Contact No."; Code[20])
        {
            TableRelation = Contact."No." WHERE("Type" = CONST("Company"));
            CaptionML = ENU = 'Contact No.', ESP = 'N� Contacto';


        }
        field(14; "Version No."; Integer)
        {
            InitValue = 0;
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Version No.', ESP = 'N� versi�n';
            NotBlank = true;
            Description = 'Q13150';


        }
        field(18; "Piecework No."; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Production Unit" = CONST(true));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Piecework No.', ESP = 'N� Unidad de obra';
            Description = 'JAV 04/03/19: Unidad de obra de la l�nea de origen';
            Editable = false;


        }
        field(33; "QB Framework Contr. No."; Code[20])
        {
            TableRelation = "QB Framework Contr. Header"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order No.', ESP = 'N� Contrato Marco';
            Description = 'QB 1.06.20 - N� Contrato Marco';
            Editable = false;


        }
        field(34; "QB Framework Contr. Line"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order No.', ESP = 'N� L�nea del Contrato Marco';
            Description = 'QB 1.08.18 - N� de l�nea del Contrato Marco';
            Editable = false;


        }
        field(107; "Code Piecework PRESTO"; Code[40])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Code Piecework PRESTO', ESP = 'C�d. U.O PRESTO';
            Description = 'QB3685';


        }
    }
    keys
    {
        key(key1;"Quote Code","Vendor No.","Contact No.","Version No.","Line No.")
        {
            SumIndexFields="Purchase Amount";
            Clustered=true;
        }
    }
    fieldgroups
    {
    }


    // procedure TypeDescription (Type@1000000003 : 'Item,Resource';Code@1000000000 :
    // procedure TypeDescription(Type: Option "Item","Resource"; Code: Code[20]): Text[250];
    procedure TypeDescription(Type: Enum "Purchase Line Type"; Code: Code[20]): Text[250];
    var
        //       Item@7001101 :
        Item: Record 27;
        //       Resource@1000000002 :
        Resource: Record 156;
        //       ComparativeQuoteLines@7001100 :
        ComparativeQuoteLines: Record 7207413;
    begin
        if ComparativeQuoteLines.GET("Quote Code", "Line No.") then
            if (Type = Type) and ("No." = Code) then
                exit(ComparativeQuoteLines.Description);
        if Type = Type::Item then
            if Item.GET(Code) then
                exit(Item.Description);
        if Type = Type::Resource then
            if Resource.GET(Code) then
                exit(Resource.Name);
    end;

    //     procedure TypeUM (TypePar@1000000003 : 'Item,Resource';Code@1000000000 :
    procedure TypeUM(TypePar: Enum "Purchase Line Type"; Code: Code[20]): Text[250];
    var
        //       Item@1000000001 :
        Item: Record 27;
        //       Resource@1000000002 :
        Resource: Record 156;
        //       ComparativeQuoteLines@7001100 :
        ComparativeQuoteLines: Record 7207413;
    begin
        if ComparativeQuoteLines.GET("Quote Code", "Line No.") then begin
            if (Type = TypePar) and ("No." = Code) then
                exit(ComparativeQuoteLines."Unit of measurement Code");
        end;

        if TypePar = TypePar::Item then begin
            if Item.GET(Code) then
                exit(Item."Base Unit of Measure");
        end;

        if TypePar = TypePar::Resource then begin
            if Resource.GET(Code) then
                exit(Resource."Base Unit of Measure");
        end;
    end;

    //     procedure TypeQTY (TypePar@7001100 : 'Item,Resource';Code@1000000000 :
    procedure TypeQTY(TypePar: Enum "Purchase Line Type"; Code: Code[20]): Decimal;
    var
        //       Item@7001103 :
        Item: Record 27;
        //       Resource@7001102 :
        Resource: Record 156;
        //       ComparativeQuoteLines@7001101 :
        ComparativeQuoteLines: Record 7207413;
    begin
        if ComparativeQuoteLines.GET("Quote Code", "Line No.") then begin
            if (Type = TypePar) and ("No." = Code) then
                exit(ComparativeQuoteLines.Quantity);
        end;

        exit(0);
    end;

    /*begin
    //{
//      JAV 04/03/19: Se a�ade el campo 18 "Piecework No." con la Unidad de obra de la l�nea de origen
//      Q13150 JDC 30/03/21 - Added field 14 "Version"
//                            Modified Primary Key
//    }
    end.
  */
}







