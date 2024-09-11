table 7206956 "QBU Framework Contr. Use"
{


    DataPerCompany = false;
    CaptionML = ENU = 'Blanket Order, use where', ESP = 'Contrato Marco, l�neas de uso';
    LookupPageID = "QB Framework Contr. Use";
    DrillDownPageID = "QB Framework Contr. Use";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Entry No..', ESP = 'N� movimiento';


        }
        field(9; "Entry Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha del Movimiento';


        }
        field(10; "Framework Contr. No."; Code[20])
        {
            TableRelation = "QB Framework Contr. Header"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order No.', ESP = 'N� Contrato marco';


        }
        field(11; "Framework Contr. Line"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order Line No.', ESP = 'N� l�nea contrato marco';


        }
        field(19; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Proyecto';


        }
        field(20; "Company"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Company', ESP = 'Empresa';


        }
        field(21; "Document Type"; Option)
        {
            OptionMembers = "Job","Comparative","Order","Shipment","Invoice";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            OptionCaptionML = ENU = 'Job,Comparative,Order,Shipment,,Invoice', ESP = 'Proyecto,Comparativo,Pedido,Albar�n,,Factura';



        }
        field(22; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document No.', ESP = 'N� Documento';


        }
        field(23; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(24; "Comparative document Status"; Option)
        {
            OptionMembers = "In-Progress","Generated","Inactive";
            DataClassification = ToBeClassified;
            OptionCaptionML = ENU = 'In-Progress,Generated,Inactive', ESP = 'En proceso,Generado,No Activo';

            Description = 'Q17502 CPA 30/06/22 - Ajustes en Contratos Marco';


        }
        field(25; "Invoice Document Sub-Type"; Option)
        {
            OptionMembers = " ","Inv. from Shipment";
            DataClassification = ToBeClassified;
            OptionCaptionML = ENU = '" ,Inv. from Shipment"', ESP = '" ,Fra. de Albar�n"';

            Description = 'Q17502 CPA 30/06/22 - Ajustes en Contratos Marco';


        }
        field(30; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Vendor No.', ESP = 'N� Proveedor';


        }
        field(31; "Type"; Enum "Purchase Line Type")
        {
            //OptionMembers=" ","G/L Account","Item","Fixed Asset","Charge (Item)","Resource";

            CaptionML = ENU = 'Type', ESP = 'Tipo';
            //OptionCaptionML=ENU='" ,G/L Account,Item,,Fixed Asset,Charge (Item),,Resource"',ESP='" ,Cuenta,Producto,,Activo fijo,Cargo (Prod.),,Recurso"';


            trigger OnValidate();
            VAR
                //                                                                 TempPurchLine@1000 :
                TempPurchLine: Record 39 TEMPORARY;
            begin
                //{
                //                                                                GetPurchHeader;
                //                                                                TestStatusOpen;
                //
                //                                                                TESTFIELD("Qty. Rcd. Not Invoiced",0);
                //                                                                TESTFIELD("Quantity Received",0);
                //                                                                TESTFIELD("Receipt No.",'');
                //
                //                                                                TESTFIELD("Return Qty. Shipped Not Invd.",0);
                //                                                                TESTFIELD("Return Qty. Shipped",0);
                //                                                                TESTFIELD("Return Shipment No.",'');
                //
                //                                                                TESTFIELD("Prepmt. Amt. Inv.",0);
                //
                //                                                                IF "Drop Shipment" THEN
                //                                                                  ERROR(
                //                                                                    Text001,
                //                                                                    FIELDCAPTION(Type),"Sales Order No.");
                //                                                                IF "Special Order" THEN
                //                                                                  ERROR(
                //                                                                    Text001,
                //                                                                    FIELDCAPTION(Type),"Special Order Sales No.");
                //                                                                IF "Prod. Order No." <> '' THEN
                //                                                                  ERROR(
                //                                                                    Text044,
                //                                                                    FIELDCAPTION(Type),FIELDCAPTION("Prod. Order No."),"Prod. Order No.");
                //
                //                                                                IF Type <> xRec.Type THEN BEGIN 
                //                                                                  IF Quantity <> 0 THEN BEGIN 
                //                                                                    ReservePurchLine.VerifyChange(Rec,xRec);
                //                                                                    CALCFIELDS("Reserved Qty. (Base)");
                //                                                                    TESTFIELD("Reserved Qty. (Base)",0);
                //                                                                    WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                //                                                                  END;
                //                                                                  IF xRec.Type IN [Type::Item,Type::"Fixed Asset"] THEN BEGIN 
                //                                                                    IF Quantity <> 0 THEN
                //                                                                      PurchHeader.TESTFIELD(Status,PurchHeader.Status::Open);
                //                                                                    DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");
                //                                                                  END;
                //                                                                  IF xRec.Type = Type::"Charge (Item)" THEN
                //                                                                    DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");
                //                                                                  IF xRec."Deferral Code" <> '' THEN
                //                                                                    DeferralUtilities.RemoveOrSetDeferralSchedule('',
                //                                                                      DeferralUtilities.GetPurchDeferralDocType,'','',
                //                                                                      xRec."Document Type",xRec."Document No.",xRec."Line No.",
                //                                                                      xRec.GetDeferralAmount,PurchHeader."Posting Date",'',xRec."Currency Code",TRUE);
                //                                                                END;
                //                                                                TempPurchLine := Rec;
                //                                                                INIT;
                //
                //                                                                IF xRec."Line Amount" <> 0 THEN
                //                                                                  "Recalculate Invoice Disc." := TRUE;
                //
                //                                                                Type := TempPurchLine.Type;
                //                                                                "System-Created Entry" := TempPurchLine."System-Created Entry";
                //                                                                OnValidateTypeOnCopyFromTempPurchLine(Rec,TempPurchLine);
                //                                                                VALIDATE("FA Posting Type");
                //
                //                                                                IF Type = Type::Item THEN
                //                                                                  "Allow Item Charge Assignment" := TRUE
                //                                                                ELSE
                //                                                                  "Allow Item Charge Assignment" := FALSE;
                //                                                                }
            END;


        }
        field(32; "No."; Code[20])
        {
            TableRelation = IF ("Type" = CONST("G/L Account")) "G/L Account" ELSE IF ("Type" = CONST("Item")) "Item" ELSE IF ("Type" = CONST("Charge (Item)")) "Item Charge" ELSE IF ("Type" = CONST("Resource")) "Resource";


            CaptionML = ENU = 'No.', ESP = 'N�';

            trigger OnValidate();
            VAR
                //                                                                 TempPurchLine@1003 :
                TempPurchLine: Record 39 TEMPORARY;
                //                                                                 FindRecordMgt@1000 :
                FindRecordMgt: Codeunit 703;
            begin
                //{
                //                                                                GetPurchSetup;
                //                                                                IF PurchSetup."Create Item from Item No." THEN
                //                                                                  "No." := FindRecordMgt.FindNoFromTypedValue(Type,"No.",NOT "System-Created Entry");
                //
                //                                                                TestStatusOpen;
                //                                                                TESTFIELD("Qty. Rcd. Not Invoiced",0);
                //                                                                TESTFIELD("Quantity Received",0);
                //                                                                TESTFIELD("Receipt No.",'');
                //
                //                                                                TESTFIELD("Prepmt. Amt. Inv.",0);
                //
                //                                                                TestReturnFieldsZero;
                //
                //                                                                IF "Drop Shipment" THEN
                //                                                                  ERROR(
                //                                                                    Text001,
                //                                                                    FIELDCAPTION("No."),"Sales Order No.");
                //
                //                                                                IF "Special Order" THEN
                //                                                                  ERROR(
                //                                                                    Text001,
                //                                                                    FIELDCAPTION("No."),"Special Order Sales No.");
                //
                //                                                                IF "Prod. Order No." <> '' THEN
                //                                                                  ERROR(
                //                                                                    Text044,
                //                                                                    FIELDCAPTION(Type),FIELDCAPTION("Prod. Order No."),"Prod. Order No.");
                //
                //                                                                OnValidateNoOnAfterChecks(Rec,xRec,CurrFieldNo);
                //
                //                                                                IF "No." <> xRec."No." THEN BEGIN 
                //                                                                  IF (Quantity <> 0) AND ItemExists(xRec."No.") THEN BEGIN 
                //                                                                    ReservePurchLine.VerifyChange(Rec,xRec);
                //                                                                    CALCFIELDS("Reserved Qty. (Base)");
                //                                                                    TESTFIELD("Reserved Qty. (Base)",0);
                //                                                                    IF Type = Type::Item THEN
                //                                                                      WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                //                                                                    OnValidateNoOnAfterVerifyChange(Rec,xRec);
                //                                                                  END;
                //                                                                  IF Type = Type::Item THEN
                //                                                                    DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");
                //                                                                  IF Type = Type::"Charge (Item)" THEN
                //                                                                    DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");
                //                                                                END;
                //
                //                                                                OnValidateNoOnBeforeInitRec(Rec,xRec,CurrFieldNo);
                //                                                                TempPurchLine := Rec;
                //                                                                INIT;
                //                                                                IF xRec."Line Amount" <> 0 THEN
                //                                                                  "Recalculate Invoice Disc." := TRUE;
                //                                                                Type := TempPurchLine.Type;
                //                                                                "No." := TempPurchLine."No.";
                //                                                                OnValidateNoOnCopyFromTempPurchLine(Rec,TempPurchLine);
                //                                                                IF "No." = '' THEN
                //                                                                  EXIT;
                //
                //                                                                IF HasTypeToFillMandatoryFields THEN BEGIN 
                //                                                                  Quantity := TempPurchLine.Quantity;
                //                                                                  "Outstanding Qty. (Base)" := TempPurchLine."Outstanding Qty. (Base)";
                //                                                                END;
                //
                //                                                                "System-Created Entry" := TempPurchLine."System-Created Entry";
                //                                                                GetPurchHeader;
                //                                                                InitHeaderDefaults(PurchHeader);
                //                                                                UpdateLeadTimeFields;
                //                                                                UpdateDates;
                //
                //                                                                OnAfterAssignHeaderValues(Rec,PurchHeader);
                //
                //                                                                CASE Type OF
                //                                                                  Type::" ":
                //                                                                    CopyFromStandardText;
                //                                                                  Type::"G/L Account":
                //                                                                    CopyFromGLAccount;
                //                                                                  Type::Item:
                //                                                                    CopyFromItem;
                //                                                                  3:
                //                                                                    ERROR(Text003);
                //                                                                  Type::"Fixed Asset":
                //                                                                    CopyFromFixedAsset;
                //                                                                  Type::"Charge (Item)":
                //                                                                    CopyFromItemCharge;
                //                                                                END;
                //
                //                                                                OnAfterAssignFieldsForNo(Rec,xRec,PurchHeader);
                //
                //                                                                IF Type <> Type::" " THEN BEGIN 
                //                                                                  PostingSetupMgt.CheckGenPostingSetupPurchAccount("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                //                                                                  PostingSetupMgt.CheckVATPostingSetupPurchAccount("VAT Bus. Posting Group","VAT Prod. Posting Group");
                //                                                                END;
                //
                //                                                                IF HasTypeToFillMandatoryFields AND NOT (Type = Type::"Fixed Asset") THEN
                //                                                                  VALIDATE("VAT Prod. Posting Group");
                //
                //                                                                UpdatePrepmtSetupFields;
                //
                //                                                                IF HasTypeToFillMandatoryFields THEN BEGIN 
                //                                                                  Quantity := xRec.Quantity;
                //                                                                  OnValidateNoOnAfterAssignQtyFromXRec(Rec,TempPurchLine);
                //                                                                  VALIDATE("Unit of Measure Code");
                //                                                                  IF Quantity <> 0 THEN BEGIN 
                //                                                                    InitOutstanding;
                //                                                                    IF IsCreditDocType THEN
                //                                                                      InitQtyToShip
                //                                                                    ELSE
                //                                                                      InitQtyToReceive;
                //                                                                  END;
                //                                                                  UpdateWithWarehouseReceive;
                //                                                                  UpdateDirectUnitCost(FIELDNO("No."));
                //                                                                  IF xRec."Job No." <> '' THEN
                //                                                                    VALIDATE("Job No.",xRec."Job No.");
                //                                                                    "Job Line Type" := xRec."Job Line Type";
                //                                                                    IF xRec."Job Task No." <> '' THEN BEGIN 
                //                                                                      VALIDATE("Job Task No.",xRec."Job Task No.");
                //                                                                      IF "No." = xRec."No." THEN
                //                                                                        VALIDATE("Job Planning Line No.",xRec."Job Planning Line No.");
                //                                                                    END;
                //                                                                END;
                //
                //                                                                CreateDim(
                //                                                                  DimMgt.TypeToTableID3(Type),"No.",
                //                                                                  DATABASE::Job,"Job No.",
                //                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                //                                                                  DATABASE::"Work Center","Work Center No.");
                //
                //                                                                PurchHeader.GET("Document Type","Document No.");
                //                                                                UpdateItemReference;
                //
                //                                                                GetDefaultBin;
                //
                //                                                                IF JobTaskIsSet THEN BEGIN 
                //                                                                  CreateTempJobJnlLine(TRUE);
                //                                                                  UpdateJobPrices;
                //                                                                  UpdateDimensionsFromJobTask;
                //                                                                END;
                //                                                                }
            END;


        }
        field(33; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Unit Price', ESP = 'Precio Unitario';


        }
        field(34; "Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';
            ;


        }
    }
    keys
    {
        key(key1; "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       QuoBuildingSetup@1100286000 :
        QuoBuildingSetup: Record 7207278;

    /*begin
    {
      JAV 02/03/22: - QB 1.10.22 Se arregla la relaci�n de tablas del campo No. que aputnaba a una err�nea

      CPA 30/06/22 Q17502 - Ajustes en Contratos Marco
                   New field: Comparative document Status
                   New field: Invoice Document Sub-Type
    }
    end.
  */
}







