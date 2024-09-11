page 7207413 "Element Situation Statistics"
{
    Editable = false;
    CaptionML = ENU = 'Element Situation Statistics', ESP = 'Estad�sitca situaci�n elemento';
    SourceTable = 7207344;
    PageType = Card;
    layout
    {
        area(content)
        {
            group("General")
            {

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
                field("Posting Group"; rec."Posting Group")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Element Type"; rec."Element Type")
                {

                }
                field("Delivered Quantity"; rec."Delivered Quantity")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Return Quantity"; rec."Return Quantity")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Quantity Balance"; rec."Quantity Balance")
                {

                }
                field("Related Product"; rec."Related Product")
                {

                }
                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {

                }
                field("Blocked"; rec."Blocked")
                {

                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Element', ESP = '&Elemento';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 7207448;
                    RunPageLink = "No." = FIELD("No."), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    Image = EditLines;
                }
                action("action2")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Entries', ESP = 'Movimientos';
                    RunObject = Page 7207452;
                    RunPageView = SORTING("Element No.");
                    RunPageLink = "Element No." = FIELD("No.");
                    Image = LedgerEntries;
                }
                action("action3")
                {
                    CaptionML = ENU = 'C&omments', ESP = 'C&omentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("IC Partner"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                group("group6")
                {
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    action("action4")
                    {
                        ShortCutKey = 'Shift+Ctrl+D';
                        CaptionML = ENU = 'Dimensions-Individual', ESP = 'Dimensiones-Individual';
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(7207344), "No." = FIELD("No.");
                        Image = Dimensions;
                    }
                    action("action5")
                    {
                        CaptionML = ENU = 'Dimensions-&Multiple', ESP = 'Dimensiones-&Multiples';
                        Image = DimensionSets;

                        trigger OnAction()
                        BEGIN
                            CurrPage.SETSELECTIONFILTER(RentalElements);
                            //*** DUPLICAR ESTA FUNCION EN ESTE FORM PARA LA PLANTILLA
                            DefaultDimensionsMultiple.RUNMODAL;
                        END;


                    }

                }
                separator("separator6")
                {

                }
                action("action7")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207449;
                    RunPageLink = "No." = FIELD("No."), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    Image = Statistics;
                }
                action("action8")
                {
                    CaptionML = ENU = 'Chr&onovision', ESP = 'Cr&onovision';
                    RunObject = Page 7207450;
                    RunPageLink = "No." = FIELD("No."), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    Image = ReviewWorksheet;
                }

            }

        }
        area(Processing)
        {


        }
    }

    var
        RentalElements: Record 7207344;
        DefaultDimensionsMultiple: Page 542;

    /*begin
    end.
  
*/
}







