page 7207272 "QB Job Sheet Lines Subform."
{
CaptionML=ENU='Lines',ESP='Lineas';
    MultipleNewLines=true;
    SourceTable=7207291;
    DelayedInsert=true;
    PageType=ListPart;
    AutoSplitKey=true;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Resource No.";rec."Resource No.")
    {
        
                Enabled=edRecurso;
                Style=Strong;
                StyleExpr=not edRecurso ;
    }
    field("Job No.";rec."Job No.")
    {
        
                Enabled=edProyecto;
                Style=Strong;
                StyleExpr=not edProyecto ;
    }
    field("Piecework No.";rec."Piecework No.")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Work Day Date";rec."Work Day Date")
    {
        
    }
    field("Work Type Code";rec."Work Type Code")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


    }
    field("Direct Cost Price";rec."Direct Cost Price")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


    }
    field("Cost Price";rec."Cost Price")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


    }
    field("Total Cost";rec."Total Cost")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


    }
    field("Sales Price";rec."Sales Price")
    {
        
    }
    field("Sale Amount";rec."Sale Amount")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
    }
    field("Compute In Hours";rec."Compute In Hours")
    {
        
    }
    field("Invoiced";rec."Invoiced")
    {
        
    }
    field("Job Task No.";rec."Job Task No.")
    {
        
    }

}

}
}actions
{
area(Processing)
{

group("group2")
{
        CaptionML=ENU='&Line',ESP='&L�nea';
    action("action1")
    {
        ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions',ESP='D&imensiones';
                      Image=Dimensions;
                      
                                
    trigger OnAction()    BEGIN
                                 _ShowDimensions;
                               END;


    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       rec.ShowShortcutDimCode(ShortcutDimCode);
                       SetEditable;
                     END;

trigger OnNewRecord(BelowxRec: Boolean)    BEGIN
                  CLEAR(ShortcutDimCode);
                  CASE WorksheetHeaderqb."Sheet Type" OF
                    WorksheetHeaderqb."Sheet Type"::"By Job"      : rec."Job No." := WorksheetHeaderqb."No. Resource /Job";
                    WorksheetHeaderqb."Sheet Type"::"By Resource" : rec."Resource No." := WorksheetHeaderqb."No. Resource /Job";
                  END;
                END;

trigger OnAfterGetCurrRecord()    BEGIN
                           SetEditable;
                         END;



    var
      WorksheetHeaderqb : Record 7207290;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      edProyecto : Boolean;
      edRecurso : Boolean;

    procedure SetHeader(pWorksheetHeaderqb : Record 7207290);
    begin
      WorksheetHeaderqb := pWorksheetHeaderqb;
      SetEditable;
    end;

    LOCAL procedure SetEditable();
    begin
      edProyecto := (WorksheetHeaderqb."Sheet Type" <> WorksheetHeaderqb."Sheet Type"::"By Job");
      edRecurso  := (WorksheetHeaderqb."Sheet Type" <> WorksheetHeaderqb."Sheet Type"::"By Resource");
      CurrPage.UPDATE(FALSE);
    end;

    procedure _ShowDimensions();
    begin
      rec.ShowDimensions;
    end;

    procedure UpdateForm(SetSaveRecord : Boolean);
    begin
      CurrPage.UPDATE(SetSaveRecord);
    end;

    // begin
    /*{
      GAP014 QMD 24/09/19 - VSTS 7594 GAP014. Descompuestos - Unidades de medida - Informe importaci�n Excel
    }*///end
}







