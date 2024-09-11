page 7207534 "Piecework Bill of Items Card"
{
CaptionML=ENU='Piecework Bill of Items Card',ESP='Ficha de descompuesto UO';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=7207386;
    DelayedInsert=true;
    PageType=Worksheet;
  layout
{
area(content)
{
group("group4")
{
        
                CaptionML=ESP='Unidad de Obra';
    field("Piecework Code";rec."Piecework Code")
    {
        
                CaptionML=ESP='N� Unidad de Obra';
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                CaptionML=ESP='Descripci�n';
                Editable=FALSE;
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Unit Of Measure";rec."Unit Of Measure")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Aver. Cost Price Pend. Budget";rec."Aver. Cost Price Pend. Budget")
    {
        
                DecimalPlaces=0:9;
                Editable=FALSE;
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Price Subcontracting Cost";rec."Price Subcontracting Cost")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Initial Produc. Price";rec."Initial Produc. Price")
    {
        
                Editable=false;
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Unit Price Sale (base)";rec."Unit Price Sale (base)")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Contract Price";rec."Contract Price")
    {
        
                Editable=false;
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Budget Filter";rec."Budget Filter")
    {
        
                Visible=FALSE;
                Style=Strong;
                StyleExpr=TRUE ;
    }

}
    part("PG_BillOfItems";7207515)
    {
        
                CaptionML=ENU='Bill Of Items Lines',ESP='L�neas descompuesto';SubPageLink="Job No."=FIELD("Job No."), "Piecework Code"=FIELD("Piecework Code"), "Cod. Budget"=FIELD("Budget Filter");
    }

}
}actions
{
area(Processing)
{

    action("PointOfUse")
    {
        
                      CaptionML=ENU='Points Of Use',ESP='Puntos de Uso';
                      Image=SplitChecks;
                      
                                
    trigger OnAction()    BEGIN
                                 CurrPage.PG_BillOfItems.PAGE.ShowBillOfItemsUse;
                               END;


    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(PointOfUse_Promoted; PointOfUse)
                {
                }
            }
        }
}
  
    var
      recDatosUo : Record 7207386;

    /*begin
    end.
  
*/
}







