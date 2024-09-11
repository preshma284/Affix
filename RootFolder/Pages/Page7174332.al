page 7174332 "SII Documents List"
{
  ApplicationArea=All;

    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = true;
    SourceTable = 7174333;
    SourceTableView = SORTING("Posting Date")
                    ORDER(Descending);
    PageType = List;
    CardPageID = "SII Document Card";

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Document Type"; rec."Document Type")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Document No."; rec."Document No.")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("External Reference"; rec."External Reference")
                {

                    StyleExpr = stline;
                }
                field("Entry No."; rec."Entry No.")
                {

                    Visible = false;
                }
                field("Register Type"; rec."Register Type")
                {

                    StyleExpr = stline;
                }
                field("Posting Date"; rec."Posting Date")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Document Date"; rec."Document Date")
                {

                    StyleExpr = stline;
                }
                field("Year"; rec."Year")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Period Name"; rec."Period Name")
                {

                    CaptionML = ENU = 'Period', ESP = 'Periodo';
                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Cust/Vendor No."; rec."Cust/Vendor No.")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Cust/Vendor Name"; rec."Cust/Vendor Name")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("VAT Registration No."; rec."VAT Registration No.")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Invoice Type"; rec."Invoice Type")
                {

                    StyleExpr = stline;
                }
                field("Invoice Type Name"; rec."Invoice Type Name")
                {

                    CaptionML = ENU = 'Invoice Type', ESP = 'Tipo Factura';
                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Modified"; rec."Modified")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Is Emited"; rec."Is Emited")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("No. Sends Includes"; rec."No. Sends Includes")
                {

                }
                field("Shipment Status"; rec."Shipment Status")
                {

                    StyleExpr = stline;
                }
                field("LSEnvironment"; LSEnvironment)
                {

                    CaptionML = ESP = 'Entorno �ltimo envio';
                }
                field("Last Shipment"; rec."Last Shipment")
                {

                }
                field("AEAT Status"; rec."AEAT Status")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Status"; rec."Status")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Tally Status"; rec."Tally Status")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Base Imbalance"; rec."Base Imbalance")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("ISP Base Imbalance"; rec."ISP Base Imbalance")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Imbalance Fee"; rec."Imbalance Fee")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Imbalance RE Fee"; rec."Imbalance RE Fee")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Imbalance Amount"; rec."Imbalance Amount")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("SII Entity"; rec."SII Entity")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("CrMemo Type"; rec."CrMemo Type")
                {

                    StyleExpr = stline;
                }
                field("Cr.Memo Type Name"; rec."Cr.Memo Type Name")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Special Regime"; rec."Special Regime")
                {

                    StyleExpr = stline;
                }
                field("Special Regime Name"; rec."Special Regime Name")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Special Regime 1"; rec."Special Regime 1")
                {

                    StyleExpr = stline;
                }
                field("Special Regime 1 Name"; rec."Special Regime 1 Name")
                {

                    StyleExpr = stline;
                }
                field("Special Regime 2"; rec."Special Regime 2")
                {

                    StyleExpr = stline;
                }
                field("Special Regime 2 Name"; rec."Special Regime 2 Name")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Description Operation 1"; rec."Description Operation 1")
                {

                    StyleExpr = stline;
                }
                field("Description Operation 2"; rec."Description Operation 2")
                {

                    StyleExpr = stline;
                }
                field("Medio Cobro/Pago"; rec."Medio Cobro/Pago")
                {

                    StyleExpr = stline;
                }
                field("CuentaMedioCobro"; rec."CuentaMedioCobro")
                {

                    StyleExpr = stline;
                }
                field("Declarate Key UE"; rec."Declarate Key UE")
                {

                    StyleExpr = stline;
                }
                field("Multiple Destination"; rec."Multiple Destination")
                {

                    StyleExpr = stline;
                }
                field("UE Country"; rec."UE Country")
                {

                    StyleExpr = stline;
                }
                field("UE Period"; rec."UE Period")
                {

                    StyleExpr = stline;
                }
                field("Bienes Description"; rec."Bienes Description")
                {

                    Editable = FALSE;
                    StyleExpr = stline;
                }
                field("Operator Address"; rec."Operator Address")
                {

                    StyleExpr = stline;
                }
                field("Documentation/Invoice UE"; rec."Documentation/Invoice UE")
                {

                    StyleExpr = stline;
                }
                field("Shipping Date"; rec."Shipping Date")
                {

                    StyleExpr = stline;
                }
                field("FA ID"; rec."FA ID")
                {

                    StyleExpr = stline;
                }
                field("Start Date of use"; rec."Start Date of use")
                {

                    StyleExpr = stline

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

    action("action1")
    {
        CaptionML=ENU='Obtener Documentos',ESP='Obtener Documentos';
                      Image=GetLines;
                      
                                trigger OnAction()    VAR
                                //  SIIImportDocument : Report 7174332;
                               BEGIN
                                //  SIIImportDocument.SetDocumentType(rec."Document Type");
                                //  SIIImportDocument.RUNMODAL;
                               END;


            }
            action("action2")
            {
                CaptionML = ENU = 'Contrastar';
                Image = CheckList;
                trigger OnAction()
                VAR
                BEGIN
                    //QuoSII1.4.03
                    IF CONFIRM('�Confirma que desea continuar?') THEN;
                    Contrastar();
                END;
            }
            action("Navigate")
            {

                CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                ToolTipML = ENU = 'Find all entries and documents that exist for the document number and posting date on the selected posted purchase document.', ESP = 'Busca todos los movimientos y los documentos que existen seg�n el n�mero de documento y la fecha de registro del documento de compra registrado seleccionado.';
                ApplicationArea = Basic, Suite;
                Image = Navigate;
                Scope = Repeater;


                trigger OnAction()
                BEGIN
                    Navigate_;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
                actionref(Navigate_Promoted; Navigate)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    BEGIN
        setStyle;

        Rec.AddData(FALSE);  //A�adir proyecto y dimensiones si no los tiene. JAV 08/09/21: - QuoSII 1.5z Se cambia la forma de obtener los datos de las dimensiones
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        //+QuoSII_1.4.99.999
        IF rec.Modified = FALSE THEN
            Rec.VALIDATE(Modified, TRUE);
        //-QuoSII_1.4.99.999
    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    VAR
        SIIDocumentShipmentLine: Record 7174336;
        SIIDocuments: Record 7174333;
        SIIDocumentShipment: Record 7174335;
    BEGIN
    END;



    var
        SIIDocumentShipmentLine: Record 7174336;
        SIIDocumentShipLine: Page 7174335;
        SIIProcesing: Codeunit 7174332;
        "Ship No.": Code[20];
        stLine: Text;
        LSEnvironment: Text;

    procedure SetShipNo(ShipNo: Code[20]);
    begin
        "Ship No." := ShipNo;
    end;

    LOCAL procedure Contrastar();
    var
        SIIDocuments: Record 7174333;
        SIIManagement: Codeunit 7174331;
    begin
        //QuoSII1.4.03
        CurrPage.SETSELECTIONFILTER(SIIDocuments);

        if SIIDocuments.FINDSET then
            repeat //QuoSII_1.4.0.021
                SIIManagement.ProcessConsulta(SIIDocuments."Document No.", SIIDocuments."Document Type", SIIDocuments."Entry No.", SIIDocuments."Register Type", 0);
            until SIIDocuments.NEXT = 0;//QuoSII_1.4.0.021
    end;

    //[External]
    procedure Navigate_();
    var
        NavigateForm: Page 344;
    begin
        NavigateForm.SetDoc(rec."Posting Date", rec."External Reference");
        NavigateForm.RUN;
    end;

    LOCAL procedure setStyle();
    begin
        //Poner estilos a las l�neas
        if (rec."Document Type" = rec."Document Type"::NO) then
            stLine := 'Subordinate'
        ELSE if (rec."Shipment Status" = rec."Shipment Status"::Enviado) and (rec."AEAT Status" = 'CORRECTO') then begin
            if (rec.Status = rec.Status::Modificada) then
                stLine := 'StandardAccent'
            ELSE
                stLine := 'Favorable';
        end ELSE if (rec."Shipment Status" = rec."Shipment Status"::" ") and (rec."AEAT Status" = 'CORRECTO') then
                stLine := 'None'
        ELSE if (rec."AEAT Status" = '') then
            stLine := 'None'
        ELSE
            stLine := 'Unfavorable';

        if (rec."Last Shipment" <> '') then
            LSEnvironment := FORMAT(rec."Last Shipment Environment")
        ELSE
            LSEnvironment := '';
    end;

    // begin
    /*{
      QuoSII1.4.03 08/03/2018 PEL: Action ConsultaDocumentos
      QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci�n de enviar a la ATCN
      QuoSII_1.4.02.042.14 18/02/19 MCM - Se elimina el caption del campo rec."Is Emited".
      QuoSII_1.4.99.999 28/06/19 QMD - Se a�ade campo para controlar que se ha editado desde la p�gina
                                       Se modifica propiedad ModifyAllowed a Yes
      JAV 08/09/21: - QuoSII 1.5z Se cambia el nombre del campo "Line Type" a rec."Register Type" que es mas informativo y as� no entra en confusi�n con campos denominados Type
                    - Se cambia la forma de obtener los datos de las dimensiones
    }*///end
}









