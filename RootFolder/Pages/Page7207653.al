page 7207653 "Guarantees List"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Guarantees List', ESP = 'Lista de garant�as';
    SourceTable = 7207441;
    PageType = Card;
    CardPageID = "Guarantees Card";

    layout
    {
        area(content)
        {
            repeater("General")
            {

                field("No."; rec."No.")
                {

                }
                field("Quote No."; rec."Quote No.")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Customer"; rec."Customer")
                {

                }
                field("Type"; rec."Type")
                {

                }
                field("Provisional Status"; rec."Provisional Status")
                {

                }
                field("Provisional Amount"; rec."Provisional Amount")
                {

                }
                field("Provisional Date ofApplication"; rec."Provisional Date ofApplication")
                {

                }
                field("Provisional Date of Issue"; rec."Provisional Date of Issue")
                {

                }
                field("Provisional Date of return"; rec."Provisional Date of return")
                {

                }
                field("Definitive Status"; rec."Definitive Status")
                {

                }
                field("Definitive Amount"; rec."Definitive Amount")
                {

                }
                field("Definitive Date of Application"; rec."Definitive Date of Application")
                {

                }
                field("Definitive Date of Issue"; rec."Definitive Date of Issue")
                {

                }
                field("Definitive Date of return"; rec."Definitive Date of return")
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

                CaptionML = ESP = 'Dimensiones';
                action("action1")
                {
                    ShortCutKey = 'Shift+Ctrl+E';
                    CaptionML = ENU = 'See Quotes', ESP = 'Ver Estudio';
                    RunObject = Page 7207361;
                    RunPageLink = "No." = FIELD("Quote No.");
                    Enabled = edEstudio;
                    Image = Quote;
                }
                action("action2")
                {
                    ShortCutKey = 'Shift+Ctrl+P';
                    CaptionML = ENU = 'Dimensions', ESP = 'Ver Proyecto';
                    RunObject = Page 7207478;
                    RunPageLink = "No." = FIELD("Job No.");
                    Enabled = edProyecto;
                    Image = Job;
                }
                action("action3")
                {
                    ShortCutKey = 'Shift+Ctrl+F';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones Estudio';
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(167), "No." = FIELD("Quote No.");
                    Enabled = edEstudio;
                    Image = Dimensions;
                }
                action("action4")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones Proyecto';
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(167), "No." = FIELD("Job No.");
                    Enabled = edProyecto;
                    Image = Dimensions;
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
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    BEGIN
        edEstudio := (rec."Quote No." <> '');
        edProyecto := (rec."Job No." <> '');
    END;



    var
        edEstudio: Boolean;
        edProyecto: Boolean;

    /*begin
    end.
  
*/
}








