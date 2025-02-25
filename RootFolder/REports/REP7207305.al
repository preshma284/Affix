report 7207305 "Job Budget Copy"
{


    ProcessingOnly = true;

    dataset
    {

    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group461")
                {

                    CaptionML = ENU = 'Option', ESP = 'Opciones';
                    group("group462")
                    {

                        CaptionML = ESP = 'Destino';
                        field("dJob"; "dJob")
                        {

                            CaptionML = ESP = 'Proyecto';
                            Enabled = FALSE;
                        }
                        field("dBudget"; "dBudget")
                        {

                            CaptionML = ESP = 'Presupuesto';
                            Enabled = FALSE;
                        }
                        field("InitialBudget"; "InitialBudget")
                        {

                            CaptionML = ESP = 'Presupuesto inicial';
                            Editable = FALSE;
                        }

                    }
                    group("group466")
                    {

                        CaptionML = ESP = 'Origen';
                        field("oJob"; "oJob")
                        {

                            CaptionML = ESP = 'Proyecto';
                            TableRelation = Job WHERE("Card Type" = CONST("Proyecto operativo"));
                        }
                        field("oBudget"; "oBudget")
                        {

                            CaptionML = ESP = 'Presupuesto';
                            TableRelation = "Job Budget"."Cod. Budget";

                            ; trigger OnLookup(var Text: Text): Boolean
                            BEGIN
                                JobBudget.RESET;
                                JobBudget.SETRANGE("Job No.", oJob);
                                CLEAR(JobBudgetList);
                                JobBudgetList.SETTABLEVIEW(JobBudget);
                                JobBudgetList.LOOKUPMODE(TRUE);
                                IF (JobBudgetList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
                                    JobBudgetList.GETRECORD(JobBudget);
                                    oBudget := JobBudget."Cod. Budget";
                                END;
                            END;


                        }
                        field("fUO"; "fUO")
                        {

                            CaptionML = ESP = 'Filtro U.O.';
                            ToolTipML = ESP = 'Si lo deja en blanco ser n todas, si no se copiar n solo las que indique en el filtro';
                        }

                    }
                    group("group470")
                    {

                        CaptionML = ESP = 'Opciones';
                        field("BudgetDelete"; "BudgetDelete")
                        {

                            CaptionML = ENU = 'Budget Delete', ESP = 'Borrar presupuesto';
                            Enabled = InitialBudget;
                        }
                        field("MeasureLineInclude"; "MeasureLineInclude")
                        {

                            CaptionML = ENU = 'Measure Lines Included', ESP = 'Incluir l¡neas de medici¢n';
                            Enabled = InitialBudget;
                        }
                        field("CodePrefix"; "CodePrefix")
                        {

                            CaptionML = ENU = 'Prefix for unit of work', ESP = 'Prefijo para unidad de obra';
                        }

                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       Job@7001121 :
        Job: Record 167;
        //       JobBudget@7001127 :
        JobBudget: Record 7207407;
        //       DataPieceworkForProduction@7001134 :
        DataPieceworkForProduction: Record 7207386;
        //       DataPieceworkForProduction2@7001105 :
        DataPieceworkForProduction2: Record 7207386;
        //       QBText@100000001 :
        QBText: Record 7206918;
        //       DefaultDimension@7001116 :
        DefaultDimension: Record 352;
        //       DefaultDimension2@7001115 :
        DefaultDimension2: Record 352;
        //       CommentLine@7001120 :
        CommentLine: Record 97;
        //       CommentLine2@7001106 :
        CommentLine2: Record 97;
        //       DataCostByPiecework@7001114 :
        DataCostByPiecework: Record 7207387;
        //       DataCostByPiecework2@7001113 :
        DataCostByPiecework2: Record 7207387;
        //       ExpectedTimeUnitData@7001132 :
        ExpectedTimeUnitData: Record 7207388;
        //       ExpectedTimeUnitData2@7001131 :
        ExpectedTimeUnitData2: Record 7207388;
        //       ManagementLineofMeasure@7001107 :
        ManagementLineofMeasure: Codeunit 7207292;
        //       JobBudgetList@7001122 :
        JobBudgetList: Page 7207598;
        //       Window@7001101 :
        Window: Dialog;
        //       Text001@7001108 :
        Text001: TextConst ENU = 'You must select a job.', ESP = 'Debe de seleccionar un proyecto.';
        //       Text002@7001109 :
        Text002: TextConst ENU = 'You can only select a job.', ESP = 'Debe selecciona un proyecto diferente al actual';
        //       NewPiecework@7001112 :
        NewPiecework: Code[20];
        //       Registro@7001133 :
        Registro: Integer;
        //       "--------------------------------- Opciones"@7001128 :
        "--------------------------------- Opciones": Integer;
        //       dJob@7001124 :
        dJob: Code[20];
        //       dBudget@7001125 :
        dBudget: Code[20];
        //       oJob@7001126 :
        oJob: Code[20];
        //       oBudget@7001123 :
        oBudget: Code[20];
        //       Text003@7001129 :
        Text003: TextConst ESP = 'Debe seleccionar un presupuesto de origen';
        //       BudgetDelete@7001103 :
        BudgetDelete: Boolean;
        //       InitialBudget@7001130 :
        InitialBudget: Boolean;
        //       MeasureLineInclude@7001111 :
        MeasureLineInclude: Boolean;
        //       CodePrefix@7001100 :
        CodePrefix: Code[2];
        //       Text004@7001104 :
        Text004: TextConst ENU = 'Will the entire job budget be erased, are you sure?', ESP = 'Se borrara todo el presupuesto actual del proyecto, ¨Esta seguro?';
        //       Text005@7001102 :
        Text005: TextConst ENU = 'Loading Cost Database\Piecework #1####################\Bill of Item   #2####################', ESP = 'Borrando';
        //       Text006@7001110 :
        Text006: TextConst ENU = 'Loading Cost Database\Piecework #1####################\Bill of Item   #2####################', ESP = 'Cargando\Unidad de obra #1####################\Descompuesto   #2####################';
        //       fUO@1100286000 :
        fUO: Text[50];
        //       CardType@1100286001 :
        CardType: Option;



    trigger OnInitReport();
    begin
        MeasureLineInclude := TRUE;
    end;

    trigger OnPreReport();
    begin
        if not Job.GET(dJob) then
            ERROR(Text001);

        if oJob = dJob then
            ERROR(Text002);

        Job.TESTFIELD("Starting Date");

        if not JobBudget.GET(oJob, oBudget) then
            ERROR(Text003);

        if BudgetDelete then
            BorrarDatos;

        Window.OPEN(Text006);
        if (InitialBudget) then
            CargarInicial
        else
            CargarSucesivo;
        Window.CLOSE;
    end;



    LOCAL procedure BorrarDatos()
    begin
        if not CONFIRM(Text004, FALSE) then
            ERROR('Proceso cancelado');

        Window.OPEN(Text005);
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", dJob);
        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Heading);
        DataPieceworkForProduction.DELETEALL;

        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", dJob);
        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
        DataPieceworkForProduction.DELETEALL(TRUE);

        DataCostByPiecework.RESET;
        DataCostByPiecework.SETRANGE("Job No.", dJob);
        DataCostByPiecework.SETRANGE("Cod. Budget", dBudget);
        DataCostByPiecework.DELETEALL;
        Window.CLOSE;
    end;

    LOCAL procedure CargarInicial()
    begin
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", oJob);
        //JAV 09/07/19: - Se a¤ade el filtro de U.O.
        if (fUO <> '') then
            DataPieceworkForProduction.SETFILTER("Piecework Code", fUO);

        if (DataPieceworkForProduction.FINDSET(FALSE)) then
            repeat
                Window.UPDATE(1, FORMAT(DataPieceworkForProduction."Piecework Code" + ' ' + DataPieceworkForProduction.Description));

                NewPiecework := CodePrefix + DataPieceworkForProduction."Piecework Code";
                DataPieceworkForProduction.SETRANGE("Budget Filter", oBudget);//jmma
                DataPieceworkForProduction.CALCFIELDS("Budget Measure");//jmma

                DataPieceworkForProduction2 := DataPieceworkForProduction;
                DataPieceworkForProduction2."Job No." := dJob;
                DataPieceworkForProduction2."Piecework Code" := NewPiecework;
                //-Q18150
                DataPieceworkForProduction2."No. Record" := '';
                //+Q18150
                DataPieceworkForProduction2.INSERT(TRUE);

                DataPieceworkForProduction2.VALIDATE("Piecework Code", NewPiecework);
                DataPieceworkForProduction2.VALIDATE("Production Unit", TRUE);
                DataPieceworkForProduction2.SETRANGE("Budget Filter", oBudget);
                if DataPieceworkForProduction."Account Type" <> DataPieceworkForProduction2."Account Type"::Heading then
                    DataPieceworkForProduction2.VALIDATE("Budget Measure", DataPieceworkForProduction."Budget Measure");

                //JAV 05/10/19: - Se elimina de la tabla "data piecework for production" la funci¢n "GenerateUniqueCode" y se pasa al validate del campo "Unique code"
                //DataPieceworkForProduction2.GenerateUniqueCode;
                DataPieceworkForProduction2.VALIDATE("Unique Code", '');
                //JAV fin

                DataPieceworkForProduction2.VALIDATE(Totaling, '');
                DataPieceworkForProduction2.MODIFY;

                //Copio los comentarios asociados si existen
                CommentLine.RESET;
                //verify

                // CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::"14");
                CommentLine.SETRANGE("Table Name", 14);
                CommentLine.SETRANGE("No.", DataPieceworkForProduction."Unique Code");
                if CommentLine.FINDSET(TRUE, TRUE) then begin
                    repeat
                        CommentLine2.INIT;
                        CommentLine2.TRANSFERFIELDS(CommentLine);
                        //verify --> 2nd scenario
                        //CommentLine2."Table Name" := CommentLine2."Table Name"::"14";

                        CommentLine2."No." := DataPieceworkForProduction2."Unique Code";
                        CommentLine2.INSERT(TRUE);
                    until CommentLine.NEXT = 0;
                end;

                //Copio los textos adicionales si existen
                QBText.CopyTo(QBText.Table::Job, DataPieceworkForProduction."Job No.", DataPieceworkForProduction."Piecework Code", '',
                              QBText.Table::Job, DataPieceworkForProduction2."Job No.", DataPieceworkForProduction2."Piecework Code", '');

                //Copio las dimensiones si existen
                DefaultDimension.RESET;
                DefaultDimension.SETRANGE("Table ID", DATABASE::"Data Piecework For Production");
                DefaultDimension.SETRANGE("No.", DataPieceworkForProduction."Unique Code");
                if DefaultDimension.FINDSET(TRUE, TRUE) then begin
                    repeat
                        DefaultDimension2.INIT;
                        DefaultDimension2.TRANSFERFIELDS(DefaultDimension);
                        DefaultDimension2."Table ID" := DATABASE::"Data Piecework For Production";
                        DefaultDimension2."No." := DataPieceworkForProduction2."Unique Code";
                        DefaultDimension2.INSERT(TRUE);
                    until DefaultDimension.NEXT = 0;
                end;

                //    //adem s de cada una unidad de obra hay que crear una l¡nea de coste que viene determinado por su descompuesto
                //    DataCostByPiecework.RESET;
                //    DataCostByPiecework.SETRANGE("Job No.",oJob);
                //    DataCostByPiecework.SETRANGE("Piecework Code",DataPieceworkForProduction."Piecework Code");
                //    DataCostByPiecework.SETRANGE("Cod. Budget",oBudget);
                //    if DataCostByPiecework.FINDSET(false) then begin
                //      repeat
                //        Window.UPDATE(2,FORMAT(DataCostByPiecework."No."+' '+DataCostByPiecework."Cod. Budget"));
                //        DataCostByPiecework2.INIT;
                //        DataCostByPiecework2 := DataCostByPiecework;
                //        DataCostByPiecework2."Job No." := dJob;
                //        DataCostByPiecework2."Piecework Code" := NewPiecework;
                //        DataCostByPiecework2."Cod. Budget" := dBudget;
                //        DataCostByPiecework2.INSERT;
                //        DataCostByPiecework2."Unique Code" := DataPieceworkForProduction2."Unique Code";
                //        DataCostByPiecework2.MODIFY;
                //      until DataCostByPiecework.NEXT=0;
                //    end;

                if Job."% Margin" <> 0 then
                    DataPieceworkForProduction2.VALIDATE("% Of Margin", Job."% Margin");

                DataPieceworkForProduction2.MODIFY;

                if MeasureLineInclude then
                    ManagementLineofMeasure.CopyLinMeasurePOPD(oJob, oBudget, DataPieceworkForProduction."Piecework Code", dJob, dBudget, NewPiecework);

            until DataPieceworkForProduction.NEXT = 0;

        CargarSucesivo();
    end;

    LOCAL procedure CargarSucesivo()
    begin
        //Eliminar los datos anteriores
        DataCostByPiecework.RESET;
        DataCostByPiecework.SETRANGE("Job No.", dJob);
        DataCostByPiecework.SETRANGE("Cod. Budget", dBudget);
        DataCostByPiecework.DELETEALL;

        ExpectedTimeUnitData.RESET;
        ExpectedTimeUnitData.SETRANGE("Job No.", dJob);
        ExpectedTimeUnitData.SETRANGE("Budget Code", dBudget);
        ExpectedTimeUnitData.DELETEALL;

        //Crear los descompuestos, solo si existen en el proyecto
        DataCostByPiecework.RESET;
        DataCostByPiecework.SETRANGE("Job No.", oJob);
        DataCostByPiecework.SETRANGE("Cod. Budget", oBudget);

        if (DataCostByPiecework.FINDSET(FALSE)) then
            repeat
                if (DataPieceworkForProduction2.GET(oJob, NewPiecework)) then begin
                    NewPiecework := CodePrefix + DataCostByPiecework."Piecework Code";

                    Window.UPDATE(1, FORMAT(DataCostByPiecework."Piecework Code"));
                    Window.UPDATE(2, FORMAT(DataCostByPiecework."No." + ' ' + DataCostByPiecework."Cod. Budget"));
                    DataCostByPiecework2.INIT;
                    DataCostByPiecework2 := DataCostByPiecework;
                    DataCostByPiecework2."Job No." := dJob;
                    DataCostByPiecework2."Piecework Code" := NewPiecework;
                    DataCostByPiecework2."Cod. Budget" := dBudget;

                    DataCostByPiecework2.INSERT;
                    DataCostByPiecework2."Unique Code" := DataPieceworkForProduction2."Unique Code";

                    DataCostByPiecework2.MODIFY;
                end;
            until DataCostByPiecework.NEXT = 0;

        //Crear las mediciones, solo si existen en el proyecto
        ExpectedTimeUnitData.RESET;
        if (ExpectedTimeUnitData.FINDLAST) then
            Registro := ExpectedTimeUnitData."Entry No."
        else
            Registro := 0;

        ExpectedTimeUnitData.RESET;
        ExpectedTimeUnitData.SETRANGE("Job No.", oJob);
        ExpectedTimeUnitData.SETRANGE("Budget Code", oBudget);
        if (ExpectedTimeUnitData.FINDSET(FALSE)) then
            repeat
                if (DataPieceworkForProduction2.GET(oJob, ExpectedTimeUnitData."Piecework Code")) then begin
                    NewPiecework := CodePrefix + ExpectedTimeUnitData."Piecework Code";

                    Registro += 1;
                    ExpectedTimeUnitData2 := ExpectedTimeUnitData;
                    ExpectedTimeUnitData2."Entry No." := Registro;
                    ExpectedTimeUnitData2."Job No." := dJob;
                    ExpectedTimeUnitData2."Piecework Code" := NewPiecework;
                    ExpectedTimeUnitData2."Budget Code" := dBudget;
                    //-Q18150
                    ExpectedTimeUnitData2.Performed := FALSE;
                    //+Q18150
                    ExpectedTimeUnitData2.INSERT;
                end;
            until ExpectedTimeUnitData.NEXT = 0;
    end;

    //     procedure ColletData (parJob@7001100 : Code[20];parBudget@7001101 : Code[20];parInitial@7001102 :
    procedure ColletData(parJob: Code[20]; parBudget: Code[20]; parInitial: Boolean)
    begin
        dJob := parJob;
        dBudget := parBudget;
        InitialBudget := parInitial;
        BudgetDelete := InitialBudget;
    end;

    //     procedure SetCartdType (cType@1100286000 :
    procedure SetCartdType(cType: Option " ","Estudio","Proyecto operativo","Promocion","Presupuesto","Suelo")
    begin
        //RE16067-LCG-24122021-INI
        CardType := cType;
        //RE16067-LCG-24122021-FIN
    end;

    /*begin
    //{
//      jmma 27/03/19: - Se corrige y amplia para que funcione correctamente
//      JAV  11/04/19: - Se cambia la forma de acturar para que pueda traer cualquier presupuesto, se rehace completamente el report para hacerlo mas funcional
//      JAV  09/07/19: - Se a¤ade el filtro de U.O.
//      JAV  05/10/19: - Se elimina de la tabla "data piecework for production" la funci¢n "GenerateUniqueCode" y se pasa al validate del campo "Unique code"
//      AML  20/06/23: - Q18150 Se quita la marca Performed al copiar Y QUITAR EL NUM. DE EXPEDIENTE.
//    }
    end.
  */

}



