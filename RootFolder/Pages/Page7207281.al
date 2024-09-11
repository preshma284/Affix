page 7207281 "QB Prepayment Edit"
{
CaptionML=ENU='Prepayment',ESP='Anticipo';
    PageType=Document;
    
  layout
{
area(content)
{
group("ToApply")
{
        
                CaptionML=ENU='To Apply',ESP='Datos';
group("C_GProyecto")
{
        
                CaptionML=ENU='Job',ESP='Proyecto';
    field("C_Proyecto";Job."No.")
    {
        
                CaptionML=ENU='Job No.',ESP='N� proyecto';
                Editable=false ;
    }
    field("C_Descripcion";Job.Description)
    {
        
                CaptionML=ENU='Job Description',ESP='Descripci�n proyecto';
                Editable=false ;
    }

}
group("C_GCliente")
{
        
                CaptionML=ENU='Customer',ESP='Cliente';
                Visible=ShowCustomer;
    field("C_Cliente";Customer."No.")
    {
        
                CaptionML=ENU='Customer',ESP='Cliente';
                TableRelation=Customer;
                Editable=false;
                
                            ;trigger OnValidate()    BEGIN
                             Customer.GET(CustomerNo);
                           END;


    }
    field("C_Nombre";Customer.Name)
    {
        
                CaptionML=ENU='Name',ESP='Nombre';
                Editable=false ;
    }

}
group("C_VendorAcc")
{
        
                CaptionML=ENU='Vendor',ESP='Proveedor';
                Visible=ShowVendor;
    field("C_Vendor";Vendor."No.")
    {
        
                CaptionML=ENU='Vendor',ESP='Proveedor';
                TableRelation=Vendor;
                Editable=false;
                
                            ;trigger OnValidate()    BEGIN
                             Vendor.GET(VendorNo);
                           END;


    }
    field("C_VendorName2";Vendor.Name)
    {
        
                CaptionML=ENU='Name',ESP='Nombre';
                Editable=FALSE ;
    }

}
group("R_Data")
{
        
                CaptionML=ENU='Post Data',ESP='Datos del Registro';
    field("R_Type";PrepmtType)
    {
        
                CaptionML=ESP='Tipo de Documento';
                Visible=vPost;
                Editable=False ;
    }
    field("R_Amount";PrepmtAmount)
    {
        
                CaptionML=ENU='Amount to apply',ESP='Importe a aplicar';
                Visible=vPost;
                Editable=false ;
    }
    field("R_PostingDate";PostingDate)
    {
        
                CaptionML=ESP='Fecha de Registro';
                
                            ;trigger OnValidate()    BEGIN
                             //DocumentDate := PostingDate; //Q18899
                             CalcDueDate;
                           END;


    }
    field("R_DocumentDate";DocumentDate)
    {
        
                CaptionML=ESP='Fecha del Documento';
                Visible=vPost;
                
                            ;trigger OnValidate()    BEGIN
                             CalcDueDate;
                           END;


    }
    field("R_PaymentTerms";PTerms)
    {
        
                CaptionML=ESP='T�rminos de Pago';
                TableRelation="Payment Terms";
                Visible=vPost;
                
                            ;trigger OnValidate()    BEGIN
                             CalcDueDate;
                           END;


    }
    field("R_DueDate";DueDate)
    {
        
                CaptionML=ESP='Fecha de Vencimiento';
                Visible=vPost;
                
                            ;trigger OnValidate()    BEGIN
                             ValidateDueDate;
                           END;


    }

}

}
    part("Lines";7207280)
    {
        
                SubPageView=SORTING("Register No.");
                Visible=seeLines;
    }

}
}
  trigger OnOpenPage()    BEGIN
                 //Q12879 -
                 CASE AccountType OF
                   QBP."Account Type"::Customer:
                     BEGIN
                       ShowCustomer := TRUE;
                       ShowVendor := FALSE;
                     END;
                   QBP."Account Type"::Vendor:
                     BEGIN
                       ShowVendor := TRUE;
                       ShowCustomer := FALSE;
                     END;
                 END;
                 //Q12879 +
               END;

trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       IF (CloseAction = ACTION::LookupOK) THEN BEGIN
                         IF (vPost) THEN BEGIN
                           IF PostingDate = 0D THEN
                             ERROR(Txt002);
                         END;

                         IF (vAplicar) THEN BEGIN
                           //++IF (PrepmtAmount > BaseAmount) THEN
                           //++  ERROR(Txt003);

                           //Mirar el �ltimo tipo
                       //    QBPrepayment.RESET;
                       //    QBPrepayment.SETRANGE("Job No.", Job."No.");
                       //    CASE AccountType OF
                       //      QBP."Account Type"::Customer :
                       //        BEGIN
                       //          QBPrepayment.SETRANGE("Account Type", QBP."Account Type"::Customer);
                       //          QBPrepayment.SETRANGE("Account No.", CustomerNo);
                       //        END;
                       //      QBP."Account Type"::Vendor :
                       //        BEGIN
                       //          QBPrepayment.SETRANGE("Account Type", QBP."Account Type"::Vendor);
                       //          QBPrepayment.SETRANGE("Account No.", VendorNo);
                       //        END;
                       //    END;
                       //    QBPrepayment.SETFILTER("Entry Type", '%1|%2', QBP."Entry Type"::Invoice, QBP."Entry Type"::Bill);
                       //
                       //    QBPrepayment.CALCSUMS(Amount);
                       //    IF (QBPrepayment.Amount <> 0) THEN BEGIN
                       //      IF QBPrepayment.FINDLAST THEN
                       //        CASE DocumentType OF
                       //          QBP."Entry Type"::Invoice :
                       //            IF (QBPrepayment."Entry Type" <> QBP."Entry Type"::Invoice) THEN
                       //              ERROR(Txt006);
                       //          QBP."Entry Type"::Bill :
                       //            IF (QBPrepayment."Entry Type" <> QBP."Entry Type"::Bill) THEN
                       //              ERROR(Txt006);
                       //        END;
                       //    END;
                         END;
                       END;
                     END;



    var
      QuoBuildingSetup : Record 7207278;
      QBP : Record 7206928;
      QBJobPrepaymentList : Page 7207031;
      vPost : Boolean;
      vAplicar : Boolean;
      vCancelar : Boolean;
      ShowCustomer : Boolean;
      ShowVendor : Boolean;
      CurrencyCode : Code

[10];
      CustomerNo : Code[20];
      VendorNo : Code[20];
      AccountType : Option;
      DocumentType : Option;
      seeLines : Boolean;
      "---------------------------- Comunes" : Integer;
      Job : Record 167;
      Customer : Record 18;
      Vendor : Record 23;
      PrepmtAmount : Decimal;
      "---------------------------- Aplicar/Cancelar" : Integer;
      EntryNo : Integer;
      EntryDocNo : Text;
      BAmount : Decimal;
      TAmount : Decimal;
      "---------------------------- Registrar" : Integer;
      Txt000c : TextConst ESP='Debe indicar un cliente v�lido';
      Txt000p : TextConst ESP='Debe indicar un proveedor v�lido';
      Txt001 : TextConst ESP='Debe indicar un importe v�lido';
      Txt002 : TextConst ESP='Debe indicar una fecha v�lida';
      Txt003 : TextConst ESP='El importe supera al pendiente';
      Txt004 : TextConst ESP='El importe no puede ser negativo';
      Txt006 : TextConst ESP='No puede usar ese tipo de documento ya que es diferente al �ltimo que us�.';
      Txt010 : TextConst ESP='Anticipo a cuenta';
      Txt011 : TextConst ESP='%1% sobre %2 para el proyecto %3';
      Txt012 : TextConst ESP='Sobre %2 para el proyecto %3';
      Txt013 : TextConst ESP='Anticipo del %1% para el proyecto %3';
      Txt014 : TextConst ESP='Para el proyecto %3';
      Txt017 : TextConst ESP='Anticipo %1 proyecto %2';
      Txt020 : TextConst ESP='Liq. %1% del anticipo pendiente de %2';
      Txt021 : TextConst ESP='Liq.Parcial anticipo pendiente de %2';
      Txt022 : TextConst ESP='Liquidaci�n completa del anticipo pendiente';
      PrepmtType : Text;
      PostingDate : Date;
      DocumentDate : Date;
      DueDate : Date;
      PTerms : Code[10];
      Txt031 : TextConst ESP='Cancelaci�n parcial anticipo %1, pte. %2';
      Txt032 : TextConst ESP='Cancelaci�n del anticipo %1';

    LOCAL procedure CalcDueDate();
    var
      PaymentTerms : Record 3;
      DueDateAdjust : Codeunit 10700;
    begin
      //JAV 20/04/22: - QB 1.10.36 Se a�ade la fecha del documento y la de vencimiento con su validaci�n
      PaymentTerms.INIT;
      if (PTerms <> '') and (DocumentDate <> 0D) then begin
        PaymentTerms.GET(PTerms);
        DueDate := CALCDATE(PaymentTerms."Due Date Calculation",DocumentDate);
        //Q19090-
        if AccountType = QBP."Account Type"::Customer then
          DueDateAdjust.SalesAdjustDueDate(DueDate,DocumentDate,PaymentTerms.CalculateMaxDueDate(DocumentDate), CustomerNo + VendorNo)
        ELSE
        //Q19090+
          DueDateAdjust.PurchAdjustDueDate(DueDate,DocumentDate,PaymentTerms.CalculateMaxDueDate(DocumentDate), CustomerNo + VendorNo);
      end ELSE begin
        DueDate := DocumentDate;
      end;

      ValidateDueDate;
    end;

    LOCAL procedure ValidateDueDate();
    var
      PaymentTerms : Record 3;
      DueDateAdjust : Codeunit 10700;
    begin
      //JAV 20/04/22: - QB 1.10.36 Se a�ade la fecha del documento y la de vencimiento con su validaci�n
      if PaymentTerms.GET(PTerms) then
        PaymentTerms.VerifyMaxNoDaysTillDueDate(DueDate,DocumentDate,'Fecha Vto.');
    end;

    LOCAL procedure "--------------------------- Datos registro"();
    begin
    end;

    procedure SetPost(pJobNo : Code[20];pAccountType : Option;pAccountNo : Code[20];pDocType : Text;pAmount : Decimal;pPaymentTerms : Code[10];pDocumentDate : Date;pPostingDate : Date);
    begin
      vPost := TRUE;
      vAplicar := FALSE;
      vCancelar := FALSE;
      seeLines := FALSE;
      Job.GET(pJobNo);
      PrepmtAmount := pAmount;
      PrepmtType := pDocType;
      PTerms := pPaymentTerms;  //JAV 20/04/22: - QB 1.10.36 Se incluye el t�rmino de pago para el c�lculo del vto.
      //Q18899-
      PostingDate := pPostingDate;
      DocumentDate := pDocumentDate;
      //Q18899+

      AccountType := pAccountType;
      CASE AccountType OF
        QBP."Account Type"::Customer :
          begin
            CustomerNo := pAccountNo;
            VendorNo := '';
            Customer.GET(CustomerNo);
          end;
        QBP."Account Type"::Vendor :
          begin
            CustomerNo := '';
            VendorNo := pAccountNo;
            Vendor.GET(VendorNo);
          end;
      end;
      //Q18899-
      if pPostingDate <> 0D then
        PostingDate := pPostingDate
      ELSE
      //Q18899+
        PostingDate := WORKDATE;

      //Q18899-
      if pDocumentDate <> 0D then
        DocumentDate := pDocumentDate
      ELSE
      //Q18899+
        DocumentDate := PostingDate;

      CalcDueDate;
    end;

    procedure GetPost(var pPostingDate : Date;var pDocumentDate : Date;var pPaymentTerms : Code[10];var pDueDate : Date);
    begin
      pPostingDate := PostingDate;
      pDocumentDate := DocumentDate;
      pPaymentTerms := PTerms;
      pDueDate := DueDate;
    end;

    LOCAL procedure "--------------------------- Datos Aplicación"();
    begin
    end;

    procedure SetAplicacion(pRecNo : Integer;JobNo : Code[20];pAccountType : Option;AccNo : Code[20];CurrencyCode : Code[10]);
    var
      TAmount : Decimal;
      Rec : Record 7206928;
    begin
      CurrPage.Lines.PAGE.SetData(pRecNo, JobNo , pAccountType, AccNo, TRUE);
      CurrPage.Lines.PAGE.GetAmounts(BAmount, TAmount);

      if (BAmount = 0) then
        ERROR('Nada pendiente sobre lo que aplicar');

      AccountType := pAccountType;
      vPost := FALSE;
      vAplicar := TRUE;
      vCancelar := FALSE;
      seeLines := TRUE;
      Job.GET(JobNo);

      //Q12879 -
      CASE AccountType OF
        QBP."Account Type"::Customer :
          begin
            CustomerNo := AccNo;
            Customer.GET(AccNo);
          end;
        QBP."Account Type"::Vendor :
          begin
            VendorNo := AccNo;
            Vendor.GET(AccNo);
          end;
      end;
      //Q12879 +
    end;

    procedure GetApplication(var EntryData : Integer;var BaseAmt : Decimal;var ApplyAmt : Decimal;var Type : Option);
    begin
      CurrPage.Lines.PAGE.GetAmounts(BaseAmt, ApplyAmt);
      CurrPage.Lines.PAGE.GetData(EntryData, Type);
    end;

    LOCAL procedure "--------------------------- Datos Cancelación"();
    begin
    end;

    procedure SetCancel(Rec : Record 7206928);
    begin
      CurrPage.Lines.PAGE.SetData(0, Rec."Job No.", Rec."Account Type", Rec."Account No.", FALSE);
      CurrPage.Lines.PAGE.GetAmounts(BAmount, TAmount);

      if (BAmount = 0) then
        ERROR('Nada pendiente sobre lo que aplicar');

      DocumentType := Rec."Entry Type";
      AccountType := Rec."Account Type";  //JAV 29/06/22: - QB 1.10.57 apuntaba a Entry Type en lugar de Account Type
      vPost := FALSE;
      vAplicar := FALSE;
      vCancelar := TRUE;
      seeLines := TRUE;
      Job.GET(rec."Job No.");

      //Q12879 -
      CASE AccountType OF
        QBP."Account Type"::Customer :
          begin
            CustomerNo := Rec."Account No.";
            Customer.GET(rec."Account No.");
          end;
        QBP."Account Type"::Vendor :
          begin
            VendorNo := Rec."Account No.";
            Vendor.GET(rec."Account No.");
          end;
      end;
      //Q12879 +

      //JAV 29/06/22: - QB 1.10.57 Anulaciones, a�adimos la fecha de cancelaci�n
      PostingDate  := WORKDATE;
    end;

    procedure GetCancel(var pEntryData : Integer;var pPostingDate : Date);
    var
      Type : Option;
    begin
      CurrPage.Lines.PAGE.GetData(pEntryData, Type);
      pPostingDate := PostingDate;
    end;

    // begin
    /*{
      JDC 26/02/21 - Q12879 Modified function "OnOpenPage", "AccountNo - OnValidate", "SetJob", "SetAplicacion"
      JDC 07/05/21 - Q13154 Modified function "GetData"
                            Modified PageLayout adding "SourceType"
      JAV 28/03/22: - QB 1.10.29 Modificacines para el tratamiento del anticipo sin factura, se a�ade la acci�n para la vista previa
      JAV 20/04/22: - QB 1.10.36 Se incluye el t�rmino de pago para el c�lculo del vto. Se a�ade la fecha del documento y la de vencimiento con su validaci�n
      JAV 29/06/22: - QB 1.10.57 PAra cancelar anticipos se presentan las fechas tambi�n
      PSM 13/02/23: - Q18899 Se incluyen las fechas de documento y registro del anticipo en la funci�n SetPost
      PSM 28/02/23: - Q19090 Llamar a la funci�n SalesAdjustDueDate cuando sea un anticipo de cliente
    }*///end
}







