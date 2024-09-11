page 7207523 "QB Location Assistant"
{
  ApplicationArea=All;

    CaptionML = ENU = 'QB Location Assistant', ESP = 'Asistente configuraci�n Almac�n';
    SourceTable = 5813;
    SourceTableView = SORTING("Location Code", "Invt. Posting Group Code")
                    WHERE("Location Code" = CONST(''));
    PageType = Card;

    layout
    {
        area(content)
        {
            group("group4")
            {

                CaptionML = ESP = 'Configuraci�n';
                field("J1"; J1)
                {

                    CaptionML = ESP = 'Proyecto estructura almac�n';
                    TableRelation = Job WHERE("Job Type" = CONST("Structure"));

                    ; trigger OnValidate()
                    BEGIN
                        QuoBuildingSetup.GET;
                        QuoBuildingSetup."Location Proyect" := J1;
                        QuoBuildingSetup.MODIFY;

                        DimensionValue.RESET;
                        DimensionValue.SETRANGE(DimensionValue."Dimension Code", FunctionQB.ReturnDimDpto);
                        IF (DimensionValue.FINDSET) THEN
                            REPEAT
                                DimensionValue."Job Structure Warehouse" := J1;
                                DimensionValue.MODIFY;
                            UNTIL DimensionValue.NEXT = 0;
                    END;


                }
                field("J2"; J2)
                {

                    CaptionML = ESP = 'Crear almac�n igual a proyecto';

                    ; trigger OnValidate()
                    BEGIN
                        QuoBuildingSetup.GET;
                        QuoBuildingSetup."Create Location Equal To Proj." := J2;
                        QuoBuildingSetup.MODIFY;
                    END;


                }
                field("C1"; C1)
                {

                    CaptionML = ENU = 'Prevent Negative Inventory', ESP = 'Evitar inventario negativo';
                    ToolTipML = ENU = 'Specifies if you can post transactions that will bring inventory levels below zero.', ESP = 'Especifica si se pueden registrar transacciones que pongan los niveles de inventario por debajo de cero.';
                    ApplicationArea = Basic, Suite;
                }

            }
            group("group8")
            {

                repeater("table")
                {

                    field("Invt. Posting Group Code"; rec."Invt. Posting Group Code")
                    {

                    }
                    field("Description"; rec."Description")
                    {

                    }
                    field("Inventory Account"; rec."Inventory Account")
                    {

                    }
                    // field("Used in Ledger Entries"; rec."Used in Ledger Entries")
                    // {

                    // }
                    field("Inventory Account (Interim)"; rec."Inventory Account (Interim)")
                    {

                    }
                    field("WIP Account"; rec."WIP Account")
                    {

                    }
                    field("Material Variance Account"; rec."Material Variance Account")
                    {

                    }
                    field("Capacity Variance Account"; rec."Capacity Variance Account")
                    {

                    }
                    field("Subcontracted Variance Account"; rec."Subcontracted Variance Account")
                    {

                    }
                    field("Cap. Overhead Variance Account"; rec."Cap. Overhead Variance Account")
                    {

                    }
                    field("Mfg. Overhead Variance Account"; rec."Mfg. Overhead Variance Account")
                    {

                    }
                    field("Location Account Consumption"; rec."Location Account Consumption")
                    {

                    }
                    field("App.Account Locat Acc. Consum."; rec."App.Account Locat Acc. Consum.")
                    {

                    }
                    field("Analytic Concept"; rec."Analytic Concept")
                    {

                    }
                    field("App. Account Concept Analytic"; rec."App. Account Concept Analytic")
                    {

                    }

                }
                part("part1"; 7207524)
                {
                    ;
                }

            }

        }
    }
    actions
    {
        area(Creation)
        {

            action("action1")
            {
                CaptionML = ESP = 'Revisar Datos';
                Image = AdjustEntries;


                trigger OnAction()
                BEGIN
                    Revisar;
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
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        Revisar;

        QuoBuildingSetup.GET;
        J1 := QuoBuildingSetup."Location Proyect";
        J2 := QuoBuildingSetup."Create Location Equal To Proj.";

        //JAV 10/04/22: - QB 1.10.33 Se elimina el campo 50084 "Location Negative", en su lugar se usar� el campo del est�ndar de conf. almac�n
        InventorySetup.GET;
        C1 := InventorySetup."Prevent Negative Inventory";
    END;



    var
        QuoBuildingSetup: Record 7207278;
        InventorySetup: Record 313;
        Location: Record 14;
        Job: Record 167;
        DimensionValue: Record 349;
        FunctionQB: Codeunit 7207272;
        J1: Code[20];
        J2: Boolean;
        C1: Boolean;

    LOCAL procedure Revisar();
    begin
        //Si el almac�n es de un proyecto, se marca como tal
        Location.RESET;
        if (Location.FINDSET(TRUE)) then
            repeat
                if (Job.GET(Location.Code)) then begin
                    Location."QB Job Location" := TRUE;
                    Location.MODIFY;
                end;
            until (Location.NEXT = 0);

        //JAV 10/04/22: - QB 1.10.33 No se desmarca variaci�n autom�tica de existencias
        //No marcar coste autom�tico en configuraci�n
        //InventorySetup.GET;
        //InventorySetup."Automatic Cost Posting" := FALSE;
        //InventorySetup.MODIFY;
    end;

    // begin
    /*{
      JAV 10/04/22: - QB 1.10.33 Se elimina el campo 50084 "Location Negative", en su lugar se usar� el campo del est�ndar de conf. almac�n y no se desmarca variaci�n autom�tica de existencias
    }*///end
}








