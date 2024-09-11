page 7207331 "Bring Certification Lines"
{
    Editable = false;
    CaptionML = ENU = 'Bring Certification Lines', ESP = 'Traer l�neas certificaci�n';
    SourceTable = 7207342;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Certification Type"; rec."Certification Type")
                {

                    HideValue = CertTypeHideValue;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Document No."; rec."Document No.")
                {

                    HideValue = DocumentHideValue;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Piecework No."; rec."Piecework No.")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }
                field("Cert Quantity to Term"; rec."Cert Quantity to Term")
                {

                }
                field("Cert Quantity to Origin"; rec."Cert Quantity to Origin")
                {

                }
                field("Invoiced Quantity"; rec."Invoiced Quantity")
                {

                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Certification Date"; rec."Certification Date")
                {

                }
                field("Contract Price"; rec."Contract Price")
                {

                }
                field("Facturado"; rec."Facturado")
                {

                    Editable = FALSE

  ;
                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Line', ESP = '&L�nea';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Show Document', ESP = 'Muestra documento';
                    Image = View;

                    trigger OnAction()
                    BEGIN
                        PostCert.GET(rec."Document No.");
                        PAGE.RUN(PAGE::"Post. Certifications", PostCert);
                    END;


                }
                action("action2")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;


                    trigger OnAction()
                    BEGIN
                        rec.ShowDimensions;
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    BEGIN
        DocumentHideValue := FALSE;
        CertTypeHideValue := FALSE;
        NoDocumentFormat;
    END;



    var
        SalesHeader: Record 36;
        DocumentHideValue: Boolean;
        DocumentEmphasize: Boolean;
        CertTypeEmphatyse: Boolean;
        CertTypeHideValue: Boolean;
        intOption: Integer;
        SalesGetShpt: Codeunit 7207284;
        Text002: TextConst ENU = '&Certificaci�n desglosada,Certificaci�n completa o &parcial en una l�nea', ESP = '&Certificaci�n desglosada,Certificaci�n com&pleta en una l�nea';
        PostCert: Record 7207341;

    procedure SetSalesHeader(var SalesHeader2: Record 36);
    begin
        SalesHeader.GET(SalesHeader2."Document Type", SalesHeader2."No.");
        //SalesHeader.TESTFIELD("Document Type",SalesHeader."Document Type"::Invoice); //GAP027
    end;

    LOCAL procedure NoDocumentFormat();
    begin

        if IsFirstDocLine then begin
            DocumentEmphasize := TRUE;
            CertTypeEmphatyse := TRUE;
        end ELSE begin
            DocumentHideValue := TRUE;
            CertTypeHideValue := TRUE;
        end;
        //--SR.001
    end;

    LOCAL procedure IsFirstDocLine(): Boolean;
    var
        HistCertificationLines: Record 7207342;
    begin
        HistCertificationLines.RESET;
        HistCertificationLines.SETRANGE("Document No.", rec."Document No.");
        HistCertificationLines.SETFILTER("Piecework No.", '<>%1', '');
        HistCertificationLines.SETRANGE("Invoiced Certif.", FALSE);
        if not HistCertificationLines.FINDFIRST then begin
            HistCertificationLines.COPYFILTERS(Rec);
            HistCertificationLines.SETRANGE("Document No.", rec."Document No.");
            HistCertificationLines.FINDFIRST;
            HistCertificationLines := HistCertificationLines;
            HistCertificationLines.INSERT;
        end;
        if rec."Line No." = HistCertificationLines."Line No." then
            exit(TRUE);
    end;

    // begin//end
}







