page 7207451 "Subf Chrono Rental Elements"
{
    CaptionML = ENU = 'Subf Chrono Rental Elements', ESP = 'Cronovisi�n maestra l�neas';
    SourceTable = 2000000007;
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                Editable = False;
                field("Period Start"; rec."Period Start")
                {

                    CaptionML = ENU = 'Period Start', ESP = 'Inicio periodo';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Period Name"; rec."Period Name")
                {

                    CaptionML = ENU = 'Period Name', ESP = 'Nombre periodo';
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("RentalElements.Delivered Quantity"; RentalElements."Delivered Quantity")
                {

                    // OptionCaptionML = ENU = 'Quantity', ESP = 'Cantidad';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowMasterEntries(0);
                    END;


                }
                field("RentalElements.Return Quantity"; RentalElements."Return Quantity")
                {

                    CaptionML = ENU = 'Returns', ESP = 'Devoluciones';
                    Style = StrongAccent;
                    StyleExpr = TRUE;



                    ; trigger OnDrillDown()
                    BEGIN
                        ShowMasterEntries(1);
                    END;


                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        Rec.RESET;
    END;

    trigger OnFindRecord(Which: Text): Boolean
    BEGIN
        EXIT(PeriodFormManagement.FindDate(Which, Rec, MasterPeriodLength));
    END;

    trigger OnNextRecord(Steps: Integer): Integer
    BEGIN
        EXIT(PeriodFormManagement.NextDate(Steps, Rec, MasterPeriodLength));
    END;    

    trigger OnAfterGetRecord()
    BEGIN
        SetDateFilter;
        RentalElements.CALCFIELDS("Total Amount", "Delivered Quantity", RentalElements."Return Quantity");
    END;



    var
        RentalElements: Record 7207344;
        // MasterPeriodLength: Option "Day","Week","Month","Quarter","Year","Period";
        MasterPeriodLength:enum "Analysis Period Type";
        AmountType: Option "Net Change","Balance at Date";
        RentalElementsEntries: Record 7207345;
        PeriodFormManagement: Codeunit 50324;



    procedure Set(var NewRentalElements: Record 7207344; NewMasterPeriodLength: Enum "Analysis Period Type"; NewAmountType: Option "Net Change","Balance at Date");
    begin
        RentalElements.COPY(NewRentalElements);
        MasterPeriodLength := NewMasterPeriodLength;
        AmountType := NewAmountType;
        CurrPage.UPDATE(FALSE);
    end;

    LOCAL procedure ShowMasterEntries(Type: Option Delivery,Retunr);
    begin
        SetDateFilter;
        RentalElementsEntries.RESET;
        RentalElementsEntries.SETCURRENTKEY("Element No.", RentalElementsEntries."Posting Date");
        RentalElementsEntries.SETRANGE("Element No.", RentalElements."No.");
        if Type = Type::Delivery then
            RentalElementsEntries.SETRANGE("Entry Type", RentalElementsEntries."Entry Type"::Delivery)
        ELSE
            RentalElementsEntries.SETRANGE("Entry Type", RentalElementsEntries."Entry Type"::Return);

        RentalElementsEntries.SETFILTER("Posting Date", RentalElements.GETFILTER("Date Filter"));
        RentalElementsEntries.SETFILTER("Global Dimension 1 Code", RentalElements.GETFILTER("Global Dimension 1 Filter"));
        RentalElementsEntries.SETFILTER("Global Dimension 2 Code", RentalElements.GETFILTER("Global Dimension 2 Filter"));
        PAGE.RUN(0, RentalElementsEntries);
    end;

    LOCAL procedure SetDateFilter();
    begin
        if AmountType = AmountType::"Net Change" then
            RentalElements.SETRANGE("Date Filter", rec."Period Start", rec."Period end")
        ELSE
            RentalElements.SETRANGE("Date Filter", 0D, rec."Period end");
    end;

    // begin//end
}







