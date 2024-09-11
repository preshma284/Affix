page 7174334 "SII Document Line"
{
CaptionML=ENU='SII Document Line',ESP='L�nea Documento SII';
    InsertAllowed=false;
    ModifyAllowed=true;
    SourceTable=7174334;
    PageType=ListPart;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("% VAT";rec."% VAT")
    {
        
                Editable=FALSE ;
    }
    field("VAT Base";rec."VAT Base")
    {
        
                Editable=FALSE ;
    }
    field("VAT Amount";rec."VAT Amount")
    {
        
                Editable=FALSE ;
    }
    field("% RE";rec."% RE")
    {
        
                Editable=FALSE ;
    }
    field("RE Amount";rec."RE Amount")
    {
        
                Editable=FALSE ;
    }
    field("Exent";rec."Exent")
    {
        
                Editable=ExentB;
                
                            ;trigger OnValidate()    BEGIN
                             UpdateModify; //+QuoSII_1.4.99.999
                           END;


    }
    field("No Taxable VAT";rec."No Taxable VAT")
    {
        
                Editable=NoTaxableVATB;
                
                            ;trigger OnValidate()    BEGIN
                             UpdateModify; //+QuoSII_1.4.99.999
                           END;


    }
    field("Inversión Sujeto Pasivo";rec."Inversión Sujeto Pasivo")
    {
        
                Editable=InversionSujetoPasivoB;
                
                            ;trigger OnValidate()    BEGIN
                             UpdateModify; //+QuoSII_1.4.99.999
                           END;


    }
    field("Exent Type";rec."Exent Type")
    {
        
                Editable=ExentTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             UpdateModify; //+QuoSII_1.4.99.999
                           END;


    }
    field("ImpArt7_14_Otros";rec."ImpArt7_14_Otros")
    {
        
                Editable=ImpArt7_14_OtrosB;
                
                            ;trigger OnValidate()    BEGIN
                             UpdateModify; //+QuoSII_1.4.99.999
                           END;


    }
    field("ImporteTAIReglasLocalizacion";rec."ImporteTAIReglasLocalizacion")
    {
        
                Editable=ImporteTAIReglasLocalizacionB;
                
                            ;trigger OnValidate()    BEGIN
                             UpdateModify; //+QuoSII_1.4.99.999
                           END;


    }
    field("No Exent Type";rec."No Exent Type")
    {
        
                Editable=NoExentTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             UpdateModify; //+QuoSII_1.4.99.999
                           END;


    }
    field("Servicio";rec."Servicio")
    {
        
                Editable=ServicioB;
                
                            ;trigger OnValidate()    BEGIN
                             UpdateModify; //+QuoSII_1.4.99.999
                           END;


    }
    field("Bienes";rec."Bienes")
    {
        
                Editable=BienesB;
                
                            

  ;trigger OnValidate()    BEGIN
                             UpdateModify; //+QuoSII_1.4.99.999
                           END;


    }

}

}
}actions
{
area(Processing)
{

    action("Edit Lines")
    {
        
                      CaptionML=ESP='Editar l�neas';
                      Promoted=true;
                      Visible=EditB;
                      PromotedIsBig=true;
                      Image=Edit;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 EditFields(TRUE);
                               END;


    }
    action("Not Edit Lines")
    {
        
                      CaptionML=ESP='false editar l�neas';
                      Promoted=true;
                      Visible=NotEditB;
                      PromotedIsBig=true;
                      Image=Edit;
                      PromotedCategory=Process;
                      
                                
    trigger OnAction()    BEGIN
                                 EditFields(FALSE);
                               END;


    }

}
}
  
trigger OnOpenPage()    BEGIN
                 EditFields(FALSE);
               END;

trigger OnModifyRecord(): Boolean    BEGIN
                     UpdateModify; //+QuoSII_1.4.99.999
                   END;



    var
      SIIDocuments : Record 7174333;
      ExentB : Boolean;
      NoTaxableVATB : Boolean;
      InversionSujetoPasivoB : Boolean;
      ExentTypeB : Boolean;
      ImpArt7_14_OtrosB : Boolean;
      ImporteTAIReglasLocalizacionB : Boolean;
      NoExentTypeB : Boolean;
      ServicioB : Boolean;
      BienesB : Boolean;
      EditB : Boolean;
      NotEditB : Boolean;

    LOCAL procedure EditFields(OpEdit : Boolean);
    begin
      ExentB := OpEdit;
      NoTaxableVATB := OpEdit;
      InversionSujetoPasivoB := OpEdit;
      ExentTypeB := OpEdit;
      ImpArt7_14_OtrosB := OpEdit;
      ImporteTAIReglasLocalizacionB := OpEdit;
      NoExentTypeB := OpEdit;
      ServicioB := OpEdit;
      BienesB := OpEdit;
      if OpEdit = TRUE then begin
        EditB := FALSE;
        NotEditB := TRUE;
      end
      ELSE begin
        EditB := TRUE;
        NotEditB := FALSE;
      end;
    end;

    LOCAL procedure UpdateModify();
    begin
      //+QuoSII_1.4.99.999
      SIIDocuments.SETRANGE( "Document No.", rec. "Document No.");
      SIIDocuments.SETRANGE( "Document Type", rec. "Document Type");
      SIIDocuments.SETRANGE( "VAT Registration No.", rec. "VAT Registration No.");
      SIIDocuments.SETRANGE( "Entry No.", rec. "Entry No.");
      SIIDocuments.SETRANGE( "Register Type", rec. "Register Type");  //JAV 30/05
      if SIIDocuments.FINDFIRST then
        if SIIDocuments.Modified = FALSE then begin
          SIIDocuments.Modified := TRUE;
          SIIDocuments.MODIFY;
        end;
      //-QuoSII_1.4.99.999
    end;

    // begin
    /*{
      QuoSII_1.4.99.999 28/06/19 QMD - Se modifica propiedad ModifyAllowed a True
      JAV 08/09/21: - QuoSII 1.5z Se cambia el nombre del campo "Line Type" a "Register Type" que es mas informativo y as� no entra en confusi�n con campos denominados Type
    }*///end
}








