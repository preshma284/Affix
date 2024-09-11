page 7207573 "Associate JU To Record"
{
CaptionML=ENU='Job Units',ESP='Unidades de Obra';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7207386;
    PopulateAllFields=true;
    SourceTableView=SORTING("Job No.","Piecework Code")
                    WHERE("Type"=FILTER("Piecework"),"Customer Certification Unit"=CONST(true));
    PageType=List;
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Piecework Code";rec."Piecework Code")
    {
        
                StyleExpr=stline ;
    }
    field("Description";rec."Description")
    {
        
                StyleExpr=stline ;
    }
    field("Description 2";rec."Description 2")
    {
        
                Visible=FALSE;
                StyleExpr=stline ;
    }
    field("Budget Measure";rec."Budget Measure")
    {
        
                BlankZero=true;
                Editable=false;
                StyleExpr=stline ;
    }
    field("Unit Price Sale (base)";rec."Unit Price Sale (base)")
    {
        
                StyleExpr=stline ;
    }
    field("Contract Price";rec."Contract Price")
    {
        
                StyleExpr=stline ;
    }
    field("Amount Sale Performed (JC)";rec."Amount Sale Performed (JC)")
    {
        
                BlankZero=true;
                StyleExpr=stline ;
    }
    field("Initial Produc. Price";rec."Initial Produc. Price")
    {
        
                StyleExpr=stline ;
    }
    field("Aver. Cost Price Pend. Budget";rec."Aver. Cost Price Pend. Budget")
    {
        
                BlankZero=true;
                Editable=FALSE;
                StyleExpr=stline ;
    }
    field("Amount Production Budget";rec."Amount Production Budget")
    {
        
                BlankZero=true;
                Editable=FALSE;
                StyleExpr=stline ;
    }
    field("Amount Cost Budget (JC)";rec."Amount Cost Budget (JC)")
    {
        
                BlankZero=true;
                Editable=FALSE;
                StyleExpr=stline ;
    }
    field("Amount Production Performed";rec."Amount Production Performed")
    {
        
                BlankZero=true;
                StyleExpr=stline ;
    }
    field("Amount Production In Progress";rec."amountProductionInProgress")
    {
        
                CaptionML=ENU='Amount Production In Progress',ESP='Importe producci�n en tr�mite';
                BlankZero=true;
                StyleExpr=stline ;
    }
    field("Total Measurement Production";rec."Total Measurement Production")
    {
        
                BlankZero=true;
                StyleExpr=stline ;
    }
    field("Amount Cost Performed (JC)";rec."Amount Cost Performed (JC)")
    {
        
                BlankZero=true;
                StyleExpr=stline ;
    }
    field("Global Dimension 1 Code";rec."Global Dimension 1 Code")
    {
        
                // BlankZero=true;
                Visible=FALSE;
                StyleExpr=stline ;
    }
    field("Global Dimension 2 Code";rec."Global Dimension 2 Code")
    {
        
                Visible=FALSE;
                StyleExpr=stline ;
    }
    field("Reassuring";rec."Reassuring")
    {
        
                StyleExpr=stline 

  ;
    }

}

}
}
  
trigger OnAfterGetRecord()    BEGIN
                       stLine := rec.GetStyle('');
                     END;

trigger OnQueryClosePage(CloseAction: Action): Boolean    VAR
                       DataJobUnitForProduction : Record 7207386;
                       ConfJobsUnits : Record 7207279;
                     BEGIN
                       //JAV 04/04/19: - Se cambia la variable OptionAction por ActionAssociate y se mejora la funci�n en general

                       NumberAsig := 0;
                       IF CloseAction = ACTION::LookupOK THEN BEGIN
                         ConfJobsUnits.GET();
                         CurrPage.SETSELECTIONFILTER(DataJobUnitForProduction);
                         IF DataJobUnitForProduction.FINDSET THEN BEGIN
                           REPEAT
                             IF ActionAssociate THEN BEGIN
                               DataJobUnitForProduction."No. Record" := ControlRecord."No.";
                               DataJobUnitForProduction."Record Type" := ControlRecord."Record Type";
                               DataJobUnitForProduction."Record Status" := ControlRecord."Record Status";
                               //asignamos el % de tramitaci�n en funci�n del estado del expediente
                               CASE ControlRecord."Record Status" OF
                                 ControlRecord."Record Status"::Management:BEGIN
                                   DataJobUnitForProduction."% Processed Production" := ConfJobsUnits."% Management Application";
                                 END;
                                 ControlRecord."Record Status"::"Technical Approval":BEGIN
                                   DataJobUnitForProduction."% Processed Production" := ConfJobsUnits."% Appl. Tecnique Approval";
                                 END;
                                 ControlRecord."Record Status"::Approved:BEGIN
                                   DataJobUnitForProduction."% Processed Production" := 100;
                                 END;
                               END;
                             END ELSE BEGIN
                               DataJobUnitForProduction.CALCFIELDS("Amount Cost Performed (JC)");
                               DataJobUnitForProduction."No. Record" := '';
                               DataJobUnitForProduction."Record Type" := 0;
                               DataJobUnitForProduction."Record Status" := 0;
                               DataJobUnitForProduction."% Processed Production" := 100;
                               //JAV 26/07/19: - No limpiar los precios de venta de la U.O. al desasociar la unidad del presupuesto de venta
                               //DataJobUnitForProduction."Contract Price" := 0;
                               //DataJobUnitForProduction."Amount Sale Contract" := 0;
                               //DataJobUnitForProduction."Unit Price Sale (base)" := 0;
                               //DataJobUnitForProduction."Sale Amount" := 0;
                             END;

                             DataJobUnitForProduction.MODIFY;
                             NumberAsig += 1;
                           UNTIL DataJobUnitForProduction.NEXT = 0;
                         END;
                       END;
                     END;



    var
      ControlRecord : Record 7207393;
      NumberAsig : Integer;
      ActionAssociate : Boolean ;
      stLine : Text;

    procedure ReceiveData(ControlRecords : Record 7207393;actionOption: Option "Associate","Remove");
    begin
      ControlRecord := ControlRecords;
      //JAV 04/04/19: - Se cambia la variable OptionAction por ActionAssociate
      //OptionAction := actionOption;
      ActionAssociate := (actionOption = actionOption::Associate);
    end;

    procedure ReturnNumber(var NumAsig : Integer);
    begin
      NumAsig := NumberAsig;
    end;

    // begin
    /*{
      JAV 04/04/19: - Se cambia la variable OptionAction de tipo option ya que no se conserva el valor al abrir el formulario, por ActionAssociate tipo boolean y se mejora el if que lo usa
      JAV 26/07/19: - Se a�aden columnas de precios de venta y se reordenan un poco
      JAV 26/07/19: - No limpiar los precios de venta de la U.O. al desasociar la unidad del presupuesto de venta
                    - Se simplifica el proceso de OnQueryClosePage y se elimnan las funciones OnPushLookupOK y OnPushLookupCancel que no serv�an de mucho
      JAV 12/04/22: - QB 1.10.35 Se eliminan los campos DataPieceworkForProduction.Activable y JobLedgEntry.Activate porque no se usan para nada
    }*///end
}







