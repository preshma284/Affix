page 7207401 "Withholding Group List"
{
  ApplicationArea=All;

CaptionML=ENU='Withholding Group List',ESP='Lista Grupos Retenciones';
    SourceTable=7207330;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Withholding Type";rec."Withholding Type")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             SetEditable;
                           END;


    }
    field("Code";rec."Code")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("QB_IRPFWithhType";rec."QB_IRPFWithhType")
    {
        
                Enabled=not edGE ;
    }
    field("QB_IRPFSpeciesYields";rec."QB_IRPFSpeciesYields")
    {
        
                Enabled=not edGE ;
    }
    field("Percentage Withholding";rec."Percentage Withholding")
    {
        
    }
    field("Withholding treating";rec."Withholding treating")
    {
        
                Editable=edGE;
                
                            ;trigger OnValidate()    BEGIN
                             SetEditable;
                           END;


    }
    field("Withholding Base";rec."Withholding Base")
    {
        
                Editable=bTipoEditable ;
    }
    field("Warranty Period";rec."Warranty Period")
    {
        
                Editable=edGE ;
    }
    field("Calc Due Date";rec."Calc Due Date")
    {
        
    }
    field("Withholding Account";rec."Withholding Account")
    {
        
    }
    field("QB_Unpaid Account";rec."QB_Unpaid Account")
    {
        
    }
    field("Payment Method Liberation";rec."Payment Method Liberation")
    {
        
                Editable=edGE ;
    }
    field("Use in";rec."Use in")
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       SetEditable;
                     END;

trigger OnNewRecord(BelowxRec: Boolean)    BEGIN
                  //JAV 25/02/20: - Si la retenci¢n es de IRPF el tipo ser  IRPF, si no lo es y tiene tipo IRPF lo borramos
                  rec."Withholding Type" := rec."Withholding Type"::"G.E";
                  rec."Withholding treating" := rec."Withholding treating"::"Payment Withholding";
                  rec."Withholding Base" := rec."Withholding Base"::"Amount Including VAT";
                END;

trigger OnQueryClosePage(CloseAction: Action): Boolean    VAR
                       WithholdingGroup : Record 7207330;
                       QB_IRPFVATStatementLine : Record 7206979;
                       vFilter : Text[250];
                     BEGIN
                       //CEI-15408-LCG-051021-INI
                       IF FromIRPF THEN
                         IF CloseAction = ACTION::LookupOK THEN
                           BEGIN
                             WithholdingGroup.RESET();
                             CurrPage.SETSELECTIONFILTER(WithholdingGroup);
                             IF WithholdingGroup.FINDSET THEN
                               REPEAT
                                 vFilter += WithholdingGroup.Code +  '|';


                               UNTIL WithholdingGroup.NEXT = 0;
                               IF (vFilter <> '') AND (vFilter <> '|') THEN
                                 BEGIN

                                   QB_IRPFVATStatementLine.RESET;
                                   IF QB_IRPFVATStatementLine.GET(Declaration,No) THEN
                                     BEGIN
                                       QB_IRPFVATStatementLine."QB_Withholding Filter" := COPYSTR(vFilter,1,STRLEN(vFilter)-1);
                                       QB_IRPFVATStatementLine.MODIFY;
                                     END;
                                 END;
                           END;
                       //CEI-15408-LCG-051021-FIN
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           SetEditable;
                         END;



    var
      edGE : Boolean ;
      bTipoEditable : Boolean ;
      FromIRPF : Boolean;
      Declaration : Code[10];
      No : Integer;

    LOCAL procedure SetEditable();
    begin
      edGE := (rec."Withholding Type" = rec."Withholding Type"::"G.E");
      bTipoEditable := (rec."Withholding treating" = rec."Withholding treating"::"Payment Withholding");
    end;

    procedure SetParameters(fIrpf : Boolean;pDeclaration : Code[10];pNo : Integer);
    begin
      FromIRPF := fIrpf;
      Declaration := pDeclaration;
      No := pNo;
    end;

    // begin
    /*{
      JAV 19/10/20: - QB 1.06.21 se a¤ade el campo 12 rec."Payment Method Liberation" para indicar la forma de pago se usr  para liberar esta retenci¢n
      Q13647 MMS 30/06/21 Se saca el campo para mejorar las Retenciones.
      Q15406 MCM 05/10/21 - QRE - Se crean los campos QB_IRPFWithhType y QB_IRPFSpeciesYields
      CEI-15408-LCG-051021-INI Al cerrar, concatenar los c¢digos en WithHolding Filter.
    }*///end
}








