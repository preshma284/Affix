report 7207436 "QB Liquidar Efectos"
{
  
  
    CaptionML=ENU='Suggest Vendor Payments',ESP='Proponer Liquidaci¢n de efectos';
    ProcessingOnly=true;
    
  dataset
{

DataItem("Vendor";"Vendor")
{

               DataItemTableView=SORTING("No.");
               

               RequestFilterFields="No.";
DataItem("Vendor Ledger Entry";"Vendor Ledger Entry")
{

               DataItemTableView=SORTING("Vendor No.","Open","Positive","Due Date","Currency Code")
                                 WHERE("Open"=CONST(true),"Positive"=CONST(false),"Document Situation"=FILTER(<>' '),"On Hold"=FILTER(=''));
               

               RequestFilterFields="Payment Method Code";
DataItemLink="Vendor No."= FIELD("No.") ;
trigger OnPreDataItem();
    BEGIN 
                               IF (varHastaFecha = 0D) THEN
                                 varHastaFecha := 99991231D;
                               SETRANGE("Due Date",varDesdeFecha,varHastaFecha);

                               IF (varMetodoPago <> '') THEN
                                 SETRANGE("Payment Method Code", varMetodoPago);

                               //Si  incluyo documentos en cartera van todos, si no filtro que est‚n en ordenes de pago £nicamente
                               IF (NOT varEnCartera) THEN
                                 SETFILTER("Document Situation",'%1|%2',"Vendor Ledger Entry"."Document Situation"::"Posted BG/PO","Vendor Ledger Entry"."Document Situation"::"Closed BG/PO");
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  //Si no tiene Importe a convertir me lo salto
                                  "Vendor Ledger Entry".CALCFIELDS("Remaining Amount");
                                  IF "Vendor Ledger Entry"."Remaining Amount" = 0 THEN
                                    CurrReport.SKIP;

                                  //Si ya est  en el registro me lo salto
                                  recLineas.RESET;
                                  recLineas.SETRANGE("Document Type", "Document Type");
                                  recLineas.SETRANGE("Document No.", "Document No.");
                                  recLineas.SETRANGE("Bill No.", "Bill No.");
                                  IF (NOT recLineas.ISEMPTY) THEN
                                    CurrReport.SKIP;

                                  //Relleno el diario
                                  NextLineNo += 10000;
                                  recLineas.INIT;
                                  recLineas."Relacion No." := NroRelacion;
                                  recLineas."Line No." := NextLineNo;
                                  recLineas.VALIDATE("No. Mov. Proveedor", "Vendor Ledger Entry"."Entry No.");

                                  //Si filtro por banco seleccionado lo hago aqu¡ pues ya he ubicado el banco en la l¡nea, as¡ no lo busco de otra forma
                                  IF (varBankAccount = '') OR (recLineas."Bank Account No." = varBankAccount) THEN
                                    recLineas.INSERT;
                                END;


}
trigger OnPreDataItem();
    BEGIN 
                               //Saltarse proveedores bloqueados
                               SETRANGE(Blocked, Vendor.Blocked::" ");
                               Window.OPEN(Text000);
                               mRec := COUNT+1;
                               nRec := 0;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  nRec += 1;
                                  Window.UPDATE(1,ROUND(nRec*10000/mRec,1));
                                END;

trigger OnPostDataItem();
    BEGIN 
                                Window.CLOSE;
                              END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group897")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';
group("group898")
{
        
                  CaptionML=ENU='Options',ESP='Registro';
    field("varFechaRegistro";"varFechaRegistro")
    {
        
                  CaptionML=ENU='Posting Date',ESP='Fecha de registro';
                  ToolTipML=ENU='Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.',ESP='Especifica la fecha de registro de este proceso. La fecha de trabajo se introduce de forma predeterminada, pero es posible cambiarla.';
                  Editable=false ;
    }

}
group("group900")
{
        
                  CaptionML=ENU='Options',ESP='Filtros';
    field("varBankAccount";"varBankAccount")
    {
        
                  CaptionML=ESP='Banco';
                  TableRelation="Bank Account" ;
    }
    field("varDesdeFecha";"varDesdeFecha")
    {
        
                  CaptionML=ESP='Desde Fecha Vto.';
    }
    field("varHastaFecha";"varHastaFecha")
    {
        
                  CaptionML=ENU='Last Payment Date',ESP='Hasta Fecha Vto.';
                  ToolTipML=ENU='Specifies the latest payment date that can appear on the vendor ledger entries to be included in the batch job. Only entries that have a due date or a payment discount date before or on this date will be included. If the payment date is earlier than the system date, a warning will be displayed.',ESP='Especifica la £ltima fecha de vencimiento que puede aparecer en los movimientos de proveedor que se van a incluir en el proceso. Solo se incluir n los movimientos cuya fecha de vencimiento sean iguales o anteriores a esta fecha. Si la fecha de vencimiento es anterior a la del sistema, se mostrar  una advertencia.';
                  ApplicationArea=Basic,Suite;
    }
    field("varMetodoPago";"varMetodoPago")
    {
        
                  CaptionML=ESP='Forma de Pago';
                  ToolTipML=ESP='Este campo se usar  solo si no es posible establecer autom ticamente la forma de pago de los nuevos efectos creados.';
                  TableRelation="Payment Method" ;
    }
    field("varEnCartera";"varEnCartera")
    {
        
                  CaptionML=ESP='Incluir documentos en cartera';
    }

}

}

}
}
  }
  labels
{
}
  
    var
//       recLineas@7001116 :
      recLineas: Record 7206925;
//       BankAccount@7001102 :
      BankAccount: Record 270;
//       NextLineNo@7001181 :
      NextLineNo: Integer;
//       Window@7001134 :
      Window: Dialog;
//       Text000@7001173 :
      Text000: TextConst ENU='Procesing @1@@@@@@@@@@@@@@@@@@@@',ESP='Procesando @1@@@@@@@@@@@@@@@@@@@@';
//       Text001@7001167 :
      Text001: TextConst ENU='Starting Document No. must contain a number.',ESP='No ha indicado fecha de registro';
//       nRec@7001101 :
      nRec: Integer;
//       mRec@7001105 :
      mRec: Integer;
//       NroRelacion@7001115 :
      NroRelacion: Integer;
//       "--- Opciones de la Page -------------------------------------------"@7001127 :
      "--- Opciones de la Page -------------------------------------------": Integer;
//       varFechaRegistro@7001132 :
      varFechaRegistro: Date;
//       varDesdeFecha@1100286003 :
      varDesdeFecha: Date;
//       varHastaFecha@7001108 :
      varHastaFecha: Date;
//       varBankAccount@7001100 :
      varBankAccount: Code[20];
//       varMetodoPago@1100286000 :
      varMetodoPago: Code[20];
//       varEnCartera@1100286002 :
      varEnCartera: Boolean;

    

trigger OnInitReport();    begin
                   varFechaRegistro := WORKDATE;
                 end;

trigger OnPreReport();    begin
                  if varFechaRegistro = 0D then
                    ERROR(Text001);

                  //Buscar nro de l¡nea y serie de registro
                  recLineas.RESET;
                  recLineas.SETRANGE("Relacion No.", NroRelacion);
                  if recLineas.FINDLAST then
                    NextLineNo := recLineas."Line No."
                  else
                    NextLineNo := 0;
                end;



LOCAL procedure "-------------" ()
    begin
    end;

//     procedure SetDatos (parNro@1000 : Integer;parFecha@7001101 :
    procedure SetDatos (parNro: Integer;parFecha: Date)
    begin
      NroRelacion := parNro;
      varFechaRegistro := parFecha;
    end;

    /*begin
    end.
  */
  
}



// RequestFilterFields="Payment Method Code";
