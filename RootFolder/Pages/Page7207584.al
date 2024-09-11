page 7207584 "Bring Piecework to The Job"
{
    CaptionML = ENU = 'Bring Piecework to The Job', ESP = 'Traer UO al proyecto';
    SourceTable = 7207277;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Cost Database Default"; rec."Cost Database Default")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("No."; rec."No.")
                {

                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Unit Type"; rec."Unit Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Comment"; rec."Comment")
                {

                }
                field("Units of Measure"; rec."Units of Measure")
                {

                }
                field("Account Type"; rec."Account Type")
                {

                }
                field("Price Cost"; rec."Price Cost")
                {

                }
                field("Proposed Sale Price"; rec."Proposed Sale Price")
                {

                }
                field("% Margin"; rec."% Margin")
                {

                }
                field("Gross Profit Percentage"; rec."Gross Profit Percentage")
                {

                }
                field("Type Cost Unit"; rec."Type Cost Unit")
                {

                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {
                CaptionML = ENU = '&Piecework', ESP = '&Unidades de obra';
                action("action1")
                {
                    CaptionML = ENU = 'Copy Piecework to The Job', ESP = 'Copiar UO al proyecto';
                    Image = MakeOrder;

                    trigger OnAction()
                    BEGIN
                        GetPiecework;
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Test', ESP = 'Indentar';
                    Image = TestReport;

                    trigger OnAction()
                    VAR
                        JobsUnitsIdentation: Codeunit 7207296;
                    BEGIN
                        //JAV 09/12/19: - Se llama a la nueva funci�n de identaci�n
                        // CLEAR(JobsUnitsIdentation);
                        // JobsUnitsIdentation.FunSetCostDatabase("Cost Database Default");
                        // JobsUnitsIdentation.RUN;
                        JobsUnitsIdentation.FunOrganise(rec."Cost Database Default");
                    END;


                }
                action("action3")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    Image = Calculate;

                    trigger OnAction()
                    BEGIN
                        PAGE.RUNMODAL(PAGE::"Piecework Card", Rec);
                    END;


                }
                action("action4")
                {
                    CaptionML = ENU = 'C&Omments', ESP = 'C&omentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("IC Partner"), "No." = FIELD("Unique Code");
                    Image = Comment;
                }
                action("action5")
                {
                    CaptionML = ENU = 'Bill of Item Data', ESP = 'Datos de descompuesto';
                    RunObject = Page 7207509;
                    RunPageView = SORTING("Cost Database Default", "No.");
                    RunPageLink = "Cost Database Default" = FIELD("Cost Database Default"), "No." = FIELD("No.");
                    Image = BinContent;
                }
                action("action6")
                {
                    CaptionML = ENU = 'Extended Text', ESP = 'Te&xtos adicionales';
                    RunObject = Page 7206929;
                    RunPageView = SORTING("Table", "Key1", "Key2");
                    RunPageLink = "Table" = CONST("Preciario"), "Key1" = FIELD("Cost Database Default"), "Key2" = FIELD("No.");
                    Image = Text;
                }
                group("group9")
                {
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;
                    action("action7")
                    {
                        ShortCutKey = 'Shift+Ctrl+D';
                        CaptionML = ENU = 'Dimensions-Individual', ESP = 'Dimensiones-Individuales';
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(7207277), "No." = FIELD("Unique Code");
                        Image = Dimensions;
                    }
                    action("action8")
                    {
                        CaptionML = ENU = 'Dimensions-Multiple', ESP = 'Dimensiones-Multiples';
                        Image = Dimensions;


                        trigger OnAction()
                        VAR
                            Piecework: Record 7207277;
                            DefaultDimensionsMultiple: Page 542;
                        BEGIN
                            //JAV 10/04/22: - QB 1.10.34 Se cambia la forma de llamar al cambio de dimensi�n m�ltiple
                            CurrPage.SETSELECTIONFILTER(Piecework);
                            DefaultDimensionsMultiple.ClearTempDefaultDim;
                            IF Piecework.FINDSET THEN
                                REPEAT
                                    DefaultDimensionsMultiple.CopyDefaultDimToDefaultDim(DATABASE::Piecework, Piecework."Unique Code");
                                UNTIL Rec.NEXT = 0;
                            DefaultDimensionsMultiple.RUNMODAL;
                        END;


                    }

                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
            }
        }
    }

    var
        After: Code[20];
        Ident: Integer;
        CJob: Code[20];
        DataPieceworkForProduction: Record 7207386;

    procedure GetPiecework();
    var
        Piecework: Record 7207277;
        CostDatabase: Record 7207271;
        // BringCostDatabase: Report 7207277;
        LText001: TextConst ENU = 'You want to Respect the price of the price.', ESP = 'Desea Respetar los precios del preciario.';
        Respect: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(Piecework);
        if CONFIRM(LText001, TRUE) then
            Respect := TRUE
        ELSE
            Respect := FALSE;
        // BringCostDatabase.JumpFilter(After, Respect, Ident);
        // BringCostDatabase.GatherDate(CJob, '');  //jmma
        // BringCostDatabase.StartDataDistinction('', '', Rec."Cost Database Default", Respect, TRUE);


        // BringCostDatabase.SETTABLEVIEW(Piecework);
        // BringCostDatabase.USEREQUESTPAGE(FALSE);
        // BringCostDatabase.RUNMODAL;
    end;

    procedure ReceivedJob(PCJob: Code[20]; PDataPieceworkForProduction: Record 7207386);
    var
        DataPieceworkForProductionL: Record 7207386;
        DataPieceworkForProductionL2: Record 7207386;
    begin
        CJob := PCJob;
        DataPieceworkForProduction := PDataPieceworkForProduction;

        // Busco el c�digo unidad de obra a asignar. Busco el mayor y le asigno el siguiente
        // C�digo de unidad que le corresponda

        DataPieceworkForProductionL.SETRANGE(DataPieceworkForProductionL."Job No.", PCJob);
        DataPieceworkForProductionL.SETRANGE(DataPieceworkForProductionL."Account Type", DataPieceworkForProductionL."Account Type"::Heading);

        if DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Unit then begin
            if DataPieceworkForProduction."Piecework Code" <> '' then
                DataPieceworkForProductionL.SETFILTER(DataPieceworkForProductionL."Piecework Code", '<%1', DataPieceworkForProduction."Piecework Code")
        end ELSE begin
            if DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Heading then begin
                DataPieceworkForProductionL.SETRANGE(DataPieceworkForProductionL."Piecework Code", DataPieceworkForProduction."Piecework Code");
            end;
        end;

        if DataPieceworkForProductionL.FINDLAST then begin
            DataPieceworkForProductionL2.SETRANGE(DataPieceworkForProductionL2."Job No.", PCJob);
            DataPieceworkForProductionL2.SETRANGE(DataPieceworkForProductionL2."Account Type", DataPieceworkForProductionL2."Account Type"::Unit);
            DataPieceworkForProductionL2.SETFILTER(DataPieceworkForProductionL2."Piecework Code", DataPieceworkForProductionL.Totaling);
            if DataPieceworkForProductionL2.FINDLAST then begin
                After := COPYSTR(DataPieceworkForProductionL2."Piecework Code", STRLEN(DataPieceworkForProductionL."Piecework Code") + 1,
                                STRLEN(DataPieceworkForProductionL2."Piecework Code") - STRLEN(DataPieceworkForProductionL."Piecework Code"));
                After := INCSTR(After);
                After := DataPieceworkForProductionL."Piecework Code" + After;
                Ident := DataPieceworkForProductionL2.Indentation;
            end ELSE begin
                After := DataPieceworkForProductionL."Piecework Code" + '01';
                Ident := DataPieceworkForProductionL.Indentation + 1;
            end;
        end ELSE begin
            After := '01';
        end;
    end;

    // begin
    /*{
      JAV 09/12/19: - Se llama a la nueva funci�n de identaci�n
      JAV 10/04/22: - QB 1.10.34 Se cambia la forma de llamar al cambio de dimensi�n m�ltiple
    }*///end
}







