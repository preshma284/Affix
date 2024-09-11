tableextension 50154 "MyExtension50154" extends "Job Journal Line"
{


    CaptionML = ENU = 'Job Journal Line', ESP = 'L�n. diario proyecto';

    fields
    {
        field(7207270; "Job Deviation Entry"; Boolean)
        {
            CaptionML = ENU = 'Job Deviation Entry', ESP = 'Movimiento proyecto desviaci�n';
            Description = 'QB2713';


        }
        field(7207271; "Compute for hours"; Boolean)
        {
            CaptionML = ENU = 'Compute for hours', ESP = 'Computa para horas';
            Description = 'QB2713';


        }
        field(7207272; "Piecework Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework Code', ESP = 'N� unidad de obra';
            Description = 'QB2713';


        }
        field(7207273; "Plant Depreciation Sheet"; Boolean)
        {
            CaptionML = ENU = 'Plant Depreciation Sheet', ESP = 'Parte de amotizaci�n planta';
            Description = 'QB2713';


        }
        field(7207274; "Post Job Entry Only"; Boolean)
        {


            CaptionML = ENU = 'Post Job Entry Only', ESP = 'Registrar s�lo mov. proyecto';
            Description = 'QB2713';

            trigger OnValidate();
            BEGIN
                IF (Type <> Type::Item) THEN
                    ERROR(
                      Text000,
                      FIELDCAPTION("Post Job Entry Only"), FIELDCAPTION(Type), JobJnlLine.Type);
                IF (Type = Type::Item) AND (NOT "Post Job Entry Only") THEN BEGIN
                    GetLocation("Location Code");
                    Location.TESTFIELD("Directed Put-away and Pick", FALSE);
                END;
            END;


        }
        field(7207275; "QB Activation Mov."; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Movimiento de Activaci�n';
            Description = 'QB 1.12.00 JAV 06/10/22: - Se marca internamente para indicar que es un movimiento de Activaci�n del gasto';


        }
        field(7207276; "Related Item Entry No."; Integer)
        {
            CaptionML = ENU = 'Related Item Entry No.', ESP = 'N�  mov. producto relacionado';
            Description = 'QB2517';


        }
        field(7207277; "Job in Progress"; Boolean)
        {
            CaptionML = ENU = 'Job in progress', ESP = 'Obra en curso';
            Description = 'QB2517';


        }
        field(7207279; "Expense Notes Code"; Code[20])
        {
            CaptionML = ENU = 'Expense Notes Code', ESP = 'C�d. Nota gasto';
            Description = 'QB2517';
            Editable = false;


        }
        field(7207281; "Activation Entry"; Boolean)
        {
            CaptionML = ENU = 'Activation Entry.', ESP = 'Mov. Activaci�n';
            Description = 'QB2516';


        }
        field(7207282; "Job Closure Entry"; Boolean)
        {
            CaptionML = ENU = 'Closing Movement of Job', ESP = 'Movimiento de cierre de obra';
            Description = 'QB2517';


        }
        field(7207283; "Job Sale Doc. Type"; Option)
        {
            OptionMembers = "Standar","Eqipament Advance","Advance by Store","Price Review";
            CaptionML = ESP = 'Tipo doc. venta proyecto';
            OptionCaptionML = ENU = 'Standar,Eqipament Advance,Advance by Store,Price Review', ESP = 'Estandar,Anticipo de maquinar�a,Anticipo por acopios,Revisi�n precios';

            Description = 'QB2517';


        }
        field(7207284; "Job Correction"; Option)
        {
            OptionMembers = " ","Cost","Invoiced";
            CaptionML = ENU = 'Job Correction', ESP = 'Correcci�n de proyecto';
            OptionCaptionML = ENU = '" ,Cost,Invoiced"', ESP = '" ,Costes,Facturaci�n"';

            Description = 'QB2414';


        }
        field(7207295; "Currency Adjust"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Ajustes de Divisas';
            Description = 'QB 1.07.10 JAV 03/12/20: - Si es por un ajuste de cambios de divisas';


        }
        field(7207296; "Related G/L Entry"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Movimiento Contable Relacionado';
            Description = 'QB 1.07.10 JAV 03/12/20: - Que movimiento contable est� relacionado con este';


        }
        field(7207297; "Cancel WIP"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Aplicaci�n del WIP';
            Description = 'QB 1.07.11 JAV 12/12/20: - Si es para cenlar el WIP';


        }
        field(7207300; "Source Type"; Option)
        {
            OptionMembers = " ","Customer","Vendor";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source Type', ESP = 'Tipo origen';
            OptionCaptionML = ENU = '" ,Customer,Vendor"', ESP = '" ,Cliente,Proveedor"';

            Description = 'GAP888';


        }
        field(7207301; "Source Document Type"; Option)
        {
            OptionMembers = " ","Shipping","Invoice","Credit Memo","Journal","Worksheet";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source Document Type', ESP = 'Tipo documento origen';
            OptionCaptionML = ENU = '" ,Shipping,Invoice,Credit Memo,Journal,Worksheet"', ESP = '" ,Albar�n,Factura,Abono,Diario,Parte de trabajo"';

            Description = 'GAP888';


        }
        field(7207302; "Source No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source No.', ESP = 'N� origen';
            Description = 'GAP888';


        }
        field(7207303; "Source Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source No.', ESP = 'Nombre origen';
            Description = 'GAP888';


        }
        field(7207304; "Provision"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Provision', ESP = 'Provisi�n';
            Description = 'GAP888';


        }
        field(7207305; "Unprovision"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Unrovision', ESP = 'Desprovisi�n';
            Description = 'GAP888';


        }
        field(7207320; "Transaction Currency"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Transaction Currency', ESP = 'Divisa Transacci�n';
            Description = 'JMMA: C�digo de divisa de la transacci�n original. OJO no es la de proyecto.';


        }
        field(7207322; "Total Cost (TC)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Total Cost (TC)', ESP = 'Coste Total (DT)';
            Description = 'JMMA: Importe de coste en la divisa de la transacci�n';


        }
        field(7207323; "Corrected Job. Ledg. Entry No."; Integer)
        {
            TableRelation = "Job Ledger Entry";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Corrected Job. Ledg. Entry No.', ESP = 'N� Movimiento proyecto corregido';
            Description = 'Q17138. 06/06/22. Funcionalidad de productos prestados';


        }
    }
    keys
    {
        // key(key1;"Journal Template Name","Journal Batch Name","Line No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Journal Template Name","Journal Batch Name","Type","No.","Unit of Measure Code","Work Type Code")
        //  {
        /* MaintainSQLIndex=false;
  */
        // }
    }
    fieldgroups
    {
    }

    var
        //       Text000@1000 :
        Text000: TextConst ENU = 'You cannot change %1 when %2 is %3.', ESP = 'No se puede cambiar %1 cuando %2 es %3.';
        //       Location@1007 :
        Location: Record 14;
        //       Item@1001 :
        Item: Record 27;
        //       Res@1002 :
        Res: Record 156;
        //       Cust@1039 :
        Cust: Record 18;
        //       ItemJnlLine@1003 :
        ItemJnlLine: Record 83;
        //       GLAcc@1004 :
        GLAcc: Record 15;
        //       Job@1005 :
        Job: Record 167;
        //       WorkType@1009 :
        WorkType: Record 200;
        //       JobJnlTemplate@1011 :
        JobJnlTemplate: Record 209;
        //       JobJnlBatch@1012 :
        JobJnlBatch: Record 237;
        //       JobJnlLine@1013 :
        JobJnlLine: Record 210;
        //       ItemVariant@1015 :
        ItemVariant: Record 5401;
        //       ResUnitofMeasure@1008 :
        ResUnitofMeasure: Record 205;
        //       ResCost@1018 :
        ResCost: Record 202;
        //       ItemTranslation@1040 :
        ItemTranslation: Record 30;
        //       CurrExchRate@1029 :
        CurrExchRate: Record 330;
        //       SKU@1028 :
        SKU: Record 5700;
        //       GLSetup@1010 :
        GLSetup: Record 98;
        //       ItemCheckAvail@1020 :
        ItemCheckAvail: Codeunit 311;
        //       NoSeriesMgt@1021 :
        NoSeriesMgt: Codeunit 396;
        //       UOMMgt@1022 :
        UOMMgt: Codeunit 5402;
        //       DimMgt@1023 :
        DimMgt: Codeunit 408;
        //       ReserveJobJnlLine@1032 :
        ReserveJobJnlLine: Codeunit 99000844;
        //       WMSManagement@1035 :
        WMSManagement: Codeunit 7302;
        //       DontCheckStandardCost@1037 :
        DontCheckStandardCost: Boolean;
        //       Text001@1060 :
        Text001: TextConst ENU = 'cannot be specified without %1', ESP = 'no se puede especificar sin %1';
        //       Text002@1033 :
        Text002: TextConst ENU = 'must be positive', ESP = 'debe ser positivo';
        //       Text003@1038 :
        Text003: TextConst ENU = 'must be negative', ESP = 'debe ser negativo';
        //       HasGotGLSetup@1016 :
        HasGotGLSetup: Boolean;
        //       CurrencyDate@1030 :
        CurrencyDate: Date;
        //       UnitAmountRoundingPrecision@1024 :
        UnitAmountRoundingPrecision: Decimal;
        //       AmountRoundingPrecision@1025 :
        AmountRoundingPrecision: Decimal;
        //       UnitAmountRoundingPrecisionFCY@1026 :
        UnitAmountRoundingPrecisionFCY: Decimal;
        //       AmountRoundingPrecisionFCY@1036 :
        AmountRoundingPrecisionFCY: Decimal;
        //       CheckedAvailability@1017 :
        CheckedAvailability: Boolean;
        //       Text004@1019 :
        Text004: TextConst ENU = '%1 is only editable when a %2 is defined.', ESP = '%1 solo es editable cuando se define un %2.';
        //       Text006@1034 :
        Text006: TextConst ENU = '%1 cannot be changed when %2 is set.', ESP = '%1 no se puede cambiar cuando se establece %2.';
        //       Text007@1006 :
        Text007:
// Job Journal Line job DEFAULT 30000 is already linked to Job Planning Line  DEERFIELD, 8 WP 1120 10000. Hence Remaining Qty. cannot be calculated correctly. Posting the line may update the linked %3 unexpectedly. Do you want to continue?
TextConst ENU = '%1 %2 is already linked to %3 %4. Hence %5 cannot be calculated correctly. Posting the line may update the linked %3 unexpectedly. Do you want to continue?', ESP = '%1 %2 ya tiene un v�nculo con %3 %4. Por lo tanto, %5 no se puede calcular correctamente. Al registrar la l�nea se pueden actualizar inesperadamente los %3 vinculados. �Desea continuar?';




    /*
    trigger OnInsert();    begin
                   LOCKTABLE;
                   JobJnlTemplate.GET("Journal Template Name");
                   JobJnlBatch.GET("Journal Template Name","Journal Batch Name");

                   ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                   ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                 end;


    */

    /*
    trigger OnModify();    begin
                   if (Type = Type::Item) and (xRec.Type = Type::Item) then
                     ReserveJobJnlLine.VerifyChange(Rec,xRec)
                   else
                     if (Type <> Type::Item) and (xRec.Type = Type::Item) then
                       ReserveJobJnlLine.DeleteLine(xRec);
                 end;


    */

    /*
    trigger OnDelete();    begin
                   if Type = Type::Item then
                     ReserveJobJnlLine.DeleteLine(Rec);
                 end;


    */

    /*
    trigger OnRename();    begin
                   ReserveJobJnlLine.RenameLine(Rec,xRec);
                 end;

    */



    // LOCAL procedure CalcBaseQty (Qty@1000 :

    /*
    LOCAL procedure CalcBaseQty (Qty: Decimal) : Decimal;
        begin
          TESTFIELD("Qty. per Unit of Measure");
          exit(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
        end;
    */


    //     LOCAL procedure CalcQtyFromBaseQty (BaseQty@1000 :

    /*
    LOCAL procedure CalcQtyFromBaseQty (BaseQty: Decimal) : Decimal;
        begin
          TESTFIELD("Qty. per Unit of Measure");
          exit(ROUND(BaseQty / "Qty. per Unit of Measure",0.00001));
        end;
    */


    LOCAL procedure CopyFromResource()
    var
        //       Resource@1000 :
        Resource: Record 156;
    begin
        Resource.GET("No.");
        Resource.CheckResourcePrivacyBlocked(FALSE);
        Resource.TESTFIELD(Blocked, FALSE);
        Description := Resource.Name;
        "Description 2" := Resource."Name 2";
        "Resource Group No." := Resource."Resource Group No.";
        "Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
        VALIDATE("Unit of Measure Code", Resource."Base Unit of Measure");
        if "Time Sheet No." = '' then
            Resource.TESTFIELD("Use Time Sheet", FALSE);
        OnAfterAssignResourceValues(Rec, Resource);
    end;


    /*
    LOCAL procedure CopyFromItem ()
        begin
          GetItem;
          Item.TESTFIELD(Blocked,FALSE);
          Description := Item.Description;
          "Description 2" := Item."Description 2";
          GetJob;
          if Job."Language Code" <> '' then
            GetItemTranslation;
          "Posting Group" := Item."Inventory Posting Group";
          "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
          VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");

          OnAfterAssignItemValues(Rec,Item);
        end;
    */



    /*
    LOCAL procedure CopyFromGLAccount ()
        begin
          GLAcc.GET("No.");
          GLAcc.CheckGLAcc;
          GLAcc.TESTFIELD("Direct Posting",TRUE);
          Description := GLAcc.Name;
          "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
          "Unit of Measure Code" := '';
          "Direct Unit Cost (LCY)" := 0;
          "Unit Cost (LCY)" := 0;
          "Unit Price" := 0;

          OnAfterAssignGLAccountValues(Rec,GLAcc);
        end;
    */



    /*
    LOCAL procedure CheckItemAvailable ()
        var
    //       JobPlanningLine@1000 :
          JobPlanningLine: Record 1003;
        begin
          if (CurrFieldNo <> 0) and (Type = Type::Item) and (Quantity > 0) and not CheckedAvailability then begin
            ItemJnlLine."Item No." := "No.";
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
            ItemJnlLine."Location Code" := "Location Code";
            ItemJnlLine."Variant Code" := "Variant Code";
            ItemJnlLine."Bin Code" := "Bin Code";
            ItemJnlLine."Unit of Measure Code" := "Unit of Measure Code";
            ItemJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
            if "Job Planning Line No." = 0 then
              ItemJnlLine.Quantity := Quantity
            else begin
              JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
              if JobPlanningLine."Remaining Qty." < (Quantity + "Remaining Qty.") then
                ItemJnlLine.Quantity := (Quantity + "Remaining Qty.") - JobPlanningLine."Remaining Qty."
              else
                exit;
            end;
            if ItemCheckAvail.ItemJnlCheckLine(ItemJnlLine) then
              ItemCheckAvail.RaiseUpdateInterruptedError;
            CheckedAvailability := TRUE;
          end;
        end;
    */




    /*
    procedure EmptyLine () : Boolean;
        begin
          exit(("Job No." = '') and ("No." = '') and (Quantity = 0));
        end;
    */



    //     procedure SetUpNewLine (LastJobJnlLine@1000 :

    /*
    procedure SetUpNewLine (LastJobJnlLine: Record 210)
        begin
          JobJnlTemplate.GET("Journal Template Name");
          JobJnlBatch.GET("Journal Template Name","Journal Batch Name");
          JobJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
          JobJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
          if JobJnlLine.FINDFIRST then begin
            "Posting Date" := LastJobJnlLine."Posting Date";
            "Document Date" := LastJobJnlLine."Posting Date";
            "Document No." := LastJobJnlLine."Document No.";
            Type := LastJobJnlLine.Type;
            VALIDATE("Line Type",LastJobJnlLine."Line Type");
          end else begin
            "Posting Date" := WORKDATE;
            "Document Date" := WORKDATE;
            if JobJnlBatch."No. Series" <> '' then begin
              CLEAR(NoSeriesMgt);
              "Document No." := NoSeriesMgt.TryGetNextNo(JobJnlBatch."No. Series","Posting Date");
            end;
          end;
          "Recurring Method" := LastJobJnlLine."Recurring Method";
          "Entry Type" := "Entry Type"::Usage;
          "Source Code" := JobJnlTemplate."Source Code";
          "Reason Code" := JobJnlBatch."Reason Code";
          "Posting No. Series" := JobJnlBatch."Posting No. Series";

          OnAfterSetUpNewLine(Rec,LastJobJnlLine,JobJnlTemplate,JobJnlBatch);
        end;
    */



    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 :

    /*
    procedure CreateDim (Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20])
        var
    //       TableID@1006 :
          TableID: ARRAY [10] OF Integer;
    //       No@1007 :
          No: ARRAY [10] OF Code[20];
        begin
          TableID[1] := Type1;
          No[1] := No1;
          TableID[2] := Type2;
          No[2] := No2;
          TableID[3] := Type3;
          No[3] := No3;
          OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

          "Shortcut Dimension 1 Code" := '';
          "Shortcut Dimension 2 Code" := '';
          "Dimension Set ID" :=
            DimMgt.GetRecDefaultDimID(
              Rec,CurrFieldNo,TableID,No,"Source Code","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
        end;
    */



    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :

    /*
    procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
        begin
          DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        end;
    */



    //     procedure LookupShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :

    /*
    procedure LookupShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
        begin
          DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
          DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        end;
    */



    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :

    /*
    procedure ShowShortcutDimCode (var ShortcutDimCode: ARRAY [8] OF Code[20])
        begin
          DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
        end;
    */


    //     LOCAL procedure GetLocation (LocationCode@1000 :


    LOCAL procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            CLEAR(Location)
        else
            if Location.Code <> LocationCode then
                Location.GET(LocationCode);
    end;




    /*
    LOCAL procedure GetJob ()
        begin
          TESTFIELD("Job No.");
          if "Job No." <> Job."No." then
            Job.GET("Job No.");
        end;
    */



    /*
    LOCAL procedure UpdateCurrencyFactor ()
        begin
          if "Currency Code" <> '' then begin
            if "Posting Date" = 0D then
              CurrencyDate := WORKDATE
            else
              CurrencyDate := "Posting Date";
            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
          end else
            "Currency Factor" := 0;
        end;
    */



    /*
    LOCAL procedure GetItem ()
        begin
          TESTFIELD("No.");
          if "No." <> Item."No." then
            Item.GET("No.");
        end;
    */



    /*
    LOCAL procedure GetSKU () : Boolean;
        begin
          if (SKU."Location Code" = "Location Code") and
             (SKU."Item No." = "No.") and
             (SKU."Variant Code" = "Variant Code")
          then
            exit(TRUE);

          if SKU.GET("Location Code","No.","Variant Code") then
            exit(TRUE);

          exit(FALSE);
        end;
    */




    /*
    procedure IsInbound () : Boolean;
        begin
          if "Entry Type" IN ["Entry Type"::Usage,"Entry Type"::Sale] then
            exit("Quantity (Base)" < 0);

          exit(FALSE);
        end;
    */



    //     procedure OpenItemTrackingLines (IsReclass@1000 :

    /*
    procedure OpenItemTrackingLines (IsReclass: Boolean)
        begin
          TESTFIELD(Type,Type::Item);
          TESTFIELD("No.");
          ReserveJobJnlLine.CallItemTracking(Rec,IsReclass);
        end;
    */



    /*
    LOCAL procedure InitRoundingPrecisions ()
        var
    //       Currency@1000 :
          Currency: Record 4;
        begin
          if (AmountRoundingPrecision = 0) or
             (UnitAmountRoundingPrecision = 0) or
             (AmountRoundingPrecisionFCY = 0) or
             (UnitAmountRoundingPrecisionFCY = 0)
          then begin
            CLEAR(Currency);
            Currency.InitRoundingPrecision;
            AmountRoundingPrecision := Currency."Amount Rounding Precision";
            UnitAmountRoundingPrecision := Currency."Unit-Amount Rounding Precision";

            if "Currency Code" <> '' then begin
              Currency.GET("Currency Code");
              Currency.TESTFIELD("Amount Rounding Precision");
              Currency.TESTFIELD("Unit-Amount Rounding Precision");
            end;

            AmountRoundingPrecisionFCY := Currency."Amount Rounding Precision";
            UnitAmountRoundingPrecisionFCY := Currency."Unit-Amount Rounding Precision";
          end;
        end;
    */




    /*
    procedure DontCheckStdCost ()
        begin
          DontCheckStandardCost := TRUE;
        end;
    */


    //     LOCAL procedure CalcUnitCost (ItemLedgEntry@1000 :

    /*
    LOCAL procedure CalcUnitCost (ItemLedgEntry: Record 32) : Decimal;
        var
    //       ValueEntry@1001 :
          ValueEntry: Record 5802;
    //       UnitCost@1004 :
          UnitCost: Decimal;
        begin
          ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
          ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
          ValueEntry.CALCSUMS("Cost Amount (Actual)","Cost Amount (Expected)");
          UnitCost :=
            (ValueEntry."Cost Amount (Expected)" + ValueEntry."Cost Amount (Actual)") / ItemLedgEntry.Quantity;

          exit(ABS(UnitCost * "Qty. per Unit of Measure"));
        end;
    */


    //     LOCAL procedure CalcUnitCostFrom (ItemLedgEntry@1000 :

    /*
    LOCAL procedure CalcUnitCostFrom (ItemLedgEntry: Record 32) : Decimal;
        var
    //       ValueEntry@1001 :
          ValueEntry: Record 5802;
        begin
          ValueEntry.RESET;
          ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
          ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
          ValueEntry.CALCSUMS("Cost Amount (Actual)","Cost Amount (Expected)");
          exit(
            (ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)") /
            ItemLedgEntry.Quantity * "Qty. per Unit of Measure");
        end;
    */


    //     LOCAL procedure SelectItemEntry (CurrentFieldNo@1000 :

    /*
    LOCAL procedure SelectItemEntry (CurrentFieldNo: Integer)
        var
    //       ItemLedgEntry@1001 :
          ItemLedgEntry: Record 32;
    //       JobJnlLine2@1002 :
          JobJnlLine2: Record 210;
        begin
          ItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code");
          ItemLedgEntry.SETRANGE("Item No.","No.");
          ItemLedgEntry.SETRANGE(Correction,FALSE);

          if "Location Code" <> '' then
            ItemLedgEntry.SETRANGE("Location Code","Location Code");

          if CurrentFieldNo = FIELDNO("Applies-to Entry") then begin
            ItemLedgEntry.SETRANGE(Positive,TRUE);
            ItemLedgEntry.SETRANGE(Open,TRUE);
          end else
            ItemLedgEntry.SETRANGE(Positive,FALSE);

          if PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK then begin
            JobJnlLine2 := Rec;
            if CurrentFieldNo = FIELDNO("Applies-to Entry") then
              JobJnlLine2.VALIDATE("Applies-to Entry",ItemLedgEntry."Entry No.")
            else
              JobJnlLine2.VALIDATE("Applies-from Entry",ItemLedgEntry."Entry No.");
            Rec := JobJnlLine2;
          end;
        end;
    */




    /*
    procedure DeleteAmounts ()
        begin
          Quantity := 0;
          "Quantity (Base)" := 0;
          "Direct Unit Cost (LCY)" := 0;
          "Unit Cost (LCY)" := 0;
          "Unit Cost" := 0;
          "Total Cost (LCY)" := 0;
          "Total Cost" := 0;
          "Unit Price (LCY)" := 0;
          "Unit Price" := 0;
          "Total Price (LCY)" := 0;
          "Total Price" := 0;
          "Line Amount (LCY)" := 0;
          "Line Amount" := 0;
          "Line Discount %" := 0;
          "Line Discount Amount (LCY)" := 0;
          "Line Discount Amount" := 0;
          "Remaining Qty." := 0;
          "Remaining Qty. (Base)" := 0;

          OnAfterDeleteAmounts(Rec);
        end;
    */



    //     procedure SetCurrencyFactor (Factor@1000 :

    /*
    procedure SetCurrencyFactor (Factor: Decimal)
        begin
          "Currency Factor" := Factor;
        end;
    */



    /*
    LOCAL procedure GetItemTranslation ()
        begin
          GetJob;
          if ItemTranslation.GET("No.","Variant Code",Job."Language Code") then begin
            Description := ItemTranslation.Description;
            "Description 2" := ItemTranslation."Description 2";
          end;
        end;
    */



    /*
    LOCAL procedure GetGLSetup ()
        begin
          if HasGotGLSetup then
            exit;
          GLSetup.GET;
          HasGotGLSetup := TRUE;
        end;
    */




    /*
    procedure UpdateAllAmounts ()
        begin
          OnBeforeUpdateAllAmounts(Rec,xRec);
          InitRoundingPrecisions;

          UpdateUnitCost;
          UpdateTotalCost;
          FindPriceAndDiscount(Rec,CurrFieldNo);
          HandleCostFactor;
          UpdateUnitPrice;
          UpdateTotalPrice;
          UpdateAmountsAndDiscounts;

          OnAfterUpdateAllAmounts(Rec,xRec);
        end;
    */




    /*
    procedure UpdateUnitCost ()
        var
    //       RetrievedCost@1000 :
          RetrievedCost: Decimal;
        begin
          if (Type = Type::Item) and Item.GET("No.") then begin
            if Item."Costing Method" = Item."Costing Method"::Standard then begin
              if not DontCheckStandardCost then begin
                // Prevent manual change of unit cost on items with standard cost
                if (("Unit Cost" <> xRec."Unit Cost") or ("Unit Cost (LCY)" <> xRec."Unit Cost (LCY)")) and
                   (("No." = xRec."No.") and ("Location Code" = xRec."Location Code") and
                    ("Variant Code" = xRec."Variant Code") and ("Unit of Measure Code" = xRec."Unit of Measure Code"))
                then
                  ERROR(
                    Text000,
                    FIELDCAPTION("Unit Cost"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");
              end;
              if RetrieveCostPrice then begin
                if GetSKU then
                  "Unit Cost (LCY)" := ROUND(SKU."Unit Cost" * "Qty. per Unit of Measure",UnitAmountRoundingPrecision)
                else
                  "Unit Cost (LCY)" := ROUND(Item."Unit Cost" * "Qty. per Unit of Measure",UnitAmountRoundingPrecision);
                "Unit Cost" := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      "Posting Date","Currency Code",
                      "Unit Cost (LCY)","Currency Factor"),
                    UnitAmountRoundingPrecisionFCY);
              end else begin
                if "Unit Cost" <> xRec."Unit Cost" then
                  "Unit Cost (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Posting Date","Currency Code",
                        "Unit Cost","Currency Factor"),
                      UnitAmountRoundingPrecision)
                else
                  "Unit Cost" := ROUND(
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        "Posting Date","Currency Code",
                        "Unit Cost (LCY)","Currency Factor"),
                      UnitAmountRoundingPrecisionFCY);
              end;
            end else begin
              if RetrieveCostPrice then begin
                if GetSKU then
                  RetrievedCost := SKU."Unit Cost" * "Qty. per Unit of Measure"
                else
                  RetrievedCost := Item."Unit Cost" * "Qty. per Unit of Measure";
                "Unit Cost" := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      "Posting Date","Currency Code",
                      RetrievedCost,"Currency Factor"),
                    UnitAmountRoundingPrecisionFCY);
                "Unit Cost (LCY)" := ROUND(RetrievedCost,UnitAmountRoundingPrecision);
              end else
                "Unit Cost (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Posting Date","Currency Code",
                      "Unit Cost","Currency Factor"),
                    UnitAmountRoundingPrecision);
            end;
          end else
            if (Type = Type::Resource) and Res.GET("No.") then begin
              if RetrieveCostPrice then begin
                ResCost.INIT;
                ResCost.Code := "No.";
                ResCost."Work Type Code" := "Work Type Code";
                CODEUNIT.RUN(CODEUNIT::"Resource-Find Cost",ResCost);
                OnAfterResourceFindCost(Rec,ResCost);
                "Direct Unit Cost (LCY)" := ROUND(ResCost."Direct Unit Cost" * "Qty. per Unit of Measure",UnitAmountRoundingPrecision);
                RetrievedCost := ResCost."Unit Cost" * "Qty. per Unit of Measure";
                "Unit Cost" := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      "Posting Date","Currency Code",
                      RetrievedCost,"Currency Factor"),
                    UnitAmountRoundingPrecisionFCY);
                "Unit Cost (LCY)" := ROUND(RetrievedCost,UnitAmountRoundingPrecision);
              end else
                "Unit Cost (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Posting Date","Currency Code",
                      "Unit Cost","Currency Factor"),
                    UnitAmountRoundingPrecision);
            end else
              "Unit Cost (LCY)" := ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    "Posting Date","Currency Code",
                    "Unit Cost","Currency Factor"),
                  UnitAmountRoundingPrecision);
        end;
    */



    /*
    LOCAL procedure RetrieveCostPrice () : Boolean;
        var
    //       ShouldRetrieveCostPrice@1000 :
          ShouldRetrieveCostPrice: Boolean;
        begin
          OnBeforeRetrieveCostPrice(Rec,xRec,ShouldRetrieveCostPrice);
          if ShouldRetrieveCostPrice then
            exit(TRUE);

          CASE Type OF
            Type::Item:
              if ("No." <> xRec."No.") or
                 ("Location Code" <> xRec."Location Code") or
                 ("Variant Code" <> xRec."Variant Code") or
                 (Quantity <> xRec.Quantity) or
                 ("Unit of Measure Code" <> xRec."Unit of Measure Code") and
                 (("Applies-to Entry" = 0) and ("Applies-from Entry" = 0))
              then
                exit(TRUE);
            Type::Resource:
              if ("No." <> xRec."No.") or
                 ("Work Type Code" <> xRec."Work Type Code") or
                 ("Unit of Measure Code" <> xRec."Unit of Measure Code")
              then
                exit(TRUE);
            Type::"G/L Account":
              if "No." <> xRec."No." then
                exit(TRUE);
            else
              exit(FALSE);
          end;
          exit(FALSE);
        end;
    */




    /*
    procedure UpdateTotalCost ()
        begin
          "Total Cost" := ROUND("Unit Cost" * Quantity,AmountRoundingPrecisionFCY);
          "Total Cost (LCY)" := ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                "Posting Date","Currency Code","Total Cost","Currency Factor"),AmountRoundingPrecision);

          OnAfterUpdateTotalCost(Rec);
        end;
    */


    //     LOCAL procedure FindPriceAndDiscount (var JobJnlLine@1000 : Record 210;CalledByFieldNo@1001 :

    /*
    LOCAL procedure FindPriceAndDiscount (var JobJnlLine: Record 210;CalledByFieldNo: Integer)
        var
    //       SalesPriceCalcMgt@1002 :
          SalesPriceCalcMgt: Codeunit 7000;
    //       PurchPriceCalcMgt@1003 :
          PurchPriceCalcMgt: Codeunit 7010;
        begin
          if RetrieveCostPrice and ("No." <> '') then begin
            SalesPriceCalcMgt.FindJobJnlLinePrice(JobJnlLine,CalledByFieldNo);

            if Type <> Type::"G/L Account" then
              PurchPriceCalcMgt.FindJobJnlLinePrice(JobJnlLine,CalledByFieldNo)
            else begin
              // Because the SalesPriceCalcMgt.FindJobJnlLinePrice function also retrieves costs for G/L Account,
              // cost and total cost need to get updated again.
              UpdateUnitCost;
              UpdateTotalCost;
            end;
          end;
        end;
    */



    /*
    LOCAL procedure HandleCostFactor ()
        begin
          if ("Cost Factor" <> 0) and
             ((("Unit Cost" <> xRec."Unit Cost") or ("Cost Factor" <> xRec."Cost Factor")) or
              ((Quantity <> xRec.Quantity) or ("Location Code" <> xRec."Location Code")))
          then
            "Unit Price" := ROUND("Unit Cost" * "Cost Factor",UnitAmountRoundingPrecisionFCY)
          else
            if (Item."Price/Profit Calculation" = Item."Price/Profit Calculation"::"Price=Cost+Profit") and
               (Item."Profit %" < 100) and
               ("Unit Cost" <> xRec."Unit Cost")
            then
              "Unit Price" := ROUND("Unit Cost" / (1 - Item."Profit %" / 100),UnitAmountRoundingPrecisionFCY);
        end;
    */



    /*
    LOCAL procedure UpdateUnitPrice ()
        begin
          "Unit Price (LCY)" := ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                "Posting Date","Currency Code",
                "Unit Price","Currency Factor"),
              UnitAmountRoundingPrecision);
        end;
    */



    /*
    LOCAL procedure UpdateTotalPrice ()
        begin
          "Total Price" := ROUND(Quantity * "Unit Price",AmountRoundingPrecisionFCY);
          "Total Price (LCY)" := ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                "Posting Date","Currency Code","Total Price","Currency Factor"),AmountRoundingPrecision);

          OnAfterUpdateTotalPrice(Rec);
        end;
    */



    /*
    LOCAL procedure UpdateAmountsAndDiscounts ()
        begin
          if "Total Price" <> 0 then begin
            if ("Line Amount" <> xRec."Line Amount") and ("Line Discount Amount" = xRec."Line Discount Amount") then begin
              "Line Amount" := ROUND("Line Amount",AmountRoundingPrecisionFCY);
              "Line Discount Amount" := "Total Price" - "Line Amount";
              "Line Amount (LCY)" := ROUND("Line Amount (LCY)",AmountRoundingPrecision);
              "Line Discount Amount (LCY)" := "Total Price (LCY)" - "Line Amount (LCY)";
              "Line Discount %" := ROUND("Line Discount Amount" / "Total Price" * 100,0.00001);
            end else
              if ("Line Discount Amount" <> xRec."Line Discount Amount") and ("Line Amount" = xRec."Line Amount") then begin
                "Line Discount Amount" := ROUND("Line Discount Amount",AmountRoundingPrecisionFCY);
                "Line Amount" := "Total Price" - "Line Discount Amount";
                "Line Discount Amount (LCY)" := ROUND("Line Discount Amount (LCY)",AmountRoundingPrecision);
                "Line Amount (LCY)" := "Total Price (LCY)" - "Line Discount Amount (LCY)";
                "Line Discount %" := ROUND("Line Discount Amount" / "Total Price" * 100,0.00001);
              end else
                if ("Line Discount Amount" <> xRec."Line Discount Amount") or ("Line Amount" <> xRec."Line Amount") or
                   ("Total Price" <> xRec."Total Price") or ("Line Discount %" <> xRec."Line Discount %")
                then begin
                  "Line Discount Amount" := ROUND("Total Price" * "Line Discount %" / 100,AmountRoundingPrecisionFCY);
                  "Line Amount" := "Total Price" - "Line Discount Amount";
                  "Line Discount Amount (LCY)" := ROUND("Total Price (LCY)" * "Line Discount %" / 100,AmountRoundingPrecision);
                  "Line Amount (LCY)" := "Total Price (LCY)" - "Line Discount Amount (LCY)";
                end;
          end else begin
            "Line Amount" := 0;
            "Line Discount Amount" := 0;
            "Line Amount (LCY)" := 0;
            "Line Discount Amount (LCY)" := 0;
          end;

          OnAfterUpdateAmountsAndDiscounts(Rec);
        end;
    */



    /*
    LOCAL procedure ValidateJobPlanningLineLink ()
        var
    //       JobPlanningLine@1000 :
          JobPlanningLine: Record 1003;
    //       JobJournalLine@1001 :
          JobJournalLine: Record 210;
        begin
          JobJournalLine.SETRANGE("Job No.","Job No.");
          JobJournalLine.SETRANGE("Job Task No.","Job Task No.");
          JobJournalLine.SETRANGE("Job Planning Line No.","Job Planning Line No.");

          if JobJournalLine.FINDFIRST then
            if ("Journal Template Name" <> JobJournalLine."Journal Template Name") or
               ("Journal Batch Name" <> JobJournalLine."Journal Batch Name") or
               ("Line No." <> JobJournalLine."Line No.")
            then begin
              JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
              if not CONFIRM(Text007,FALSE,
                   TABLECAPTION,
                   STRSUBSTNO('%1, %2, %3',"Journal Template Name","Journal Batch Name","Line No."),
                   JobPlanningLine.TABLECAPTION,
                   STRSUBSTNO('%1, %2, %3',JobPlanningLine."Job No.",JobPlanningLine."Job Task No.",JobPlanningLine."Line No."),
                   FIELDCAPTION("Remaining Qty."))
              then
                ERROR('');
            end;
        end;
    */




    /*
    procedure ShowDimensions ()
        begin
          "Dimension Set ID" :=
            DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."));
          DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        end;
    */




    /*
    procedure UpdateDimensions ()
        var
    //       DimensionSetIDArr@1000 :
          DimensionSetIDArr: ARRAY [10] OF Integer;
        begin
          CreateDim(
            DimMgt.TypeToTableID2(Type),"No.",
            DATABASE::Job,"Job No.",
            DATABASE::"Resource Group","Resource Group No.");
          if "Job Task No." <> '' then begin
            DimensionSetIDArr[1] := "Dimension Set ID";
            DimensionSetIDArr[2] :=
              DimMgt.CreateDimSetFromJobTaskDim("Job No.",
                "Job Task No.","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
            DimMgt.CreateDimForJobJournalLineWithHigherPriorities(
              Rec,CurrFieldNo,DimensionSetIDArr[3],"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Source Code",DATABASE::Job);
            "Dimension Set ID" :=
              DimMgt.GetCombinedDimensionSetID(
                DimensionSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
          end
        end;
    */




    /*
    procedure IsOpenedFromBatch () : Boolean;
        var
    //       JobJournalBatch@1002 :
          JobJournalBatch: Record 237;
    //       TemplateFilter@1001 :
          TemplateFilter: Text;
    //       BatchFilter@1000 :
          BatchFilter: Text;
        begin
          BatchFilter := GETFILTER("Journal Batch Name");
          if BatchFilter <> '' then begin
            TemplateFilter := GETFILTER("Journal Template Name");
            if TemplateFilter <> '' then
              JobJournalBatch.SETFILTER("Journal Template Name",TemplateFilter);
            JobJournalBatch.SETFILTER(Name,BatchFilter);
            JobJournalBatch.FINDFIRST;
          end;

          exit((("Journal Batch Name" <> '') and ("Journal Template Name" = '')) or (BatchFilter <> ''));
        end;
    */




    /*
    procedure IsNonInventoriableItem () : Boolean;
        begin
          if Type <> Type::Item then
            exit(FALSE);
          if "No." = '' then
            exit(FALSE);
          GetItem;
          exit(Item.IsNonInventoriableType);
        end;
    */




    /*
    procedure IsInventoriableItem () : Boolean;
        begin
          if Type <> Type::Item then
            exit(FALSE);
          if "No." = '' then
            exit(FALSE);
          GetItem;
          exit(Item.IsInventoriableType);
        end;
    */




    /*
    procedure RowID1 () : Text[250];
        var
    //       ItemTrackingMgt@1000 :
          ItemTrackingMgt: Codeunit 6500;
        begin
          exit(
            ItemTrackingMgt.ComposeRowID(DATABASE::"Job Journal Line","Entry Type",
              "Journal Template Name","Journal Batch Name",0,"Line No."));
        end;
    */



    //     LOCAL procedure OnAfterAssignGLAccountValues (var JobJournalLine@1000 : Record 210;GLAccount@1001 :

    /*
    LOCAL procedure OnAfterAssignGLAccountValues (var JobJournalLine: Record 210;GLAccount: Record 15)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAssignItemValues (var JobJournalLine@1000 : Record 210;Item@1001 :

    /*
    LOCAL procedure OnAfterAssignItemValues (var JobJournalLine: Record 210;Item: Record 27)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAssignResourceValues (var JobJournalLine@1000 : Record 210;Resource@1001 :


    LOCAL procedure OnAfterAssignResourceValues(var JobJournalLine: Record 210; Resource: Record 156)
    begin
    end;




    //     LOCAL procedure OnAfterAssignItemUoM (var JobJournalLine@1000 : Record 210;Item@1001 :

    /*
    LOCAL procedure OnAfterAssignItemUoM (var JobJournalLine: Record 210;Item: Record 27)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAssignResourceUoM (var JobJournalLine@1000 : Record 210;Resource@1001 :

    /*
    LOCAL procedure OnAfterAssignResourceUoM (var JobJournalLine: Record 210;Resource: Record 156)
        begin
        end;
    */



    //     LOCAL procedure OnAfterDeleteAmounts (var JobJournalLine@1000 :

    /*
    LOCAL procedure OnAfterDeleteAmounts (var JobJournalLine: Record 210)
        begin
        end;
    */



    //     LOCAL procedure OnAfterResourceFindCost (var JobJournalLine@1000 : Record 210;var ResourceCost@1001 :

    /*
    LOCAL procedure OnAfterResourceFindCost (var JobJournalLine: Record 210;var ResourceCost: Record 202)
        begin
        end;
    */



    //     LOCAL procedure OnAfterSetUpNewLine (var JobJournalLine@1000 : Record 210;LastJobJournalLine@1001 : Record 210;JobJournalTemplate@1002 : Record 209;JobJournalBatch@1003 :

    /*
    LOCAL procedure OnAfterSetUpNewLine (var JobJournalLine: Record 210;LastJobJournalLine: Record 210;JobJournalTemplate: Record 209;JobJournalBatch: Record 237)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateTotalCost (var JobJournalLine@1000 :

    /*
    LOCAL procedure OnAfterUpdateTotalCost (var JobJournalLine: Record 210)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateTotalPrice (var JobJournalLine@1000 :

    /*
    LOCAL procedure OnAfterUpdateTotalPrice (var JobJournalLine: Record 210)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateAmountsAndDiscounts (var JobJournalLine@1000 :

    /*
    LOCAL procedure OnAfterUpdateAmountsAndDiscounts (var JobJournalLine: Record 210)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCreateDimTableIDs (var JobJournalLine@1000 : Record 210;var FieldNo@1001 : Integer;var TableID@1003 : ARRAY [10] OF Integer;var No@1002 :

    /*
    LOCAL procedure OnAfterCreateDimTableIDs (var JobJournalLine: Record 210;var FieldNo: Integer;var TableID: ARRAY [10] OF Integer;var No: ARRAY [10] OF Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnBeforeRetrieveCostPrice (JobJournalLine@1000 : Record 210;xJobJournalLine@1001 : Record 210;var ShouldRetrieveCostPrice@1002 :

    /*
    LOCAL procedure OnBeforeRetrieveCostPrice (JobJournalLine: Record 210;xJobJournalLine: Record 210;var ShouldRetrieveCostPrice: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeValidateWorkTypeCodeQty (var JobJournalLine@1000 : Record 210;xJobJournalLine@1001 : Record 210;Resource@1002 : Record 156;WorkType@1003 :

    /*
    LOCAL procedure OnBeforeValidateWorkTypeCodeQty (var JobJournalLine: Record 210;xJobJournalLine: Record 210;Resource: Record 156;WorkType: Record 200)
        begin
        end;

        [Integration(TRUE,TRUE)]
    */

    //     LOCAL procedure OnBeforeUpdateAllAmounts (var JobJournalLine@1000 : Record 210;xJobJournalLine@1001 :

    /*
    LOCAL procedure OnBeforeUpdateAllAmounts (var JobJournalLine: Record 210;xJobJournalLine: Record 210)
        begin
        end;

        [Integration(TRUE,TRUE)]
    */

    //     LOCAL procedure OnAfterUpdateAllAmounts (var JobJournalLine@1000 : Record 210;xJobJournalLine@1001 :

    /*
    LOCAL procedure OnAfterUpdateAllAmounts (var JobJournalLine: Record 210;xJobJournalLine: Record 210)
        begin
        end;

        /*begin
        //{
    //      CPA 06/06/22: - Q19138. Funcionalidad de productos prestados.
    //          - Nuevo campo: "Corrected Job. Ledg. Entry No."
    //      JAV 06/10/22: - QB 1.12.00 Se a�ade el campo 7207275 "QB Activation Mov."
    //    }
        end.
      */
}




