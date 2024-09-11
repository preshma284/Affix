page 50001 "QuoSync Received"
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='Company Sync Received',ESP='Sincronizar Empresas: Recibir';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=50001;
    PageType=Document;
  layout
{
area(content)
{
repeater("table1")
{
        
    field("Entry No";rec."Entry No")
    {
        
    }
    field("Origin";rec."Origin")
    {
        
    }
    field("Origin Entry No";rec."Origin Entry No")
    {
        
    }
    field("Destination";rec."Destination")
    {
        
    }
    field("Table";rec."Table")
    {
        
    }
    field("Type";rec."Type")
    {
        
    }
    field("FORMAT(Key)";FORMAT(rec."Key"))
    {
        
                CaptionML=ENU='Key',ESP='Clave';
    }
    field("XML Size";rec."XML Size")
    {
        
                
                          ;trigger OnLookup(var Text: Text): Boolean    BEGIN
                           Rec.CALCFIELDS(XML);
                          //  TempBlob.Blob := XML;
                           TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
                           Blob.Write(rec.XML);
                          //  txtXML := TempBlob.ReadAsTextWithCRLFLineSeparator;
                           TempBlob.CreateInStream(InStr, TextEncoding::Windows);
                           InStr.Read(txtXML);
                           CLEAR(QBSyncseeXML);
                           QBSyncseeXML.SetXML(txtXML);
                           QBSyncseeXML.RUNMODAL;
                         END;


    }
    field("Date Send";rec."Date Send")
    {
        
    }
    field("Date Received";rec."Date Received")
    {
        
    }
    field("Procesed";rec."Procesed")
    {
        
    }
    field("Date Procesed";rec."Date Procesed")
    {
        
    }
    field("Whit Error";rec."Whit Error")
    {
        
    }
    field("Text Error";rec."Text Error")
    {
        
    }

}

}
}actions
{
area(Processing)
{

    action("action1")
    {
        CaptionML=ESP='Recibir';
                      Image=ImportDatabase;
                      
                                trigger OnAction()    BEGIN
                                 Receive;
                               END;


    }
    action("action2")
    {
        CaptionML=ESP='Procesar';
                      Image=Process;
                      
                                trigger OnAction()    BEGIN
                                 Process;
                               END;


    }
    action("action3")
    {
        CaptionML=ESP='Eliminar correctos';
                      Image=Delete;
                      
                                trigger OnAction()    BEGIN
                                 DeleteReg(FALSE);
                               END;


    }
    action("action4")
    {
        CaptionML=ESP='Eliminar todos';
                      Image=DeleteExpiredComponents;
                      
                                
    trigger OnAction()    BEGIN
                                 DeleteReg(TRUE);
                               END;


    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
            }
        }
}
  
    var
      QBCompanySyncSetup : Record 50002;
      TempBlob : Codeunit "Temp Blob";
      Instr: InStream;
      Blob: OutStream;
      QBCompanySyncReceiveData : Codeunit 50001;
      dgb:Codeunit 12;
      QBSyncseeXML : Page 50004;
      txtXML : Text;

    LOCAL procedure Receive();
    begin
      QBCompanySyncReceiveData.ReceiveDataFromCompany(0);
    end;

    LOCAL procedure Process();
    begin
      QBCompanySyncReceiveData.ProcessLog;
    end;

    LOCAL procedure DeleteReg(pError : Boolean);
    begin
      QBCompanySyncReceiveData.DeleteObsoleteRecords(pError);
    end;

    // begin//end
}









