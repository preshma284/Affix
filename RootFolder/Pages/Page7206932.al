page 7206932 "QB Crear Efectos Cabecera"
{
Permissions=TableData 7000002=rimd;
    CaptionML=ESP='Cabecera de Creaci�n de Efectos';
    SourceTable=7206922;
    PageType=Document;
    
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
    field("OrdenPago";rec."OrdenPago")
    {
        
                
                          ;trigger OnLookup(var Text: Text): Boolean    BEGIN
                           IF PaymentOrder.GET(rec.OrdenPago) THEN BEGIN
                             CLEAR(pgPaymentOrder);
                             pgPaymentOrder.SETRECORD(PaymentOrder);
                             pgPaymentOrder.RUNMODAL;
                           END;
                         END;


    }
    field("Fichero";rec."Fichero")
    {
        
                
                          ;trigger OnLookup(var Text: Text): Boolean    BEGIN
                           HYPERLINK(rec.Fichero);
                         END;


    }
group("group27")
{
        
                CaptionML=ESP='Banco';
    field("Bank Account No.";rec."Bank Account No.")
    {
        
    }
    field("Bank Account Name";rec."Bank Account Name")
    {
        
                Visible=false ;
    }
    field("Currency Code";rec."Currency Code")
    {
        
                Visible=false ;
    }
    field("Bank Payment Type";rec."Bank Payment Type")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             Activar;
                           END;


    }
    field("Report";rec."Report")
    {
        
                Enabled=actPagare ;
    }
    field("Agrupar";rec."Agrupar")
    {
        
                ToolTipML=ESP='Si marca esta opci�n se crear�n pagar�s para cada proveedor agrupando los que tengan la misma fecha de vencimiento';
                Enabled=actAgrupar ;
    }
    field("Confirming";rec."Confirming")
    {
        
                Visible=false;
                Enabled=actConfirming ;
    }

}

}
    part("Lineas";7206933)
    {
        
                SubPageView=SORTING("Relacion No.","Line No.");SubPageLink="Relacion No."=FIELD("Relacion No.");
                Enabled=actLineas;
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
    action("CreateVendorBills")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='Create Vendor Bills',ESP='Proponer L�neas';
                      ToolTipML=ENU='Create bills from vendor invoices.',ESP='Crear efectos a partir de las facturas de los proveedores.';
                      ApplicationArea=Basic,Suite;
                      Enabled=actCrear;
                      Image=SuggestVendorBills;
                      
                                trigger OnAction()    VAR
                                //  Generar : Report 7207432;
                               BEGIN
                                 BankAccount.GET(rec."Bank Account No.");
                                //  CLEAR(Generar);
                                //  Generar.SetDatos(rec."Relacion No.", rec."Posting Date", BankAccount."Currency Code", FALSE);
                                //  Generar.RUNMODAL;
                                 CurrPage.UPDATE(FALSE);
                               END;


    }
    action("InsertBills")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='Create Vendor Bills',ESP='Insertar Efectos';
                      ToolTipML=ENU='Create bills from vendor invoices.',ESP='Crear efectos a partir de las facturas de los proveedores.';
                      ApplicationArea=Basic,Suite;
                      Visible=FALSE;
                      Enabled=actCrear;
                      Image=SuggestVendorBills;
                      
                                trigger OnAction()    VAR
                                //  Generar : Report 7207432;
                               BEGIN
                                 BankAccount.GET(rec."Bank Account No.");
                                //  CLEAR(Generar);
                                //  Generar.SetDatos(rec."Relacion No.", rec."Posting Date", BankAccount."Currency Code", TRUE);
                                //  Generar.RUNMODAL;
                                 CurrPage.UPDATE(FALSE);
                               END;


    }
    action("PagoAnticipado")
    {
        
                      Ellipsis=true;
                      CaptionML=ESP='Pago Anticipado';
                      ToolTipML=ESP='Crear efecto para el pago anticipado a un proveedor';
                      ApplicationArea=Basic,Suite;
                      Enabled=actCrear;
                      Image=SuggestVendorPayments;
                      
                                trigger OnAction()    VAR
                                //  Generar : Report 7207435;
                               BEGIN
                                //  CLEAR(Generar);
                                //  Generar.SetRelacion(Rec."Relacion No.");
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
                      Enabled=actRegistro;
                      Image=PostOrder;
                      
                                trigger OnAction()    BEGIN
                                 Registrar;
                                 MESSAGE(Text008);
                                 CurrPage.UPDATE(FALSE);
                               END;


    }
    action("OrdenPago_")
    {
        
                      CaptionML=ESP='Crear Orden Pago';
                      ToolTipML=ESP='Registrar el diario y crear pagar�s de los movimientos de tipo efecto';
                      Enabled=actOrden;
                      Image=PostedDeposit;
                      
                                trigger OnAction()    BEGIN
                                 RegistrarOrdenPago;
                                 CurrPage.UPDATE(FALSE);
                               END;


    }

}
group("group8")
{
        CaptionML=ENU='Electronic Payments',ESP='Pagar�s';
                      Image=Payment ;
    action("CheckPrint")
    {
        
                      AccessByPermission=TableData 272=R;
                      Ellipsis=true;
                      CaptionML=ENU='Print Check',ESP='Imprimir Pagar�s';
                      ToolTipML=ENU='Prepare to print the check.',ESP='Prepara el cheque para imprimir.';
                      ApplicationArea=Basic,Suite;
                      Enabled=actPagare;
                      Image=PrintCheck;
                      
                                trigger OnAction()    BEGIN
                                 QBFuncionesPagos.ImprimirPagares(Rec,'');
                               END;


    }
    action("PrintCarta")
    {
        
                      AccessByPermission=TableData 272=R;
                      Ellipsis=true;
                      CaptionML=ENU='Print Check',ESP='Imprimir Carta';
                      ToolTipML=ENU='Prepare to print the check.',ESP='Prepara el cheque para imprimir.';
                      ApplicationArea=Basic,Suite;
                      Enabled=actPagare;
                      Image=PrintCheck;
                      
                                trigger OnAction()    BEGIN
                                 QBFuncionesPagos.ImprimirCarta(Rec, '');
                               END;


    }
    action("CheckCancel")
    {
        
                      CaptionML=ENU='Void Check',ESP='Anular Pagar�';
                      ToolTipML=ENU='Void the check if, for example, the check is not cashed by the bank.',ESP='Permite anular el cheque si, por ejemplo, el banco no lo cobra.';
                      ApplicationArea=Basic,Suite;
                      Enabled=actPagare;
                      Image=VoidCheck;
                      
                                trigger OnAction()    BEGIN
                                 CurrPage.Lineas.PAGE.GETRECORD(Lineas);
                                 IF (Lineas."No. Pagare" <> '') THEN
                                   IF CONFIRM(Text000,FALSE,Lineas."No. Pagare") THEN
                                     QBFuncionesPagos.AnularPagare(Lineas);
                               END;


    }
    action("CheckCancelAll")
    {
        
                      CaptionML=ENU='Void &All Checks',ESP='Anular t&odos los Pagar�s';
                      ToolTipML=ENU='Void all checks if, for example, the checks are not cashed by the bank.',ESP='Permite anular todos los cheques si, por ejemplo, el banco no los cobra.';
                      ApplicationArea=Basic,Suite;
                      Enabled=actPagare;
                      Image=VoidAllChecks;
                      
                                trigger OnAction()    BEGIN
                                 IF CONFIRM(Text001,FALSE) THEN BEGIN
                                   Lineas.RESET;
                                   Lineas.SETRANGE("Relacion No.", rec."Relacion No.");
                                   Lineas.SETFILTER("No. Pagare",'<>%1','');
                                   IF Lineas.FINDSET THEN
                                     REPEAT
                                       QBFuncionesPagos.AnularPagare(Lineas);
                                     UNTIL Lineas.NEXT = 0;
                                 END;
                               END;


    }
    action("CheckVer")
    {
        
                      CaptionML=ESP='Ver Pagar�s';
                      RunObject=Page 374;
                      RunPageView=SORTING("Entry No.");
RunPageLink="Payment Relation"=FIELD("Relacion No.");
                      Enabled=actPagare;
                      Image=CheckJournal;
    }

}
group("group14")
{
        CaptionML=ENU='Electronic Payments',ESP='Norma 67';
                      Image=ElectronicPayment ;
    action("N67")
    {
        
                      CaptionML=ESP='Generar N67';
                      ToolTipML=ESP='Exporta un archivo con la informaci�n de pagar�s de las l�neas en formato de la Norma 67.';
                      ApplicationArea=Basic,Suite;
                      Enabled=actElectronico;
                      Image=Export;
                      
                                trigger OnAction()    VAR
                                //  rpExportN67 : Report 7207434;
                                 Generar : Boolean;
                               BEGIN
                                 //Generar si todas las l�neas tienen un n�mero de pagar� asociado
                                 Lineas.RESET;
                                 Lineas.SETRANGE("Relacion No.", rec."Relacion No.");
                                 Lineas.SETFILTER("No. Pagare", '=%1','');
                                 IF NOT Lineas.ISEMPTY THEN
                                   ERROR(Text003);

                                 //Generar si no se ha generado antes
                                 Lineas.RESET;
                                 Lineas.SETRANGE("Relacion No.", rec."Relacion No.");
                                 Lineas.SETRANGE("Exported to Payment File", TRUE);
                                 IF Lineas.ISEMPTY THEN
                                   Generar := TRUE
                                 ELSE
                                   Generar := CONFIRM(Text004, FALSE);

                                 IF Generar THEN BEGIN
                                  //  CLEAR(rpExportN67);
                                  //  rpExportN67.SetFiltros(Rec."Relacion No.");
                                  //  rpExportN67.RUNMODAL;
                                 END;
                               END;


    }
    action("AnularN67")
    {
        
                      CaptionML=ESP='Anular N67';
                      ToolTipML=ESP='Anula la marca de exportado a N67 e intenta eliminar el fichero generado.';
                      ApplicationArea=Basic,Suite;
                      Enabled=actElectronicoAnular;
                      Image=CancelledEntries;
                      
                                trigger OnAction()    VAR
                                //  rpExportN67 : Report 7207434;
                                 Generar : Boolean;
                               BEGIN
                                 IF (rec.Fichero <> '') THEN BEGIN
                                   IF CONFIRM(Text007, TRUE) THEN BEGIN
                                     Lineas.RESET;
                                     Lineas.SETRANGE("Relacion No.", rec."Relacion No.");
                                     Lineas.SETRANGE("Exported to Payment File", TRUE);
                                     Lineas.MODIFYALL("Exported to Payment File", FALSE);

                                     IF EXISTS(rec.Fichero) THEN
                                       ERASE(rec.Fichero);

                                     rec.Fichero := '';
                                     Rec.MODIFY;
                                   END;
                                 END;

                                 CurrPage.UPDATE(FALSE);
                               END;


    }

}
group("group17")
{
        CaptionML=ENU='Electronic Payments',ESP='Pagos electr�nicos';
                      Visible=false;
                      Image=ElectronicPayment ;
    action("AgruparEfectos")
    {
        
                      CaptionML=ESP='Agrupar Efectos';
                      Enabled=actAgruparEfectos;
                      Image=CreateElectronicReminder;
                      
                                trigger OnAction()    BEGIN
                                 AgruparEfectos_;
                               END;


    }
    action("GenerarPagoElec")
    {
                      Visible=false;
                      Image=ExportElectronicDocument;
                      
                                trigger OnAction()    BEGIN
                                 GenPE;
                               END;


    }
    action("AnularPagoElec")
    {
        
                      CaptionML=ESP='Anular Pago Electr�nico';
                      Visible=false;
                      Image=CancelFALedgerEntries;
                      
                                
    trigger OnAction()    BEGIN
                                 CanPE;
                               END;


    }

}

}
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ESP = 'Nuevo';
            }
            group(Category_Process)
            {
                CaptionML = ESP = 'Procesar';

                actionref(CreateVendorBills_Promoted; CreateVendorBills)
                {
                }
                actionref(InsertBills_Promoted; InsertBills)
                {
                }
                actionref(PagoAnticipado_Promoted; PagoAnticipado)
                {
                }
                actionref(Post_Promoted; Post)
                {
                }
                actionref(OrdenPago__Promoted; OrdenPago_)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ESP = 'Imprimir';
            }
            group(Category_Category4)
            {
                CaptionML = ESP = 'Crear';
            }
            group(Category_Category5)
            {
                CaptionML = ESP = 'Pagar�s';

                actionref(CheckPrint_Promoted; CheckPrint)
                {
                }
                actionref(PrintCarta_Promoted; PrintCarta)
                {
                }
                actionref(CheckCancel_Promoted; CheckCancel)
                {
                }
                actionref(CheckCancelAll_Promoted; CheckCancelAll)
                {
                }
                actionref(CheckVer_Promoted; CheckVer)
                {
                }
            }
            group(Category_Category6)
            {
                CaptionML = ESP = 'Pagos Electr�nicos';

                actionref(AgruparEfectos_Promoted; AgruparEfectos)
                {
                }
                actionref(GenerarPagoElec_Promoted; GenerarPagoElec)
                {
                }
                actionref(AnularPagoElec_Promoted; AnularPagoElec)
                {
                }
                actionref(N67_Promoted; N67)
                {
                }
                actionref(AnularN67_Promoted; AnularN67)
                {
                }
            }
        }
}
  trigger OnOpenPage()    BEGIN
                 FunctionQB.OpenPagePaymentRelations;
                 Activar;
               END;

trigger OnAfterGetRecord()    BEGIN
                       Activar;
                     END;



    var
      FunctionQB : Codeunit 7207272;
      BankAccount : Record 270;
      Lineas : Record 7206923;
      PaymentOrder : Record 7000020;
      pgPaymentOrder : Page 7000050;
      QBFuncionesPagos : Codeunit 7206922;
      actCrear : Boolean ;
      actPagare : Boolean ;
      actElectronico : Boolean ;
      actElectronicoAnular : Boolean ;
      actRegistro : Boolean ;
      Text000 : TextConst ESP='Confirme que desea cancelar el pagar� %1';
      Text001 : TextConst ESP='Confirme que desea cancelar todos los pagar�s impresos';
      actOrden : Boolean ;
      Text002 : TextConst ESP='Confirme que desea generar los efectos de la presente relaci�n';
      Text003 : TextConst ESP='No ha generado pagar�s para todas las l�neas';
      Text004 : TextConst ESP='Ya ha generado el pago electr�nico, �desea volver a generarlo?\Reemplazar� al fichero anteriormente generado';
      Text005 : TextConst ESP='No ha indicado la fecha de registro';
      Text006 : TextConst ESP='No ha seleccionado el tipo de pago';
      actLineas : Boolean ;
      actAgrupar : Boolean;
      actAgruparEfectos : Boolean;
      actConfirming : Boolean;
      Text007 : TextConst ESP='Confirme que desea cancelar el pago electr�nico';
      Text008 : TextConst ESP='Proceso finalizado';

    LOCAL procedure Activar();
    begin
      actCrear             := (not rec.Registrada);
      actPagare            := (not rec.Registrada) and (rec."Bank Payment Type" = rec."Bank Payment Type"::"Computer Check");
      actElectronico       := (not rec.Registrada) and (rec."Bank Payment Type" = rec."Bank Payment Type"::"Computer Check");
      actElectronicoAnular := (not rec.Registrada) and (rec.Fichero <> '');
      actRegistro          := (not rec.Registrada) and (rec."Bank Payment Type" IN [rec."Bank Payment Type"::"Computer Check", rec."Bank Payment Type"::"Manual Check"]);
      actOrden             := (not rec.Registrada) and (rec."Bank Payment Type" IN [rec."Bank Payment Type"::OrdenPago]);
      actLineas            := (rec."Bank Payment Type" <> rec."Bank Payment Type"::" ");
      actAgrupar           := (rec."Bank Payment Type" <> rec."Bank Payment Type"::" ");
      actConfirming        := (rec."Bank Payment Type" = rec."Bank Payment Type"::OrdenPago);
      actAgruparEfectos    := (not rec.Registrada) and (rec."Bank Payment Type" = rec."Bank Payment Type"::OrdenPago);
      CurrPage.EDITABLE(not rec.Registrada);
    end;

    LOCAL procedure Registrar();
    begin
      //Ver que todo sea correcto
      rec.VerificarErrores;

      //Registrar
      if not rec.Registrada then begin
        if CONFIRM(Text002,FALSE) then begin
          QBFuncionesPagos.RegistrarRelacion(Rec);
          Rec.GET(rec."Relacion No.");
        end;
      end;
    end;

    LOCAL procedure RegistrarOrdenPago();
    begin
      //Registrar
      if not rec.Registrada then
        Registrar;

      //Crear Orden de Pago si no existe
      if (rec.Registrada) and (rec.OrdenPago = '') then
        QBFuncionesPagos.CrearOrdenPago(rec."Relacion No.");
    end;

    LOCAL procedure GenPE();
    begin
    end;

    LOCAL procedure CanPE();
    begin
    end;

    LOCAL procedure AgruparEfectos_();
    begin
      QBFuncionesPagos.AgruparEfectos(rec."Relacion No.", rec.Agrupar);
    end;

    // begin//end
}








