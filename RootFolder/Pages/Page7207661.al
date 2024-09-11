page 7207661 "QB Tables Setup List"
{
  ApplicationArea=All;

    CaptionML = ENU = 'QB Tables Setup', ESP = 'Conf. Tablas para QB';
    SourceTable = 7206903;
    DelayedInsert = true;
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            repeater("table1")
            {

                field("Table"; rec."Table")
                {

                }
                field("Table Name"; rec."Table Name")
                {

                }
                field("Field No."; rec."Field No.")
                {

                }
                field("Languaje"; rec."Languaje")
                {

                }
                field("Caption"; rec."Caption")
                {

                }
                field("New Caption"; rec."New Caption")
                {

                }
                field("Mandatory Field"; rec."Mandatory Field")
                {

                }
                field("MDimension Code"; rec."MDimension Code")
                {

                }
                field("MDimension Table"; rec."MDimension Table")
                {

                }
                field("MDimension Field"; rec."MDimension Field")
                {

                }
                field("MDimension Prefix"; rec."MDimension Prefix")
                {

                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        QuoBuildingSetup.GET;
    END;

    trigger OnClosePage()
    BEGIN
        //Eliminar los registros vacios
        rec.DeleteEmpty;
    END;



    var
        QuoBuildingSetup: Record 7207278;/*

    begin
    {
      JAV 25/04/22: - QB 1.10.36 Se eliminan campos que pasan a QM MasterData. Se eliminan funciones para crear datos por defecto que ya no se usan aqu� sino en las p�ginas espec�ficas.
    }
    end.*/


}








