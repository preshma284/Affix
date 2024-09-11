page 7207556 "Propose Subcontracting"
{
Editable=false;
    CaptionML=ENU='Propose Subcontracting',ESP='Proponer subcontrataciones';
    SourceTable=7207386;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Piecework Code";rec."Piecework Code")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
    }
    field("Budget Measure";rec."Budget Measure")
    {
        
    }
    field("Amount Production Budget";rec."Amount Production Budget")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Aver. Cost Price Pend. Budget";rec."Aver. Cost Price Pend. Budget")
    {
        
    }
    field("Budget Cost";rec."ShowBudgetCost")
    {
        
                CaptionML=ENU='Budget Cost',ESP='Imp. Coste Ppto';
                Editable=FALSE ;
    }
    field("No. Subcontracting Resource";rec."No. Subcontracting Resource")
    {
        
    }
    field("Measured Qty Subc. Piecework";rec."Measured Qty Subc. Piecework")
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
        CaptionML=ENU='Job Units',ESP='&Unidades de obra';
    action("action1")
    {
        CaptionML=ESP='Descompuesto';
                      RunObject=Page 7207526;
                      RunPageView=SORTING("Job No.","Piecework Code","Cod. Budget","Cost Type","No.");
RunPageLink="Job No."=FIELD("Job No."), "Piecework Code"=FIELD("Piecework Code");
                      Image=BinContent;
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
            }
        }
}
  trigger OnAfterGetRecord()    BEGIN
                       IndentedDescription := 0;
                     END;

trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       IF CloseAction = ACTION::LookupOK THEN
                           LookupOKOnPush;
                     END;



    var
      PurchaseHeader : Record 38;
      ComparativeHeader : Record 7207412;
      IndentedDescription : Integer;
      DocumentType: Option "Order","Comparative";

    procedure PassPurchaseOrder(PurchaseHeaderPass : Record 38);
    begin
      PurchaseHeader := PurchaseHeaderPass;
      DocumentType := DocumentType::Order;
    end;

    procedure PassComparative(ComparativeHeaderPass : Record 7207412);
    begin
      ComparativeHeader := ComparativeHeaderPass;
      DocumentType := DocumentType::Comparative;
    end;

    LOCAL procedure LookupOKOnPush();
    var
      GetSubcontract : Codeunit 7207294;
      GetCompleteSubcontracting : Codeunit 7207299;
    begin
      CurrPage.SETSELECTIONFILTER(Rec);
      if DocumentType = DocumentType::Order then begin
       GetSubcontract.SetMedic(PurchaseHeader);
       GetSubcontract.CreateLines(Rec);
      end ELSE begin
        GetCompleteSubcontracting.SetComparative(ComparativeHeader);
        GetCompleteSubcontracting.CreateLines(Rec);
      end;
    end;

    // begin//end
}







