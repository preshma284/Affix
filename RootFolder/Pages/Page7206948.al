page 7206948 "QB External Worksheet List"
{
  ApplicationArea=All;

CaptionML=ENU='Worksheet List',ESP='Lista partes de trabajo';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7206933;
    SourceTableView=SORTING("Vendor No.");
    PageType=List;
    CardPageID="QB External Worksheet Card";
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("No.";rec."No.")
    {
        
    }
    field("Vendor No.";rec."Vendor No.")
    {
        
    }
    field("Vendor Name";rec."Vendor Name")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Posting Description";rec."Posting Description")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
    }

}

}
area(FactBoxes)
{
    part("part1";7207505)
    {
        SubPageLink="No."=FIELD("Vendor No.");
                Visible=TRUE;
    }
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
//Name=<Action7001113>;
                      //CaptionML=ESP='<Action7001113>';
group("<Action7001114>")
{
        
                      CaptionML=ENU='&Line',ESP='&L�nea';
    action("action1")
    {
        ShortCutKey='Shift+F5';
                      CaptionML=ENU='Vendor Card',ESP='Ficha Proveedor';
                      Image=Vendor;
                      
                                trigger OnAction()    VAR
                                 Vendor : Record 23;
                                 VendorCard : Page 26;
                               BEGIN
                                 Vendor.GET(rec."Vendor No.");

                                 CLEAR(VendorCard);
                                 VendorCard.SETRECORD(Vendor);
                                 VendorCard.RUNMODAL;
                               END;


    }

}
group("group4")
{
        CaptionML=ENU='P&osting',ESP='&Registro';
    action("Register")
    {
        
                      ShortCutKey='F9';
                      CaptionML=ENU='P&ost',ESP='Registrar';
                      Image=Post;
                      
                                trigger OnAction()    VAR
                                 PostWorksheet : Codeunit 7207270;
                               BEGIN
                                 QBExternalWorksheetHeader.GET(Rec."No.");
                                 IF CONFIRM(Text001,FALSE, rec."No.") THEN BEGIN
                                   CLEAR(PostWorksheet);
                                   PostWorksheet.ExternalWorksheet_Post(QBExternalWorksheetHeader);
                                 END;
                               END;


    }
    action("BatchRegister")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='Post &Batch',ESP='Registrar por &lotes';
                      Image=PostBatch;
                      
                                
    trigger OnAction()    VAR
                                 PostWorksheet : Codeunit 7207270;
                               BEGIN
                                 IF CONFIRM(Text002,FALSE) THEN BEGIN
                                   CLEAR(PostWorksheet);
                                   PostWorksheet.ExternalWorksheet_BatchPost;
                                 END;
                                 CurrPage.UPDATE(FALSE);
                               END;


    }

}

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Register_Promoted; Register)
                {
                }
                actionref(BatchRegister_Promoted; BatchRegister)
                {
                }
            }
        }
}
  trigger OnOpenPage()    BEGIN
                 FunctionQB.AccessToWSReports;
               END;



    var
      QBExternalWorksheetHeader : Record 7206933;
      FunctionQB : Codeunit 7207272;
      Option : Integer;
      CJob : Code[20];
      Text001 : TextConst ESP='Confirme que desea registrar el documento %1';
      Text002 : TextConst ESP='Confirme que desea registrar todos los documentos pendientes';

    procedure SETFILTER(PTypeSheet : Integer;PCJob : Code[20]);
    begin
      Option := PTypeSheet;
      CJob := PCJob;
    end;

    // begin//end
}









