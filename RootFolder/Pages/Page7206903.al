page 7206903 "Withholding Movements IRPF"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Withholding Movements', ESP = 'Movs. Retenciones IRPF';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207329;
    SourceTableView = SORTING("Entry No.")
                    WHERE("Withholding Type" = CONST("PIT"));
    DataCaptionFields = "No.";
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Document No."; rec."Document No.")
                {

                }
                field("External Document No."; rec."External Document No.")
                {

                }
                field("Type"; rec."Type")
                {

                }
                field("No."; rec."No.")
                {

                }
                field("Account Name"; rec."Account Name")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {

                }
                field("Withholding Type"; rec."Withholding Type")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("Withholding Base"; rec."Withholding Base")
                {

                }
                field("Amount"; rec."Amount")
                {

                }
                field("Amount (LCY)"; rec."Amount (LCY)")
                {

                }
                field("Due Date"; rec."Due Date")
                {

                }
                field("Open"; rec."Open")
                {

                }
                field("User ID"; rec."User ID")
                {

                }
                field("Source Code"; rec."Source Code")
                {

                }
                field("Withholding treating"; rec."Withholding treating")
                {

                }
                field("Release Date"; rec."Release Date")
                {

                }
                field("Released-to Document No."; rec."Released-to Document No.")
                {

                }
                field("Applies-to ID"; rec."Applies-to ID")
                {

                }
                field("Released-to Movement No."; rec."Released-to Movement No.")
                {

                }
                field("Entry No."; rec."Entry No.")
                {

                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("<Action53>")
            {

                CaptionML = ENU = 'Ent&ry', ESP = '&Movimiento';
            }
        }
        area(Processing)
        {

            action("<Action3>")
            {

                ShortCutKey = 'Shift+Ctrl+D';
                CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                Image = Dimensions;

                trigger OnAction()
                BEGIN
                    rec.ShowDimensions;
                END;


            }
            action("<Action37>")
            {

                CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                Image = Navigate;

                trigger OnAction()
                VAR
                    NavigatePage: Page 344;
                BEGIN
                    NavigatePage.SetDoc(rec."Posting Date", rec."Document No.");
                    NavigatePage.RUN;
                END;


            }
            action("WithholdingMovementsRet")
            {

                CaptionML = ESP = 'Withholding Movements IRPF';
                RunObject = Page 7207018;
                Image = OpenWorksheet;
            }
            group("group7")
            {
                CaptionML = ENU = 'Telematic VAT', ESP = 'IVA Telem�tico';
                Image = ElectronicDoc;
                action("Generate TXT File")
                {

                    Ellipsis = true;
                    CaptionML = ENU = 'Generate txt file', ESP = 'Generar archivo txt';
                    ToolTipML = ENU = 'Create a text file for the selected VAT declaration according to the transference format template defined for the VAT declaration. A window will show all the lines in the template where the Ask check box was selected, so that you can Rec.INSERT or Rec.MODIFY the content of the values to be included in the file for these elements.', ESP = 'Permite crear un archivo de texto para la declaraci�n de IVA seleccionada seg�n la plantilla de formato transferencia definida para la declaraci�n de IVA. Aparecer� una ventana con todas las l�neas de la plantilla en las que se activ� la casilla Preguntar, para que pueda insertar o modificar el contenido de los valores que desea incluir en el archivo para estos elementos.';
                    ApplicationArea = Basic, Suite;
                    Image = CreateDocument;


                    trigger OnAction()
                    VAR
                        // GenerateTXTFile: Report 7207397;
                    BEGIN
                        //QRE+
                        // GenerateTXTFile.RUNMODAL;
                        // CLEAR(GenerateTXTFile);
                        //QRE-
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("<Action37>_Promoted"; "<Action37>")
                {
                }
                actionref("Generate TXT File_Promoted"; "Generate TXT File")
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        //JAV 07/03/19: - Se ponen no activos los botones de acci�n cuando es una linea de IRPF
        bLiberar := (rec."Withholding Type" = rec."Withholding Type"::"G.E") AND (rec.Open);
        bLiquidar := (rec."Withholding Type" = rec."Withholding Type"::"G.E") AND (rec."Released-to Movement No." = 0);
        //JAV --
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        //CODEUNIT.RUN(CODEUNIT::"Mov. retenci�n-Editar",Rec);
        //EXIT(FALSE);
    END;



    var
        WithholdingMovements: Record 7207329;
        cduWithholdingtreating: Codeunit 7207306;
        Window: Dialog;
        read: Integer;
        Text001: TextConst ENU = 'Releasing Whithholding/s... \#1#######', ESP = 'Liberando retenci�n/es... \#1#######';
        bLiberar: Boolean;
        bLiquidar: Boolean;/*

    begin
    {
      JAV 18/10/19: - Esta pantalla es solo para ver retenciones de IRPF
      MCM 06/10/21: - Q15410 QRE Creaci�n de la acci�n "Generate TXT File"
      JDC 01/06/22: - QB 1.10.49 (Q17128) Added fields 50000 "Customer Name", 50001 "Vendor Name"
    }
    end.*/


}









