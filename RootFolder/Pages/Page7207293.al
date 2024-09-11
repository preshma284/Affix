page 7207293 "List For Job"
{
    Editable = false;
    CaptionML = ENU = 'List For Sub-Job', ESP = 'Lista de Sub-Proyectos';
    InsertAllowed = false;
    SourceTable = 167;
    PageType = List;
    CardPageID = "Operative Jobs Card";
    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("No."; rec."No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {

                }
                field("Starting Date"; rec."Starting Date")
                {

                }
                field("Ending Date"; rec."Ending Date")
                {

                }
                field("Status"; rec."Status")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Person Responsible"; rec."Person Responsible")
                {

                }
                field("Job Matrix - Work"; rec."Job Matrix - Work")
                {

                    Editable = False;
                }

            }

        }
        area(FactBoxes)
        {
            part("part1"; 7207499)
            {
                SubPageLink = "No." = FIELD("No."), "Resource Filter" = FIELD("Resource Filter"), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter");
            }
            part("part2"; 7207500)
            {
                SubPageLink = "No." = FIELD("No."), "Resource Filter" = FIELD("Resource Filter"), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter");
            }
            part("part3"; 7207501)
            {
                SubPageLink = "No." = FIELD("No."), "Resource Filter" = FIELD("Resource Filter"), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter");
            }
            part("part4"; 7207502)
            {
                SubPageLink = "No." = FIELD("No."), "Resource Filter" = FIELD("Resource Filter"), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter");
            }
            part("part5"; 7207503)
            {
                SubPageLink = "No." = FIELD("No."), "Resource Filter" = FIELD("Resource Filter"), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter");
            }
            systempart(Links; Links)
            {
                ;
            }
            systempart(Notes; Notes)
            {
                ;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Jobs', ESP = 'Trabajos';
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207332;
                    RunPageLink = "No." = FIELD("No."), "Resource Filter" = FIELD("Resource Filter"), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter");
                    Image = Statistics;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Comment', ESP = 'Comentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Job"), "No." = FIELD("No.");
                    Image = ViewComments;
                }

            }
            group("group5")
            {
                CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                action("action3")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimension-Single', ESP = 'Dimension-Individual';
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(167), "No." = FIELD("No.");
                    Image = Dimensions;
                }
                action("action4")
                {
                    CaptionML = ENU = 'Dimensions-Multiple', ESP = 'Dimensiones_Multiples';
                    Image = DimensionSets;

                    trigger OnAction()
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(Job);
                        DefaultDimensionsMultiple.SetMultiJob(Job);
                        DefaultDimensionsMultiple.RUNMODAL;
                    END;


                }
                action("action5")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Ledger Entries', ESP = 'Movimientos';
                    RunObject = Page 92;
                    RunPageView = SORTING("Job No.", "Posting Date");
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = JobLedger;
                }
                separator("separator6")
                {

                }
                action("action7")
                {
                    CaptionML = ENU = 'Create Job', ESP = 'Crear Sub-Proyecto';
                    Image = CreateJobSalesInvoice;

                    trigger OnAction()
                    BEGIN
                        Job.GET(Rec.GETFILTER("Matrix Job it Belongs"));
                        IF Job."Job Matrix - Work" = Job."Job Matrix - Work"::Work THEN
                            ERROR(Text003, Job."No.");
                        IF NOT CONFIRM(Text000, FALSE, rec."Matrix Job it Belongs") THEN
                            ERROR(Text001)
                        ELSE BEGIN
                            CreateJobWork;
                            InsertDimension;
                            CurrPage.UPDATE;
                            IF Rec.FINDLAST THEN;
                        END;
                    END;


                }

            }
            group("group11")
            {
                CaptionML = ENU = 'Planning', ESP = 'Planificaci�n';
                action("action8")
                {
                    CaptionML = ENU = 'Resource Allocations', ESP = 'Asignaci�n recursos';
                    RunObject = Page 221;
                    Image = TeamSales;
                }
                action("action9")
                {
                    CaptionML = ENU = 'Resource availability', ESP = 'Disponibilidad recurso';
                    RunObject = Page 225;
                    Image = ResourceLedger;
                }
                separator("separator10")
                {

                }
                action("action11")
                {
                    CaptionML = ENU = 'Res. Group Allocated per Job', ESP = 'Asignaci�n fam. recursos';
                    RunObject = Page 228;
                    Image = ResourceGroup;
                }
                action("action12")
                {
                    CaptionML = ENU = 'Res. Group Availability', ESP = 'Disponibilidad fam. recurso';
                    RunObject = Page 226;
                    Image = ResourceSkills;
                }

            }

        }
        area(Processing)
        {

            action("action13")
            {
                CaptionML = ENU = 'Prices', ESP = 'Precios';
                RunObject = Page 204;
                RunPageLink = "Job No." = FIELD("No.");
                Image = SalesPrices;
            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action13_Promoted; action13)
                {
                }
                actionref(action7_Promoted; action7)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
                actionref(action9_Promoted; action9)
                {
                }
            }
        }
    }

    var
        Job: Record 167;
        DefaultDimensionsMultiple: Page 542;
        Text001: TextConst ENU = 'The job will not be created to respect the warning message', ESP = 'Proceso cancelado';
        Text003: TextConst ENU = 'Creating jobs is not allowed', ESP = 'No esta permitido crear Sub-Proyectos para el proyecto %1';
        Text000: TextConst ENU = 'A Job will be created for the job: %1 \ Do you want to continue?', ESP = 'Se va a crear un Sub-Proyecto para el Proyecto: %1\�Desea continuar?';

    procedure CreateJobWork();
    var
        Job: Record 167;
        JobInsert: Record 167;
    begin
        // Vamos a copiar los datos de la ficha de proyecto si el campo Job."Proyecto matriz - trabajo" es Trabajo
        Job.GET(rec.GETFILTER("Matrix Job it Belongs"));
        JobInsert.TRANSFERFIELDS(Job);
        JobInsert."Matrix Job it Belongs" := Rec.GETFILTER("Matrix Job it Belongs");
        // Vamos a modificar datos de campos necesarios para la creaci�n de trabajo
        JobInsert.VALIDATE(Status, JobInsert.Status::Open);
        JobInsert.VALIDATE("Job Matrix - Work", JobInsert."Job Matrix - Work"::Work);
        JobInsert.VALIDATE("Matrix Job it Belongs", Job."No.");
        JobInsert.VALIDATE("Allocation Item by Unfold", FALSE);
        JobInsert.INSERT(TRUE);
        Job."Allocation Item by Unfold" := TRUE;
        Job.MODIFY;
        // Debemos de controlar que al crear un trabajo si el proyecto matriz tiene Cod. departamento debemos de mantener la T(352)
    end;

    procedure InsertDimension();
    var
        Job: Record 167;
        DefaultDimension: Record 352;
        DefaultDimension2: Record 352;
        FunctionQB: Codeunit 7207272;
    begin
        // Copiamos las dimensiones del matriz
        Job.GET(rec.GETFILTER("Matrix Job it Belongs"));

        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", DATABASE::Job);
        DefaultDimension.SETRANGE("No.", Job."No.");
        DefaultDimension.SETFILTER("Dimension Code", '<>%1', FunctionQB.ReturnDimJobs);
        if DefaultDimension.FINDSET then
            repeat
                DefaultDimension2 := DefaultDimension;
                DefaultDimension2."No." := DefaultDimension."No.";
                if not DefaultDimension2.INSERT(TRUE) then
                    DefaultDimension2.MODIFY(TRUE);
            until DefaultDimension.NEXT = 0;
    end;

    // begin
    /*{
      JAV 26/10/20: - Se cambian los textos para que en lugar de "Trabajo" ponga "Proyecto hijo"
    }*///end
}







