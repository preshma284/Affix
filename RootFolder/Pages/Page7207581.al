page 7207581 "Price Bill of Item Assignment"
{
    Editable = false;
    CaptionML = ENU = 'Price Bill of Item Assignment List', ESP = 'Lista asignaci�n descom. preci';
    SourceTable = 7207277;
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                IndentationColumn = rec.Identation;
                ShowAsTree = true;
                field("No."; rec."No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Alias"; rec."Alias")
                {

                }
                field("Price Cost"; rec."Price Cost")
                {

                }
                field("Proposed Sale Price"; rec."Proposed Sale Price")
                {

                }
                field("Posting Group Unit Cost"; rec."Posting Group Unit Cost")
                {

                }
                field("Cost Database Default"; rec."Cost Database Default")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }

            }
            part("BillofItemData"; 7207582)
            {
                SubPageLink = "Cod. Cost database" = FIELD("Cost Database Default"), "Cod. Piecework" = FIELD("No.");
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Piecework', ESP = '&Unidades de obra';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';

                    trigger OnAction()
                    BEGIN
                        PAGE.RUNMODAL(PAGE::"Piecework Card", Rec);
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'C&omments', ESP = 'C&omentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("IC Partner"), "No." = FIELD("Unique Code");
                }
                group("group5")
                {
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    action("action3")
                    {
                        ShortCutKey = 'Shift+Ctrl+D';
                        CaptionML = ENU = 'Dimensions-Individual', ESP = 'Dimensiones-Individuales';
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(7207277), "No." = FIELD("Unique Code");
                    }
                    action("action4")
                    {
                        CaptionML = ENU = 'Dimensions-Multiples', ESP = 'Dimensiones-Multiples';

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
                separator("separator5")
                {

                }
                action("action6")
                {
                    CaptionML = ENU = 'Bill of Item Data', ESP = 'Datos de descompuesto';
                    RunObject = Page 7207509;
                    RunPageView = SORTING("Cost Database Default", "No.");
                    RunPageLink = "Cost Database Default" = FIELD("Cost Database Default"), "No." = FIELD("No.");
                    Image = BinContent;
                }
                separator("separator7")
                {

                }
                action("action8")
                {
                    CaptionML = ENU = 'Extended Text', ESP = 'Te&xtos adicionales';
                    RunObject = Page 7206929;
                    RunPageView = SORTING("Table", "Key1", "Key2");
                    RunPageLink = "Table" = CONST("Preciario"), "Key1" = FIELD("Cost Database Default"), "Key2" = FIELD("No.");
                }

            }

        }
        area(Processing)
        {


        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action6_Promoted; action6)
                {
                }
            }
        }
    }

    trigger OnInit()
    BEGIN
        CurrPage.LOOKUPMODE := TRUE;
    END;

    trigger OnOpenPage()
    BEGIN
        Acept := FALSE;
    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    VAR
        LText001: TextConst ENU='Do you want to Rec.COPY the selected bill of item to the piecewrk %1 of job %2?',ESP='�Desea copiar el descompuesto seleccionado a la unidad de obra %1 del proyecto %2?';
        LText002: TextConst ENU='Do you want to respect the cost database of the price?',ESP='�Desea respetar los precios del preciario?';
        Currency: Record 4;
        Job: Record 167;
        DataCostByPiecework: Record 7207387;
        LText000: TextConst ENU='Piecework %1 already exists for %2 and %3',ESP='Ya existe la unidad de obra %1 para %2 y %3';
    BEGIN
        IF CloseAction = ACTION::LookupOK THEN
            LookupOKOnPush;
        IF Acept THEN BEGIN
            IF NOT CONFIRM(LText001, TRUE, DataPieceworkForProductionAssign."Piecework Code", DataPieceworkForProductionAssign."Job No.") THEN
                EXIT;
            IF CONFIRM(LText002, TRUE) THEN
                Respect := TRUE
            ELSE
                Respect := FALSE;
            CLEAR(Currency);
            Currency.InitRoundingPrecision;
            Job.GET(DataPieceworkForProductionAssign."Job No.");
            IF DataCopy.FINDSET THEN BEGIN
                REPEAT
                    DataCostByPiecework.INIT;
                    DataCostByPiecework.VALIDATE("Job No.", DataPieceworkForProductionAssign."Job No.");
                    DataCostByPiecework.VALIDATE("Piecework Code", DataPieceworkForProductionAssign."Piecework Code");
                    DataCostByPiecework.VALIDATE("Cost Type", DataCopy.Type);
                    DataCostByPiecework.VALIDATE("No.", DataCopy."No.");
                    DataCostByPiecework.VALIDATE("Analytical Concept Direct Cost", DataCopy."Concep. Analytical Direct Cost");
                    DataCostByPiecework.VALIDATE("Analytical Concept Ind. Cost", DataCopy."Concep. Anal. Indirect Cost");
                    IF Respect THEN BEGIN
                        DataCostByPiecework.VALIDATE("Performance By Piecework", DataCopy."Quantity By");
                        DataCostByPiecework.VALIDATE("Direc Unit Cost", DataCopy."Direct Unit Cost");
                        DataCostByPiecework.VALIDATE("Indirect Unit Cost", DataCopy."Unit Cost Indirect");
                        DataCostByPiecework.VALIDATE("Budget Cost", ROUND(DataCopy."Quantity By" * (DataCopy."Direct Unit Cost"
                                        + DataCopy."Unit Cost Indirect"),
                                        Currency."Amount Rounding Precision"));
                    END ELSE BEGIN
                        DataCostByPiecework.VALIDATE("Direc Unit Cost");
                        DataCostByPiecework.VALIDATE("Indirect Unit Cost");
                        //DataCostByPiecework.VALIDATE("Budget Cost",ROUND(DataCopy."Quantity By" * (DataCostByPiecework."Direct Unitary Cost (JC)"
                        //                + DataCostByPiecework."Indirect Unit Cost"),Currency."Amount Rounding Precision"));
                    END;
                    IF Job."Budget Status" = Job."Budget Status"::Blocked THEN BEGIN
                        DataCostByPiecework.VALIDATE("Direc Unit Cost", 0);
                        DataCostByPiecework.VALIDATE("Indirect Unit Cost", 0);
                        DataCostByPiecework.VALIDATE("Budget Cost", 0);
                    END;
                    DataCostByPiecework."Code Cost Database" := DataCopy."Cod. Cost database";
                    DataCostByPiecework."Unique Code" := DataPieceworkForProductionAssign."Unique Code";
                    DataCostByPiecework."Code Cost Database" := DataPieceworkForProductionAssign."Code Cost Database";
                    DataCostByPiecework.VALIDATE("Cod. Budget", CurrentBudget);
                    IF NOT DataCostByPiecework.INSERT THEN BEGIN
                        MESSAGE(LText000, DataCostByPiecework."Piecework Code", DataCostByPiecework."Cost Type", DataCostByPiecework."No.");
                        CurrPage.CLOSE;
                    END;
                UNTIL DataCopy.NEXT = 0;
            END;
        END;
    END;



    var
        Acept: Boolean;
        DataPieceworkForProductionAssign: Record 7207386;
        CurrentBudget: Code[20];
        Respect: Boolean;
        DataCopy: Record 7207384;

    LOCAL procedure LookupOKOnPush();
    begin
        Acept := TRUE;
        CurrPage.BillofItemData.PAGE.ReceivesFilter(DataCopy);
    end;

    procedure DefinitionFilter(PType: Option "Piecework","Cost Unit");
    begin
        Rec.FILTERGROUP(2);
        Rec.SETRANGE("Unit Type", PType);
        Rec.FILTERGROUP(0);
    end;

    procedure GetPiecework(var PDataPieceworkForProduction: Record 7207386; PCurrentBudget: Code[20]);
    begin
        DataPieceworkForProductionAssign := PDataPieceworkForProduction;
        CurrentBudget := PCurrentBudget;
    end;

    // begin
    /*{
      JAV 10/04/22: - QB 1.10.34 Se cambia la forma de llamar al cambio de dimensi�n m�ltiple
    }*///end
}







