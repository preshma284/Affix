page 7207021 "QPR Budget Template Card"
{
CaptionML=ENU='Budget Template Card',ESP='Ficha de Plantilla de Presupuesto';
    SourceTable=7206980;
    PageType=Card;
  layout
{
area(content)
{
group("Group")
{
        
                CaptionML=ENU='Template',ESP='Plantilla';
    field("Template Code";rec."Template Code")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }

}
    part("part1";7207023)
    {
        
                SubPageView=SORTING("Template Code","Code");SubPageLink="Template Code"=FIELD("Template Code");
    }

}
}actions
{
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='&Actions',ESP='&Acciones';
    action("action1")
    {
        CaptionML=ENU='Export Budget Template To Excel',ESP='Exportar Plantilla a Excel';
                      Image=Export;
                      
                                trigger OnAction()    VAR
                                //  QPRExportBudgetLinesExcel : Report 7207452;
                               BEGIN
                                //  CLEAR(QPRExportBudgetLinesExcel);
                                //  QPRExportBudgetLinesExcel.SetParametros(Rec."Template Code");
                                //  QPRExportBudgetLinesExcel.RUNMODAL;
                               END;


    }
    action("action2")
    {
        CaptionML=ENU='Import Budget since Excel',ESP='Importar Plantilla desde Excel';
                      Image=Import;
                      
                                
    trigger OnAction()    VAR
                                //  QPRImportBudgetTemplExcel : Report 7207453;
                               BEGIN
                                //  CLEAR(QPRImportBudgetTemplExcel);
                                //  QPRImportBudgetTemplExcel.SetParameters(Rec."Template Code");
                                //  QPRImportBudgetTemplExcel.RUNMODAL;
                               END;


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
            }
        }
}
  /*

    begin
    {
      JAV 08/04/22: - QB 1.10.32 Se mejoran las plantillas de presupuestos, se cambian nombres y captios, se a�ade activable
    }
    end.*/
  

}







