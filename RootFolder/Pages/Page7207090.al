page 7207090 "RE Setup"
{
  ApplicationArea=All;

CaptionML=ENU='Real Estate Setup',ESP='Configuraci�n de Proyectos Inmobiliarios';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=7207278;
    PageType=Card;
    
  layout
{
area(content)
{
group("group5")
{
        
                CaptionML=ESP='Versiones';
    field("QBGlobalConf.Version QB";QBGlobalConf."Version QB")
    {
        
                CaptionML=ESP='Versi�n QB';
                Editable=false;
                
                          ;trigger OnLookup(var Text: Text): Boolean    BEGIN
                           CLEAR(QBVersionChanges);
                           QBVersionChanges.SetProduct('QuoBuilding');
                           QBVersionChanges.RUNMODAL;
                         END;


    }
    field("QBGlobalConf.QPR Version";QBGlobalConf."QPR Version")
    {
        
                CaptionML=ESP='Versi�n Presupuestos';
                Editable=false;
                
                          ;trigger OnLookup(var Text: Text): Boolean    BEGIN
                           CLEAR(QBVersionChanges);
                           QBVersionChanges.SetProduct('QPR');
                           QBVersionChanges.RUNMODAL;
                         END;


    }
    field("QBGlobalConf.RE Version";QBGlobalConf."RE Version")
    {
        
                CaptionML=ESP='Versi�n Real Estate';
                Editable=false;
                
                          ;trigger OnLookup(var Text: Text): Boolean    BEGIN
                           CLEAR(QBVersionChanges);
                           QBVersionChanges.SetProduct('RE');
                           QBVersionChanges.RUNMODAL;
                         END;


    }

}
group("group9")
{
        
                CaptionML=ENU='Modulos adicionales',ESP='Modulos activos';
    field("RE Real Estate";rec."RE Real Estate")
    {
        
    }

}
group("group11")
{
        
                CaptionML=ENU='QuoBuilding',ESP='Configuraci�n';
group("group12")
{
        
                CaptionML=ENU='QuoBuilding',ESP='Datos generales';

}
    field("RE Serie for RE Proyect";rec."RE Serie for RE Proyect")
    {
        
    }
    field("RE Dimension for RE Proyect";rec."RE Dimension for RE Proyect")
    {
        
    }
    field("RE Use Currency in RE";rec."RE Use Currency in RE")
    {
        
    }

}

}
}actions
{
area(Processing)
{

    action("action1")
    {
        CaptionML=ESP='Crear Configuraci�n';
                      Image=Setup;
                      
                                trigger OnAction()    BEGIN
                                 QuobuildingInitialize.InitQPR;
                               END;


    }
    action("action2")
    {
        CaptionML=ESP='Revisar Proyectos';
                      Image=ChangeDimensions;
                      
                                
    trigger OnAction()    BEGIN
                                 COMMIT;
                                 QuobuildingInitialize.UpdateJobsDimension;
                               END;


    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
}
  














trigger OnOpenPage()    BEGIN
                 Rec.RESET;
                 IF NOT Rec.GET THEN BEGIN
                   Rec.INIT;
                   Rec.INSERT;
                 END;
                 rQBVersionChanges.UpdateConf;
                 Rec.GET; //Actualizar los cambios

                 //Conf. Global
                 QBGlobalConf.GetGlobalConf('');
               END;

trigger OnAfterGetRecord()    BEGIN
                       SetEditable;
                     END;



    var
      QBGlobalConf : Record 7206985;
      QuoBuildingSetup : Record 7207278;
      rQBVersionChanges : Record 7206921;
      QBVersionChanges : Page 7207301;
      QuobuildingInitialize : Codeunit 7207287;
      edCreatePG : Boolean;

    LOCAL procedure SetEditable();
    begin
      edCreatePG := (rec."QB_QPR Create Auto" = rec."QB_QPR Create Auto"::None);
    end;

    // begin
    /*{
      Q15432 - MCM - 06/10/21 - QPR - Creaci�n de campo QB_QPR Create Resources y grupo QuoRealEstate
      QPR Q15432 MCM 14/10/21 - Se a�ade el campo QB_QPR Resource UOM
      JAV 08/04/22: - QPR 1.00.09 Se a�ade columna para gastos activables
      JAV 10/10/22: - QB 1.12.00 Se elimina el campo "RE Activable" que pasa a la page espec�fica
    }*///end
}








