page 50000 "QuoSync Send"
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='Company Sync Send',ESP='Sincronizar Empresas: Exportaci�n';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=50000;
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
    field("Destination";rec."Destination")
    {
        
    }
    field("Destination Entry No";rec."Destination Entry No")
    {
        
    }
    field("Date Send";rec."Date Send")
    {
        
    }
    field("Table";rec."Table")
    {
        
    }
    field("Type";rec."Type")
    {
        
    }
    field("FORMAT(Key)";FORMAT(rec.Key))
    {
        
                CaptionML=ENU='Key',ESP='Clave';
    }
    field("XML Size";rec."XML Size")
    {
        
                
                              ;trigger OnAssistEdit()    BEGIN
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
    field("Received";rec.Received)
    {
        
    }
    field("Date Received";rec."Date Received")
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       Rec.CALCFIELDS(XML);
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           Rec.CALCFIELDS(XML);
                         END;



    var
      TempBlob : Codeunit "Temp Blob";
      Instr: InStream;
      Blob: OutStream;
      QBSyncseeXML : Page 50004;
      txtXML : Text;

    /*begin
    end.
  
*/
}









