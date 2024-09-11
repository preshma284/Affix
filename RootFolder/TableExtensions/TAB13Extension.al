tableextension 50103 "QBU Salesperson/Purchaser" extends "Salesperson/Purchaser"
{

    DataCaptionFields = "Code", "Name";
    CaptionML = ENU = 'Salesperson/Purchaser', ESP = 'Vendedor/Comprador';
    LookupPageID = "Salespersons/Purchasers";

    fields
    {
        field(7207270; "QB VAT Registration No."; Text[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'VAT Registration No.', ESP = 'CIF/NIF';
            Description = 'JAV 18/03/20: [TT] El NIF del vendedor para poder incluirlo en la impresi�n de los contratos de venta';

            trigger OnValidate();
            BEGIN
                "QB VAT Registration No." := UPPERCASE("QB VAT Registration No.");
                //To-Do Debe verificarse el formato, pero no tenemos pais del que verificar
            END;


        }
        field(7238179; "QB_Clave de Negocio"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Clave de Negocio';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238180; "QB_SalesPerson Type"; Option)
        {
            OptionMembers = " ","Internal","External";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Salesperson Type', ESP = 'Tipo vendedor';
            OptionCaptionML = ENU = '" ,Internal,External"', ESP = '" ,Interno,Externo"';

            Description = 'QRE 1.00.00 15449';

            trigger OnValidate();
            BEGIN
                IF ("QB_SalesPerson Type" <> "QB_SalesPerson Type"::External) THEN
                    TESTFIELD("QB_Vendor No.", '');
            END;


        }
        field(7238181; "QB_Integration Id"; Integer)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'SAC Integration Id', ESP = 'N� vendedor integraci�n SAC';
            Description = 'QRE 1.00.00 15449';

            trigger OnValidate();
            VAR
                //                                                                 SalespersonPurchaser@1100254000 :
                SalespersonPurchaser: Record 13;
            BEGIN
                IF ("QB_Integration Id" <> 0) THEN BEGIN
                    SalespersonPurchaser.RESET;
                    SalespersonPurchaser.SETCURRENTKEY("QB_Integration Id");
                    SalespersonPurchaser.SETRANGE("QB_Integration Id", "QB_Integration Id");
                    SalespersonPurchaser.SETFILTER(Code, '<>%1', Code);
                    IF NOT SalespersonPurchaser.ISEMPTY THEN
                        ERROR(RE_Text50001);
                END;
            END;


        }
        field(7238182; "QB_Initials"; Code[3])
        {
            TableRelation = "Siglas"."Codigo";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Initials', ESP = 'Siglas de la Calle';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238184; "QB_Nacionalidad"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15449';


        }
        field(7238185; "QB_Numero"; Text[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N�';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238186; "QB_Escalera"; Text[15])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Escalera';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238187; "QB_Piso"; Text[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Piso';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238188; "QB_Puerta"; Text[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Puerta';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238189; "QB_Address"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Address', ESP = 'Direcci�n';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238190; "QB_Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Address 2', ESP = 'Direcci�n 2';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238191; "QB_City"; Text[30])
        {
            TableRelation = IF ("QB_Country/Region Code" = CONST()) "Post Code".City ELSE IF ("QB_Country/Region Code" = FILTER(<> '')) "Post Code"."City" WHERE("Country/Region Code" = FIELD("QB_Country/Region Code"));


            ValidateTableRelation = false;
            //TestTableRelation=false;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'City', ESP = 'Poblaci�n';
            Description = 'QRE 1.00.00 15449';

            trigger OnValidate();
            VAR
                //                                                                 PostCode@1000 :
                PostCode: Record 225;
            BEGIN
                PostCode.ValidateCity(QB_City, "QB_Post Code", QB_County, "QB_Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            END;


        }
        field(7238192; "QB_Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Country/Region Code', ESP = 'C�d. pa�s/regi�n';
            Description = 'QRE 1.00.00 15449';

            trigger OnValidate();
            VAR
                //                                                                 PostCode@1000 :
                PostCode: Record 225;
            BEGIN
                PostCode.ValidateCountryCode(QB_City, "QB_Post Code", QB_County, "QB_Country/Region Code");
            END;


        }
        field(7238193; "QB_Post Code"; Code[20])
        {
            TableRelation = IF ("QB_Country/Region Code" = CONST()) "Post Code" ELSE IF ("QB_Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("QB_Country/Region Code"));


            ValidateTableRelation = false;
            //TestTableRelation=false;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Post Code', ESP = 'C�digo postal';
            Description = 'QRE 1.00.00 15449';

            trigger OnValidate();
            VAR
                //                                                                 PostCode@1000 :
                PostCode: Record 225;
            BEGIN
                PostCode.ValidatePostCode(QB_City, "QB_Post Code", QB_County, "QB_Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            END;


        }
        field(7238194; "QB_County"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'County', ESP = 'Provincia';
            Description = 'QRE 1.00.00 15449';
            CaptionClass = '5,1,' + "QB_Country/Region Code";


        }
        field(7238195; "QB_Mobile Phone No."; Text[30])
        {
            ExtendedDatatype = PhoneNo;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Mobile Phone No.', ESP = 'N� tel�fono m�vil';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238196; "QB_Mobile Phone No. 2"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Mobile Phone No. 2', ESP = 'N� tel�fono m�vil 2';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238197; "QB_Apellido 1"; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Surname 1', ESP = 'Apellido 1';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238198; "QB_Apellido 2"; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Surname 2', ESP = 'Apellido 2';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238200; "QB_Extern Salesperson Type"; Option)
        {
            OptionMembers = "Indirect","Direct";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo vendedor externo';
            OptionCaptionML = ESP = 'Indirecto,Directo';

            Description = 'QRE 1.00.00 15449';


        }
        field(7238201; "QB_Vendor No."; Code[20])
        {
            TableRelation = "Vendor";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Vendor No.', ESP = 'N� proveedor asociado';
            Description = 'QRE 1.00.00 15449';

            trigger OnValidate();
            VAR
                //                                                                 rVendor@1100254000 :
                rVendor: Record 23;
                //                                                                 rSalesperson@1100254001 :
                rSalesperson: Record 13;
            BEGIN
                IF ("QB_Vendor No." <> '') THEN BEGIN
                    TESTFIELD("QB_SalesPerson Type", "QB_SalesPerson Type"::External);
                    rSalesperson.RESET;
                    rSalesperson.SETFILTER(Code, '<>%1', Code);
                    rSalesperson.SETRANGE("QB_Vendor No.", "QB_Vendor No.");
                    IF rSalesperson.FINDFIRST THEN
                        ERROR(RE_Text50004, rSalesperson.Code, "QB_Vendor No.");

                    rVendor.GET("QB_Vendor No.");
                    rVendor.VALIDATE("Purchaser Code", Code);
                    rVendor.MODIFY(TRUE);
                END ELSE IF (xRec."QB_Vendor No." <> '') THEN BEGIN
                    IF NOT CONFIRM(RE_Text50002, FALSE) THEN
                        ERROR(RE_Text50003);
                    VALIDATE("QB_SalesPerson Type", "QB_SalesPerson Type"::" ");
                END;
            END;


        }
        field(7238202; "QB_Id CRM"; GUID)
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15449';
            Editable = false;


        }
        field(7238203; "QB_trademark"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Nombre comercial';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238204; "QB_ErrorAdministrator"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Error manager (does not remove lines)', ESP = 'Administrador errores (no elimina lineas)';
            Description = 'QRE 1.00.00 15449';


        }
    }
    keys
    {
        // key(key1;"Code")
        //  {
        /* Clustered=true;
  */
        // }
    }
    fieldgroups
    {
        // fieldgroup(Brick;"Code","Name","Image")
        // {
        // 
        // }
    }

    var
        //       DimMgt@1000 :
        DimMgt: Codeunit 408;
        //       PostActionTxt@1001 :
        PostActionTxt: TextConst ENU = 'post', ESP = 'registre';
        //       CreateActionTxt@1002 :
        CreateActionTxt: TextConst ENU = 'create', ESP = 'cree';
        //       SalespersonTxt@1005 :
        SalespersonTxt: TextConst ENU = 'Salesperson', ESP = 'Vendedor';
        //       PurchaserTxt@1006 :
        PurchaserTxt: TextConst ENU = 'Purchaser', ESP = 'Comprador';
        //       BlockedSalesPersonPurchErr@1003 :
        BlockedSalesPersonPurchErr:
// "%1 = post or create, %2 = Salesperson / Purchaser, %3 = salesperson / purchaser code."
TextConst ENU = 'You cannot %1 this document because %2 %3 is blocked due to privacy.', ESP = 'No puede %1 este documento porque el %2 %3 est� bloqueado por motivos de privacidad.';
        //       PrivacyBlockedGenericTxt@1004 :
        PrivacyBlockedGenericTxt:
// "%1 = Salesperson / Purchaser, %2 = salesperson / purchaser code."
TextConst ENU = 'Privacy Blocked must not be true for %1 %2.', ESP = 'La opci�n Privacidad bloqueada no debe ser verdadera para %1 %2.';
        //       RE_Text50000@1100286000 :
        RE_Text50000: TextConst ENU = 'You cannot delete the salesperson because he/she has posted commissions, before you must cancel the commissions', ESP = 'No puede eliminar el vendedor al tener comisiones registradas. Primero debe cancelar las que tenga asociadas';
        //       RE_Text50001@1100286004 :
        RE_Text50001: TextConst ENU = 'There is already a Salesperson with this external number. It has to be unique', ESP = 'Ya existe un vendedor con este n�mero de inventario. El n�mero debe ser �nico';
        //       RE_Text50002@1100286003 :
        RE_Text50002: TextConst ENU = 'When you leave the vendor empty, the salesperson won''t be an external salesperson anymore, do you want to continue?', ESP = 'Al quitar el proveedor, el vendedor dejar� de ser un vendedor externo, �Desea continuar?';
        //       RE_Text50003@1100286002 :
        RE_Text50003: TextConst ENU = 'Process canceled by user', ESP = 'Proceso cancelado por el usuario';
        //       RE_Text50004@1100286001 :
        RE_Text50004: TextConst ENU = 'There is already the salesperson %1 with this vendor %2', ESP = 'Ya existe el vendedor %1 asociado a este proveedor %2';





    /*
    trigger OnInsert();    begin
                   VALIDATE(Code);
                   DimMgt.UpdateDefaultDim(
                     DATABASE::"Salesperson/Purchaser",Code,
                     "Global Dimension 1 Code","Global Dimension 2 Code");
                 end;


    */

    /*
    trigger OnModify();    begin
                   VALIDATE(Code);
                 end;


    */

    /*
    trigger OnDelete();    var
    //                TeamSalesperson@1000 :
                   TeamSalesperson: Record 5084;
                 begin
                   TeamSalesperson.RESET;
                   TeamSalesperson.SETRANGE("Salesperson Code",Code);
                   TeamSalesperson.DELETEALL;
                   DimMgt.DeleteDefaultDim(DATABASE::"Salesperson/Purchaser",Code);
                 end;


    */

    /*
    trigger OnRename();    begin
                   DimMgt.RenameDefaultDim(DATABASE::"Salesperson/Purchaser",xRec.Code,Code);
                 end;

    */




    /*
    procedure CreateInteraction ()
        var
    //       TempSegmentLine@1000 :
          TempSegmentLine: Record 5077 TEMPORARY;
        begin
          TempSegmentLine.CreateInteractionFromSalesperson(Rec);
        end;
    */



    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :

    /*
    procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
        begin
          DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
          DimMgt.SaveDefaultDim(DATABASE::"Salesperson/Purchaser",Code,FieldNumber,ShortcutDimCode);
          MODIFY;
        end;
    */



    //     procedure GetPrivacyBlockedTransactionText (SalespersonPurchaser2@1001 : Record 13;IsPostAction@1000 : Boolean;IsSalesperson@1003 :
    procedure GetPrivacyBlockedTransactionText(SalespersonPurchaser2: Record 13; IsPostAction: Boolean; IsSalesperson: Boolean): Text[150];
    var
        //       Action@1002 :
        Action: Text[30];
        //       Type@1004 :
        Type: Text[20];
    begin

        if IsPostAction then
            Action := PostActionTxt
        else
            Action := CreateActionTxt;

        if IsSalesperson then
            Type := SalespersonTxt
        else
            Type := PurchaserTxt;

        exit(STRSUBSTNO(BlockedSalesPersonPurchErr, Action, Type, SalespersonPurchaser2.Code));
    end;


    //     procedure GetPrivacyBlockedGenericText (SalespersonPurchaser2@1000 : Record 13;IsSalesperson@1001 :
    procedure GetPrivacyBlockedGenericText(SalespersonPurchaser2: Record 13; IsSalesperson: Boolean): Text[150];
    var
        //       Type@1002 :
        Type: Text[20];
    begin

        if IsSalesperson then
            Type := SalespersonTxt
        else
            Type := PurchaserTxt;

        exit(STRSUBSTNO(PrivacyBlockedGenericTxt, Type, SalespersonPurchaser2.Code));
    end;

    //     procedure VerifySalesPersonPurchaserPrivacyBlocked (SalespersonPurchaser2@1000 :
    procedure VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser2: Record 13): Boolean;
    begin

        if SalespersonPurchaser2."Privacy Blocked" then
            exit(TRUE);
        exit(FALSE);
    end;

    /*begin
    //{
//      JAV 18/03/20: - Se incluye el campo del NIF del vendedor para poder incluirlo en la impresi�n de los contratos de venta
//    }
    end.
  */
}




