page 7207100 "QPR Budgets Setup"
{
  ApplicationArea=All;

CaptionML=ENU='Budgets Setup',ESP='Configuraci�n de Presupuestos';
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
    field("QPR Budgets";rec."QPR Budgets")
    {
        
    }

}
group("group11")
{
        
                CaptionML=ENU='QuoBuilding',ESP='Dimensiones';
group("group12")
{
        
                CaptionML=ENU='QuoBuilding',ESP='Dimensiones';
    field("QPR Dimension for Budget";rec."QPR Dimension for Budget")
    {
        
    }
    field("QPR Value dimension for Budget";rec."QPR Value dimension for Budget")
    {
        
                ToolTipML=ESP='Dimensi�n a utilizar para los Presupuestos';
    }
    field("QPR Analysis View for Budget";rec."QPR Analysis View for Budget")
    {
        
    }

}

}
group("group16")
{
        
                CaptionML=ESP='Contadores';
    field("QPR Serie for Budgets";rec."QPR Serie for Budgets")
    {
        
    }

}
group("group18")
{
        
                CaptionML=ESP='Datos generales';
    field("QPR Use Currency in Budgets";rec."QPR Use Currency in Budgets")
    {
        
    }

}
group("group20")
{
        
                CaptionML=ENU='QuoRealEstate',ESP='Partidas Presupuestarias';
    field("QB_QPR Gen. Business Post. Gr.";rec."QB_QPR Gen. Business Post. Gr.")
    {
        
                ToolTipML=ESP='Se usa para concer a que cuenta contable se asocian las l�neas de presupuesto que no sean de origen cuenta';
    }
    field("QB_QPR VAT Product Post. Gr.";rec."QB_QPR VAT Product Post. Gr.")
    {
        
    }
    field("QB_QPR Create Dim.Value";rec."QB_QPR Create Dim.Value")
    {
        
    }
    field("QB_QPR Create Auto";rec."QB_QPR Create Auto")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             SetEditable;
                           END;


    }
    field("QB_QPR Base UOM";rec."QB_QPR Base UOM")
    {
        
                Editable=not edCreatePG ;
    }
    field("QB_QPR Create Post. Group";rec."QB_QPR Create Post. Group")
    {
        
                Editable=edCreatePG 

  ;
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
      JAV 10/10/22: - QB 1.12.00 Se elimina el campo "QPR Activable" que pasa a la page espec�fica
    }*///end
}








