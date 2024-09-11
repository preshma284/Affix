page 7207448 "Rental Elements List"
{
Editable=false;
    CaptionML=ENU='Rental Elements List',ESP='Lista elementos alquiler';
    SourceTable=7207344;
    PageType=List;
    CardPageID="Rental Elements Card";
  layout
{
area(content)
{
repeater("Group")
{
        
    field("No.";rec."No.")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Billing Rate Type";rec."Billing Rate Type")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Product Posting Group";rec."Product Posting Group")
    {
        
    }
    field("Product VAT Posting Group";rec."Product VAT Posting Group")
    {
        
    }
    field("Rent Price/Time Unit";rec."Rent Price/Time Unit")
    {
        
    }
    field("Posting Group";rec."Posting Group")
    {
        
    }
    field("Related Product";rec."Related Product")
    {
        
    }
    field("Global Dimensions 1 Code";rec."Global Dimensions 1 Code")
    {
        
    }
    field("Global Dimensions 2 Code";rec."Global Dimensions 2 Code")
    {
        
    }
    field("Blocked";rec."Blocked")
    {
        
    }

}

}
}actions
{
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='&Elements',ESP='&Elemento';
    action("action1")
    {
        ShortCutKey='Shift+F7';
                      CaptionML=ENU='Card',ESP='Ficha';
                      RunObject=Page 7207448;
RunPageLink="No."=FIELD("No."), "Date Filter"=FIELD("Date Filter"), "Global Dimension 1 Filter"=FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter"=FIELD("Global Dimension 2 Filter");
                      Image=EditLines ;
    }
    action("action2")
    {
        ShortCutKey='Ctrl+F7';
                      CaptionML=ENU='Entries',ESP='Movimientos';
                      RunObject=Page 7207452;
                      RunPageView=SORTING("Element No.");
RunPageLink="Element No."=FIELD("No.");
                      Image=JobLedger ;
    }
    action("action3")
    {
        CaptionML=ENU='C&omments',ESP='C&omentarios';
                      RunObject=Page 124;
RunPageLink="Table Name"=CONST("IC Partner"), "No."=FIELD("No.");
                      Image=ViewComments ;
    }
group("group6")
{
        CaptionML=ENU='Dimensions',ESP='Dimensiones';
    action("action4")
    {
        ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions-Individual',ESP='Dimesniones-Individuales';
                      RunObject=Page 540;
RunPageLink="Table ID"=CONST(7207344), "No."=FIELD("No.");
                      Image=Dimensions ;
    }
    action("action5")
    {
        CaptionML=ENU='Dimensions-&Multiple',ESP='Dimensiones-&M�ltiples';
                      Image=DimensionSets;
                      
                                trigger OnAction()    VAR
                                 RentalElements : Record 7207344;
                                 DefaultDimensionsMultiple : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(RentalElements);
                                 //*** DUPLICAR ESTA FUNCION EN ESTE FORM PARA LA PLANTILLA
                                 DefaultDimensionsMultiple.RUNMODAL;
                               END;


    }
    separator("separator6")
    {
        
    }
    action("action7")
    {
        ShortCutKey='F7';
                      CaptionML=ENU='Statistics',ESP='Estad�sticas';
                      RunObject=Page 7207449;
RunPageLink="No."=FIELD("No."), "Date Filter"=FIELD("Date Filter"), "Global Dimension 1 Filter"=FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter"=FIELD("Global Dimension 2 Filter");
                      Image=Statistics ;
    }
    action("action8")
    {
        CaptionML=ENU='Cronovisi�n',ESP='Cr&onovisi�n';
                      RunObject=Page 7207450;
RunPageLink="No."=FIELD("No."), "Global Dimension 1 Filter"=FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter"=FIELD("Global Dimension 2 Filter");
                      Image=MachineCenterCalendar;
    }

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
                actionref(action8_Promoted; action8)
                {
                }
            }
        }
}
  

    /*begin
    end.
  
*/
}







