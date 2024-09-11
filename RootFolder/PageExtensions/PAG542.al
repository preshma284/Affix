pageextension 52234 MyExtension127 extends "Default Dimensions-Multiple"
{
    CaptionML = ENU = 'Default Dimensions-Multiple', ESP = 'Dimensiones predet.-M�ltiple';
    // SourceTable=352;
    // DataCaptionExpression=rec.GetCaption;
    // PageType=List;
    // SourceTableTemporary=true;

    // layout
    // {
    //     addlast(content)
    //     {
            // repeater("Control1")
            // {

            //     field("Dimension Code"; rec."Dimension Code")
            //     {

            //         ToolTipML = ENU = 'Specifies the code for the default dimension.', ESP = 'Especifica el c�digo de la dimensi�n predeterminada.';
            //         ApplicationArea = Dimensions;

            //         ; trigger OnValidate()
            //         BEGIN
            //             IF (xRec."Dimension Code" <> '') AND (xRec."Dimension Code" <> rec."Dimension Code") THEN
            //                 ERROR(CannotRenameErr, rec.TABLECAPTION);
            //         END;


            //     }
            //     field("Dimension Value Code"; rec."Dimension Value Code")
            //     {

            //         ToolTipML = ENU = 'Specifies the dimension value code to suggest as the default dimension.', ESP = 'Especifica el c�digo de valor de dimensi�n para proponerlo como dimensi�n predeterminada.';
            //         ApplicationArea = Dimensions;
            //     }
            //     field("Value Posting"; rec."Value Posting")
            //     {

            //         ToolTipML = ENU = 'Specifies how default dimensions and their values must be used.', ESP = 'Especifica la forma en que deben utilizarse las dimensiones predeterminadas y sus valores.';
            //         ApplicationArea = Dimensions;
            //     }

            // }

    //     }
    // }

    // trigger OnInit()
    // BEGIN
    //     CurrPage.LOOKUPMODE := TRUE;
    // END;

    trigger OnOpenPage()
    BEGIN
        GetDefaultDim;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        DimensionValueCodeOnFormat(FORMAT(rec."Dimension Value Code"));
        ValuePostingOnFormat(FORMAT(rec."Value Posting"));
    END;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    BEGIN
        Rec.SETRANGE("Dimension Code", rec."Dimension Code");
        IF NOT Rec.FIND('-') AND (rec."Dimension Code" <> '') THEN BEGIN
            rec."Multi Selection Action" := rec."Multi Selection Action"::Change;
            Rec.INSERT;
        END;
        Rec.SETRANGE("Dimension Code");
        EXIT(FALSE);
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        rec."Multi Selection Action" := rec."Multi Selection Action"::Change;
        Rec.MODIFY;
        EXIT(FALSE);
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        rec."Multi Selection Action" := rec."Multi Selection Action"::Delete;
        Rec.MODIFY;
        EXIT(FALSE);
    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    BEGIN
        IF CloseAction = ACTION::LookupOK THEN
            LookupOKOnPush;
    END;



    var
        CannotRenameErr: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        Text001: TextConst ENU = '(Conflict)', ESP = '(Conflicto)';
        TempDefaultDim2: Record 352 TEMPORARY;
        TempDefaultDim3: Record 352 TEMPORARY;
        TotalRecNo: Integer;

    //[External]
    // procedure ClearTempDefaultDim();
    // begin
    //     TempDefaultDim2.DELETEALL;
    // end;

    //[External]
    procedure SetMultiGLAcc(var GLAcc: Record 15);
    begin
        ClearTempDefaultDim;
        WITH GLAcc DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::"G/L Account", "No.");
                until Rec.NEXT = 0;
    end;

    LOCAL procedure SetCommonDefaultDim();
    var
        DefaultDim: Record 352;
    begin
        Rec.SETRANGE(
          "Multi Selection Action", rec."Multi Selection Action"::Delete);
        if Rec.FIND('-') then
            repeat
                if TempDefaultDim3.FIND('-') then
                    repeat
                        if DefaultDim.GET(
                             TempDefaultDim3."Table ID", TempDefaultDim3."No.", rec."Dimension Code")
                        then
                            DefaultDim.DELETE(TRUE);
                    until TempDefaultDim3.NEXT = 0;
            until Rec.NEXT = 0;
        Rec.SETRANGE(
          "Multi Selection Action", rec."Multi Selection Action"::Change);
        if Rec.FIND('-') then
            repeat
                if TempDefaultDim3.FIND('-') then
                    repeat
                        if DefaultDim.GET(
                             TempDefaultDim3."Table ID", TempDefaultDim3."No.", rec."Dimension Code")
                        then begin
                            DefaultDim."Dimension Code" := rec."Dimension Code";
                            DefaultDim."Dimension Value Code" := rec."Dimension Value Code";
                            DefaultDim."Value Posting" := rec."Value Posting";
                            OnBeforeSetCommonDefaultCopyFields(DefaultDim, Rec);
                            DefaultDim.MODIFY(TRUE);
                        end ELSE begin
                            DefaultDim.INIT;
                            DefaultDim."Table ID" := TempDefaultDim3."Table ID";
                            DefaultDim."No." := TempDefaultDim3."No.";
                            DefaultDim."Dimension Code" := rec."Dimension Code";
                            DefaultDim."Dimension Value Code" := rec."Dimension Value Code";
                            DefaultDim."Value Posting" := rec."Value Posting";
                            OnBeforeSetCommonDefaultCopyFields(DefaultDim, Rec);
                            DefaultDim.INSERT(TRUE);
                        end;
                    until TempDefaultDim3.NEXT = 0;
            until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiCust(var Cust: Record 18);
    begin
        ClearTempDefaultDim;
        WITH Cust DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::Customer, "No.");
                until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiVendor(var Vend: Record 23);
    begin
        ClearTempDefaultDim;
        WITH Vend DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::Vendor, "No.");
                until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiItem(var Item: Record 27);
    begin
        ClearTempDefaultDim;
        WITH Item DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::Item, "No.");
                until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiResGr(var ResGr: Record 152);
    begin
        ClearTempDefaultDim;
        WITH ResGr DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::"Resource Group", "No.");
                until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiResource(var Res: Record 156);
    begin
        ClearTempDefaultDim;
        WITH Res DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::Resource, "No.");
                until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiJob(var Job: Record 167);
    begin
        ClearTempDefaultDim;
        WITH Job DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::Job, "No.");
                until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiBankAcc(var BankAcc: Record 270);
    begin
        ClearTempDefaultDim;
        WITH BankAcc DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::"Bank Account", "No.");
                until Rec.NEXT = 0;
    end;

    //[External]
    // procedure SetMultiEmployee(var Employee: Record 5200);
    // begin
    //     ClearTempDefaultDim;
    //     WITH Employee DO
    //         if Rec.FIND('-') then
    //             repeat
    //                 CopyDefaultDimToDefaultDim(DATABASE::Employee, "No.");
    //             until Rec.NEXT = 0;
    // end;

    //[External]
    procedure SetMultiFA(var FA: Record 5600);
    begin
        ClearTempDefaultDim;
        WITH FA DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::"Fixed Asset", "No.");
                until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiInsurance(var Insurance: Record 5628);
    begin
        ClearTempDefaultDim;
        WITH Insurance DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::Insurance, "No.");
                until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiRespCenter(var RespCenter: Record 5714);
    begin
        ClearTempDefaultDim;
        WITH RespCenter DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::"Responsibility Center", Code);
                until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiSalesperson(var SalesPurchPerson: Record 13);
    begin
        ClearTempDefaultDim;
        WITH SalesPurchPerson DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::"Salesperson/Purchaser", Code);
                until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiWorkCenter(var WorkCenter: Record 99000754);
    begin
        ClearTempDefaultDim;
        WITH WorkCenter DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::"Work Center", rec."No.");
                until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiCampaign(var Campaign: Record 5071);
    begin
        ClearTempDefaultDim;
        WITH Campaign DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::Campaign, "No.");
                until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiCustTemplate(var CustTemplate: Record "Customer Templ.");
    begin
        ClearTempDefaultDim;
        WITH CustTemplate DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::"Customer Templ.", rec."No.");
                until Rec.NEXT = 0;
    end;

    //[External]
    // procedure CopyDefaultDimToDefaultDim(TableID: Integer; No: Code[20]);
    // var
    //     DefaultDim: Record 352;
    // begin
    //     TotalRecNo := TotalRecNo + 1;
    //     TempDefaultDim3."Table ID" := TableID;
    //     TempDefaultDim3."No." := No;
    //     TempDefaultDim3.INSERT;

    //     DefaultDim.SETRANGE("Table ID", TableID);
    //     DefaultDim.SETRANGE("No.", No);
    //     if DefaultDim.FIND('-') then
    //         repeat
    //             TempDefaultDim2 := DefaultDim;
    //             TempDefaultDim2.INSERT;
    //         until DefaultDim.NEXT = 0;
    // end;

    LOCAL procedure GetDefaultDim();
    var
        Dim: Record 348;
        RecNo: Integer;
    begin
        Rec.DELETEALL;
        if Dim.FIND('-') then
            repeat
                RecNo := 0;
                TempDefaultDim2.SETRANGE("Dimension Code", Dim.Code);
                Rec.SETRANGE("Dimension Code", Dim.Code);
                if TempDefaultDim2.FIND('-') then
                    repeat
                        if Rec.FIND('-') then begin
                            if rec."Dimension Value Code" <> TempDefaultDim2."Dimension Value Code" then begin
                                if (rec."Multi Selection Action" <> 10) and
                                   (rec."Multi Selection Action" <> 21)
                                then begin
                                    rec."Multi Selection Action" :=
                                      rec."Multi Selection Action" + 10;
                                    rec."Dimension Value Code" := '';
                                end;
                            end;
                            if rec."Value Posting" <> TempDefaultDim2."Value Posting" then begin
                                if (rec."Multi Selection Action" <> 11) and
                                   (rec."Multi Selection Action" <> 21)
                                then begin
                                    rec."Multi Selection Action" :=
                                      rec."Multi Selection Action" + 11;
                                    rec."Value Posting" := rec."Value Posting"::" ";
                                end;
                            end;
                            Rec.MODIFY;
                            RecNo := RecNo + 1;
                        end ELSE begin
                            Rec := TempDefaultDim2;
                            Rec.INSERT;
                            RecNo := RecNo + 1;
                        end;
                    until TempDefaultDim2.NEXT = 0;

                if Rec.FIND('-') and (RecNo <> TotalRecNo) then
                    if (rec."Multi Selection Action" <> 10) and
                       (rec."Multi Selection Action" <> 21)
                    then begin
                        rec."Multi Selection Action" :=
                          rec."Multi Selection Action" + 10;
                        rec."Dimension Value Code" := '';
                        Rec.MODIFY;
                    end;
            until Dim.NEXT = 0;

        Rec.RESET;
        Rec.SETCURRENTKEY("Dimension Code");
        Rec.SETCURRENTKEY("Dimension Code");
        Rec.SETFILTER(
          "Multi Selection Action", '<>%1', rec."Multi Selection Action"::Delete);
    end;

    //[External]
    procedure SetMultiServiceItem(var ServiceItem: Record 5940);
    begin
        ClearTempDefaultDim;
        WITH ServiceItem DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::"Service Item", "No.");
                until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiServiceItemGroup(var ServiceItemGroup: Record 5904);
    begin
        ClearTempDefaultDim;
        WITH ServiceItemGroup DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::"Service Item Group", Code);
                until Rec.NEXT = 0;
    end;

    //[External]
    procedure SetMultiServiceOrderType(var ServiceOrderType: Record 5903);
    begin
        ClearTempDefaultDim;
        WITH ServiceOrderType DO
            if Rec.FIND('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::"Service Order Type", Code);
                until Rec.NEXT = 0;
    end;

    LOCAL procedure LookupOKOnPush();
    begin
        SetCommonDefaultDim;
    end;

    LOCAL procedure DimensionValueCodeOnFormat(Text: Text[1024]);
    begin
        if rec."Dimension Code" <> '' then
            if (rec."Multi Selection Action" = 10) or
               (rec."Multi Selection Action" = 21)
            then
                Text := Text001;
    end;

    LOCAL procedure ValuePostingOnFormat(Text: Text[1024]);
    begin
        if rec."Dimension Code" <> '' then
            if (rec."Multi Selection Action" = 11) or
               (rec."Multi Selection Action" = 21)
            then
                Text := Text001;
    end;

    // [Integration]
    LOCAL procedure OnBeforeSetCommonDefaultCopyFields(var DefaultDimension: Record 352; FromDefaultDimension: Record 352);
    begin
    end;

    // begin//end
}











