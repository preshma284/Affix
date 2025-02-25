pageextension 50107 MyExtension10765 extends 10765//112
{
    layout
    {
        addfirst("Invoice Details")
        {
            group("QB_Datos")
            {

                CaptionML = ESP = 'Datos Generales';
                field("QB_WitholdingDueDate"; rec."QW Witholding Due Date")
                {

                    Editable = edDueDate;
                }
                field("QB_PaymentBankNo"; rec."Payment bank No.")
                {

                }
                field("External Document No."; rec."External Document No.")
                {

                }
                field("WorkDescription"; "WorkDescription")
                {

                    CaptionML = ENU = 'rec."Work Description"', ESP = 'Descripci¢n del trabajo';
                    MultiLine = true;
                }
            }
            group("QB_SII")
            {

                CaptionML = ESP = 'SII';
                Visible = seeSII;
            }
        }
        addafter("Succeeded VAT Registration No.")
        {
            field("QB_DoNotSendToSII"; rec."Do not send to SII")
            {

                Visible = seeSII;
            }
        }


        modify("Special Scheme Code")
        {
            Visible = seeMSSII;


        }


        modify("Invoice Type")
        {
            Visible = seeMSSII;


        }


        modify("ID Type")
        {
            Visible = seeMSSII;


        }


        modify("Succeeded Company Name")
        {
            Visible = seeMSSII;


        }


        modify("Succeeded VAT Registration No.")
        {
            Visible = seeMSSII;


        }

    }

    actions
    {


    }

    //trigger
    trigger OnOpenPage()
    BEGIN
        xSalesInvoiceHeader := Rec;

        //QB
        edDueDate := (rec."QW Cod. Withholding by GE" <> '');
        seeQFA := FunctionQB.AccessToFacturae;
        seeMSSII := FunctionQB.AccessToSII;
        seeQuoSII := FunctionQB.AccessToQuoSII;
        seeSII := seeMSSII OR seeQuoSII;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        //QB
        xSalesInvoiceHeader.CALCFIELDS("Work Description");
        IF NOT xSalesInvoiceHeader."Work Description".HASVALUE THEN
            WorkDescription := ''
        ELSE BEGIN
            CR[1] := 10;
            // TempBlob.Blob := xSalesInvoiceHeader."Work Description";
            /*To be tested*/

            TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
            Blob.Write(xSalesInvoiceHeader."Work Description");
            // WorkDescription := TempBlob.ReadAsText(CR, TEXTENCODING::Windows); to be tested
            Tempblob.CreateInStream(InStr, TextEncoding::Windows);
            InStr.Read(CR);
            WorkDescription := CR
        END;

        xWorkDescription := WorkDescription;
    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    BEGIN
        IF CloseAction = ACTION::LookupOK THEN
            IF RecordChanged THEN
                CODEUNIT.RUN(CODEUNIT::"Sales Invoice Header - Edit", Rec);

        //JAV 06/07/22: - QB 1.10.59 Se cambia la forma de manejo de los campos propios para no usar cambios en la CU est ndar
        IF (CloseAction = ACTION::LookupOK) THEN
            OnBeforeChangeDocument(Rec);

        Rec.CALCFIELDS("Work Description");
        Rec."Work Description" := Rec."Work Description";
        Rec.MODIFY(TRUE);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        Rec.CALCFIELDS("Work Description");
        Rec."Work Description" := Rec."Work Description";
    END;


    //trigger

    var
        xSalesInvoiceHeader: Record 112;
        "--------------------------- QB": Integer;
        edDueDate: Boolean;
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;

        WorkDescription: Text;
        xWorkDescription: Text;
        CR: Text;
        FunctionQB: Codeunit 7207272;
        seeQFA: Boolean;
        seeMSSII: Boolean;
        seeQuoSII: Boolean;
        seeSII: Boolean;




    //procedure
    Local procedure RecordChanged(): Boolean;
    begin
        exit(
          (rec."Special Scheme Code" <> xSalesInvoiceHeader."Special Scheme Code") or
          (rec."Invoice Type" <> xSalesInvoiceHeader."Invoice Type") or
          (rec."ID Type" <> xSalesInvoiceHeader."ID Type") or
          (rec."Succeeded Company Name" <> xSalesInvoiceHeader."Succeeded Company Name") or
          (rec."Succeeded VAT Registration No." <> xSalesInvoiceHeader."Succeeded VAT Registration No."));
    end;
    //procedure SetRec(SalesInvoiceHeader : Record 112);
    //    begin
    //      Rec := SalesInvoiceHeader;
    //      Rec.INSERT;
    //    end;
    LOCAL procedure "-------------------------- QB"();
    begin
    end;

    [BusinessEvent(false)]
    procedure OnBeforeChangeDocument(Rec: Record 112);
    begin
    end;

    //procedure
}

