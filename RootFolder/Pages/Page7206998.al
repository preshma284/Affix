page 7206998 "QB Framework Contr. Closed"
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='Closed Blanket Purchase List',ESP='Lista de contratos marco cerrados';
    SourceTable=7206937;
    PageType=List;
    CardPageID="QB Framework Contr. Card";
    RefreshOnActivate=true;
    PromotedActionCategoriesML=ENU='New,Process,Report,Request Approval',ESP='Nuevo,Procesar,Informe,Solicitar aprobaci�n';
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("No.";rec."No.")
    {
        
                ToolTipML=ENU='Specifies the number of the involved entry or record, according to the specified number series.',ESP='Especifica el n�mero de la entrada o el registro relacionado, seg�n la serie num�rica especificada.';
                ApplicationArea=Suite;
    }
    field("Vendor No.";rec."Vendor No.")
    {
        
                ToolTipML=ENU='Specifies the name of the vendor who delivered the items.',ESP='Especifica el nombre del proveedor que envi� los art�culos.';
                ApplicationArea=Suite;
    }
    field("Vendor Name";rec."Vendor Name")
    {
        
                ToolTipML=ENU='Specifies the name of the vendor who delivered the items.',ESP='Especifica el nombre del proveedor que envi� los art�culos.';
                ApplicationArea=Suite;
    }
    field("Init Date";rec."Init Date")
    {
        
                ToolTipML=ENU='Specifies the date when the posting of the purchase document will be recorded.',ESP='Especifica la fecha en que se registrar� el registro del documento de compra.';
                ApplicationArea=Suite;
                Visible=FALSE ;
    }
    field("Purchaser Code";rec."Purchaser Code")
    {
        
                ToolTipML=ENU='Specifies which purchaser is assigned to the vendor.',ESP='Especifica el comprador asignado al proveedor.';
                ApplicationArea=Suite;
                Visible=FALSE ;
    }
    field("Currency Code";rec."Currency Code")
    {
        
                ToolTipML=ENU='Specifies the code of the currency of the amounts on the purchase lines.',ESP='Especifica el c�digo de divisa de los importes de las l�neas de compra.';
                ApplicationArea=Suite;
                Visible=FALSE ;
    }

}

}
area(FactBoxes)
{
    systempart(Links;Links)
    {
        
                Visible=FALSE;
    }
    systempart(Notes;Notes)
    {
        ;
    }

}
}
  trigger OnOpenPage()    BEGIN
                 Rec.FILTERGROUP(2);
                 Rec.SETRANGE(Status, rec.Status::Closed);
                 Rec.FILTERGROUP(0);
               END;



    var
      DocPrint : Codeunit 229;
      OpenApprovalEntriesExist : Boolean;
      CanCancelApprovalForRecord : Boolean;

    LOCAL procedure SetControlAppearance();
    var
      ApprovalsMgmt : Codeunit 1535;
    begin
    end;

    // begin
    /*{
      JDC 25/02/21: - Q12867 Created
      JAV 10/08/22: - QB 1.11.01 Se cambia el campo estado y el propio estado
    }*///end
}








