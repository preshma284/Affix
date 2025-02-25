report 7207277 "Bring Cost Database"
{


    CaptionML = ENU = 'Bring Cost Database', ESP = 'Traer preciario';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Cost Database"; "Cost Database")
        {

            DataItemTableView = SORTING("Code");
            ;
            DataItem("Piecework"; "Piecework")
            {

                DataItemTableView = SORTING("Cost Database Default", "No.");


                RequestFilterFields = "No.";
                DataItemLink = "Cost Database Default" = FIELD("Code");
                trigger OnPreDataItem();
                BEGIN
                    //jmma 270121
                    Piecework.SETRANGE("Cost Database Default", "Cost Database".Code);
                    //jmma 120221 se a¤ade la l¡nea inferior
                    IF opcSource <> '' THEN
                        Piecework.SETRANGE("Cost Database Default", opcSource);
                    IF (opcSource <> '') AND (UnitCopy <> '') THEN BEGIN
                        Piecework.SETRANGE("Cost Database Default", opcSource);
                        Piecework.SETRANGE("No.", UnitCopy);
                    END;

                    //JMMA SE PONE ARRIBA Piecework.SETRANGE( "Cost Database Default","Cost Database".Code);

                    Job.GET(V_Job);

                    //JMMA ERROR AL BORRAR SI SE LANZA DESDE PRESUPUESTO DE VENTA
                    IF CostBudget = '' THEN
                        CostBudget := Job."Current Piecework Budget";

                    IF (opcAction = opcAction::Eliminar) THEN BEGIN
                        Window.UPDATE(3, Text009);

                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETRANGE("Job No.", V_Job);
                        DataPieceworkForProduction.SETRANGE("Budget Filter", CostBudget);
                        //-Q20047
                        //JAV 02/10/19: - Solo borra los datos del tipo de preciario a cargar (directos, indirectos, ambos)
                        //CASE "Cost Database"."Type JU" OF
                        //  "Cost Database"."Type JU"::Direct   : DataPieceworkForProduction.SETFILTER(Type, '<>%1', "Unit Type"::Piecework);
                        //  "Cost Database"."Type JU"::Indirect : DataPieceworkForProduction.SETFILTER(Type, '=%1',  "Unit Type"::"Cost Units");
                        //END;
                        //
                        //JAV fin
                        IF DataPieceworkForProduction.FINDSET(TRUE, TRUE) THEN
                            REPEAT
                                Window.UPDATE(1, FORMAT(DataPieceworkForProduction."Code Cost Database" + ' ' + DataPieceworkForProduction.Description));
                                ////DeleteData(DataPieceworkForProduction."Customer Certification Unit",DataPieceworkForProduction."Production Unit",CostBudget,JobBudget."Actual Budget");
                                DataPieceworkForProduction.DeleteData(TRUE, TRUE);
                                DataPieceworkForProduction.DELETE(FALSE);  //Para que no pregunte cuando son unidades de mayor
                            UNTIL DataPieceworkForProduction.NEXT = 0;
                    END;

                    Window.UPDATE(3, Text010);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    IF Job.GET(V_Job) THEN;
                    IF SalesBudget <> '' THEN BEGIN
                        //-AML Q20043
                        //IF NOT Piecework."Certification Unit" THEN
                        IF NOT Piecework."Certification Unit" AND (("Cost Database"."Type JU" = "Cost Database"."Type JU"::Direct) OR ("Cost Database"."Type JU" = "Cost Database"."Type JU"::Booth)) THEN
                            //+AML
                            CurrReport.SKIP;
                    END ELSE BEGIN
                        IF NOT Job."Separation Job Unit/Cert. Unit" THEN BEGIN
                            DataPieceworkForProd_NR.RESET;
                            DataPieceworkForProd_NR.SETRANGE("Job No.", V_Job);
                            DataPieceworkForProd_NR.SETRANGE("Budget Filter", CostBudget);
                            DataPieceworkForProd_NR.SETRANGE("Piecework Code", Piecework."No.");
                            DataPieceworkForProd_NR.SETFILTER("No. Record", '<>%1', '');
                            IF DataPieceworkForProd_NR.FINDFIRST THEN
                                SalesBudget := DataPieceworkForProd_NR."No. Record";
                        END;
                    END;

                    //Si hay un expediente de venta, lo leemos para buscar su estado y ponerlo en las unidades de obra
                    RecordType := 0;
                    RecordStatus := 0;
                    IF Records.GET(V_Job, SalesBudget) THEN BEGIN
                        RecordType := Records."Record Type";
                        RecordStatus := Records."Record Status";
                    END;

                    //JAV 03/05/20: - Se busca el n£mero de la U.O. nueva
                    IF (lenInitialValue <> 0) THEN BEGIN
                        //Si ha cambiado la parte inicial del n£mero, incrementamos el valor
                        IF (COPYSTR(Piecework."No.", 1, lenInitialValue) <> antNo) THEN BEGIN
                            IF (antNo <> '') THEN
                                opcInitialValue := INCSTR(opcInitialValue);
                            antNo := Piecework."No.";
                        END;
                        newNumber := opcPrefix + opcInitialValue + COPYSTR(Piecework."No.", lenInitialValue + 1);
                    END ELSE BEGIN
                        newNumber := opcPrefix + Piecework."No.";
                    END;

                    //Si ya existe, dar un error para evitar problemas, ya que solo se puede con unidades de mayor, y eso es un caso muy raro
                    IF DataPieceworkForProduction2.GET(V_Job, newNumber) THEN
                        ERROR(Text005, newNumber);

                    Window.UPDATE(1, FORMAT(Piecework."No." + ' ' + Piecework.Description));
                    V_Multiplier := 0;

                    CLEAR(DataPieceworkForProduction);

                    DataPieceworkForProduction."Job No." := V_Job;
                    DataPieceworkForProduction.VALIDATE("Piecework Code", newNumber);
                    DataPieceworkForProduction.Type := Piecework."Unit Type";
                    DataPieceworkForProduction."Code Cost Database" := Piecework."Cost Database Default";
                    DataPieceworkForProduction."Code Piecework PRESTO" := Piecework."PRESTO Code Sales";
                    DataPieceworkForProduction.Type := Piecework."Unit Type";
                    //-AML Q20043 Q20047 Para costes Indirectos
                    IF "Cost Database"."Type JU" = "Cost Database"."Type JU"::Indirect THEN BEGIN
                        DataPieceworkForProduction.Type := DataPieceworkForProduction.Type::"Cost Unit";
                        DataPieceworkForProduction."Allocation Terms" := Piecework."Allocation Terms";
                        DataPieceworkForProduction."Subtype Cost" := Piecework."Subtype Cost";
                    END
                    ELSE BEGIN
                        DataPieceworkForProduction.Type := DataPieceworkForProduction.Type;
                    END;
                    //+AML

                    DataPieceworkForProduction.Description := Piecework.Description;
                    DataPieceworkForProduction."Description 2" := Piecework."Description 2";
                    DataPieceworkForProduction."Type Unit Cost" := Piecework."Type Cost Unit";
                    DataPieceworkForProduction."% Expense Cost" := 0;
                    DataPieceworkForProduction."Global Dimension 1 Code" := Piecework."Global Dimension 1 Code";
                    DataPieceworkForProduction."Global Dimension 2 Code" := Piecework."Global Dimension 2 Code";
                    DataPieceworkForProduction."Unit Of Measure" := Piecework."Units of Measure";
                    DataPieceworkForProduction.Blocked := Piecework.Blocked;
                    DataPieceworkForProduction."Subtype Cost" := Piecework."Subtype Cost";
                    DataPieceworkForProduction."Posting Group Unit Cost" := Piecework."Posting Group Unit Cost";
                    DataPieceworkForProduction."Allocation Terms" := Piecework."Allocation Terms";
                    DataPieceworkForProduction."Additional Auto Text" := Piecework."Automatic Additional Text";
                    DataPieceworkForProduction."Gross Profit Percentage" := Piecework."Gross Profit Percentage";
                    DataPieceworkForProduction."Periodic Cost" := Piecework."Periodic Cost";
                    DataPieceworkForProduction."Job Billing Structure" := Piecework."Jobs Structured Billing";
                    DataPieceworkForProduction."No. Subcontracting Resource" := Piecework."Resource Subcontracting Code";
                    DataPieceworkForProduction."Analytical Concept Subcon Code" := Piecework."Concept Analitycal Subcon Code";
                    DataPieceworkForProduction.VALIDATE("Activity Code", Piecework."Cod. Activity");//jmma
                                                                                                    //-Q20047
                    DataPieceworkForProduction.SETRANGE("Budget Filter", CostBudget);
                    //+Q20047
                    IF SalesBudget <> '' THEN BEGIN
                        DataPieceworkForProduction."No. Record" := SalesBudget;
                        //JAV 02/02/21 - QB 1.08.07 Al cargar el precio, poner en las unidades de obra el tipo y estado del expediente
                        DataPieceworkForProduction."Record Type" := RecordType;
                        DataPieceworkForProduction."Record Status" := RecordStatus;

                        DataPieceworkForProduction.VALIDATE("Customer Certification Unit", TRUE);
                        DataPieceworkForProduction.VALIDATE("Currency Code", Job."Currency Code");//jmma 080920 Divisas
                        IF NOT Job."Separation Job Unit/Cert. Unit" THEN
                            DataPieceworkForProduction.VALIDATE("Production Unit", TRUE);
                    END ELSE BEGIN
                        DataPieceworkForProduction.VALIDATE("Production Unit", TRUE);
                    END;

                    DataPieceworkForProduction."Account Type" := Piecework."Account Type";

                    IF Piecework."Unit Type" = Piecework."Unit Type"::Piecework THEN
                        DataPieceworkForProduction.VALIDATE("Initial Produc. Price", Piecework."Proposed Sale Price");

                    IF DataPieceworkForProductionCert.GET(DataPieceworkForProduction."Job No.", DataPieceworkForProduction."Piecework Code") AND (DataPieceworkForProductionCert."Customer Certification Unit") THEN BEGIN
                        DataPieceworkForProduction."Customer Certification Unit" := TRUE;
                        DataPieceworkForProduction."Unique Code" := DataPieceworkForProductionCert."Unique Code";
                        //JMMA 180920 corrige error al traer preciario s¢lo venta en partidas sin detalle de medici¢n
                        //DataPieceworkForProduction.VALIDATE("Sale Quantity (base)",DataPieceworkForProductionCert."Sales Amount (Base)");
                        DataPieceworkForProduction.VALIDATE("Sale Quantity (base)", DataPieceworkForProductionCert."Sale Quantity (base)");
                        DataPieceworkForProduction.VALIDATE("Contract Price", DataPieceworkForProductionCert."Contract Price");
                        DataPieceworkForProduction.VALIDATE("Currency Code", Job."Currency Code");//jmma 080920 Divisas
                    END ELSE BEGIN
                        IF (NOT Job."Separation Job Unit/Cert. Unit") OR (SalesBudget <> '') THEN BEGIN
                            IF Piecework."Account Type" = Piecework."Account Type"::Unit THEN BEGIN
                                IF (Piecework."Measurement Sale" = 0) THEN //JAV 18/08/20: - Nuevo campo de medici¢n de venta
                                    DataPieceworkForProduction.VALIDATE("Sale Quantity (base)", Piecework."Measurement Cost")
                                ELSE
                                    DataPieceworkForProduction.VALIDATE("Sale Quantity (base)", Piecework."Measurement Sale");
                                DataPieceworkForProduction.VALIDATE("Contract Price", Piecework."Proposed Sale Price");
                            END;
                            IF Piecework."Account Type" = Piecework."Account Type"::Heading THEN BEGIN
                                IF SeeIfChildrenPage THEN BEGIN
                                    DataPieceworkForProduction."Account Type" := DataPieceworkForProduction."Account Type"::Heading;
                                    DataPieceworkForProduction.Totaling := '';
                                    IF (Piecework."Measurement Sale" = 0) THEN //JAV 18/08/20: - Nuevo campo de medici¢n de venta
                                        DataPieceworkForProduction.VALIDATE("Sale Quantity (base)", Piecework."Measurement Cost")
                                    ELSE
                                        DataPieceworkForProduction.VALIDATE("Sale Quantity (base)", Piecework."Measurement Sale");
                                    DataPieceworkForProduction.VALIDATE("Contract Price", Piecework."Proposed Sale Price");
                                END;
                            END;
                        END ELSE BEGIN
                            IF (Job."Separation Job Unit/Cert. Unit") AND (SalesBudget <> '') THEN BEGIN
                                IF Piecework."Account Type" = Piecework."Account Type"::Heading THEN BEGIN
                                    IF SeeIfChildrenPage THEN BEGIN
                                        DataPieceworkForProduction."Account Type" := DataPieceworkForProduction."Account Type"::Unit;
                                        DataPieceworkForProduction.Totaling := '';
                                        DataPieceworkForProduction.VALIDATE("Currency Code", Job."Currency Code");//jmma 080920 Divisas
                                        IF (Piecework."Measurement Sale" = 0) THEN //JAV 18/08/20: - Nuevo campo de medici¢n de venta
                                            DataPieceworkForProduction.VALIDATE("Sale Quantity (base)", Piecework."Measurement Cost")
                                        ELSE
                                            DataPieceworkForProduction.VALIDATE("Sale Quantity (base)", Piecework."Measurement Sale");
                                        DataPieceworkForProduction.VALIDATE("Contract Price", Piecework."Proposed Sale Price");
                                    END;
                                END;
                            END;
                        END;
                    END;
                    IF (opcAction = opcAction::"A¤adir Descompuestos") THEN BEGIN
                        IF DataPieceworkForProduction.GET(V_Job, newNumber) THEN
                            ChargeUnits(TRUE)
                    END ELSE
                        ChargePiecework;
                    //-Q20047
                    IF "Cost Database"."Type JU" = "Cost Database"."Type JU"::Indirect THEN BEGIN

                        DataPieceworkForProduction."Allocation Terms" := Piecework."Allocation Terms";
                        DataPieceworkForProduction."Subtype Cost" := Piecework."Subtype Cost";
                        IF DataPieceworkForProduction."Allocation Terms" = DataPieceworkForProduction."Allocation Terms"::"Fixed Amount" THEN BEGIN
                            DataPieceworkForProduction."Date init" := Job."Starting Date";
                            DataPieceworkForProduction."Date end" := Job."Ending Date";
                            IF DataPieceworkForProduction."Subtype Cost" = DataPieceworkForProduction."Subtype Cost"::"Current Expenses" THEN BEGIN
                                DataPieceworkForProduction.VALIDATE("Cost Amount Base", 1);
                                DataPieceworkForProduction.VALIDATE("Measure Budg. Piecework Sol", DataPieceworkForProduction."Cost Amount Base");
                            END
                            ELSE BEGIN
                                DataPieceworkForProduction.VALIDATE("Cost Amount Base", Piecework."Base Price Cost");
                                DataPieceworkForProduction.VALIDATE("Measure Budg. Piecework Sol", Piecework."Base Price Cost");
                            END;
                        END
                        ELSE BEGIN
                            DataPieceworkForProduction.VALIDATE("% Expense Cost", 0);
                        END;
                    END;
                    DataPieceworkForProduction.MODIFY;
                    //+Q20047
                END;

                trigger OnPostDataItem();
                BEGIN
                    DataPieceworkForProduction.RESET;
                    DataPieceworkForProduction.SETRANGE("Job No.", V_Job);
                    DataPieceworkForProduction.SETRANGE("Budget Filter", CostBudget);
                    IF DataPieceworkForProduction.FINDSET(FALSE, FALSE) THEN
                        REPEAT
                            IF DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Heading THEN BEGIN
                                DataPieceworkForProduction."Sale Amount" := 0;
                                DataPieceworkForProduction."Amount Sale Contract" := 0;
                                DataPieceworkForProductionP.RESET;
                                DataPieceworkForProductionP.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
                                DataPieceworkForProductionP.SETFILTER("Piecework Code", DataPieceworkForProduction.Totaling);
                                DataPieceworkForProductionP.SETRANGE("Account Type", DataPieceworkForProductionP."Account Type"::Unit);
                                DataPieceworkForProductionP.SETRANGE("Customer Certification Unit", TRUE);
                                IF DataPieceworkForProductionP.FINDSET THEN
                                    REPEAT
                                        DataPieceworkForProduction."Amount Sale Contract" += DataPieceworkForProductionP."Amount Sale Contract";
                                        DataPieceworkForProduction."Sale Amount" += DataPieceworkForProductionP."Sale Amount";
                                    UNTIL DataPieceworkForProductionP.NEXT = 0;
                                DataPieceworkForProduction.MODIFY;
                            END;
                        UNTIL DataPieceworkForProduction.NEXT = 0;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                IF (NOT opcProcess) THEN
                    "Cost Database".SETRANGE(Code, opcSource);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                CLEAR(CurrencyQ);
                CurrencyQ.InitRoundingPrecision;

                lenInitialValue := STRLEN(opcInitialValue);
            END;

            trigger OnPostDataItem();
            VAR
                //                                 JobsChangesLog@1100286000 :
                JobsChangesLog: Codeunit 7207356;
            BEGIN
                IF (NOT opcProcess) THEN BEGIN
                    //JAV 18/03/19: - Se guarda el £ltimo preciario cargado en la ficha del proyecto
                    Job.GET(V_Job);
                    IF ("Cost Database"."Type JU" IN ["Cost Database"."Type JU"::Direct, "Cost Database"."Type JU"::Booth]) THEN BEGIN
                        Job."Import Cost Database Direct" := "Cost Database".Code;
                        Job."Import Cost Database Dir. Date" := CURRENTDATETIME;
                    END;
                    IF ("Cost Database"."Type JU" IN ["Cost Database"."Type JU"::Indirect, "Cost Database"."Type JU"::Booth]) THEN BEGIN
                        Job."Import Cost Database Indirect" := "Cost Database".Code;
                        Job."Import Cost Database Ind. Date" := CURRENTDATETIME;
                    END;
                    Job.MODIFY;
                    //JAV 18/03/19 fin

                    //JAV 02/10/19: - Guardar en el log de cambios del proyecto
                    JobsChangesLog.AddCostDatabase(Job, "Cost Database", opcIncludeCostMeasure, opcIncludeSaleDataCost, opcIncludeSaleMeasure, opcRespect, (opcAction = opcAction::Eliminar));
                END;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group378")
                {

                    CaptionML = ENU = 'Options';
                    field("opcSource"; "opcSource")
                    {

                        CaptionML = ESP = 'Preciario a cargar';
                        TableRelation = "Cost Database";
                    }
                    field("opcIncludeCostMeasure"; "opcIncludeCostMeasure")
                    {

                        CaptionML = ENU = 'Incluir descompuesto de l¡neas de medici¢n', ESP = 'Incluir L¡neas de medici¢n de coste';
                    }
                    field("opcIncludeSaleDataCost"; "opcIncludeSaleDataCost")
                    {

                        CaptionML = ESP = 'Incluir descompuestos de venta';
                    }
                    field("opcIncludeSaleMeasure"; "opcIncludeSaleMeasure")
                    {

                        CaptionML = ENU = 'Incluir descompuesto de l¡neas de medici¢n', ESP = 'Incluir L¡neas de medici¢n de venta';
                    }
                    field("opcRespect"; "opcRespect")
                    {

                        CaptionML = ESP = 'Respetar precios preciario';
                    }
                    field("opcAction"; "opcAction")
                    {

                        CaptionML = ENU = 'Delete current Pieceword', ESP = 'Acci¢n Unidades de Obra actuales';

                        ; trigger OnValidate()
                        BEGIN
                            CASE opcAction OF
                                opcAction::Eliminar:
                                    MESSAGE(Text001);
                                opcAction::Mezclar:
                                    MESSAGE(Text002);
                                opcAction::"A¤adir Descompuestos":
                                    MESSAGE(Text003);
                            END;
                        END;


                    }
                    field("opcPrefix"; "opcPrefix")
                    {

                        CaptionML = ESP = 'A¤adir prefijo';
                    }
                    field("opcInitialValue"; "opcInitialValue")
                    {

                        CaptionML = ESP = 'Renumerar a partir de';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       QuoBuildingSetup@1000000103 :
        QuoBuildingSetup: Record 7207278;
        //       CurrencyQ@1100286118 :
        CurrencyQ: Record 4;
        //       Job@1100286017 :
        Job: Record 167;
        //       DataPieceworkForProduction@1100286016 :
        DataPieceworkForProduction: Record 7207386;
        //       DataPieceworkForProductionCert@1100286015 :
        DataPieceworkForProductionCert: Record 7207386;
        //       DataPieceworkForProductionP@1100286006 :
        DataPieceworkForProductionP: Record 7207386;
        //       DataPieceworkForProd_NR@1100286005 :
        DataPieceworkForProd_NR: Record 7207386;
        //       TemDataPieceworkForProd_NR@1100286004 :
        TemDataPieceworkForProd_NR: Record 7207386 TEMPORARY;
        //       DataPieceworkForProduction2@1100286003 :
        DataPieceworkForProduction2: Record 7207386;
        //       CommentLine@1100286014 :
        CommentLine: Record 97;
        //       CommentLine2@1100286013 :
        CommentLine2: Record 97;
        //       QBText@1100286012 :
        QBText: Record 7206918;
        //       DefaultDimension@1100286011 :
        DefaultDimension: Record 352;
        //       DefaultDimension2@1100286010 :
        DefaultDimension2: Record 352;
        //       BillofItemData@1100286009 :
        BillofItemData: Record 7207384;
        //       DataCostByJU@1000000108 :
        DataCostByJU: Record 7207387;
        //       JobBudget@1100286007 :
        JobBudget: Record 7207407;
        //       DataCostByPieceworkCert@1100286031 :
        DataCostByPieceworkCert: Record 7207340;
        //       MeasureLinePieceworkCertif@1100286032 :
        MeasureLinePieceworkCertif: Record 7207343;
        //       Records@1100286041 :
        Records: Record 7207393;
        //       ManagementLineofMeasure@1100286019 :
        ManagementLineofMeasure: Codeunit 7207292;
        //       Window@7001100 :
        Window: Dialog;
        //       Text000@7001102 :
        Text000: TextConst ENU = 'You must filter for a cost database', ESP = 'Debe de filtrar por un preciario';
        //       UnitCopy@7001107 :
        UnitCopy: Code[20];
        //       V_Job@7001109 :
        V_Job: Code[20];
        //       SalesBudget@7001110 :
        SalesBudget: Code[20];
        //       CostBudget@1100286025 :
        CostBudget: Code[20];
        //       Prefix@7001114 :
        Prefix: Code[20];
        //       V_Multiplier@7001116 :
        V_Multiplier: Decimal;
        //       V_Identation@7001128 :
        V_Identation: Integer;
        //       antNo@1100286021 :
        antNo: Code[20];
        //       lenInitialValue@1100286022 :
        lenInitialValue: Integer;
        //       newNumber@1100286023 :
        newNumber: Code[20];
        //       SaleBudget@1100286026 :
        SaleBudget: Boolean;
        //       Total@1100286034 :
        Total: Decimal;
        //       RecordType@1100286043 :
        RecordType: Integer;
        //       RecordStatus@1100286042 :
        RecordStatus: Integer;
        //       "------------------------------------------- Opciones"@1100286029 :
        "------------------------------------------- Opciones": Integer;
        //       opcSource@1100286024 :
        opcSource: Code[20];
        //       opcIncludeCostMeasure@1100286028 :
        opcIncludeCostMeasure: Boolean;
        //       opcIncludeSaleDataCost@1100286030 :
        opcIncludeSaleDataCost: Boolean;
        //       opcIncludeSaleMeasure@1100286000 :
        opcIncludeSaleMeasure: Boolean;
        //       opcRespect@1100286001 :
        opcRespect: Boolean;
        //       opcAction@1100286002 :
        opcAction: Option "Eliminar","Mezclar","A¤adir Descompuestos";
        //       opcInitialValue@1100286020 :
        opcInitialValue: Code[20];
        //       Text001@1100286040 :
        Text001: TextConst ENU = 'The previous Piecework and all related tables will be erased', ESP = 'Se borrar n las Unidades de Obra existentes y todas las tablas relacionadas';
        //       Text002@1100286039 :
        Text002: TextConst ENU = 'The previous Piecework and all related tables will be erased', ESP = 'Se actualizar n las Unidades de Obra existentes, mezcl ndolas con las nuevas';
        //       Text003@1100286033 :
        Text003: TextConst ENU = 'It is Pieceword previous and will act with the new one, mixing it', ESP = 'Se a¤adir n descompuestos a las Unidades de Obra existentes';
        //       Text004@7001101 :
        Text004: TextConst ENU = 'Loading Cost Database\Jobs Units #1####################\Bill of Item   #2####################', ESP = '#3############# Preciario\Unidad de obra: #1####################\Descompuesto: #2####################';
        //       Text005@1100286038 :
        Text005: TextConst ESP = 'Ya existe la Unidad de Obra %1, no se puede reemplazar';
        //       Text007@7001146 :
        Text007: TextConst ESP = 'Se va a reemplazar la informaci¢n del Cap¡tulo/Subcap¡tulo %1 %2. ¨Est  de acuerdo?.';
        //       Text008@7001147 :
        Text008: TextConst ESP = 'No se puede reemplazar una unidad de obra con el Tipo Mov. unidad';
        //       opcPrefix@1100286027 :
        opcPrefix: Code[3];
        //       opcProcess@1100286035 :
        opcProcess: Boolean;
        //       Text009@1100286036 :
        Text009: TextConst ESP = 'Borrando';
        //       Text010@1100286037 :
        Text010: TextConst ESP = 'Cargando';



    trigger OnInitReport();
    begin
        //JAV 24/09/19: - Por defecto no marca borrar el anterior pues es mas peligroso, y se marcan las otras opciones que son habituales marcar siempre
        opcSource := '';
        opcIncludeCostMeasure := TRUE;
        opcIncludeSaleDataCost := TRUE;
        opcIncludeSaleMeasure := TRUE;
        opcRespect := TRUE;
        opcAction := opcAction::Mezclar;
        opcPrefix := '';
        opcInitialValue := '';
        opcProcess := FALSE;
    end;

    trigger OnPreReport();
    begin
        if (not opcProcess) and (opcSource = '') then
            ERROR(Text000);

        Window.OPEN(Text004);
    end;



    procedure SeeIfChildrenPage(): Boolean;
    var
        //       P_JobsUnits@7001100 :
        P_JobsUnits: Record 7207277;
    begin
        if Piecework."Account Type" = Piecework."Account Type"::Unit then
            exit(TRUE);
        P_JobsUnits.SETRANGE("Cost Database Default", Piecework."Cost Database Default");
        P_JobsUnits.SETFILTER("No.", Piecework.Totaling);
        if P_JobsUnits.FINDSET then
            repeat
                if (P_JobsUnits."No." <> Piecework."No.") then begin
                    if (P_JobsUnits."Account Type" = P_JobsUnits."Account Type"::Heading) or
                       (P_JobsUnits."Certification Unit") then
                        exit(FALSE);
                end;
            until P_JobsUnits.NEXT = 0;
        exit(TRUE);
    end;

    procedure Multiplier()
    var
        //       P_JobsUnits@7001100 :
        P_JobsUnits: Record 7207277;
    begin
        V_Multiplier := 1;
        P_JobsUnits.SETRANGE("Cost Database Default", Piecework."Cost Database Default");
        P_JobsUnits.SETRANGE("Account Type", Piecework."Account Type"::Heading);
        if P_JobsUnits.FINDSET then
            repeat
                if COPYSTR(Piecework."No.", 1, STRLEN(P_JobsUnits."No.")) = P_JobsUnits."No." then begin
                    if P_JobsUnits."Measurement Cost" <> 0 then
                        V_Multiplier := V_Multiplier * P_JobsUnits."Measurement Cost"
                    else
                        // Antes estaba por 0 y ahora ponemos por cero porque hay unidades que vienen con medici¢n cero
                        V_Multiplier := V_Multiplier * 0;
                end;
            until P_JobsUnits.NEXT = 0;
    end;

    //     procedure GatherDate (NoJob@7001100 : Code[20];codBudget@7001102 :
    procedure GatherDate(NoJob: Code[20]; codBudget: Code[20])
    begin
        V_Job := NoJob;
        CostBudget := codBudget;
    end;

    //     procedure JumpFilter (pNextJU@7001101 : Code[20];pRespect@7001102 : Boolean;pIdent@7001103 :
    procedure JumpFilter(pNextJU: Code[20]; pRespect: Boolean; pIdent: Integer)
    begin
        opcInitialValue := pNextJU;
        opcAction := opcAction::Mezclar;
        opcRespect := pRespect;
        V_Identation := pIdent;
        opcProcess := TRUE;
    end;

    //     procedure GatherDateJU (P_DataJobUnitForProduction@7001100 :
    procedure GatherDateJU(P_DataJobUnitForProduction: Record 7207386)
    begin
        DataPieceworkForProduction := P_DataJobUnitForProduction;
    end;

    //     procedure GatherRecord (pSalesBudget@7001100 :
    procedure GatherRecord(pSalesBudget: Code[20])
    begin
        SalesBudget := pSalesBudget;
    end;

    //     procedure StartDataDistinction (P_CodePrefix@7001100 : Code[20];P_CodeJobUnit@7001101 : Code[20];P_CodeCostDatabase@7001102 : Code[20];P_RespectPrice@7001103 : Boolean;P_DataMeasure@7001104 :
    procedure StartDataDistinction(P_CodePrefix: Code[20]; P_CodeJobUnit: Code[20]; P_CodeCostDatabase: Code[20]; P_RespectPrice: Boolean; P_DataMeasure: Boolean)
    begin
        //Esta funci¢n se llama al Inicializar la producci¢n a partir de la venta, para luego lanzar el report sin pantalla.
        opcPrefix := P_CodePrefix;
        UnitCopy := P_CodeJobUnit;
        opcSource := P_CodeCostDatabase;
        opcIncludeCostMeasure := P_DataMeasure;
        opcIncludeSaleDataCost := FALSE;
        opcIncludeSaleMeasure := FALSE;
        opcRespect := P_RespectPrice;
    end;

    //     procedure DeleteData (DeleteCertification@1100251000 : Boolean;DeleteProduction@1100251001 : Boolean;budgetCode@7001100 : Code[20];BudgetCurrent@7001105 :
    procedure DeleteData(DeleteCertification: Boolean; DeleteProduction: Boolean; budgetCode: Code[20]; BudgetCurrent: Boolean)
    var
        //       HistMeasurementsLines@7207771 :
        HistMeasurementsLines: Record 7207339;
        //       MeasureLineJUCertification@7207772 :
        MeasureLineJUCertification: Record 7207343;
        //       HistLinesMeasuresProd@7207775 :
        HistLinesMeasuresProd: Record 7207402;
        //       JobLedgerEntry@7207776 :
        JobLedgerEntry: Record 169;
        //       MeasurementLinesJUProd@7207777 :
        MeasurementLinesJUProd: Record 7207390;
        //       DataCostByJU@1000000108 :
        DataCostByJU: Record 7207387;
        //       ForecastDataAmountsJU@7207779 :
        ForecastDataAmountsJU: Record 7207392;
        //       PeriodificationUnitCost@7207780 :
        PeriodificationUnitCost: Record 7207432;
        //       CommentLine@7207781 :
        CommentLine: Record 97;
        //       DefaultDimension@7207782 :
        DefaultDimension: Record 352;
        //       HistSalePricesJU@7207783 :
        HistSalePricesJU: Record 7207385;
        //       Text010@7001101 :
        Text010: TextConst ENU = 'There are regsitradas measurements for the piecework %1 job %2', ESP = 'Existen mediciones regsitradas para la unidad de obra %1 proyecto %2';
        //       RelCertificationproduct@7001102 :
        RelCertificationproduct: Record 7207397;
        //       ExpectedTimeUnitData@7001103 :
        ExpectedTimeUnitData: Record 7207388;
        //       Text004@7001104 :
        Text004: TextConst ENU = 'When there are allocations for the piecework %1, the record can not be deleted', ESP = 'Al existir imputaciones para la unidad de obra %1 no se puede eliminar el registro';
    begin
        if DeleteCertification then begin
            DataPieceworkForProduction.VALIDATE("Sales Amount (Base)", 0);
            DataPieceworkForProduction.VALIDATE("Unit Price Sale (base)", 0);

            HistMeasurementsLines.RESET;
            HistMeasurementsLines.SETCURRENTKEY("Job No.", "Piecework No.");
            HistMeasurementsLines.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
            HistMeasurementsLines.SETRANGE("Piecework No.", DataPieceworkForProduction."Piecework Code");
            if HistMeasurementsLines.FINDFIRST then
                if budgetCode = 'MASTER' then
                    ERROR(Text010, DataPieceworkForProduction."Piecework Code", DataPieceworkForProduction."Job No.");

            //Borrar las mediciones
            MeasureLineJUCertification.RESET;
            MeasureLineJUCertification.SETCURRENTKEY("Job No.", "Piecework Code", "Line No.");
            MeasureLineJUCertification.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
            MeasureLineJUCertification.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
            MeasureLineJUCertification.DELETEALL;

            //Borramos los descompuestos de venta
            DataCostByPieceworkCert.RESET;
            DataCostByPieceworkCert.SETCURRENTKEY("Job No.", "Piecework Code");
            DataCostByPieceworkCert.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
            DataCostByPieceworkCert.SETRANGE("Job No.", DataPieceworkForProduction."Piecework Code");
            DataCostByPieceworkCert.DELETEALL;

            //borramos las relaciones
            RelCertificationproduct.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
            if DataPieceworkForProduction."Production Unit" then
                RelCertificationproduct.SETRANGE("Production Unit Code", DataPieceworkForProduction."Piecework Code");
            if DataPieceworkForProduction."Customer Certification Unit" then
                RelCertificationproduct.SETRANGE("Certification Unit Code", DataPieceworkForProduction."Piecework Code");
            RelCertificationproduct.DELETEALL;

        end;

        if DeleteProduction then begin
            HistLinesMeasuresProd.RESET;
            HistLinesMeasuresProd.SETCURRENTKEY("Job No.", "Piecework No.", "Posting Date");
            HistLinesMeasuresProd.SETRANGE(HistLinesMeasuresProd."Piecework No.", DataPieceworkForProduction."Piecework Code");
            HistLinesMeasuresProd.SETRANGE(HistLinesMeasuresProd."Job No.", DataPieceworkForProduction."Job No.");
            if HistLinesMeasuresProd.FINDFIRST then
                if JobBudget."Actual Budget" = TRUE then
                    ERROR(Text004, DataPieceworkForProduction."Job No.");

            JobLedgerEntry.RESET;
            JobLedgerEntry.SETCURRENTKEY("Job No.", "Posting Date", Type, "No.", "Entry Type", "Piecework No.");
            JobLedgerEntry.SETRANGE(JobLedgerEntry."Job No.", DataPieceworkForProduction."Job No.");
            JobLedgerEntry.SETRANGE(JobLedgerEntry."Piecework No.", DataPieceworkForProduction."Piecework Code");
            if JobLedgerEntry.FINDFIRST then
                if CostBudget = 'MASTER' then
                    ERROR(Text004, DataPieceworkForProduction."Job No.");

            MeasurementLinesJUProd.RESET;
            MeasurementLinesJUProd.SETCURRENTKEY("Job No.", "Piecework Code");
            MeasurementLinesJUProd.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
            MeasurementLinesJUProd.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
            MeasurementLinesJUProd.SETRANGE("Code Budget", CostBudget);
            if MeasurementLinesJUProd.FINDFIRST then
                MeasurementLinesJUProd.DELETEALL(TRUE);

            ExpectedTimeUnitData.RESET;
            ExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code");
            ExpectedTimeUnitData.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
            ExpectedTimeUnitData.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
            ExpectedTimeUnitData.SETRANGE("Budget Code", budgetCode);
            ExpectedTimeUnitData.DELETEALL(TRUE);

            DataCostByJU.RESET;
            DataCostByJU.SETCURRENTKEY("Job No.", "Piecework Code");
            DataCostByJU.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
            DataCostByJU.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
            DataCostByJU.SETRANGE("Cod. Budget", budgetCode);
            DataCostByJU.DELETEALL(TRUE);

            ForecastDataAmountsJU.SETCURRENTKEY("Job No.");
            ForecastDataAmountsJU.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
            ForecastDataAmountsJU.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
            ForecastDataAmountsJU.SETRANGE("Cod. Budget", CostBudget);
            //JAV 20/10/21: - QB 1.09.22 Considerar £nicamente ingresos y gastos, no certificaciones
            ForecastDataAmountsJU.SETFILTER("Unit Type", '%1|%2', ForecastDataAmountsJU."Entry Type"::Expenses, ForecastDataAmountsJU."Entry Type"::Incomes);

            ForecastDataAmountsJU.DELETEALL;

            //si borran borramos las periodificaciones de la Unit de coste
            PeriodificationUnitCost.RESET;
            PeriodificationUnitCost.SETCURRENTKEY("Job No.", "Unit Cost", Date);
            PeriodificationUnitCost.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
            PeriodificationUnitCost.SETRANGE("Unit Cost", DataPieceworkForProduction."Piecework Code");
            PeriodificationUnitCost.SETRANGE("Cod. Budget", CostBudget);
            PeriodificationUnitCost.DELETEALL(TRUE);

            //Borramos los comentarios asociados.
            CommentLine.RESET;
            CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::"Job Cost Piecework");
            CommentLine.SETRANGE("No.", DataPieceworkForProduction."Unique Code");
            CommentLine.DELETEALL(TRUE);


            //Borramos las dimensiones.
            DefaultDimension.RESET;
            DefaultDimension.SETRANGE("Table ID", DATABASE::"Data Piecework For Production");
            DefaultDimension.SETRANGE("No.", DataPieceworkForProduction."Unique Code");
            DefaultDimension.DELETEALL(TRUE);

            HistSalePricesJU.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
            HistSalePricesJU.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
            HistSalePricesJU.DELETEALL(TRUE);

            //ponemos datos en blanco
            DataPieceworkForProduction."% Expense Cost" := 0;
            DataPieceworkForProduction."Initial Produc. Price" := 0;

            //borramos las relaciones
            RelCertificationproduct.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
            if DataPieceworkForProduction."Production Unit" then
                RelCertificationproduct.SETRANGE("Production Unit Code", DataPieceworkForProduction."Piecework Code");
            if DataPieceworkForProduction."Customer Certification Unit" then
                RelCertificationproduct.SETRANGE("Certification Unit Code", DataPieceworkForProduction."Piecework Code");
            RelCertificationproduct.DELETEALL;

        end;
    end;

    //     procedure SetBudgetType (IsSale@1100286000 :
    procedure SetBudgetType(IsSale: Boolean)
    begin
        //Q9291
        SaleBudget := IsSale;
    end;

    LOCAL procedure ChargePiecework()
    begin
        if DataPieceworkForProduction."Customer Certification Unit" then begin
            if not DataPieceworkForProduction.INSERT(TRUE) then
                if not DataPieceworkForProduction.MODIFY(TRUE) then
                    CurrReport.SKIP;
        end else begin
            if not DataPieceworkForProduction.INSERT(TRUE) then
                CurrReport.SKIP;
        end;

        COMMIT;

        //JMMA correcci¢n por importaci¢n bce a presupuesto distinto de inicial
        DataPieceworkForProduction.SETRANGE("Budget Filter", CostBudget);

        if Piecework."Account Type" = Piecework."Account Type"::Unit then begin
            Multiplier;
        end else begin
            if SalesBudget <> '' then
                V_Multiplier := 1;
        end;

        // Copia los comentarios asociados si existen
        CommentLine.RESET;
        CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::Piecework);
        CommentLine.SETRANGE("No.", Piecework."Unique Code");
        if CommentLine.FINDFIRST then begin
            repeat
                CommentLine2.INIT;
                CommentLine2.TRANSFERFIELDS(CommentLine);
                CommentLine2."Table Name" := CommentLine2."Table Name"::"Job Cost Piecework";
                CommentLine2."No." := DataPieceworkForProduction."Unique Code";
                if not CommentLine2.INSERT(TRUE) then
                    CommentLine2.MODIFY(TRUE);
            until CommentLine.NEXT = 0;
        end;

        // Copiar textos adicionales si existen
        QBText.CopyTo(QBText.Table::Preciario, Piecework."Cost Database Default", Piecework."No.", '',
                      QBText.Table::Job, DataPieceworkForProduction."Job No.", DataPieceworkForProduction."Piecework Code", '');

        // Copiar las dimensiones si exiten
        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", DATABASE::Piecework);
        DefaultDimension.SETRANGE("No.", Piecework."Unique Code");
        if DefaultDimension.FINDFIRST then begin
            repeat
                DefaultDimension2.INIT;
                DefaultDimension2.TRANSFERFIELDS(DefaultDimension);
                DefaultDimension2."Table ID" := DATABASE::"Data Piecework For Production";
                DefaultDimension2."No." := DataPieceworkForProduction."Unique Code";
                if not DefaultDimension2.INSERT(TRUE) then
                    DefaultDimension2.MODIFY(TRUE);
            until DefaultDimension.NEXT = 0;
        end;

        // Cargar los descompuestos de Coste
        ChargeUnits(FALSE);

        if (SalesBudget = '') or (not Job."Separation Job Unit/Cert. Unit") then begin
            if Piecework."Account Type" = Piecework."Account Type"::Unit then begin
                if DataPieceworkForProduction."Unit Of Measure" <> '%' then
                    DataPieceworkForProduction.VALIDATE("Measure Budg. Piecework Sol", Piecework."Measurement Cost" * V_Multiplier)
                else
                    DataPieceworkForProduction.VALIDATE("Measure Budg. Piecework Sol", 1 * V_Multiplier);
            end else
                DataPieceworkForProduction.VALIDATE("Measure Budg. Piecework Sol", 0);
        end else begin
            if DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Unit then begin
                if DataPieceworkForProduction."Unit Of Measure" <> '%' then
                    DataPieceworkForProduction."Measure Budg. Piecework Sol" := Piecework."Measurement Cost" * V_Multiplier
                else
                    DataPieceworkForProduction."Measure Budg. Piecework Sol" := 1 * V_Multiplier;
            end else
                DataPieceworkForProduction."Measure Budg. Piecework Sol" := 0;
        end;

        if DataPieceworkForProduction."Customer Certification Unit" then begin
            DataPieceworkForProduction.VALIDATE("Sales Amount (Base)", DataPieceworkForProduction."Measure Budg. Piecework Sol");
        end;

        if V_Identation <> 0 then
            DataPieceworkForProduction.Indentation := V_Identation
        else
            DataPieceworkForProduction.Indentation := Piecework.Identation;

        if DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Heading then begin
            DataPieceworkForProduction.Totaling := DataPieceworkForProduction."Piecework Code" + '..' + PADSTR(DataPieceworkForProduction."Piecework Code", 20, '9');
        end;

        DataPieceworkForProduction."No. Subcontracting Resource" := Piecework."Resource Subcontracting Code";
        if Job."% Margin" <> 0 then begin
            if DataPieceworkForProduction.Type = DataPieceworkForProduction.Type::Piecework then
                DataPieceworkForProduction.VALIDATE("% Of Margin", Job."% Margin")
            else
                DataPieceworkForProduction.VALIDATE("% Of Margin", 0);
        end;
        DataPieceworkForProduction.MODIFY;

        //Incluir l¡neas de medici¢n de coste
        if opcIncludeCostMeasure then begin
            if Job."Card Type" = Job."Card Type"::"Proyecto operativo" then begin //Q9291 Si es un proyecto
                if SalesBudget = '' then
                    ManagementLineofMeasure.CopyPRESTO_To_Production(V_Job, "Cost Database".Code, Piecework."No.",
                                                                     DataPieceworkForProduction."Piecework Code",
                                                                     CostBudget) //jmma correcci¢n por importaci¢n bce a presupuesto distinto de inicial
                else begin
                    ManagementLineofMeasure.CopyPRESTO_To_Certification(V_Job, "Cost Database".Code, Piecework."No.", 0);
                    if not Job."Separation Job Unit/Cert. Unit" then begin
                        ManagementLineofMeasure.CopyPRESTO_To_Production(V_Job, "Cost Database".Code, Piecework."No.",
                                                                         DataPieceworkForProduction."Piecework Code",
                                                                         CostBudget); //jmma correcci¢n por importaci¢n bce a presupuesto distinto de inicial
                    end;
                end;
            end else begin  //Q9291 Si es un estudio
                if not SaleBudget then
                    ManagementLineofMeasure.CopyPRESTO_To_Production(V_Job, "Cost Database".Code, Piecework."No.",
                                                                     DataPieceworkForProduction."Piecework Code",
                                                                     CostBudget)
                else begin
                    ManagementLineofMeasure.CopyPRESTO_To_Certification(V_Job, "Cost Database".Code, Piecework."No.", 0);
                    if not Job."Separation Job Unit/Cert. Unit" then begin
                        ManagementLineofMeasure.CopyPRESTO_To_Production(V_Job, "Cost Database".Code, Piecework."No.",
                                                                         DataPieceworkForProduction."Piecework Code",
                                                                         CostBudget);
                    end;
                end;
            end;
        end;

        //Cargar los descompuestos de venta
        if (opcIncludeSaleDataCost) then begin
            BillofItemData.SETRANGE("Cod. Cost database", Piecework."Cost Database Default");
            BillofItemData.SETRANGE("Cod. Piecework", Piecework."No.");
            BillofItemData.SETRANGE(Use, BillofItemData.Use::Sales);       //Cargar solo descompuestos de venta
                                                                           //-Q20043
                                                                           //BillofItemData.SETFILTER(Type,'%1|%2',BillofItemData.Type::Item,BillofItemData.Type::Resource);
            BillofItemData.SETFILTER(Type, '%1|%2|%3', BillofItemData.Type::Item, BillofItemData.Type::Resource, BillofItemData.Type::Account);
            //+Q20043
            if BillofItemData.FINDFIRST then
                repeat
                    Window.UPDATE(2, 'V ' + FORMAT(BillofItemData."No." + ' ' + BillofItemData.Description));
                    CLEAR(DataCostByPieceworkCert);
                    DataCostByPieceworkCert.VALIDATE("Job No.", V_Job);
                    DataCostByPieceworkCert.VALIDATE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                    DataCostByPieceworkCert.VALIDATE("No. Record", SalesBudget);
                    DataCostByPieceworkCert.VALIDATE("Line Type", BillofItemData.Type);
                    DataCostByPieceworkCert.VALIDATE("No.", BillofItemData."No.");
                    DataCostByPieceworkCert.VALIDATE("Currency Code", "Cost Database".Currency); //JMMA divisas
                                                                                                 //-Q18970 AML Incluir el Order No para evitar repetidos
                    DataCostByPieceworkCert."Order No." := BillofItemData."Order No.";
                    //+Q18970
                    //JMMA 15/10/19 error precio, siempre trae el del recurso.
                    if opcRespect then
                        //AML -Q18285
                        //DataCostByPieceworkCert.VALIDATE("Sale Price", BillofItemData."Direct Unit Cost");
                        DataCostByPieceworkCert.VALIDATE("Sale Price", BillofItemData."Total Price");
                    //+Q18285

                    if BillofItemData."Bill of Item Units" <> 0 then
                        DataCostByPieceworkCert.VALIDATE("Performance By Piecework", BillofItemData."Quantity By" * BillofItemData."Bill of Item Units")
                    else
                        DataCostByPieceworkCert.VALIDATE("Performance By Piecework", BillofItemData."Quantity By");

                    if BillofItemData.Description <> '' then begin
                        DataCostByPieceworkCert.Description := BillofItemData.Description;
                        DataCostByPieceworkCert."Description 2" := BillofItemData."Description 2";
                    end;

                    DataCostByPieceworkCert."Code Cost Database" := BillofItemData."Cod. Cost database";
                    DataCostByPieceworkCert."Unique Code" := DataCostByPieceworkCert."Unique Code";
                    if not DataCostByPieceworkCert.INSERT(TRUE) then begin
                        //Q18970 PROBLEMA CON REPETIDOS
                        //DataCostByPieceworkCert.MODIFY(TRUE);
                        ERROR('%1 %2 duplicado', DataCostByPieceworkCert."Line Type", DataCostByPieceworkCert."No.");
                        //18970
                    end;
                    // Copiar textos adicionales si existen
                    QBText.CopyTo(QBText.Table::Preciario, BillofItemData."Cod. Cost database", BillofItemData."Cod. Piecework", BillofItemData."No.",
                                  QBText.Table::Job, DataCostByPieceworkCert."Job No.", DataCostByPieceworkCert."Piecework Code", DataCostByPieceworkCert."No.");

                until BillofItemData.NEXT = 0;
        end;

        //Incluir l¡neas de medici¢n de venta
        if opcIncludeSaleMeasure then begin
            //Elimino las que se hayan creado por el proceso de costes si voy a cargar las de venta
            MeasureLinePieceworkCertif.RESET;
            MeasureLinePieceworkCertif.SETRANGE("Job No.", V_Job);
            MeasureLinePieceworkCertif.SETRANGE("Piecework Code", Piecework."No.");
            MeasureLinePieceworkCertif.DELETEALL(TRUE);

            ManagementLineofMeasure.CopyPRESTO_To_Certification(V_Job, "Cost Database".Code, Piecework."No.", 1);
        end;
    end;

    //     LOCAL procedure ChargeUnitsBAK (pAddOnly@1100286000 :
    LOCAL procedure ChargeUnitsBAK(pAddOnly: Boolean)
    begin
        // Cargar los descompuestos de Coste
        //-Q20047 Para los % de produccion y de coste para indirectos no necesitamos descompuesto.
        if (Piecework."Allocation Terms" = Piecework."Allocation Terms"::"% about direct cost") or (Piecework."Allocation Terms" = Piecework."Allocation Terms"::"% about production") then exit;
        //+Q20047
        BillofItemData.SETRANGE("Cod. Cost database", Piecework."Cost Database Default");
        BillofItemData.SETRANGE("Cod. Piecework", Piecework."No.");
        BillofItemData.SETRANGE(Use, BillofItemData.Use::Cost);       //Cargar solo descompuestos de coste
                                                                      //-Q20043
                                                                      //BillofItemData.SETFILTER(Type,'%1|%2',BillofItemData.Type::Item,BillofItemData.Type::Resource);
        BillofItemData.SETFILTER(Type, '%1|%2|%3', BillofItemData.Type::Item, BillofItemData.Type::Resource, BillofItemData.Type::Account);
        //+Q20043
        if BillofItemData.FINDFIRST then
            repeat
                Window.UPDATE(2, 'C ' + FORMAT(BillofItemData."No." + ' ' + BillofItemData.Description));
                CLEAR(DataCostByJU);
                DataCostByJU.VALIDATE("Job No.", V_Job);
                DataCostByJU.VALIDATE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                //jmma correcci¢n por importaci¢n bce a presupuesto distinto de inicial
                DataCostByJU.VALIDATE("Cod. Budget", CostBudget);
                DataCostByJU.VALIDATE("Cost Type", BillofItemData.Type);
                DataCostByJU.VALIDATE("No.", BillofItemData."No.");
                //-Q18970 AML A¤adir Order No para evitar repetidos
                DataCostByJU.VALIDATE("Order No.", BillofItemData."Order No.");
                //+Q18970
                DataCostByJU.VALIDATE("Analytical Concept Direct Cost", BillofItemData."Concep. Analytical Direct Cost");
                DataCostByJU.VALIDATE("Analytical Concept Ind. Cost", BillofItemData."Concep. Anal. Indirect Cost");

                //JMMA 15/10/19 error precio, siempre trae el del recurso.
                if opcRespect then begin
                    //DataCostByJU.VALIDATE("Direct Unitary Cost (JC)",BillofItemData."Direct Unit Cost");
                    //-Q18970 Los subniveles tambien pueden tener cargados porcentuales.
                    //{
                    //            if BillofItemData."Father Code" = '' then DataCostByJU.VALIDATE("Direct Unitary Cost (JC)",BillofItemData."Total Price")
                    //            else begin
                    //              DataCostByJU.VALIDATE("Direct Unitary Cost (JC)",BillofItemData."Base Unit Cost");
                    //            end;
                    //            }
                    //-Q20047
                    //(DataCostByJU.VALIDATE("Direct Unitary Cost (JC)",BillofItemData."Base Unit Cost" + BillofItemData."Received from Percentajes");//
                    if DataPieceworkForProduction2.GET(V_Job, newNumber) then;
                    if (DataPieceworkForProduction2.Type = DataPieceworkForProduction2.Type::Piecework) or (DataPieceworkForProduction2."Subtype Cost" = DataPieceworkForProduction2."Subtype Cost"::"Current Expenses") then begin
                        DataCostByJU.VALIDATE("Direc Unit Cost", BillofItemData."Base Unit Cost" + BillofItemData."Received from Percentajes");
                        if (DataPieceworkForProduction2.Type = DataPieceworkForProduction2.Type::"Cost Unit") then
                            DataCostByJU.VALIDATE("Performance By Piecework", 1);
                    end
                    else begin
                        if (DataPieceworkForProduction2.Type = DataPieceworkForProduction2.Type::"Cost Unit") and (DataPieceworkForProduction2."Subtype Cost" <> DataPieceworkForProduction2."Subtype Cost"::"Current Expenses") then begin
                            DataCostByJU.VALIDATE("Direc Unit Cost", 1);
                            DataCostByJU.VALIDATE("Performance By Piecework", 1);
                        end;
                    end;
                end;
                //+Q20047
                //JAV 02/10/19: - En indirectos, si no son corrientres cantidad debe ser cero o uno
                if DataPieceworkForProduction2.GET(V_Job, newNumber) then
                    //-Q20047
                    if (DataPieceworkForProduction2.Type = DataPieceworkForProduction2.Type::"Cost Unit") then
                        //+Q20047
                        if DataPieceworkForProduction2."Allocation Terms" = DataPieceworkForProduction2."Allocation Terms"::"Fixed Amount" then begin
                            if DataPieceworkForProduction2."Subtype Cost" <> DataPieceworkForProduction2."Subtype Cost"::"Current Expenses" then begin
                                if (BillofItemData."Quantity By" <> 1) then
                                    BillofItemData."Quantity By" := 0;
                                if (BillofItemData."Bill of Item Units" <> 1) then
                                    BillofItemData."Bill of Item Units" := 0;
                                if (DataCostByJU."Direct Unitary Cost (JC)" <> 0) then begin
                                    DataCostByJU."Direct Unitary Cost (JC)" := 0;
                                    DataCostByJU."Direc Unit Cost" := 0;
                                end;
                            end
                            //-Q20047
                            else begin

                                DataCostByJU.VALIDATE("Performance By Piecework", 1);
                                DataCostByJU.VALIDATE("Direc Unit Cost", BillofItemData."Base Unit Cost");
                            end;
                        end;
                //+Q20047
                //JAV fin

                //-Q20047
                if (DataPieceworkForProduction2.Type = DataPieceworkForProduction2.Type::Piecework) then
                    //+Q20047
                    if BillofItemData."Bill of Item Units" <> 0 then
                        DataCostByJU.VALIDATE("Performance By Piecework", BillofItemData."Quantity By" * BillofItemData."Bill of Item Units")
                    else
                        DataCostByJU.VALIDATE("Performance By Piecework", BillofItemData."Quantity By");

                //jmma error en variable.
                if opcRespect then begin
                    //jmma cambio para divisa DataCostByJU.VALIDATE("Direct Unitary Cost LCY",BillofItemData."Direct Unit Cost");
                    DataCostByJU.VALIDATE("Currency Code", "Cost Database".Currency); //JMMA divisas
                    DataCostByJU.SetOnChange; //jmma 12/11/20
                                              //DataCostByJU.VALIDATE("Direc Unit Cost",BillofItemData."Direct Unit Cost");
                                              //-Q20047
                                              //DataCostByJU.VALIDATE("Direc Unit Cost",BillofItemData."Total Price");
                    if DataPieceworkForProduction.Type = DataPieceworkForProduction.Type::Piecework then DataCostByJU.VALIDATE("Direc Unit Cost", BillofItemData."Total Price");
                    //+Q20047
                    //-Q20047 Solo pongo el coste indirecto si es un coste fijo y gastos generales.
                    //DataCostByJU.VALIDATE("Indirect Unit Cost",BillofItemData."Unit Cost Indirect");
                    if (DataPieceworkForProduction."Allocation Terms" = DataPieceworkForProduction."Allocation Terms"::"Fixed Amount") and
                       (DataPieceworkForProduction."Subtype Cost" = DataPieceworkForProduction."Subtype Cost"::"Current Expenses") then
                        DataCostByJU.VALIDATE("Indirect Unit Cost", BillofItemData."Unit Cost Indirect");
                    //+Q20047
                    //DataCostByJU.VALIDATE("Budget Cost",ROUND((DataCostByJU."Performance By Piecework" * BillofItemData."Direct Unit Cost") +
                    //-Q18970
                    //if BillofItemData."Father Code" = ''  then
                    //   DataCostByJU.VALIDATE("Budget Cost",ROUND((DataCostByJU."Performance By Piecework" * BillofItemData."Total Price") +
                    //                                          (DataCostByJU."Performance By Piecework" * BillofItemData."Unit Cost Indirect"),
                    //                                          CurrencyQ."Unit-Amount Rounding Precision"))
                    //else begin
                    //   DataCostByJU.VALIDATE("Direc Unit Cost",BillofItemData."Base Unit Cost");
                    //   DataCostByJU.VALIDATE("Budget Cost",ROUND((DataCostByJU."Performance By Piecework" * BillofItemData."Base Unit Cost") +
                    //                                          (DataCostByJU."Performance By Piecework" * BillofItemData."Unit Cost Indirect"),
                    //                                          CurrencyQ."Unit-Amount Rounding Precision"));
                    //end;
                    //   DataCostByJU.VALIDATE("Direc Unit Cost",BillofItemData."Base Unit Cost");
                    //   DataCostByJU.VALIDATE("Budget Cost",ROUND((DataCostByJU."Performance By Piecework" * BillofItemData."Base Unit Cost") +
                    //                                          (DataCostByJU."Performance By Piecework" * BillofItemData."Unit Cost Indirect"),
                    //                                          CurrencyQ."Unit-Amount Rounding Precision"));
                    //-Q20047
                    if DataPieceworkForProduction2.Type = DataPieceworkForProduction2.Type::Piecework then begin
                        //+Q20047
                        DataCostByJU.VALIDATE("Direc Unit Cost", BillofItemData."Base Unit Cost" + BillofItemData."Received from Percentajes");
                        DataCostByJU.VALIDATE("Budget Cost", ROUND(((DataCostByJU."Performance By Piecework" * BillofItemData."Base Unit Cost") + BillofItemData."Received from Percentajes") +
                                                              (DataCostByJU."Performance By Piecework" * BillofItemData."Unit Cost Indirect"),
                                                              CurrencyQ."Unit-Amount Rounding Precision"));
                        //-Q20047
                    end;
                    //+Q20047
                    //+Q18970
                    //jmma
                    if BillofItemData.Description <> '' then begin
                        DataCostByJU.Description := BillofItemData.Description;
                        DataCostByPieceworkCert."Description 2" := BillofItemData."Description 2";
                    end;
                    //jmma
                end else begin
                    //JMMA CAMBIO PARA DIVISA DataCostByJU.VALIDATE("Direct Unitary Cost LCY");
                    DataCostByJU.VALIDATE("Currency Code", "Cost Database".Currency); //JMMA divisas
                    DataCostByJU.SetOnChange;//jmma 12/11/20
                    DataCostByJU.VALIDATE("Direc Unit Cost");
                    DataCostByJU.VALIDATE("Indirect Unit Cost");
                    DataCostByJU.VALIDATE("Budget Cost", ROUND((DataCostByJU."Performance By Piecework" * DataCostByJU."Direct Unitary Cost (JC)") +
                                                              //JMMA CAMBIO PARA DIVISA DataCostByJU.VALIDATE("Budget Cost",ROUND((DataCostByJU."Performance By Piecework" * DataCostByJU."Direc Unit Cost") +
                                                              (DataCostByJU."Performance By Piecework" * DataCostByJU."Indirect Unit Cost"),
                                                              CurrencyQ."Unit-Amount Rounding Precision"));

                end;

                DataCostByJU."Code Cost Database" := BillofItemData."Cod. Cost database";
                DataCostByJU."Unique Code" := DataCostByJU."Unique Code";
                //-Q18970
                DataCostByJU.INSERT;
                //if not DataCostByJU.INSERT then
                //if (not pAddOnly) then
                //DataCostByJU.MODIFY;
                //+Q18970
                // Copiar textos adicionales si existen
                QBText.CopyTo(QBText.Table::Preciario, BillofItemData."Cod. Cost database", BillofItemData."Cod. Piecework", BillofItemData."No.",
                              QBText.Table::Job, DataCostByJU."Job No.", DataCostByJU."Piecework Code", DataCostByJU."No.");

            until BillofItemData.NEXT = 0;
    end;

    //     LOCAL procedure ChargeUnits (pAddOnly@1100286000 :
    LOCAL procedure ChargeUnits(pAddOnly: Boolean)
    begin
        //Para 20047 20043 18970 se ha de copiar entera
        // Cargar los descompuestos de Coste
        BillofItemData.SETRANGE("Cod. Cost database", Piecework."Cost Database Default");
        BillofItemData.SETRANGE("Cod. Piecework", Piecework."No.");
        BillofItemData.SETRANGE(Use, BillofItemData.Use::Cost);       //Cargar solo descompuestos de coste
        BillofItemData.SETFILTER(Type, '%1|%2|%3', BillofItemData.Type::Item, BillofItemData.Type::Resource, BillofItemData.Type::Account);
        if BillofItemData.FINDFIRST then
            repeat
                Window.UPDATE(2, 'C ' + FORMAT(BillofItemData."No." + ' ' + BillofItemData.Description));
                CLEAR(DataCostByJU);
                DataCostByJU.VALIDATE("Job No.", V_Job);
                DataCostByJU.VALIDATE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                //jmma correcci¢n por importaci¢n bce a presupuesto distinto de inicial
                DataCostByJU.VALIDATE("Cod. Budget", CostBudget);
                DataCostByJU.VALIDATE("Cost Type", BillofItemData.Type);
                DataCostByJU.VALIDATE("No.", BillofItemData."No.");
                DataCostByJU.VALIDATE("Order No.", BillofItemData."Order No.");
                DataCostByJU.VALIDATE("Analytical Concept Direct Cost", BillofItemData."Concep. Analytical Direct Cost");
                DataCostByJU.VALIDATE("Analytical Concept Ind. Cost", BillofItemData."Concep. Anal. Indirect Cost");

                //JMMA 15/10/19 error precio, siempre trae el del recurso.
                if opcRespect then begin
                    //jmma cambio para divisa DataCostByJU.VALIDATE("Direct Unitary Cost LCY",BillofItemData."Direct Unit Cost");
                    DataCostByJU.VALIDATE("Currency Code", "Cost Database".Currency); //JMMA divisas
                    DataCostByJU.SetOnChange; //jmma 12/11/20
                                              //JAV 02/10/19: - En indirectos, si no son corrientres cantidad debe ser cero o uno
                end;
                if DataPieceworkForProduction2.GET(V_Job, newNumber) then;
                if (DataPieceworkForProduction2.Type = DataPieceworkForProduction2.Type::"Cost Unit") and (DataPieceworkForProduction."Allocation Terms" = DataPieceworkForProduction."Allocation Terms"::"Fixed Amount") and
                   (DataPieceworkForProduction2."Subtype Cost" = DataPieceworkForProduction2."Subtype Cost"::"Current Expenses") then begin
                    DataCostByJU.VALIDATE("Direc Unit Cost", BillofItemData."Base Unit Cost");
                    DataCostByJU.VALIDATE("Performance By Piecework", 1);
                end
                else begin
                    if (DataPieceworkForProduction2.Type = DataPieceworkForProduction2.Type::"Cost Unit") and (DataPieceworkForProduction."Allocation Terms" = DataPieceworkForProduction."Allocation Terms"::"Fixed Amount") and
                       (DataPieceworkForProduction2."Subtype Cost" <> DataPieceworkForProduction2."Subtype Cost"::"Current Expenses") then begin
                        DataCostByJU.VALIDATE("Direc Unit Cost", 1);
                        DataCostByJU.VALIDATE("Direc Unit Cost", 1);
                        DataCostByJU.VALIDATE("Performance By Piecework", 1);
                    end;
                    if (DataPieceworkForProduction2.Type = DataPieceworkForProduction2.Type::"Cost Unit") and (DataPieceworkForProduction."Allocation Terms" <> DataPieceworkForProduction."Allocation Terms"::"Fixed Amount") then begin
                        DataCostByJU.VALIDATE("Direc Unit Cost", 1);
                        DataCostByJU.VALIDATE("Direc Unit Cost", 1);
                        DataCostByJU.VALIDATE("Performance By Piecework", 1);
                        DataPieceworkForProduction.VALIDATE("Cost Amount Base", Piecework."Measurement Cost");
                    end;
                end;
                /////////////////////////////////////////////////////

                if (DataPieceworkForProduction2.Type = DataPieceworkForProduction2.Type::Piecework) then begin
                    if BillofItemData."Bill of Item Units" <> 0 then
                        DataCostByJU.VALIDATE("Performance By Piecework", BillofItemData."Quantity By" * BillofItemData."Bill of Item Units")
                    else
                        DataCostByJU.VALIDATE("Performance By Piecework", BillofItemData."Quantity By");
                end;
                //jmma error en variable.
                if opcRespect then begin
                    if DataPieceworkForProduction.Type = DataPieceworkForProduction.Type::Piecework then DataCostByJU.VALIDATE("Direc Unit Cost", BillofItemData."Total Price");
                    //-Q20047 Solo pongo el coste indirecto si es un coste fijo y gastos generales.
                    if DataPieceworkForProduction2.Type = DataPieceworkForProduction2.Type::Piecework then begin
                        DataCostByJU.VALIDATE("Direc Unit Cost", BillofItemData."Base Unit Cost" + BillofItemData."Received from Percentajes");
                        DataCostByJU.VALIDATE("Budget Cost", ROUND(((DataCostByJU."Performance By Piecework" * BillofItemData."Base Unit Cost") + BillofItemData."Received from Percentajes") +
                                                            (DataCostByJU."Performance By Piecework" * BillofItemData."Unit Cost Indirect"),
                                                            CurrencyQ."Unit-Amount Rounding Precision"));
                    end;
                    //jmma
                    if BillofItemData.Description <> '' then begin
                        DataCostByJU.Description := BillofItemData.Description;
                        DataCostByPieceworkCert."Description 2" := BillofItemData."Description 2";
                    end;
                    //jmma
                end else begin
                    DataCostByJU.VALIDATE("Direc Unit Cost");
                    DataCostByJU.VALIDATE("Indirect Unit Cost");
                    DataCostByJU.VALIDATE("Budget Cost", ROUND((DataCostByJU."Performance By Piecework" * DataCostByJU."Direct Unitary Cost (JC)") +
                                                              //JMMA CAMBIO PARA DIVISA DataCostByJU.VALIDATE("Budget Cost",ROUND((DataCostByJU."Performance By Piecework" * DataCostByJU."Direc Unit Cost") +
                                                              (DataCostByJU."Performance By Piecework" * DataCostByJU."Indirect Unit Cost"),
                                                                CurrencyQ."Unit-Amount Rounding Precision"));
                end;

                DataCostByJU."Code Cost Database" := BillofItemData."Cod. Cost database";
                DataCostByJU."Unique Code" := DataCostByJU."Unique Code";
                DataCostByJU.INSERT;
                // Copiar textos adicionales si existen
                QBText.CopyTo(QBText.Table::Preciario, BillofItemData."Cod. Cost database", BillofItemData."Cod. Piecework", BillofItemData."No.",
                              QBText.Table::Job, DataCostByJU."Job No.", DataCostByJU."Piecework Code", DataCostByJU."No.");

            until BillofItemData.NEXT = 0;
    end;

    /*begin
    //{
//      PGM 24/09/18: - QVE_3865 Controlar las unidades de obra ya existentes para que no se reemplaze.
//      JMMA        : - ERROR AL BORRAR SI SE LANZA DESDE PRESUPUESTO DE VENTA
//      JAV 18/03/19: - Se guarda el £ltimo preciario cargado en la ficha del proyecto
//      JAV 24/09/19: - Por defecto no marca borrar el anterior pues es mas peligroso, y se marcan las otras opciones que son habituales marcar siempre
//      JAV 02/10/19: - Guardar en el log de cambios del proyecto
//                    - Solo borra los datos del tipo de preciario a cargar (directos, indirectos, ambos)
//                    - En indirectos, si no son corrientres cantidad debe ser cero o uno
//      JMMA 15/10/19 - Eror precio, siempre trae el del recurso. Se corrige para que si se marca que respete precio de preciaro lo haga correctamente
//      PGM 14/05/20: - Q9291 Modificaci¢n hecha para que rellene las mediciones cuando se traiga el preciario al presupuesto de venta de un estudio
//      JAV 20/10/21: - QB 1.09.22 Considerar £nicamente ingresos y gastos, no certificaciones
//      AML 31/05/23  - Q18970 Permitir la repetici¢n de PRoductos y recursos en descompuesto. Y  Correcci¢n de errores.
//      AML 23/08/23  - Q20043 Carga de indirectos.
//      AML 29/08/23  - Q20047 Indirectos
//    }
    end.
  */

}



