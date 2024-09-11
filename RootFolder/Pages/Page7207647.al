page 7207647 "RC Resp Compras Contrat. Act"
{
    CaptionML = ENU = 'Activities', ESP = 'Actividades';
    SourceTable = 7206916;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group("group40")
            {

                CaptionML = ENU = 'Invoicing', ESP = 'Proveedores y Planificaci�n';

                ;
                field("Comparativos Ptes Gen."; rec."Comparativos Ptes Gen.")
                {

                    DrillDownPageID = "Comparative Quote List";
                }
                field("Pedidos abiertos"; rec."Pedidos abiertos")
                {

                    CaptionML = ESP = 'Pedidos Abiertos';
                    DrillDownPageID = "Purchase List";
                }
                field("Pedidos de Compra"; rec."Pedidos de Compra")
                {

                    CaptionML = ENU = 'Jobs - WIP Not Posted', ESP = 'Pedidos de Compra';
                    DrillDownPageID = "Purchase List";
                }

            }
            group("group44")
            {

                CaptionML = ENU = 'Approvals', ESP = 'Pagos';
                field("Payments Due Today"; rec."Payments Due Today")
                {

                    CaptionML = ESP = 'Pagos vencidos';
                    DrillDownPageID = "Vendor Ledger Entries";
                }
                field("Vendors - Payment on Hold"; rec."Vendors - Payment on Hold")
                {

                    CaptionML = ESP = 'Proveedores pagos suspendido';
                    DrillDownPageID = "Vendor List";
                }

            }
            group("group47")
            {

                CaptionML = ENU = 'Approvals', ESP = 'Aprobaciones';
                field("ApPen Comparativos"; rec."ApPen Comparativos")
                {

                    CaptionML = ESP = 'Comparativos ptes. Aprobar';
                    DrillDownPageID = "Approval Request Entries";
                }
                field("ApPen Contracts and Orders"; rec."ApPen Contracts and Orders")
                {

                    CaptionML = ESP = 'Pedidos ptes. Aprobar';
                    DrillDownPageID = "Approval Request Entries";
                }
                field("My pending approvals"; rec."My pending approvals")
                {

                    DrillDownPageID = "Requests to Approve";
                }
                field("Movements pending approval"; rec."Movements pending approval")
                {

                    DrillDownPageID = "Approval Entries"

  ;
                }

            }

        }

    }

    trigger OnOpenPage()
    BEGIN
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;

        ApplyGlobalFilters;
        UpdateActivities;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        UpdateActivities;
    END;



    var
        MyActivity: Record 7207280;
        i: Integer;
        MyActivitySelected: Code[250];

    procedure ApplyGlobalFilters();
    begin
        CLEAR(Rec);
        Rec.SETFILTER("Date Filter", '>=%1', WORKDATE);
        Rec.SETFILTER("Date Filter2", '<%1', WORKDATE);
        Rec.SETFILTER("User ID Filter", '=%1', USERID);
    end;

    procedure UpdateActivities();
    begin
        i := 1;
        MyActivitySelected := '';
        CLEAR(MyActivity);
        if MyActivity.FINDFIRST then begin
            repeat
                if i = 1 then begin
                    MyActivitySelected := MyActivity."Activity Code";
                end ELSE if i < 13 then
                        MyActivitySelected := MyActivitySelected + '|' + MyActivity."Activity Code";
                i := i + 1;
            until MyActivity.NEXT = 0;
            Rec.SETFILTER(MyActivityFilter, MyActivitySelected);
            CalcFieldsActivities;
        end ELSE begin
            ApplyGlobalFilters;
            CalcFieldsActivities;
        end;
    end;

    procedure CalcFieldsActivities();
    begin
        Rec.CALCFIELDS(Necesidades, "Comparativos Ofertas", "Pedidos abiertos", "Pedidos de Compra", "Datos Evaluación proveedor",
                   "Retenciones BE vencidas", rec."ApPen Comparativos", rec."ApPen Contracts and Orders",
                   rec."Payments Due Today", rec."Vendors - Payment on Hold");

        Rec.CALCFIELDS("My pending approvals", "Movements pending approval");
    end;

    // begin//end
}







