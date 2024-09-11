table 7207411 "QBU Line Reception Job"
{


    CaptionML = ENU = 'Line Reception Job', ESP = 'L�neas recepci�n proyecto';
    PasteIsValid = false;
    LookupPageID = "Subform Reception Job";
    DrillDownPageID = "Subform Reception Job";

    fields
    {
        field(1; "Recept. Document No."; Code[20])
        {
            CaptionML = ENU = 'Recept. Document No.', ESP = 'No. documento recepci�n';
            Editable = false;


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'No. l�nea';
            Editable = false;


        }
        field(3; "Document No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST("Order"));
            CaptionML = ENU = 'Document No.', ESP = 'No. documento';


        }
        field(4; "Document Line No."; Integer)
        {
            TableRelation = "Purchase Line";
            CaptionML = ENU = 'Document Line No.', ESP = 'No. l�nea documento';


        }
        field(5; "Type"; Option)
        {
            OptionMembers = " ","G/L Account","Item","Fixed Asset","Charge (Item)","Resource";

            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = '" ,G/L Account,Item,,Fixed Asset,Charge (Item),,Resource"', ESP = '" , Cuenta,Producto,Activo fijo,Cargo(Producto),,Recurso"';


            trigger OnValidate();
            BEGIN
                TestStatusOpen;
            END;


        }
        field(6; "No."; Code[20])
        {
            TableRelation = IF ("Type" = CONST(" ")) "Standard Text" ELSE IF ("Type" = CONST("G/L Account")) "G/L Account" ELSE IF ("Type" = CONST("Item")) "Item" ELSE IF ("Type" = CONST("Fixed Asset")) "Fixed Asset" ELSE IF ("Type" = CONST("Charge (Item)")) "Item Charge" ELSE IF ("Type" = CONST("Resource")) "Resource";


            CaptionML = ENU = 'No.', ESP = 'No.';

            trigger OnLookup();
            VAR
                //                                                               LStandardText@7001100 :
                LStandardText: Record 7;
                //                                                               LStandardTextCodes@7001101 :
                LStandardTextCodes: Page 8;
                //                                                               LGLAccount@7001102 :
                LGLAccount: Record 15;
                //                                                               LGLAccountList@7001103 :
                LGLAccountList: Page "G/L Account List";
                //                                                               LItem@7001104 :
                LItem: Record 27;
                //                                                               LItemList@7001105 :
                LItemList: Page "Item List";
                //                                                               LJob@7001106 :
                LJob: Record 167;
                //                                                               LDataCostByPiecework@7001107 :
                LDataCostByPiecework: Record 7207387;
                //                                                               LPieceworkCostList@7001108 :
                LPieceworkCostList: Page 7207525;
                //                                                               LResource@7001109 :
                LResource: Record 156;
                //                                                               LResourceList@7001110 :
                LResourceList: Page 77;
                //                                                               LFixedAsset@7001111 :
                LFixedAsset: Record 5600;
                //                                                               LFixedAssetList@7001112 :
                LFixedAssetList: Page 5601;
                //                                                               LItemCharge@7001113 :
                LItemCharge: Record 5800;
                //                                                               LPageItemCharges@7001114 :
                LPageItemCharges: Page 5800;
            BEGIN
                CASE Type OF
                    Type::" ":
                        BEGIN
                            IF LStandardText.GET("No.") THEN
                                LStandardTextCodes.SETRECORD(LStandardText);
                            LStandardTextCodes.LOOKUPMODE(TRUE);
                            IF LStandardTextCodes.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                LStandardTextCodes.GETRECORD(LStandardText);
                                VALIDATE("No.", LStandardText.Code);
                            END;
                        END;
                    Type::"G/L Account":
                        BEGIN
                            IF "Piecework No." = '' THEN BEGIN
                                IF LGLAccount.GET("No.") THEN
                                    LGLAccountList.SETRECORD(LGLAccount);
                                LGLAccountList.LOOKUPMODE(TRUE);
                                IF LGLAccountList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    LGLAccountList.GETRECORD(LGLAccount);
                                    VALIDATE("No.", LGLAccount."No.");
                                END;
                            END;
                        END;
                    Type::Item:
                        BEGIN
                            IF "Piecework No." = '' THEN BEGIN
                                IF LItem.GET("No.") THEN
                                    LItemList.SETRECORD(LItem);
                                LItemList.LOOKUPMODE(TRUE);
                                IF LItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    LItemList.GETRECORD(LItem);
                                    VALIDATE("No.", LItem."No.");
                                END;
                            END ELSE BEGIN
                                LJob.GET("Job No.");
                                LDataCostByPiecework.SETRANGE("Job No.", "Job No.");
                                LDataCostByPiecework.SETRANGE("Piecework Code", "Piecework No.");
                                LDataCostByPiecework.SETRANGE("Cod. Budget", LJob."Latest Reestimation Code");
                                LDataCostByPiecework.SETRANGE("Cost Type", LDataCostByPiecework."Cost Type"::Item);
                                LDataCostByPiecework.SETRANGE("No.", "No.");
                                IF LDataCostByPiecework.FINDFIRST THEN
                                    LPieceworkCostList.SETRECORD(LDataCostByPiecework);
                                LDataCostByPiecework.SETRANGE("No.");
                                LPieceworkCostList.SETTABLEVIEW(LDataCostByPiecework);
                                LPieceworkCostList.EDITABLE(FALSE);
                                LPieceworkCostList.LOOKUPMODE(TRUE);
                                IF LPieceworkCostList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    LPieceworkCostList.GETRECORD(LDataCostByPiecework);
                                    VALIDATE("No.", LDataCostByPiecework."No.");
                                END;
                            END;
                        END;
                    Type::Resource:
                        BEGIN
                            IF "Piecework No." = '' THEN BEGIN
                                IF LResource.GET("No.") THEN
                                    LResourceList.SETRECORD(LResource);
                                LResourceList.LOOKUPMODE(TRUE);
                                IF LResourceList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    LResourceList.GETRECORD(LResource);
                                    VALIDATE("No.", LResource."No.");
                                END;
                            END ELSE BEGIN
                                LJob.GET("Job No.");
                                LDataCostByPiecework.SETRANGE("Job No.", "Job No.");
                                LDataCostByPiecework.SETRANGE("Piecework Code", "Piecework No.");
                                LDataCostByPiecework.SETRANGE("Cod. Budget", LJob."Latest Reestimation Code");
                                LDataCostByPiecework.SETRANGE("Cost Type", LDataCostByPiecework."Cost Type"::Resource);
                                LDataCostByPiecework.SETRANGE("No.", "No.");
                                IF LDataCostByPiecework.FINDFIRST THEN
                                    LPieceworkCostList.SETRECORD(LDataCostByPiecework);
                                LDataCostByPiecework.SETRANGE("No.");
                                LPieceworkCostList.SETTABLEVIEW(LDataCostByPiecework);
                                LPieceworkCostList.EDITABLE(FALSE);
                                LPieceworkCostList.LOOKUPMODE(TRUE);
                                IF LPieceworkCostList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    LPieceworkCostList.GETRECORD(LDataCostByPiecework);
                                    VALIDATE("No.", LDataCostByPiecework."No.");
                                END;
                            END;
                        END;
                    Type::"Fixed Asset":
                        BEGIN
                            IF LFixedAsset.GET("No.") THEN
                                LFixedAssetList.SETRECORD(LFixedAsset);
                            LFixedAssetList.LOOKUPMODE(TRUE);
                            IF LFixedAssetList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                LFixedAssetList.GETRECORD(LFixedAsset);
                                VALIDATE("No.", LFixedAsset."No.");
                            END;
                        END;
                    Type::"Charge (Item)":
                        BEGIN
                            IF LItemCharge.GET("No.") THEN
                                LPageItemCharges.SETRECORD(LItemCharge);
                            LPageItemCharges.LOOKUPMODE(TRUE);
                            IF LPageItemCharges.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                LPageItemCharges.GETRECORD(LItemCharge);
                                VALIDATE("No.", LItemCharge."No.");
                            END;
                        END;
                END;
            END;


        }
        field(7; "Expected Receipt Date"; Date)
        {
            CaptionML = ENU = 'Expected Receipt Date', ESP = 'Fecha recepci�n esperada';


        }
        field(8; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(9; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(10; "Quantity"; Decimal)
        {
            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';
            DecimalPlaces = 0 : 5;


        }
        field(11; "Outstanding Quantity"; Decimal)
        {
            CaptionML = ENU = 'Outstanding Quantity', ESP = 'Cantidad pendiente';
            DecimalPlaces = 0 : 5;
            Editable = false;


        }
        field(12; "Qty. to Receive"; Decimal)
        {


            CaptionML = ENU = 'Qty. to Receive', ESP = 'Cantidad a recibir';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            BEGIN
                IF "Outstanding Quantity" < "Qty. to Receive" THEN
                    ERROR(Text002, "Outstanding Quantity");

                "Qty. to Receive (Base)" := "Qty. to Receive" * "Qty. per Unit of Measure";
                "Amount to Receive Origin" := "Qty. to Receive" + "Quantity Received";
            END;


        }
        field(13; "Unit Price (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Unit Price (LCY)', ESP = 'Precio venta (LCY)';
            AutoFormatType = 2;


        }
        field(14; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(15; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(16; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';


        }
        field(17; "Quantity Received"; Decimal)
        {


            CaptionML = ENU = 'Quantity Received', ESP = 'Cantidad recibida';
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate();
            BEGIN
                VALIDATE("Qty. to Receive", "Amount to Receive Origin" - "Quantity Received");
            END;


        }
        field(18; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'Cod. divisa';
            Editable = false;


        }
        field(19; "Unit Cost"; Decimal)
        {
            CaptionML = ENU = 'Unit Cost', ESP = 'Coste unitario';
            Editable = false;
            AutoFormatType = 2;


        }
        field(20; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Job Task No.', ESP = 'No. tarea proyecto';


        }
        field(21; "Qty. per Unit of Measure"; Decimal)
        {
            InitValue = 1;
            CaptionML = ENU = 'Qty. per Unit of Measure', ESP = 'Cantidad por unidad medida';
            DecimalPlaces = 0 : 5;
            Editable = false;


        }
        field(22; "Unit of Measure Code"; Code[10])
        {
            TableRelation = IF ("Type" = CONST("Item")) "Item Unit of Measure"."Code" WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";
            CaptionML = ENU = 'Unit of Measure Code', ESP = 'Cod. unidad de medida';


        }
        field(23; "Quantity (Base)"; Decimal)
        {
            CaptionML = ENU = 'Quantity (Base)', ESP = 'Cantidad (Base)';
            DecimalPlaces = 0 : 5;


        }
        field(24; "Outstanding QTy. (Base)"; Decimal)
        {
            CaptionML = ENU = 'Outstanding QTy. (Base)', ESP = 'Cdad. pendiente (base)';
            DecimalPlaces = 0 : 5;
            Editable = false;


        }
        field(25; "Qty. to Receive (Base)"; Decimal)
        {
            CaptionML = ENU = 'Qty. to Receive (Base)', ESP = 'Cdad. a recibir (base)';
            DecimalPlaces = 0 : 5;


        }
        field(26; "Qty.Received (Base)"; Decimal)
        {
            CaptionML = ENU = 'Qty.Received (Base)', ESP = 'Cdad. recibida (base)';
            DecimalPlaces = 0 : 5;
            Editable = false;


        }
        field(27; "Status"; Option)
        {
            OptionMembers = " ","Registered","Wrong Record";
            CaptionML = ENU = 'Status', ESP = 'Estado';
            OptionCaptionML = ENU = '" ,Registered,Wrong Record"', ESP = '" ,Registrada,Registro erroneo"';



        }
        field(28; "Piecework No."; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Production Unit" = FILTER(true));
            CaptionML = ENU = 'Piecework No.', ESP = 'No. unidad de obra';


        }
        field(29; "Amount to Receive Origin"; Decimal)
        {
            CaptionML = ENU = 'Amount to Receive Origin', ESP = 'Cantidad a recibir a origen';
            DecimalPlaces = 0 : 5;


        }
    }
    keys
    {
        key(key1; "Recept. Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       Text001@7001100 :
        Text001: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Text002@7001101 :
        Text002: TextConst ENU = 'You cannot handle more than the outstanding %1 units.', ESP = 'No puede manipular m�s de %1 unidades pendientes.';
        //       Item@7001102 :
        Item: Record 27;



    trigger OnRename();
    begin
        ERROR(Text001, TABLECAPTION);
    end;



    LOCAL procedure TestStatusOpen()
    begin
    end;

    //     procedure ItemAvailability (AvailabilityType@1000 :
    procedure ItemAvailability(AvailabilityType: Option "Date","Variant","Location")
    var
        //       ItemAvailabilitybyPeriods@1001 :
        ItemAvailabilitybyPeriods: Page "Item Availability by Periods";
        //       ItemAvailabilitybyVariant@1002 :
        ItemAvailabilitybyVariant: Page "Item Availability by Variant";
        //       ItemAvailabilitybyLocation@1003 :
        ItemAvailabilitybyLocation: Page "Item Availability by Location";
    begin
        TESTFIELD("No.");
        Item.RESET;
        Item.GET("No.");
        Item.SETRANGE("No.", "No.");
        Item.SETRANGE("Date Filter", 0D, "Expected Receipt Date");

        CASE AvailabilityType OF
            AvailabilityType::Date:
                begin
                    CLEAR(ItemAvailabilitybyPeriods);
                    ItemAvailabilitybyPeriods.SETRECORD(Item);
                    ItemAvailabilitybyPeriods.SETTABLEVIEW(Item);
                    ItemAvailabilitybyPeriods.RUNMODAL;
                end;
            AvailabilityType::Variant:
                begin
                    CLEAR(ItemAvailabilitybyVariant);
                    ItemAvailabilitybyVariant.SETRECORD(Item);
                    ItemAvailabilitybyVariant.SETTABLEVIEW(Item);
                    ItemAvailabilitybyVariant.RUNMODAL;
                end;
            AvailabilityType::Location:
                begin
                    CLEAR(ItemAvailabilitybyLocation);
                    ItemAvailabilitybyLocation.SETRECORD(Item);
                    ItemAvailabilitybyLocation.SETTABLEVIEW(Item);
                    ItemAvailabilitybyLocation.RUNMODAL;
                end;
        end;
    end;

    //     procedure AutofillQtyToReceive (var WhseReceiptLine@1000 :
    procedure AutofillQtyToReceive(var WhseReceiptLine: Record 7207411)
    begin
        /*To be Tested*/
        // WITH WhseReceiptLine DO begin
        if FINDSET then
            repeat
                VALIDATE("Qty. to Receive", WhseReceiptLine."Outstanding Quantity");
                MODIFY;
            until NEXT = 0;
        // end;
    end;

    //     procedure DeleteQtyToReceive (var WhseReceiptLine@1000 :
    procedure DeleteQtyToReceive(var WhseReceiptLine: Record 7207411)
    begin
        /*To be Tested*/
        // WITH WhseReceiptLine DO begin
        if FINDSET then
            repeat
                VALIDATE("Qty. to Receive", 0);
                MODIFY;
            until NEXT = 0;
        // end;
    end;

    /*begin
    end.
  */
}







