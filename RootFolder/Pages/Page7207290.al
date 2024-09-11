page 7207290 "QB Cost Database Errors"
{
    CaptionML = ENU = 'Cost Database Errors', ESP = 'Errores en el preciario';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7207271;

    layout
    {
        area(content)
        {
            group("group23")
            {

                CaptionML = ESP = 'Errores';
                field("Ptext"; "Ptext")
                {

                    CaptionML = ESP = 'Cap/Part.';
                    ToolTipML = ESP = 'Si deja en blanco el texto para venta, se usar� el de coste para la misma';
                    Editable = FALSE;
                    MultiLine = true;
                }
                field("Utext"; "Utext")
                {

                    CaptionML = ESP = 'Descompuestos';
                    Editable = FALSE;
                    MultiLine = true

  ;
                }

            }

        }
    }
    trigger OnAfterGetCurrRecord()
    BEGIN
        Ptext := QBCostDatabase.CD_GetError(Rec, 0);
        Utext := QBCostDatabase.CD_GetError(Rec, 1);
    END;



    var
        QBCostDatabase: Codeunit 7206986;
        Ptext: Text;
        Text01: TextConst ESP = 'Si deja en blanco el texto para venta, se usar� el de coste para la misma';
        Utext: Text;/*

    begin
    {
      JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3. Nueva pantalla para ver los errores
    }
    end.*/


}







