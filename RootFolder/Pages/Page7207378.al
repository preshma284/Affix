page 7207378 "Transfers Between Jobs Lines"
{
    CaptionML = ENU = 'Lines', ESP = 'Lineas';
    SourceTable = 7207287;
    SourceTableView = SORTING("Document No.", "Line No.");
    PageType = ListPart;
    AutoSplitKey = true;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Document Type"; rec."Document Type")
                {

                }
                field("Allocation Account of Transfe"; rec."Allocation Account of Transfe")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Amount"; rec."Amount")
                {

                }
                field("Origin Job No."; rec."Origin Job No.")
                {

                }
                field("Origin Departament"; rec."Origin Departament")
                {

                }
                field("Origin C.A."; rec."Origin C.A.")
                {

                }
                field("Origin Piecework"; rec."Origin Piecework")
                {

                }
                field("Origin Task No."; rec."Origin Task No.")
                {

                    Visible = False;
                }
                field("Destination Job No."; rec."Destination Job No.")
                {

                }
                field("Destination Departament"; rec."Destination Departament")
                {

                }
                field("Destination C.A."; rec."Destination C.A.")
                {

                }
                field("Destination Piecework"; rec."Destination Piecework")
                {

                }
                field("Destination Task No."; rec."Destination Task No.")
                {

                    Visible = False

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                CaptionML = ESP = 'Dim. Origen';
                Image = Dimensions;

                trigger OnAction()
                BEGIN
                    rec.ShowDimensionsOrigin;
                END;


            }
            action("action2")
            {
                CaptionML = ESP = 'Dim. Destino';
                Image = Dimensions;


                trigger OnAction()
                BEGIN
                    rec.ShowDimensionsDestination;
                END;


            }

        }
    }

    var
        JobsSetup: Record 315;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    // begin
    /*{
      JAV 28/10/19: - Se cambia el name y caption para que sea mas significativo del contenido
    }*///end
}







