table 7207429 "Selected Vendors Quote"
{


    CaptionML = ENU = 'Selected Vendors Quote', ESP = 'Proveed. seleccionados oferta';

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor";
            CaptionML = ENU = 'Vendor No.', ESP = 'C�d. Proveedor';
            Description = 'Key 2';
            Editable = false;


        }
        field(2; "Activity Code"; Code[50])
        {
            TableRelation = "Activity QB"."Activity Code";
            CaptionML = ENU = 'Activity Code', ESP = 'C�d. Actividad';
            Description = 'Key 4';
            Editable = false;


        }
        field(3; "Ambito actividad"; Option)
        {
            OptionMembers = "Local","Autonomous","Nacional";
            CaptionML = ENU = 'Ambito actividad', ESP = '�mbito actividad';
            OptionCaptionML = ENU = 'Local,Autonomous,Nacional', ESP = 'Local,Auton�mico,Nacional';

            BlankZero = false;
            Editable = false;


        }
        field(4; "Vendor Name"; Text[50])
        {
            CaptionML = ENU = 'Vendor Name', ESP = 'Nombre proveedor';
            Editable = false;


        }
        field(5; "Vendor City"; Text[50])
        {
            CaptionML = ENU = 'Vendor City', ESP = 'Poblaci�n proveedor';
            Editable = false;


        }
        field(6; "Quote No."; Code[20])
        {
            CaptionML = ENU = 'Quote No.', ESP = 'N� comparativo';
            Description = 'Key 1';
            Editable = false;


        }
        field(7; "Selected"; Boolean)
        {
            CaptionML = ENU = 'Selected', ESP = 'Seleccionado';


        }
        field(8; "Contact No."; Code[20])
        {
            TableRelation = Contact."No." WHERE("Type" = CONST("Company"));
            CaptionML = ENU = 'Contact No.', ESP = 'N� contacto';
            Description = 'Key 3';


        }
        field(9; "County"; Code[30])
        {
            TableRelation = "Country/Region";


            CaptionML = ENU = 'Country/Region Code', ESP = 'Provincia';
            Description = 'QB 1.8.06 JAV 28/01/21 Se amplia la longitud';
            Editable = false;

            trigger OnValidate();
            BEGIN
                //GEN001
            END;


        }
        field(10; "Country/Region Code"; Code[30])
        {
            TableRelation = "Country/Region";


            CaptionML = ENU = 'Country/Region Code', ESP = 'C�d. pa�s/regi�n';
            Description = 'QB 1.8.06 JAV 28/01/21 Se amplia la longitud';

            trigger OnValidate();
            BEGIN
                //GEN001
            END;


        }
        field(11; "Operation Counties"; Text[50])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Operation County', ESP = 'Provincias en que opera';
            Description = 'QB 1.0 - JAV 03/04/20 ELECNOR GEN001-04';

            trigger OnValidate();
            VAR
                //                                                                 OpCountry@1100286000 :
                OpCountry: Text;
                //                                                                 Country@1100286002 :
                Country: Code[20];
                //                                                                 CountryRegion@1100286001 :
                CountryRegion: Record 9;
                //                                                                 i@1100286003 :
                i: Integer;
            BEGIN
                //GEN001
            END;


        }
        field(12; "Operation Countries"; Text[50])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Operation Country', ESP = 'Paises en que opera';
            Description = 'QB 1.0 - JAV 03/04/20 ELECNOR GEN001-04';

            trigger OnValidate();
            VAR
                //                                                                 OpCountry@1100286000 :
                OpCountry: Text;
                //                                                                 Country@1100286002 :
                Country: Code[20];
                //                                                                 CountryRegion@1100286001 :
                CountryRegion: Record 9;
                //                                                                 i@1100286003 :
                i: Integer;
            BEGIN
                //GEN001
            END;


        }
        field(30; "Evaluation Global"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Evaluaci�n global';
            Description = 'QB 1.06.08 - JAV 14/08/20: - Puntuaci�n final obtenida en esta actividad, en el momento de creaci�n del comparativo';
            Editable = false;

            trigger OnValidate();
            BEGIN
                "Clasification Global" := CodesEvaluation.GetClasification("Evaluation Global");
            END;


        }
        field(31; "Clasification Global"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Clasificaci�n global';
            Description = 'QB 1.06.08 - JAV 14/08/20: - Clasificaci�n final obtenida en esta actividad, en el momento de creaci�n del comparativo';
            Editable = false;


        }
        field(32; "Evaluation Activity"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Evaluaci�n de la actividad';
            Description = 'QB 1.06.08 - JAV 14/08/20: - Puntuaci�n media del proveedor en todas las actividades,, en el momento de creaci�n del comparativo';
            Editable = false;

            trigger OnValidate();
            BEGIN
                "Clasification Activity" := CodesEvaluation.GetClasification("Evaluation Activity");
            END;


        }
        field(33; "Clasification Activity"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Clasificaci�n de la actividad';
            Description = 'QB 1.06.08 - JAV 14/08/20: - Clasificaci�n media del proveedor en todas las actividades,, en el momento de creaci�n del comparativo';
            Editable = false;


        }
        field(50000; "Comparative Blocked"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative Blocked', ESP = 'Bloqueado para comparativos';
            Description = 'QPE6436';
            Editable = false;


        }
        field(50001; "Comment"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blocked Comment', ESP = 'Comentario';
            Description = 'QPE6436';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Quote No.", "Vendor No.", "Contact No.", "Activity Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       CodesEvaluation@1100286000 :
        CodesEvaluation: Record 7207422;

    //     procedure CreateContact (QuoteNo@7001101 :
    procedure CreateContact(QuoteNo: Code[20]): Code[20];
    var
        //       ComparativeQuoteHeader@7001102 :
        ComparativeQuoteHeader: Record 7207412;
        //       ContactActivitiesQB@7001103 :
        ContactActivitiesQB: Record 7207430;
        //       Contact@7001104 :
        Contact: Record 5050;
        //       SelectedVendorsQuote@7001105 :
        SelectedVendorsQuote: Record 7207429;
        //       CreatingContacts@7001100 :
        CreatingContacts: Codeunit 7207335;
        //       CodContac@1100286000 :
        CodContac: Code[20];
    begin
        //JAV 25/07/19: - Cuando creas un contacto, retorna el contacto creado
        CLEAR(CreatingContacts);
        exit(CreatingContacts.CreateContact(QuoteNo));

        //{--- JAV 25/07/19: - Esto ya lo hace el proceso siguiente al retornar el c�digo creado
        //      if ComparativeQuoteHeader."Activity Filter" <> '' then
        //        ContactActivitiesQB.SETFILTER("Activity Code",ComparativeQuoteHeader."Activity Filter")
        //      else
        //        ContactActivitiesQB.SETRANGE("Activity Code",ComparativeQuoteHeader."Activity Code");
        //      if ContactActivitiesQB.FINDSET(FALSE,FALSE) then
        //        repeat
        //          if Contact.GET(ContactActivitiesQB."Contact No.") then begin
        //            if Contact.Type = Contact.Type::Company then begin
        //              SelectedVendorsQuote.INIT;
        //              SelectedVendorsQuote."Quote No." := QuoteNo;
        //              SelectedVendorsQuote."Vendor No." := '';
        //              SelectedVendorsQuote."Contact No." := ContactActivitiesQB."Contact No.";
        //              SelectedVendorsQuote."Activity Code" := ContactActivitiesQB."Activity Code";
        //              SelectedVendorsQuote."Vendor Name" := Contact.Name;
        //              SelectedVendorsQuote."Vendor City" := Contact.City;
        //              SelectedVendorsQuote."Ambito actividad" := Contact."Area Activity";
        //              if SelectedVendorsQuote.INSERT then;
        //            end;
        //          end;
        //        until ContactActivitiesQB.NEXT = 0;
        //      ---}
    end;

    //     procedure GenerateComparative (QuoteNo@7001102 : Code[20];ActivityFilter@7001112 :
    procedure GenerateComparative(QuoteNo: Code[20]; ActivityFilter: Text[250])
    var
        //       ComparativeQuoteLines@7001101 :
        ComparativeQuoteLines: Record 7207413;
        //       VendorConditionsData@7001105 :
        VendorConditionsData: Record 7207414;
        //       VendorConditionsData2@7001118 :
        VendorConditionsData2: Record 7207414;
        //       ComparativeQuoteHeader@7001108 :
        ComparativeQuoteHeader: Record 7207412;
        //       Job@7001109 :
        Job: Record 167;
        //       PurchasesPayablesSetup@7001110 :
        PurchasesPayablesSetup: Record 312;
        //       PurchaseJournalLine@7001111 :
        PurchaseJournalLine: Record 7207281;
        //       CompanyInformation@7001113 :
        CompanyInformation: Record 79;
        //       DataPieceworkForProduction@7001115 :
        DataPieceworkForProduction: Record 7207386;
        //       Resource@7001116 :
        Resource: Record 156;
        //       Item@7001117 :
        Item: Record 27;
        //       LineNo@7001103 :
        LineNo: Integer;
        //       Quantity@7001114 :
        Quantity: Decimal;
        //       GenerateLinesComparative@7001100 :
        GenerateLinesComparative: Boolean;
        //       Text000@7001104 :
        Text000: TextConst ENU = 'Do you want to delete the existing lines of the Quote?', ESP = '�Quiere borrar las l�neas existentes de la oferta?';
        //       Window@7001106 :
        Window: Dialog;
        //       Text001@7001107 :
        Text001: TextConst ENU = 'Generating comparative @1@@@@@@@@@@@', ESP = 'Generando comparativo @1@@@@@@@@@@@';
    begin
        GenerateLinesComparative := TRUE;
        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.SETCURRENTKEY("Quote No.", "Line No.");
        ComparativeQuoteLines.SETRANGE("Quote No.", QuoteNo);
        if ComparativeQuoteLines.FINDLAST then begin
            LineNo := ComparativeQuoteLines."Line No.";
            //{if CONFIRM(Text000) then begin
            //           ComparativeQuoteLines.DELETEALL;
            //           LineNo := 0;
            //           VendorConditionsData2.RESET;
            //           VendorConditionsData2.SETRANGE("Quote Code",QuoteNo);
            //           VendorConditionsData2.DELETEALL(TRUE);
            //         end else
            //           GenerateLinesComparative := FALSE;}
            GenerateLinesComparative := FALSE;//jmma
        end else
            LineNo := 0;
        Window.OPEN(Text001);
        CompanyInformation.GET;
        if ComparativeQuoteHeader.GET("Quote No.") then
            if ComparativeQuoteHeader."Job No." <> '' then
                Job.GET(ComparativeQuoteHeader."Job No.");

        if GenerateLinesComparative then begin
            PurchaseJournalLine.RESET;
            PurchaseJournalLine.SETCURRENTKEY("Job No.", "Activity Code");
            PurchaseJournalLine.SETRANGE("Job No.", ComparativeQuoteHeader."Job No.");
            PurchaseJournalLine.SETFILTER(PurchaseJournalLine."Activity Code", ActivityFilter);
            if ComparativeQuoteHeader."Comparative Type" <> ComparativeQuoteHeader."Comparative Type"::Mixed then begin
                if ComparativeQuoteHeader."Comparative Type" = ComparativeQuoteHeader."Comparative Type"::Item then
                    PurchaseJournalLine.SETRANGE(Type, PurchaseJournalLine.Type::Item);
                if ComparativeQuoteHeader."Comparative Type" = ComparativeQuoteHeader."Comparative Type"::Resource then
                    PurchaseJournalLine.SETRANGE(Type, PurchaseJournalLine.Type::Resource);
            end;
            if PurchaseJournalLine.FINDSET then begin
                repeat
                    Window.UPDATE(1, LineNo);
                    Quantity := 0;
                    ComparativeQuoteLines.INIT;
                    ComparativeQuoteLines."Quote No." := QuoteNo;
                    LineNo := LineNo + 10000;
                    ComparativeQuoteLines."Line No." := LineNo;
                    ComparativeQuoteLines.Type := PurchaseJournalLine.Type;
                    ComparativeQuoteLines."Job No." := ComparativeQuoteHeader."Job No.";
                    ComparativeQuoteLines.VALIDATE("No.", PurchaseJournalLine."No.");
                    ComparativeQuoteLines.VALIDATE("Unit of measurement Code", PurchaseJournalLine."Unit of Measure Code");
                    if (ComparativeQuoteHeader."Comparative To" = ComparativeQuoteHeader."Comparative To"::Location) and
                       (ComparativeQuoteHeader."Location Code" <> '') then begin
                        ComparativeQuoteLines.VALIDATE("Location Code", ComparativeQuoteHeader."Location Code");
                    end;
                    PurchaseJournalLine.CALCFIELDS("Stock Contracts Items (Base)", "Stock Contracts Resource (B)");
                    if (PurchaseJournalLine.Quantity < 0) and (PurchaseJournalLine."Estimated Amount" > 0) then begin
                        Quantity := ABS(PurchaseJournalLine.Quantity);
                        PurchaseJournalLine.VALIDATE("Estimated Price", ABS(PurchaseJournalLine."Estimated Price"));
                    end else begin
                        if PurchaseJournalLine.Type = PurchaseJournalLine.Type::Resource then begin
                            if DataPieceworkForProduction.GET(PurchaseJournalLine."Job No.", PurchaseJournalLine."Job Unit") then
                                if DataPieceworkForProduction."Type Unit Cost" <> DataPieceworkForProduction."Type Unit Cost"::External then
                                    Quantity := PurchaseJournalLine.Quantity - PurchaseJournalLine."Stock Contracts Items (Base)" -
                                    PurchaseJournalLine."Stock Contracts Resource (B)"
                                else
                                    Quantity := PurchaseJournalLine.Quantity - PurchaseJournalLine."Stock Contracts Items (Base)" -
                                                  PurchaseJournalLine."Stock Contracts Resource (B)";
                        end else
                            Quantity := PurchaseJournalLine.Quantity;
                    end;
                    if Quantity > 0 then begin
                        ComparativeQuoteLines.VALIDATE(Quantity, Quantity);
                        ComparativeQuoteLines.VALIDATE("Estimated Price", PurchaseJournalLine."Estimated Price");
                        ComparativeQuoteLines.VALIDATE("Target Price", PurchaseJournalLine."Target Price");
                        if ComparativeQuoteLines.Quantity <> 0 then begin
                            ComparativeQuoteLines.INSERT(TRUE);
                            ComparativeQuoteLines.VALIDATE("Piecework No.", PurchaseJournalLine."Job Unit");
                            ComparativeQuoteLines.VALIDATE(Quantity, Quantity);
                            ComparativeQuoteLines."Unit of measurement Code" := PurchaseJournalLine."Unit of Measure Code";
                            ComparativeQuoteLines."Shortcut Dimension 1 Code" := PurchaseJournalLine."Shortcut Dimension 1 Code";
                            ComparativeQuoteLines."Shortcut Dimension 2 Code" := PurchaseJournalLine."Shortcut Dimension 2 Code";
                            ComparativeQuoteLines.Description := PurchaseJournalLine.Decription;
                            ComparativeQuoteLines."Description 2" := PurchaseJournalLine.Decription;
                            if ComparativeQuoteLines.Description = '' then begin
                                if ComparativeQuoteLines.Type = ComparativeQuoteLines.Type::Resource then begin
                                    Resource.GET(ComparativeQuoteLines."No.");
                                    ComparativeQuoteLines.VALIDATE(ComparativeQuoteLines.Description, Resource.Name);
                                end;
                                if ComparativeQuoteLines.Type = ComparativeQuoteLines.Type::Item then begin
                                    Item.GET(ComparativeQuoteLines."No.");
                                    ComparativeQuoteLines.VALIDATE(ComparativeQuoteLines.Description, Item.Description);
                                end;
                            end;
                            ComparativeQuoteLines."Initial Estimated Quantity" := Quantity;
                            ComparativeQuoteLines."Initial Estimated Amount" := ComparativeQuoteLines."Initial Estimated Quantity" *
                                                                        ComparativeQuoteLines."Estimated Price";
                            ComparativeQuoteLines.MODIFY(TRUE);
                        end;
                    end;
                until PurchaseJournalLine.NEXT = 0;
            end;
        end;
        SETRANGE(Selected, TRUE);
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if FINDSET(FALSE,FALSE) then begin
        if FINDSET(FALSE) then begin
            repeat
                //JAV 10/08/19: - Se llama a la funci�n AddVendor para a�adir un vendor/contacto al comparativo
                AddVendor(ComparativeQuoteHeader."Job No.", ComparativeQuoteHeader."No.", "Activity Code", "Vendor No.", "Contact No.");
            until NEXT = 0;
        end;
        Window.CLOSE;
    end;

    //     procedure AddVendor (JobNo@1100286003 : Code[20];QuoteNo@1100286002 : Code[20];ActivityFilter@1100286004 : Code[250];VendorNo@1100286001 : Code[20];ContactNo@1100286000 :
    procedure AddVendor(JobNo: Code[20]; QuoteNo: Code[20]; ActivityFilter: Code[250]; VendorNo: Code[20]; ContactNo: Code[20])
    var
        //       VendorConditionsData@1100286005 :
        VendorConditionsData: Record 7207414;
        //       VendorQualityData@1100286006 :
        VendorQualityData: Record 7207418;
        //       text001@1100286007 :
        text001: TextConst ESP = 'El proveedor %1 est� bloqueado para comparativos, no se generar�';
        //       ActivityQB@100000000 :
        ActivityQB: Record 7207280;
    begin
        //JAV 10/08/19: - Se a�ade la funci�n AddVendor para a�adir un vendor/contacto al comparativo
        //JAV 07/11/22: - QB 1.12.15 Se amplia la variable ActivityFilter de 20 a 250 para evitar errores de desbordamiento

        //Mirar que no exista ya con alguna versi�n
        VendorConditionsData.RESET;
        VendorConditionsData.SETRANGE("Quote Code", QuoteNo);
        if (VendorNo <> '') then
            VendorConditionsData.SETRANGE("Vendor No.", VendorNo);
        if (ContactNo <> '') then
            VendorConditionsData.SETRANGE("Vendor No.", ContactNo);
        if (not VendorConditionsData.ISEMPTY) then
            exit;

        ActivityQB.RESET;
        ActivityQB.SETFILTER("Activity Code", ActivityFilter);
        if (ActivityQB.FINDSET(FALSE)) then
            repeat
                //JAV 24/09/19: - Si el proveedor selecionado en el descompuesto no tiene asocida la actividad, se crea
                if (not VendorQualityData.GET(VendorNo, ActivityQB."Activity Code")) then begin
                    VendorQualityData.INIT;
                    VendorQualityData."Vendor No." := VendorNo;
                    VendorQualityData."Activity Code" := ActivityQB."Activity Code";
                    VendorQualityData.INSERT(TRUE);
                end;

                //No debe estar bloqueado para comprativos
                if (VendorQualityData."Comparative Blocked") then
                    MESSAGE(text001, "Vendor No.");
            until ActivityQB.NEXT = 0;

        //A�ador el vendedor
        VendorConditionsData.INIT;
        VendorConditionsData."Quote Code" := QuoteNo;
        VendorConditionsData."Job No." := JobNo;
        if VendorNo <> '' then begin
            VendorConditionsData.VALIDATE("Vendor No.", VendorNo);
            VendorConditionsData."Contact No." := '';
        end else begin
            VendorConditionsData.VALIDATE(VendorConditionsData."Contact No.", ContactNo);
            VendorConditionsData."Vendor No." := '';
        end;
        if (VendorNo <> '') or (ContactNo <> '') then //Q8178 A�adido este control para que no cree una l�nea en blanco
            if not VendorConditionsData.INSERT(TRUE) then
                VendorConditionsData.MODIFY(TRUE);
    end;

    /*begin
    //{
//      JAV 25/07/19: - Cuando creas un contacto, retorna el contacto creado
//      JAV 10/08/19: - Se a�ade la funci�n AddVendor para a�adir un vendor/contacto al comparativo
//      JAV 24/09/19: - Si el proveedor selecionado en el descompuesto no tiene asocida la actividad, se crea
//      PGM 31/10/19: - Q8178 A�adido un control para no que no crees lineas en blanco al generar proveedores para los comparativos
//      JAV 07/11/22: - QB 1.12.15 Se amplia la variable ActivityFilter de 20 a 250 para evitar errores de desbordamiento en la funci�n AddVendor
//    }
    end.
  */
}







