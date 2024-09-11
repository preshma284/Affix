page 7206926 "Jobs Status List"
{
  ApplicationArea=All;

CaptionML=ENU='Internal Status',ESP='Estados internos';
    SourceTable=7207440;
    DelayedInsert=true;
    SourceTableView=SORTING("Usage","Order")
                    ORDER(Ascending);
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Usage";rec."Usage")
    {
        
    }
    field("Code";rec."Code")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Order";rec."Order")
    {
        
    }
    field("Operative";rec."Operative")
    {
        
    }
    field("Editable Card";rec."Editable Card")
    {
        
    }
    field("Date Caption";rec."Date Caption")
    {
        
    }
    field("Change Date";rec."Change Date")
    {
        
    }
    field("Date 1 editable";rec."Date 1 editable")
    {
        
    }
    field("Date 2 editable";rec."Date 2 editable")
    {
        
    }
    field("Date 3 editable";rec."Date 3 editable")
    {
        
    }
    field("Date 4 editable";rec."Date 4 editable")
    {
        
    }
    field("Date 5 editable";rec."Date 5 editable")
    {
        
    }
    field("Date E editable";rec."Date E editable")
    {
        
    }
    field("Activation";rec."Activation")
    {
        
                ToolTipML=ESP='"Indica si el proyecto en este estado puede generar los movimientos de activaci¢n de los gastos. Solo funcionar  si la configuraci¢n de Gastos Activables est  activa y el proyecto tiene la marca de activable. "';
                
                            ;trigger OnValidate()    BEGIN
                             SetActives();
                           END;


    }
    field("Activation Account";rec."Activation Account")
    {
        
                ToolTipML=ESP='Cuenta al debe para los movimientos de la activaci¢n del proyecto (grupo 3)';
                Enabled=edActivation ;
    }
    field("Activation Account BalGes";rec."Activation Account BalGes")
    {
        
                ToolTipML=ESP='Cuenta al haber para los movimientos de la activaci¢n del proyecto en estado de comercialziaci¢n';
                Enabled=edActivation ;
    }
    field("Activation Account BalFin";rec."Activation Account BalFin")
    {
        
                ToolTipML=ESP='Cuenta al haber para los movimientos de la activaci¢n del proyecto en estado de gesti¢n';
                Enabled=edActivationCom 

  ;
    }

}

}
}
  

trigger OnAfterGetCurrRecord()    BEGIN
                           SetActives();
                         END;



    var
      edActivation : Boolean;
      edActivationCom : Boolean;

    LOCAL procedure SetActives();
    begin
      edActivation    := (Rec.Activation <> Rec.Activation::"  ");
      edActivationCom := (Rec.Activation = Rec.Activation::Financial);
    end;

    // begin
    /*{
      JAV 10/10/22: - QB 1.12.00 Se cambia el campo activable a option, hay que recompilar la page
    }*///end
}









