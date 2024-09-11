page 7207106 "QPR tmp Budget Jobs List"
{
Editable=false;
    CaptionML=ENU='Budget List',ESP='Lista de Presupuestos';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=167;
    SourceTableView=SORTING("No.")
                    ORDER(Descending)
                    WHERE("Card Type"=FILTER("Presupuesto"),"Archived"=CONST(false));
    PageType=Card;
    SourceTableTemporary=true;
    CardPageID="QPR Budget Jobs Card";
    RefreshOnActivate=true;
    PromotedActionCategoriesML=ENU='New,Process,Report,4,Currencies,Attributes',ESP='Nuevo,Procesar,Informe,4,Divisas,Atributos';
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("No.";rec."No.")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Description 2";rec."Description 2")
    {
        
    }
    field("Creation Date";rec."Creation Date")
    {
        
    }
    field("Currency Code";rec."Currency Code")
    {
        
    }
    field("Global Dimension 1 Code";rec."Global Dimension 1 Code")
    {
        
    }
    field("Job Type";rec."Job Type")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Mandatory Allocation Term By";rec."Mandatory Allocation Term By")
    {
        
    }
    field("Invoicing Type";rec."Invoicing Type")
    {
        
    }
    field("Internal Status";rec."Internal Status")
    {
        
    }
    field("Starting Date";rec."Starting Date")
    {
        
    }
    field("Ending Date";rec."Ending Date")
    {
        
    }
    field("Person Responsible";rec."Person Responsible")
    {
        
                Visible=False ;
    }
    field("Next Invoice Date";rec."Next Invoice Date")
    {
        
                Visible=False ;
    }
    field("Job Posting Group";rec."Job Posting Group")
    {
        
                Visible=False ;
    }
    field("Budget Cost Amount";rec."Budget Cost Amount")
    {
        
                CaptionML=ENU='Budget Cost Amount',ESP='Presupuesto';
    }
    field("Actual Production Amount";rec."Actual Production Amount")
    {
        
                CaptionML=ENU='Actual Earned Value Amount',ESP='Comprometido';
    }
    field("Invoiced Price (LCY)";rec."Invoiced Price (LCY)")
    {
        
                CaptionML=ENU='Invoiced Price',ESP='Realizado';
    }
    field("Production Budget Amount";rec."Production Budget Amount")
    {
        
                CaptionML=ENU='Estimated Value Budget Amount',ESP='Gasto';
    }
    field("Responsibility Center";rec."Responsibility Center")
    {
        
    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 rec.FilterResponsability(Rec);

                 //JAV 08/04/20: - Si se usan las divisas en los proyectos
                 JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 1);
               END;

trigger OnAfterGetRecord()    BEGIN
                       FunOnAfterGetRecord;
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           FunOnAfterGetRecord;
                         END;



    var
      Job : Record 167;
      FunctionQB : Codeunit 7207272;
      seeDragDrop : Boolean;
      "--------------------------------------- Divisas" : Integer;
      JobCurrencyExchangeFunction : Codeunit 7207332;
      useCurrencies : Boolean;
      edCurrencies : Boolean;
      edCurrencyCode : Boolean;
      edInvoiceCurrencyCode : Boolean;
      canEditJobsCurrencies : Boolean;
      canChangeFactboxCurrency : Boolean;
      ShowCurrency : Integer;
      "-------------------------- QB Atributos" : Integer;
      ClientTypeManagement : Codeunit 50192;
      TempFilterJobAttributesBuffer : Record 7206911 TEMPORARY;
      TempJobFilteredFromAttributes : Record 7206911 TEMPORARY;
      TempJobFilteredFromPickJob : Record 7206911 TEMPORARY;
      IsOnPhone : Boolean;
      RunOnTempRec : Boolean;
      RunOnPickJob : Boolean;

    procedure ExistJob() : Boolean;
    var
      Job : Record 167;
    begin
      if rec."Job Matrix - Work" = rec."Job Matrix - Work"::"Matrix Job" then begin
        Job.RESET;
        Job.SETCURRENTKEY("Job Matrix - Work","Matrix Job it Belongs");
        Job.SETRANGE("Job Matrix - Work",Job."Job Matrix - Work"::Work);
        Job.SETRANGE("Matrix Job it Belongs",rec."No.");
        if not Job.ISEMPTY then
          exit(TRUE)
        ELSE
          exit(FALSE);
      end ELSE
        exit(FALSE);
    end;

    LOCAL procedure FunOnAfterGetRecord();
    var
      QuoBuildingSetup : Record 7207278;
      JobVersion : Record 167;
      Resource : Record 156;
      JobClassification : Record 7207276;
      DirFacContact : Record 5050;
      QuoteType : Record 7207283;
      TAuxJobPhases : Record 7206914;
      ResponsibilityCenter : Record 5714;
      Opportunity : Record 5092;
      SalesPerson : Record 13;
    begin
      //Si se pueden ver las divisas del proyecto
      JobCurrencyExchangeFunction.SetRecordCurrencies(Rec, edCurrencies, canEditJobsCurrencies, canChangeFactboxCurrency, edCurrencyCode, edInvoiceCurrencyCode);
    end;

    LOCAL procedure SetCurrencyFB();
    begin
    end;

    procedure SetCompany(pCompany : Text);
    begin
      Rec.RESET;
      Rec.DELETEALL;

      Job.RESET;
      Job.CHANGECOMPANY(pCompany);
      Job.SETRANGE("Card Type", Job."Card Type"::Presupuesto);
      if (Job.FINDSET) then
        repeat
          Rec := Job;
          Rec.INSERT;
        until Job.NEXT = 0;
      Job.RESET;
    end;

    procedure GetJob() : Code[20];
    begin
      CurrPage.GETRECORD(Rec);
      exit(Rec."No.");
    end;

    // begin//end
}







