page 7207301 "QB Version Changes"
{
    CaptionML = ENU = 'Versions Changes', ESP = 'Cambios en las versiones';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7206921;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("txtProduct"; txtProduct)
                {

                    CaptionML = ESP = 'Producto';
                    Visible = FALSE;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("txtVersion"; txtVersion)
                {

                    CaptionML = ESP = 'Versi�n';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Date"; rec."Date")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Type"; rec."Type")
                {

                    StyleExpr = stDatos;
                }
                field("Description"; rec."Description")
                {

                    StyleExpr = stDatos

  ;
                }

            }

        }
    }



    trigger OnOpenPage()
    BEGIN
        rec.AddAll;
        Rec.RESET;
        Rec.SETCURRENTKEY(Order);
        rec.ASCENDING(FALSE);
        Rec.SETRANGE(Product, gProduct);
        Rec.FINDFIRST;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        IF (rec.Line = 1) THEN BEGIN
            txtProduct := rec.Product;
            txtVersion := rec.Version
        END ELSE BEGIN
            txtProduct := '';
            txtVersion := '';
        END;

        stDatos := 'Standar';
        CASE rec.Type OF
            rec.Type::Base:
                stDatos := 'Strong';
            rec.Type::Mejora:
                stDatos := 'StandardAccent';
            rec.Type::Arreglo:
                stDatos := 'Ambiguous';
        END;
    END;



    var
        txtVersion: Text;
        txtProduct: Text;
        gProduct: Text;
        stDatos: Text;

    procedure SetProduct(pProduct: Text);
    begin
        gProduct := pProduct;
    end;

    // begin//end
}







