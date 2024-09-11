page 7207643 "RC Adm. Obra Activities"
{
    CaptionML = ENU = 'Activities', ESP = 'Actividades';
    SourceTable = 7206916;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group("group47")
            {

                CaptionML = ENU = 'Invoicing', ESP = 'Actividades de Compras';

                ;
                field("Pedidos de Compra"; rec."Pedidos de Compra")
                {

                    CaptionML = ENU = 'Jobs - WIP Not Posted', ESP = 'Pedidos de Compra';
                    DrillDownPageID = "Purchase List";
                }
                field("Facturas de Compra"; rec."Facturas de Compra")
                {

                    CaptionML = ESP = 'Facturas de Compra';
                    DrillDownPageID = "Purchase List";
                }

            }
            group("group50")
            {

                CaptionML = ENU = 'Approvals', ESP = 'Aprobaciones';

                ;
                field("My pending approvals"; rec."My pending approvals")
                {

                    DrillDownPageID = "Requests to Approve";
                }
                field("Movements pending approval"; rec."Movements pending approval")
                {

                    DrillDownPageID = "Approval Entries";
                }
                field("Comparativos Ptes Gen."; rec."Comparativos Ptes Gen.")
                {

                    DrillDownPageID = "Comparative Quote List"

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
        MyJob: Record 9154;
        i: Integer;
        JobsSelected: Code[250];
        GenJnlLine: Record 81;
        GenJnlManagement: Codeunit 230;

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
        JobsSelected := '';
        CLEAR(MyJob);
        if MyJob.FINDFIRST then begin
            repeat
                if i = 1 then begin
                    JobsSelected := MyJob."Job No.";
                end ELSE if i < 13 then
                        JobsSelected := JobsSelected + '|' + MyJob."Job No.";
                i := i + 1;
            until MyJob.NEXT = 0;
            Rec.SETFILTER(JobFilter, JobsSelected);
            CalcFieldsActivities;
        end ELSE begin
            ApplyGlobalFilters;
            CalcFieldsActivities;
        end;
    end;

    procedure CalcFieldsActivities();
    begin
        Rec.CALCFIELDS(Necesidades, "Comparativos Ofertas", "Pedidos de Compra", Recepciones,
                   "ApPen Facturas Compra", "Retenciones BE vencidas", "Albaranes Salida", "Partes de trabajo",
                   "Imputacion Costes Indirectos", "Regularizac. Almacenes a Proy.");

        Rec.CALCFIELDS("My pending approvals", "Movements pending approval");
    end;

    // begin//end
}







