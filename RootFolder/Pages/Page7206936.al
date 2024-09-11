page 7206936 "QB Liq. Efectos Cabecera"
{
CaptionML=ESP='Cabecera de Liquidaci�n de Efectos';
    SourceTable=7206924;
    PageType=Document;
    PromotedActionCategoriesML=ESP='Nuevo,Procesar,Imprimir,Crear,Pagar�s,Pagos Electr�nicos';
    
  layout
{
area(content)
{
group("General")
{
        
    field("Relacion No.";rec."Relacion No.")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }

}
    part("Lineas";7206937)
    {
        
                SubPageView=SORTING("Relacion No.","Line No.");SubPageLink="Relacion No."=FIELD("Relacion No.");
                UpdatePropagation=Both 

  ;
    }

}
}actions
{
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='P&osting',ESP='&Procesar';
                      Image=Post ;
    action("Proponer")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='Create Vendor Bills',ESP='Proponer Liquidaci�n';
                      ToolTipML=ENU='Create bills from vendor invoices.',ESP='Crear efectos a partir de las facturas de los proveedores.';
                      ApplicationArea=Basic,Suite;
                      Promoted=true;
                      Enabled=actRegistro;
                      PromotedIsBig=true;
                      Image=SuggestVendorBills;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                //  Generar : Report 7207436;
                               BEGIN
                                //  CLEAR(Generar);
                                //  Generar.SetDatos(rec."Relacion No.", rec."Posting Date");
                                //  Generar.RUNMODAL;
                                 CurrPage.UPDATE(FALSE);
                               END;


    }
    action("Post")
    {
        
                      ShortCutKey='F9';
                      CaptionML=ENU='P&ost',ESP='Registrar';
                      ToolTipML=ENU='Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.',ESP='Finaliza el documento o el diario registrando los importes y las cantidades en las cuentas relacionadas de los libros de su empresa.';
                      ApplicationArea=Basic,Suite;
                      Promoted=true;
                      Enabled=actRegistro;
                      PromotedIsBig=true;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      
                                
    trigger OnAction()    BEGIN
                                 IF (rec."Posting Date" = 0D) THEN
                                   ERROR(Text005);

                                 IF (rec.HayErrores) THEN
                                   ERROR(Text000);

                                 //Registrar
                                 IF NOT rec.Registrado THEN BEGIN
                                   QBFuncionesLiquidacion.RegistrarRelacionPagos(rec."Relacion No.");
                                   COMMIT;
                                   MESSAGE(Text008);
                                 END;
                               END;


    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 FunctionQB.OpenPagePaymentRelations;
                 Activar;
               END;



    var
      FunctionQB : Codeunit 7207272;
      BankAccount : Record 270;
      Lineas : Record 7206925;
      PaymentOrder : Record 7000020;
      pgPaymentOrder : Page 7000050;
      QBFuncionesLiquidacion : Codeunit 7206923;
      actCrear : Boolean ;
      actPagare : Boolean ;
      actElectronico : Boolean ;
      actElectronicoAnular : Boolean ;
      actRegistro : Boolean ;
      actOrden : Boolean ;
      Text000 : TextConst ESP='Hay l�neas con errores, no puede registrar.';
      Text005 : TextConst ESP='No ha indicado fecha de registro.';
      Text008 : TextConst ESP='Proceso finalizado';

    LOCAL procedure Activar();
    begin
      actRegistro := (not rec.Registrado);

      CurrPage.EDITABLE(not rec.Registrado);
      CurrPage.UPDATE(TRUE);
    end;

    // begin//end
}








