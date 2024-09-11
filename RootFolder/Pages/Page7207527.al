page 7207527 "Select. Prod. Unit List"
{
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
        
    }
    field("Code Piecework PRESTO";rec."Code Piecework PRESTO")
    {
        
    }
    field("Additional Text Code";rec."Additional Text Code")
    {
        
                Visible=seeAditionalCode ;
    }
    field("Account Type";rec."Account Type")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Amount Production Budget";rec."Amount Production Budget")
    {
        
    }
    field("Aver. Cost Price Pend. Budget";rec."Aver. Cost Price Pend. Budget")
    {
        
    }
    field("Budget Measure";rec."Budget Measure")
    {
        
    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 QuoBuildingSetup.GET();
                 seeAditionalCode := (QuoBuildingSetup."Use Aditional Code");
               END;

trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       IF CloseAction = ACTION::LookupOK THEN
                           LookupOKOnPush;
                     END;



    var
      QuoBuildingSetup : Record 7207278;
      ProdMeasureLines : Record 7207400;
      DataPieceWorkforProduction : Record 7207386;
      AmountCost : Boolean ;
      codeMeasure : Code[20];
      noLine : Integer;
      seeAditionalCode : Boolean;

    LOCAL procedure FunShowAmountCost();
    begin
      if rec."Account Type" <> rec."Account Type"::Unit then begin
        AmountCost := TRUE;
      end;
    end;

    procedure RecieveData(parcodeMeasure : Code[20]);
    begin
      codeMeasure := parcodeMeasure;
    end;

    LOCAL procedure LookupOKOnPush();
    begin
      if codeMeasure <> '' then begin
        noLine := 0;
        ProdMeasureLines.SETRANGE("Document No.", codeMeasure);
        if ProdMeasureLines.FINDLAST then
          noLine := ProdMeasureLines."Line No." + 10000
        ELSE
          noLine := 10000;
        CurrPage.SETSELECTIONFILTER(DataPieceWorkforProduction);
        if DataPieceWorkforProduction.FINDSET then
          repeat
            if DataPieceWorkforProduction."Account Type" = DataPieceWorkforProduction."Account Type"::Unit then begin
              //JAV 23/07/20: Miro si ya existe para no duplicar las U.O.
              ProdMeasureLines.RESET;
              ProdMeasureLines.SETRANGE("Document No.",codeMeasure);
              ProdMeasureLines.SETRANGE("Piecework No.",DataPieceWorkforProduction."Piecework Code");
              if (ProdMeasureLines.ISEMPTY) then begin
                ProdMeasureLines.INIT;
                ProdMeasureLines."Document No." := codeMeasure;
                ProdMeasureLines."Line No." := noLine;
                ProdMeasureLines.VALIDATE("Job No.",DataPieceWorkforProduction."Job No.");
                ProdMeasureLines.VALIDATE("Piecework No.",DataPieceWorkforProduction."Piecework Code");
                ProdMeasureLines.INSERT(TRUE);
                noLine := noLine + 10000;
              end;
            end;
          until DataPieceWorkforProduction.NEXT = 0;
      end;
    end;

    // begin
    /*{
      JAV 04/04/19: - Se a¤ade el campo del precio de contrato
    }*///end
}







