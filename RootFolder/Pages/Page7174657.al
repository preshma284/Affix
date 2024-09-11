page 7174657 "Log. DragDrop Sharepoint"
{
  ApplicationArea=All;

CaptionML=ENU='Log. DragDrop Sharepoint',ESP='Log. Ficheros a Sharepoint';
    InsertAllowed=false;
    ModifyAllowed=false;
    SourceTable=7174653;
    SourceTableView=SORTING("Entry No.")
                    ORDER(Ascending);
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Entry No.";rec."Entry No.")
    {
        
                Editable=FALSE ;
    }
    field("File Name";rec."File Name")
    {
        
                Editable=FALSE ;
    }
    field("File Content";rec."File Content")
    {
        
                Editable=FALSE ;
    }
    field("Dictionary SP";rec."Dictionary SP")
    {
        
                Editable=FALSE ;
    }
    field("Sharepoint Site Definition";rec."Sharepoint Site Definition")
    {
        
                Editable=FALSE ;
    }
    field("Creation Date";rec."Creation Date")
    {
        
                Editable=FALSE ;
    }
    field("User";rec."User")
    {
        
                Editable=FALSE ;
    }
    field("Send";rec."Send")
    {
        
                Editable=FALSE ;
    }
    field("Send Date";rec."Send Date")
    {
        
                Editable=FALSE ;
    }
    field("Update Metadata Only";rec."Update Metadata Only")
    {
        
    }

}

}
}actions
{
area(Processing)
{

    action("ShowRequest")
    {
        
                      CaptionML=ENU='Show Request XML',ESP='Mostrar solicitud XML';
                      ToolTipML=ENU='Displays the XML sent to the web service as a message.',ESP='Muestra el XML enviado al servicio web como un mensaje.';
                      ApplicationArea=All;
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=SendTo;
                      PromotedCategory=Category4;
                      Scope=Repeater;
                      
                                trigger OnAction()    VAR
                                 TempBlob : Codeunit "Temp Blob";
                                 InStr : InStream;
                                 vbigtext : BigText;
                               BEGIN

                                 Rec.CALCFIELDS("Dictionary SP");
                                 rec."Dictionary SP".CREATEINSTREAM(InStr);
                                 vbigtext.READ(InStr);
                                 MESSAGE(FORMAT(vbigtext));
                               END;


    }
    action("ShowResponse")
    {
        
                      CaptionML=ENU='Show Response XML',ESP='Mostrar respuesta XML';
                      ToolTipML=ENU='Displays the response received from the web service as a message.',ESP='Muestra la respuesta recibida del servicio web como un mensaje.';
                      ApplicationArea=All;
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Receipt;
                      PromotedCategory=Category4;
                      Scope=Repeater;
                      
                                
    trigger OnAction()    VAR
                                 TempBlob : Codeunit "Temp Blob";
                                 InStr : InStream;
                                 vbigtext : BigText;
                               BEGIN

                                 Rec.CALCFIELDS("Response SP");
                                 rec."Response SP".CREATEINSTREAM(InStr);
                                 vbigtext.READ(InStr);
                                 MESSAGE(FORMAT(vbigtext));
                               END;


    }

}
}
  /*

    begin
    {
      QUONEXT 20.07.17 DRAG&DROP. Log de los ficheros que se procesan en Sharepoint.

      17160 CPA 25-05-22. Factboxed de D&D en factura de venta y compra
    }
    end.*/
  

}









