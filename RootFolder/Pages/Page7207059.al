page 7207059 "QB Post. Service Order List"
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='Post. Service Order',ESP='Ped. Serv. Pte. Facturar';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7206968;
    SourceTableView=WHERE("Posted Invoice No."=FILTER(''));
    PageType=List;
    CardPageID="QB Post. Service Order";
    
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
    field("Job Description";rec."Job Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Description 2";rec."Description 2")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Posting Description";rec."Posting Description")
    {
        
                Editable=FALSE;
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
    }
    field("Currency Code";rec."Currency Code")
    {
        
    }
    field("Currency Factor";rec."Currency Factor")
    {
        
    }
    field("Comment";rec."Comment")
    {
        
    }
    field("No. Series";rec."No. Series")
    {
        
    }
    field("Job No.";rec."Job No.")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Grouping Criteria";rec."Grouping Criteria")
    {
        
    }
    field("Customer No.";rec."Customer No.")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Invoice Generated";rec."Invoice Generated")
    {
        
    }
    field("Pre-Assigned Invoice No.";rec."Pre-Assigned Invoice No.")
    {
        
    }
    field("Posted Invoice No.";rec."Posted Invoice No.")
    {
        
    }
    field("Ext order service";rec."Ext order service")
    {
        
    }
    field("Invoicing Date";rec."Invoicing Date")
    {
        
    }

}

}
area(FactBoxes)
{
    systempart(Links;Links)
    {
        ;
    }
    systempart(Notes;Notes)
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
        CaptionML=ENU='&Documents',ESP='&Medici�n';
    action("action1")
    {
        CaptionML=ENU='Co&mments',ESP='C&omentarios';
                      RunObject=Page 7207305;
RunPageLink="No."=FIELD("No.");
                      Visible=false;
                      Image=ViewComments ;
    }

}

}
area(Processing)
{

    action("Invoice")
    {
        
                      CaptionML=ENU='Invoice',ESP='Facturar';
                      Image=PostedOrder;
                      
                                
    trigger OnAction()    VAR
                                //  R_QBInvoiceServiceOrders : Report 7207448;
                               BEGIN
                                 QBPostedServiceOrderHeader.RESET;
                                 CurrPage.SETSELECTIONFILTER(QBPostedServiceOrderHeader);
                                 REPORT.RUN(7207448,TRUE,FALSE,QBPostedServiceOrderHeader);
                               END;


    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Invoice_Promoted; Invoice)
                {
                }
            }
        }
}
  
trigger OnOpenPage()    BEGIN
                 FunctionQB.AccessToServiceOrder(TRUE);

                 rec.FilterResponsability(Rec);
                 /*{SE COMENTA. NO EXISTE LA FUNCION FilterLevel EN CODEUNIT 5700
                 UserSetupManagement.FilterLevel(CFilteLevel);
                 Rec.FILTERGROUP(2);
                 Rec.SETFILTER("Access Level",CFilteLevel);
                 Rec.FILTERGROUP(0);
                 }*/
               END;



    var
      UserSetupManagement : Codeunit 5700;
      CFilteLevel : Code[250];
      QBPostedServiceOrderHeader : Record 7206968;
      FunctionQB : Codeunit 7207272;/*

    begin
    {
      // Q16313 Se modifica la propiedad "SourceTableView" de la p�gina: WHERE(Posted Invoice No.=FILTER(''))
    }
    end.*/
  

}








