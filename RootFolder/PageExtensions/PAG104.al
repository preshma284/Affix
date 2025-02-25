pageextension 50102 MyExtension104 extends 104//85
{
    layout
    {
        addafter("New Page")
        {
            field("Analytic Concept"; rec."Analytic Concept")
            {

                Visible = FALSE;
            }
            field("Dimension 1 Filter"; rec."Dimension 1 Filter")
            {

                Enabled = Dimension1FilterEnable;

                ; trigger OnLookup(var Text: Text): Boolean
                BEGIN
                    QBPagePublisher.LookUpDimFilterPageAccountSchedule(Rec, 1, Text, booldimension);
                    EXIT(booldimension);//QB
                END;


            }
            field("Dimension 2 Filter"; rec."Dimension 2 Filter")
            {

                Enabled = Dimension2FilterEnable;

                ; trigger OnLookup(var Text: Text): Boolean
                BEGIN
                    QBPagePublisher.LookUpDimFilterPageAccountSchedule(Rec, 2, Text, booldimension);
                    EXIT(booldimension);//QB
                END;


            }
            field("Dimension 3 Filter"; rec."Dimension 3 Filter")
            {

                Enabled = Dimension3FilterEnable;

                ; trigger OnLookup(var Text: Text): Boolean
                BEGIN
                    QBPagePublisher.LookUpDimFilterPageAccountSchedule(Rec, 2, Text, booldimension);
                    EXIT(booldimension);//QB
                END;


            }
            field("Dimension 4 Filter"; rec."Dimension 4 Filter")
            {

                Enabled = Dimension4FilterEnable;

                ; trigger OnLookup(var Text: Text): Boolean
                BEGIN
                    QBPagePublisher.LookUpDimFilterPageAccountSchedule(Rec, 1, Text, booldimension);
                    EXIT(booldimension);//QB
                END;


            }
        }

    }

    actions
    {


    }

    //trigger

    trigger OnOpenPage()
    var
        OriginalSchedName: Code[10];

    begin

        OriginalSchedName := CurrentSchedName;
        AccSchedManagement.OpenAndCheckSchedule(CurrentSchedName, Rec);
        IF CurrentSchedName <> OriginalSchedName THEN
            CurrentSchedNameOnAfterValidate;

        //QB
        QBPagePublisher.ActualFiltersPageAccountSchedule(Rec, Dimension1FilterEnable, Dimension2FilterEnable,
                                                              Dimension3FilterEnable, Dimension4FilterEnable,
                                                              CurrentSchedName);
        //QB fin

        //QB
        QBPagePublisher.DimensionFilterEnablePageAccountSchedule(Dimension1FilterEnable, Dimension2FilterEnable, Dimension3FilterEnable, Dimension4FilterEnable);

    end;


    var
        AccSchedManagement: Codeunit 8;
        CurrentSchedName: Code[10];
        DimCaptionsInitialized: Boolean;
        CostObjectTotallingEnabled: Boolean;
        CostCenterTotallingEnabled: Boolean;
        "----------------------------------- QB": Integer;
        Dimension1FilterEnable: Boolean;
        Dimension2FilterEnable: Boolean;
        Dimension3FilterEnable: Boolean;
        Dimension4FilterEnable: Boolean;
        QBPagePublisher: Codeunit 7207348;
        booldimension: Boolean;



    //procedure
    //procedure SetAccSchedName(NewAccSchedName : Code[10]);
    //    begin
    //      CurrentSchedName := NewAccSchedName;
    //    end;
    Local procedure CurrentSchedNameOnAfterValidate();
       begin
         CurrPage.SAVERECORD;
         AccSchedManagement.SetName(CurrentSchedName,Rec);
         CurrPage.UPDATE(FALSE);
       end;
    //
    //    //[External]
    //procedure SetupAccSchedLine(var AccSchedLine : Record 85);
    //    begin
    //      AccSchedLine := Rec;
    //      if ( rec."Line No." = 0  )then begin
    //        AccSchedLine := xRec;
    //        AccSchedLine.SETRANGE("Schedule Name",CurrentSchedName);
    //        if ( AccSchedLine.NEXT = 0  )then
    //          AccSchedLine."Line No." := xRec."Line No." + 10000
    //        ELSE begin
    //          if ( AccSchedLine.FINDLAST  )then
    //            AccSchedLine."Line No." += 10000;
    //          AccSchedLine.SETRANGE("Schedule Name");
    //        end;
    //      end;
    //    end;

    //procedure
}

