page 7207447 "Rental Elements Card"
{
CaptionML=ENU='Rental Elements Card',ESP='Ficha elementos alquiler';
    SourceTable=7207344;
    PageType=Card;
    RefreshOnActivate=true;
  layout
{
area(content)
{
group("General")
{
        
                CaptionML=ENU='General',ESP='General';
    field("No.";rec."No.")
    {
        
                AssistEdit=true;
                Style=Strong;
                StyleExpr=TRUE;
                
                              ;trigger OnAssistEdit()    BEGIN
                               IF rec.AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;


    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Description 2";rec."Description 2")
    {
        
    }
    field("Base Unit of Measure";rec."Base Unit of Measure")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Posting Group";rec."Posting Group")
    {
        
    }
    field("Rent Price/Time Unit";rec."Rent Price/Time Unit")
    {
        
    }
    field("Billing Rate Type";rec."Billing Rate Type")
    {
        
    }
    field("Time Average Unit";rec."Time Average Unit")
    {
        
    }
    field("Element Unit Weight";rec."Element Unit Weight")
    {
        
    }
    field("Alias";rec."Alias")
    {
        
    }
    field("Blocked";rec."Blocked")
    {
        
    }
    field("Last Date Modified";rec."Last Date Modified")
    {
        
    }
    field("Related Product";rec."Related Product")
    {
        
    }
    field("Invoicing Resource";rec."Invoicing Resource")
    {
        
    }
    field("Work Type";rec."Work Type")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Element Type";rec."Element Type")
    {
        
    }
    field("Element List Handle";rec."Element List Handle")
    {
        
    }
    field("Bill of Materials";rec."Bill of Materials")
    {
        
    }

}
group("group42")
{
        
                CaptionML=ENU='Posting',ESP='Registro';
    field("Global Dimensions 1 Code";rec."Global Dimensions 1 Code")
    {
        
    }
    field("Global Dimensions 2 Code";rec."Global Dimensions 2 Code")
    {
        
    }

}

}
area(FactBoxes)
{
    part("part1";7207463)
    {
        ;
    }
    systempart(Notes;Notes)
    {
        ;
    }
    systempart(Links;Links)
    {
        ;
    }

}
}actions
{
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='&Element',ESP='&Elemento';
    action("action1")
    {
        ShortCutKey='Ctrl+F7';
                      CaptionML=ENU='Entries',ESP='Movimientos';
                      RunObject=Page 7207452;
                      RunPageView=SORTING("Element No.");
RunPageLink="Element No."=FIELD("No.");
                      Image=ResourceLedger;
    }
    action("action2")
    {
        CaptionML=ENU='C&Omments',ESP='C&omentarios';
                      RunObject=Page 124;
RunPageLink="Table Name"=CONST("Elements"), "No."=FIELD("No.");
                      Image=ViewComments ;
    }
    action("action3")
    {
        ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions',ESP='Dimensiones';
                      RunObject=Page 540;
RunPageLink="Table ID"=CONST(7207344), "No."=FIELD("No.");
                      Image=Dimensions ;
    }
    separator("separator4")
    {
        
    }
    action("action5")
    {
        ShortCutKey='F7';
                      CaptionML=ENU='Statistics',ESP='Estad�sitcas';
                      RunObject=Page 7207449;
RunPageLink="No."=FIELD("No."), "Date Filter"=FIELD("Date Filter"), "Global Dimension 1 Filter"=FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter"=FIELD("Global Dimension 2 Filter");
                      Image=Statistics ;
    }
    action("action6")
    {
        CaptionML=ENU='Chr&onovision',ESP='Cr&onovici�n';
                      RunObject=Page 7207450;
RunPageLink="No."=FIELD("No."), "Global Dimension 1 Filter"=FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter"=FIELD("Global Dimension 2 Filter");
                      Image=MachineCenterCalendar;
    }
    action("action7")
    {
        CaptionML=ENU='Pending Return',ESP='Pendientes de devoluci�n';
                      RunObject=Page 7207452;
                      RunPageView=SORTING("Element No.","Posting Date")
                                  WHERE("Pending"=CONST(true),"Entry Type"=CONST("Delivery"));
RunPageLink="Element No."=FIELD("No.");
                      Image=CopyFromTask;
    }
    action("action8")
    {
        CaptionML=ENU='Job Statistics',ESP='Estad�sitcas por proyecto';
                      RunObject=Page 7207414;
                      RunPageView=SORTING("No.")
                                  WHERE("Delivered Quantity"=FILTER(<>0));
RunPageLink="Posting Date Filter"=FIELD("Date Filter"), "Element Filter"=FIELD("No.");
                      Image=LedgerBudget;
    }
    separator("separator9")
    {
        
    }
    action("action10")
    {
        CaptionML=ENU='&List of Components',ESP='&Lista de componentes';
                      RunObject=Page 7207446;
RunPageLink="Rent Elements Code"=FIELD("No.");
                      Image=AssemblyBOM ;
    }

}
group("group13")
{
        CaptionML=ENU='Location',ESP='A&lmacen';
    action("action11")
    {
        CaptionML=ENU='Item Entries',ESP='Movimientos prod';
                      RunObject=Page 38;
                      RunPageView=SORTING("Item No.");
RunPageLink="Item No."=FIELD("Related Product");
                      Image=ItemLedger ;
    }
group("group15")
{
        CaptionML=ENU='Prod. &Availability by',ESP='&Disponibilidad prod. por';
    action("action12")
    {
        CaptionML=ENU='Period',ESP='Periodo';
                      RunObject=Page 157;
RunPageLink="No."=FIELD("Related Product"), "Date Filter"=FIELD("Date Filter");
                      Image=ItemAvailabilitybyPeriod ;
    }
    action("action13")
    {
        CaptionML=ENU='Variant',ESP='Variante';
                      RunObject=Page 5414;
RunPageLink="No."=FIELD("Related Product"), "Date Filter"=FIELD("Date Filter");
                      Image=ItemVariant ;
    }
    action("action14")
    {
        CaptionML=ENU='Location',ESP='Almacen';
                      RunObject=Page 492;
RunPageLink="No."=FIELD("Related Product"), "Date Filter"=FIELD("Date Filter");
                      Image=ItemAvailbyLoc ;
    }

}

}
group("group19")
{
        CaptionML=ENU='Actions',ESP='Acciones';
    action("action15")
    {
        CaptionML=ENU='Create Invoicing Resource',ESP='&Crear recurso de facturaci�n';
                      Image=CalculateRemainingUsage;
                      
                                trigger OnAction()    BEGIN
                                 RentalElements.GenerateResourceInvoiced(Rec);
                               END;


    }

}

}
area(Processing)
{


}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action7_Promoted; action7)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
                actionref(action15_Promoted; action15)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action6_Promoted; action6)
                {
                }
            }
        }
}
  
    var
      RentalElements : Record 7207344;

    /*begin
    end.
  
*/
}







