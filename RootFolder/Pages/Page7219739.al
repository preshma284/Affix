page 7219739 "Ficha fase de venta/alquiler"
{
    CaptionML = ENU = 'Rental/sales stage record', ESP = 'Ficha fase de venta/alquiler';
    SourceTable = 7238195;
    DataCaptionFields = "No.","Nombre";
    PageType = Card;
    layout
    {
        area(content)
        {
            grid("group19")
            {

                CaptionML = ESP = 'N� fase venta / alquiler';
                GridLayout = Columns;
                field("No."; rec."No.")
                {

                    Enabled = false;
                }
                field("Nombre"; rec."Nombre")
                {

                    CaptionML = ENU = 'Name', ESP = 'Nombre';
                }

            }

        }
        area(FactBoxes)
        {
            systempart(Links; Links)
            {

                Visible = TRUE;
            }
            systempart(Notes; Notes)
            {

                Visible = TRUE;
            }

        }
    }
    /*

      begin
      {
        RE15721-LCG-16122021 - A�adir campo "QB_Investment Opportunity No." para ver trazabilidad.
        RE15623 DGG 201221 - Se a�ade funcionalidad en Page Action: Calendario Hitos Generales.
        RE16384 DGG 010322 - Se a�aden iconos a las acciones:Sectores, Fincas aportadas y Fincas resultantes
        RE16812 DGG 280322 - Se muestran los siguientes campos en General :"Tipo uso","S.C. bajo rasante","Sup. Edificable","Sup. Const. S/Rasante","Tipo Edificacion"
        RE16902 DGG 300322 - Se muestra campo "QB_Plot Area"
      }
      end.*/


}







