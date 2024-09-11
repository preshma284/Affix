page 7207280 "QB Prepayment Edit SubForm"
{
    CaptionML = ENU = 'QB Prepayment List', ESP = 'Lineas de Anticipos';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7206998;
    SourceTableView = SORTING("Register No.", "Entry No.");
    PageType = ListPart;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater("General")
            {

                field("Entry No."; rec."Entry No.")
                {

                    Visible = false;
                    Editable = false;
                }
                field("Entry Type"; rec."Entry Type")
                {

                    Editable = false;
                }
                field("Document No."; rec."Document No.")
                {

                }
                field("Description"; rec."Description")
                {

                    Editable = false;
                }
                field("Posting Date"; rec."Posting Date")
                {

                    Editable = false;
                }
                field("Document Date"; rec."Document Date")
                {

                    Editable = false;
                }
                field("External Document No."; rec."External Document No.")
                {

                    Editable = false;
                }
                field("Currency Code"; rec."Currency Code")
                {

                    Editable = false;
                }
                field("Amount"; rec."Amount")
                {

                    Editable = false;
                }
                field("Amount (LCY)"; rec."Amount (LCY)")
                {

                    Visible = false;
                    Editable = false;
                }
                field("-Applied Amount"; -rec."Applied Amount")
                {

                    CaptionML = ESP = 'Importe Aplicado';
                    Editable = false;
                }
                field("Amount + Applied Amount"; rec.Amount + rec."Applied Amount")
                {

                    CaptionML = ESP = 'Importe Pendiente';
                    Editable = false;
                }
                field("To Apply %"; rec."To Apply %")
                {

                    ToolTipML = ESP = 'Indica el porcentaje que se desea aplicar o cancelar sobre el importe pendiente de este anticipo';
                    BlankZero = true;
                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        sumapp := sumapp + rec."To Apply Amount" - xRec."To Apply Amount";
                    END;


                }
                field("To Apply Amount"; rec."To Apply Amount")
                {

                    ToolTipML = ESP = 'Indica el importe que se desea aplicar o cancelar sobre el importe pendiente de este anticipo';
                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        sumapp := sumapp + rec."To Apply Amount" - xRec."To Apply Amount";
                    END;


                }
                field("To Apply Description"; rec."To Apply Description")
                {

                    ToolTipML = ESP = 'Indica la descripci�n que se desea usar en el asiento de aplicaci�n o cancelaci�n';
                    Style = Strong;
                    StyleExpr = TRUE;
                }

            }
            group("Totales")
            {

                group("group52")
                {

                    field("sumpte"; sumpte)
                    {

                        CaptionML = ESP = 'Pendiente';
                        Editable = false;
                    }
                    field("sumapp"; sumapp)
                    {

                        CaptionML = ESP = 'Aplicado';
                        Editable = false;
                    }
                    field("sumpte - sumapp"; sumpte - sumapp)
                    {

                        CaptionML = ESP = 'Restante';
                    }

                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        Rec.CALCFIELDS("Applied Amount");
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        Rec.CALCFIELDS("Applied Amount");
    END;



    var
        QBPrepayment: Record 7206928;
        QBPrepaymentData: Record 7206998;
        sumpte: Decimal;
        sumapp: Decimal;
        GData: Integer;

    procedure SetData(pData: Integer; pJob: Code[20]; pType: Option; pAccount: Code[20]; pApply: Boolean);
    begin
        //-----------------------------------------------------------------------------------------
        // JAV 13/06/22: - QB 1.10.49 Crear los registros necesarios en la tabla temporal
        //-----------------------------------------------------------------------------------------
        GData := pData;
        sumpte := 0;
        sumapp := 0;

        //Primero ponemos los registros que ya se han empleado
        if (GData <> 0) then begin
            QBPrepaymentData.RESET;
            QBPrepaymentData.SETRANGE("Register No.", GData);
            if (QBPrepaymentData.FINDSET(FALSE)) then
                repeat
                    Rec := QBPrepaymentData;
                    if (pApply) then
                        Rec."To Apply Type" := Rec."To Apply Type"::Apply
                    ELSE
                        Rec."To Apply Type" := Rec."To Apply Type"::Cancel;
                    Rec.INSERT;
                    QBPrepaymentData.CALCFIELDS("Applied Amount");
                    sumpte += QBPrepaymentData.Amount + QBPrepaymentData."Applied Amount";
                    sumapp += QBPrepaymentData."To Apply Amount";
                until (QBPrepaymentData.NEXT = 0);
        end;

        //Ahora revisamos el resto por si hay nuevos registros
        QBPrepayment.RESET;
        QBPrepayment.SETRANGE("Job No.", pJob);
        QBPrepayment.SETRANGE("Account Type", pType);
        QBPrepayment.SETRANGE("Account No.", pAccount);
        QBPrepayment.SETFILTER("Entry Type", '%1|%2', QBPrepayment."Entry Type"::Invoice, QBPrepayment."Entry Type"::Bill);
        if (QBPrepayment.FINDSET(FALSE)) then
            repeat
                QBPrepayment.CALCFIELDS("Applied Amount");
                if (QBPrepayment.Amount <> QBPrepayment."Applied Amount") then begin
                    if (not Rec.GET(GData, QBPrepayment."Entry No.")) then begin
                        Rec.INIT;
                        Rec.TRANSFERFIELDS(QBPrepayment);
                        Rec."Register No." := pData;
                        Rec."Entry No." := QBPrepayment."Entry No.";
                        if (pApply) then
                            Rec."To Apply Type" := Rec."To Apply Type"::Apply
                        ELSE
                            Rec."To Apply Type" := Rec."To Apply Type"::Cancel;
                        if Rec.INSERT then
                            sumpte += QBPrepayment.Amount + QBPrepayment."Applied Amount";
                    end;
                end;
            until QBPrepayment.NEXT = 0;
        Rec.RESET;
    end;

    procedure GetAmounts(var pBase: Decimal; var pTotal: Decimal);
    begin
        //-----------------------------------------------------------------------------------------
        // JAV 13/06/22: - QB 1.10.49 Retorna los totales de los registros insertados
        //-----------------------------------------------------------------------------------------
        pBase := sumpte;
        pTotal := sumapp;
    end;

    procedure GetData(var pData: Integer; var pType: Option "No","Invoice","Bill");
    begin
        //-----------------------------------------------------------------------------------------
        // JAV 13/06/22: - QB 1.10.49 Retorna el registro de datos asociado al anticipo
        //-----------------------------------------------------------------------------------------

        pType := pType::No;

        //Elimino los registros existentes pues los voy a reemplazar por los temporales siempre
        if (GData <> 0) then begin
            QBPrepaymentData.RESET;
            QBPrepaymentData.SETRANGE("Register No.", GData);
            QBPrepaymentData.DELETEALL;
        end;

        //Si tiene importe y es menor al pendiente total se crean los nuevos registros
        if (sumapp <> 0) and (sumpte >= sumapp) then begin
            //Si no hya registro creo uno nuevo
            if (GData = 0) then begin
                QBPrepaymentData.RESET;
                if QBPrepaymentData.FINDLAST then
                    GData := QBPrepaymentData."Register No." + 1
                ELSE
                    GData := 1;
            end;

            //Traspasar los registros
            Rec.RESET;
            Rec.SETFILTER("To Apply Amount", '<>0');
            if (Rec.FINDSET(FALSE)) then
                repeat
                    if ((Rec."Entry Type" = Rec."Entry Type"::Invoice) and (pType = pType::Bill)) or
                       ((Rec."Entry Type" = Rec."Entry Type"::Bill) and (pType = pType::Invoice)) then
                        ERROR('No puede mezclar anticipos de tipo factura y de tipo efecto en una misma aplicaci�n o cancelaci�n.');

                    if (Rec."Entry Type" = Rec."Entry Type"::Invoice) then
                        pType := pType::Invoice
                    ELSE
                        pType := pType::Bill;

                    QBPrepaymentData.INIT;
                    QBPrepaymentData.TRANSFERFIELDS(Rec);
                    QBPrepaymentData."Register No." := GData;
                    QBPrepaymentData.INSERT;
                until Rec.NEXT = 0;
        end;

        pData := GData;
    end;

    // begin//end
}







