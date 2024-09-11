page 7174335 "SII Document Ship Line"
{
CaptionML=ENU='SII Document Ship Line',ESP='L�neas Env�os SII';
    InsertAllowed=false;
    ModifyAllowed=false;
    SourceTable=7174336;
    PageType=ListPart;
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Ship No.";rec."Ship No.")
    {
        
    }
    field("Document No.";rec."Document No.")
    {
        
    }
    field("Register Type";rec."Register Type")
    {
        
    }
    field("Status";rec."Status")
    {
        
    }
    field("AEAT Status";rec."AEAT Status")
    {
        
    }
    field("Base Imponible";rec."Base Imponible")
    {
        
    }
    field("Importe IVA";rec."Importe IVA")
    {
        
    }

}

}
}actions
{
area(Processing)
{

    action("<Page SII Document Card>")
    {
        
                      CaptionML=ENU='Ficha Documento';
                      RunObject=Page 7174336;
RunPageLink="Document No."=FIELD("Document No."), "Document Type"=FIELD("Document Type"), "VAT Registration No."=FIELD("VAT Registration No."), "Entry No."=FIELD("Entry No."), "Register Type"=FIELD("Register Type");
                      Image=ViewSourceDocumentLine ;
    }
    action("action2")
    {
        CaptionML=ESP='Marcar como subido';
                      Promoted=true;
                      Visible=isAdmin;
                      PromotedIsBig=true;
                      Image=MakeAgreement;
                      
                                trigger OnAction()    BEGIN
                                 MarkSend;
                               END;


    }
    action("action3")
    {
        CaptionML=ESP='Quitar Env�o';
                      Visible=isAdmin;
                      
                                
    trigger OnAction()    BEGIN
                                 DeleteLine;
                               END;


    }

}
}
  trigger OnOpenPage()    BEGIN
                 //JAV 04/08/21: - QuoSII 1.5z Si el usuario es administrador hacer visibles algunas opciones
                 CompanyInformation.GET;
                 isAdmin := (CompanyInformation."QuoSII Admin" = USERID);
               END;



    var
      TextMark : TextConst ESP='MARCADO COMO SUBIDO';
      TextMarkStatus : TextConst ESP='CORRECTO';
      isAdmin : Boolean;
      CompanyInformation : Record 79;
      SIIDocumentError : Record 7174332;
      SIIDocuments : Record 7174333;
      Text001 : TextConst ESP='ATENCION: Este proceso elimina el estado del env�o de la l�nea actual, �sela con precauci�n. Confirme que desea eliminar';

    LOCAL procedure MarkSend();
    begin
      //Crear el registro de estado
      SIIDocumentError.RESET;
      SIIDocumentError.SETRANGE( "Ship No.", rec. "Ship No.");
      SIIDocumentError.SETRANGE( "Document Type", rec. "Document Type");
      SIIDocumentError.SETRANGE( "Document No.", rec. "Document No.");
      SIIDocumentError.SETRANGE("Error Desc", TextMark);
      if (SIIDocumentError.FINDFIRST) then
        SIIDocumentError.DELETE;

      SIIDocumentError.INIT;
      SIIDocumentError."Ship No." := Rec."Ship No.";
      SIIDocumentError."Document Type" := Rec."Document Type";
      SIIDocumentError."Document No." := Rec."Document No.";
      SIIDocumentError."Error Desc" := TextMark;
      SIIDocumentError.HoraEnvio := CURRENTDATETIME;
      SIIDocumentError."AEAT Status" := TextMarkStatus;
      SIIDocumentError."VAT Registration No." := Rec."VAT Registration No.";
      SIIDocumentError."Posting Date" := Rec."Posting Date";
      SIIDocumentError."Entry No." := Rec."Entry No.";
      SIIDocumentError."Register Type" := Rec."Register Type";
      SIIDocumentError.INSERT;

      //Marcar el documento
      SIIDocuments.RESET;
      SIIDocuments.SETRANGE( "Document Type", rec. "Document Type");
      SIIDocuments.SETRANGE( "Document No.", rec. "Document No.");
      if (SIIDocuments.FINDFIRST) then begin
        SIIDocuments."AEAT Status" := TextMarkStatus;
        SIIDocuments.Status := SIIDocuments.Status::Enviada;
        SIIDocuments.MODIFY;
      end;

      //Marcar la l�nea
      rec.Status := rec.Status::Enviada;
      rec."AEAT Status" := TextMarkStatus;
      Rec.MODIFY;
    end;

    LOCAL procedure DeleteLine();
    begin
      if (CONFIRM(Text001, FALSE)) then begin
        //Elimino el estado del env�o
        SIIDocumentError.RESET;
        SIIDocumentError.SETRANGE( "Ship No.", rec. "Ship No.");
        SIIDocumentError.SETRANGE( "Document Type", rec. "Document Type");
        SIIDocumentError.SETRANGE( "Document No.", rec. "Document No.");
        SIIDocumentError.DELETEALL;

        //Desmarcar el documento
        SIIDocuments.RESET;
        SIIDocuments.SETRANGE( "Document Type", rec. "Document Type");
        SIIDocuments.SETRANGE( "Document No.", rec. "Document No.");
        if (SIIDocuments.FINDFIRST) then begin
          SIIDocuments."AEAT Status" := '';
          SIIDocuments.Status := SIIDocuments.Status::" ";
          SIIDocuments.MODIFY;
        end;

        //Desmarcar la l�nea
        rec.Status := rec.Status::" ";
        rec."AEAT Status" := '';
        Rec.MODIFY;
      end;
    end;

    // begin
    /*{
      BUG17265 AJS 06052021 La opci�n ficha documento no filtraba por el Entry No.
      JAV 08/09/21: - QuoSII 1.5z Se cambia el nombre del campo "Line Type" a rec."Register Type" que es mas informativo y as� no entra en confusi�n con campos denominados Type
    }*///end
}








