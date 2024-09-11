table 7206901 "QBU Report Selections"
{


    CaptionML = ENU = 'QuoBuilding Report Selections', ESP = 'Selecci�n informes para QuoBuilding';

    fields
    {
        field(1; "Usage"; Option)
        {
            OptionMembers = "Q1","Q2","Q3","Q4","Q5","Q6","Q7","Q8","Q9","J1","J2","J3","J4","J5","J6","J7","J8","J9","P1","P2","P3","P4","P5","P6","P7","P8","P9","V1","V2","V3","V4","V5","V6","V7","V8","V9","G1","G2","G3","G4","G5","G6","G7","G8","G9","W1","W2","W3","W4","W5","W6","W7","W8","W9";
            CaptionML = ENU = 'Usage', ESP = 'Uso';
            OptionCaptionML = ESP = 'Estudio: Oferta,Estudio: Presupuesto Medici�n,Estudio: Presupuesto Producto,Estudio: Cuadro Descompuestos,,,,,,Proyecto: Oferta,Proyecto: Relaci�n Valorada,Proyecto: Relaci�n Valorada Registrada,Proyecto: Medici�n,Proyecto: Medici�n registrada,Proyecto: Certificaci�n,Proyecto: Certificaci�n Registrada,,,Compras: Contrato (Pedido),Compras: Albar�n/FRI,Compras: Proforma Proveedor,,,,,,,Ventas: Albar�n,,,,,,,,,Pagos Electr�nicos,Pagar�s,Carta,,,,,,,SW Medici�n,SW Comparativo';



        }
        field(2; "Sequence"; Code[10])
        {
            CaptionML = ENU = 'Sequence', ESP = 'Secuencia';
            Numeric = true;


        }
        field(3; "Report ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Report"));


            CaptionML = ENU = 'Report ID', ESP = 'Id. informe';

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Report Caption");
            END;


        }
        field(4; "Report Caption"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("AllObjWithCaption"."Object Caption" WHERE("Object Type" = CONST("Report"),
                                                                                                                "Object ID" = FIELD("Report ID")));
            CaptionML = ENU = 'Report Caption', ESP = 'Nombre del informe';
            Editable = false;


        }
        field(5; "Caption"; Text[250])
        {
            CaptionML = ENU = 'Caption', ESP = 'T�tulo en la selecci�n';


        }
        field(10; "Minimal Amount"; Decimal)
        {
            CaptionML = ENU = 'Custom Report Layout Code', ESP = 'Importe m�nimo';


        }
        field(11; "Selection"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Seleccionar';


        }
        field(20; "SW Description"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'SW Descripción';


        }
        field(21; "SW Parameter"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'SW Par�metro';


        }
    }
    keys
    {
        key(key1; "Usage", "Sequence")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Usage", "Sequence", "Report ID", "Report Caption")
        {

        }
    }

    var
        //       QBReportSelections@1100286000 :
        QBReportSelections: Record 7206901;
        //       txtQB000@1100286001 :
        txtQB000: TextConst ESP = 'No ha definido el n�mero del informe';
        //       txtQB001@1100286002 :
        txtQB001: TextConst ESP = 'Seleccione el formato que desea utilizar';
        //       txtQB002@1100286003 :
        txtQB002: TextConst ESP = 'No ha definido un formato para imprimir %1';
        //       txtQB003@1100286004 :
        txtQB003: TextConst ESP = 'Seleccione formato para %1';




    trigger OnModify();
    begin
        if (not IsWebService) then
            TESTFIELD("Report Caption")
        else
            TESTFIELD("SW Parameter");
    end;



    procedure NewRecord()
    begin
        QBReportSelections.SETRANGE(Usage, Usage);
        if QBReportSelections.FINDLAST and (QBReportSelections.Sequence <> '') then
            Sequence := INCSTR(QBReportSelections.Sequence)
        else
            Sequence := '1';
    end;

    procedure AddDefaultsReports()
    begin
        //JAV 10/01/21: - QB 1.10.09 Se a�ade la verificaci�n de que no existan reports en ese grupo de informes, as� no a�ade los est�ndar si ya se han definido otros

        if (not ExistReports(QBReportSelections.Usage::Q1)) then
            AddReport(QBReportSelections.Usage::Q1, '1', 7207421, 0, FALSE);
        if (not ExistReports(QBReportSelections.Usage::Q2)) then
            AddReport(QBReportSelections.Usage::Q2, '1', 7207295, 0, FALSE);
        if (not ExistReports(QBReportSelections.Usage::Q3)) then
            AddReport(QBReportSelections.Usage::Q3, '1', 7207306, 0, FALSE);
        if (not ExistReports(QBReportSelections.Usage::Q4)) then
            AddReport(QBReportSelections.Usage::Q4, '1', 7207299, 0, FALSE);

        if (not ExistReports(QBReportSelections.Usage::J1)) then
            AddReport(QBReportSelections.Usage::J1, '1', 7207358, 0, FALSE);
        if (not ExistReports(QBReportSelections.Usage::J2)) then
            AddReport(QBReportSelections.Usage::J2, '1', 7207349, 0, FALSE);
        if (not ExistReports(QBReportSelections.Usage::J3)) then
            AddReport(QBReportSelections.Usage::J3, '1', 7207351, 0, FALSE);
        if (not ExistReports(QBReportSelections.Usage::J4)) then
            AddReport(QBReportSelections.Usage::J4, '1', 7207422, 0, FALSE);
        if (not ExistReports(QBReportSelections.Usage::J5)) then
            AddReport(QBReportSelections.Usage::J5, '1', 7207423, 0, FALSE);
        if (not ExistReports(QBReportSelections.Usage::J6)) then
            AddReport(QBReportSelections.Usage::J6, '1', 7207301, 0, FALSE);
        if (not ExistReports(QBReportSelections.Usage::J7)) then begin
            AddReport(QBReportSelections.Usage::J7, '1', 7207297, 0, TRUE);
            AddReport(QBReportSelections.Usage::J7, '2', 7207298, 0, TRUE);
        end;

        if (not ExistReports(QBReportSelections.Usage::P1)) then begin
            AddReport(QBReportSelections.Usage::P1, '1', 7207411, 0, FALSE);
            AddReport(QBReportSelections.Usage::P1, '2', 7207412, 1500, FALSE);
            AddReport(QBReportSelections.Usage::P1, '3', 7207413, 60000, FALSE);
        end;

        if (not ExistReports(QBReportSelections.Usage::P2)) then
            AddReport(QBReportSelections.Usage::P2, '1', 7207327, 0, FALSE);

        //Esto ya no se utiliza de esta manera
        // if (not ExistReports(QBReportSelections.Usage::G1)) then begin
        //  QBReportSelections.RESET;
        //  QBReportSelections.SETRANGE(Usage, QBReportSelections.Usage::G1);
        //  if (QBReportSelections.ISEMPTY) then begin
        //    AddReport(QBReportSelections.Usage::G1, '01',   50052,     0, TRUE);
        //    AddReport(QBReportSelections.Usage::G1, '02',   50053,     0, TRUE);
        //    AddReport(QBReportSelections.Usage::G1, '03',   50054,     0, TRUE);
        //    AddReport(QBReportSelections.Usage::G1, '04',   50055,     0, TRUE);
        //    AddReport(QBReportSelections.Usage::G1, '05',   50056,     0, TRUE);
        //    AddReport(QBReportSelections.Usage::G1, '06',   50057,     0, TRUE);
        //    AddReport(QBReportSelections.Usage::G1, '07',   50058,     0, TRUE);
        //    AddReport(QBReportSelections.Usage::G1, '08',   50059,     0, TRUE);
        //    AddReport(QBReportSelections.Usage::G1, '09',   50060,     0, TRUE);
        //    AddReport(QBReportSelections.Usage::G1, '10',   50061,     0, TRUE);
        //    AddReport(QBReportSelections.Usage::G1, '11',   50051,     0, TRUE);
        //  end;
        // end;

        if (not ExistReports(QBReportSelections.Usage::G2)) then begin
            AddReport(QBReportSelections.Usage::G2, '1', 7207439, 0, TRUE);
            AddReport(QBReportSelections.Usage::G2, '2', 7207438, 0, TRUE);
        end;

        if (not ExistReports(QBReportSelections.Usage::G3)) then
            AddReport(QBReportSelections.Usage::G3, '1', 7207440, 0, TRUE);
    end;

    //     LOCAL procedure ExistReports (pUsage@1100286000 :
    LOCAL procedure ExistReports(pUsage: Option): Boolean;
    begin
        //JAV 10/01/21: - QB 1.10.09 Esta funci�n retorna si existen reports de ese grupo de informes
        QBReportSelections.RESET;
        QBReportSelections.SETRANGE(Usage, pUsage);
        exit(not QBReportSelections.ISEMPTY);
    end;

    //     LOCAL procedure AddReport (pUsage@1100286000 : Option;pSec@1100286002 : Text;pNro@1100286001 : Integer;pAmount@1100286003 : Decimal;pSel@1100286004 :
    LOCAL procedure AddReport(pUsage: Option; pSec: Text; pNro: Integer; pAmount: Decimal; pSel: Boolean)
    begin
        QBReportSelections.INIT;
        QBReportSelections.Usage := pUsage;
        QBReportSelections.Sequence := pSec;
        QBReportSelections."Report ID" := pNro;
        QBReportSelections."Minimal Amount" := pAmount;
        QBReportSelections.Selection := pSel;
        if QBReportSelections.INSERT then
            COMMIT;
    end;

    procedure IsWebService(): Boolean;
    begin
        exit(Usage IN [Usage::W1, Usage::W2, Usage::W3, Usage::W4, Usage::W5, Usage::W6, Usage::W7, Usage::W8, Usage::W9]);
    end;

    LOCAL procedure "---------------------------- Funciones para la impresión"()
    begin
    end;


    //     procedure Print (ReportUsage@1000 : Integer;RecordVariant@1001 :
    procedure Print(ReportUsage: Integer; RecordVariant: Variant)
    begin
        //----------------------------------------------------------------------------------------------------------------------------------------
        // Funci�n........: Print  -> Lanza la impresi�n de un informe usando la pantalla de opciones de este
        //   ReportUsage..: Integer con el n�mero del informe
        //   RecordVariant: Variant con los registros a imprimir
        //----------------------------------------------------------------------------------------------------------------------------------------
        PrintDocuments(ReportUsage, RecordVariant, TRUE, 0, FALSE);
    end;


    //     procedure PrintAmount (ReportUsage@1000 : Integer;RecordVariant@1001 : Variant;pAmount@1100286000 :
    procedure PrintAmount(ReportUsage: Integer; RecordVariant: Variant; pAmount: Decimal)
    begin
        //----------------------------------------------------------------------------------------------------------------------------------------
        // Funci�n........: Print  -> Lanza la impresi�n de un informe, indicando el importe para su posible uso en el selector
        //   ReportUsage..: Integer con el n�mero del informe
        //   RecordVariant: Variant con los registros a imprimir
        //   pAmount......: Decimal con el importe del report
        //----------------------------------------------------------------------------------------------------------------------------------------
        PrintDocuments(ReportUsage, RecordVariant, TRUE, pAmount, FALSE);
    end;


    //     procedure PrintWithoutGUI (ReportUsage@1000 : Integer;RecordVariant@1001 :
    procedure PrintWithoutGUI(ReportUsage: Integer; RecordVariant: Variant)
    begin
        //----------------------------------------------------------------------------------------------------------------------------------------
        // Funci�n........: Print  -> Lanza la impresi�n de un informe sin usar la pantalla de opciones de este
        //   ReportUsage..: Integer con el n�mero del informe
        //   RecordVariant: Variant con los registros a imprimir
        //----------------------------------------------------------------------------------------------------------------------------------------
        PrintDocuments(ReportUsage, RecordVariant, FALSE, 0, FALSE);
    end;


    //     procedure PrintOneReport (pReportNumber@1100286001 : Integer;WithGUI@1100286002 : Boolean;RecordVariant@1100286000 :
    procedure PrintOneReport(pReportNumber: Integer; WithGUI: Boolean; RecordVariant: Variant)
    var
        //       ReportLayoutSelection@1100286004 :
        ReportLayoutSelection: Record 9651;
        //       CustomReportLayout@1100286003 :
        CustomReportLayout: Record 9650;
        //       number@1100286009 :
        number: Integer;
        //       LayoutCode@1100286008 :
        LayoutCode: ARRAY[50] OF Text;
        //       LayoutName@1100286007 :
        LayoutName: ARRAY[50] OF Text;
        //       Options@1100286006 :
        Options: Text;
        //       Selected@1100286005 :
        Selected: Integer;
    begin
        //----------------------------------------------------------------------------------------------------------------------------------------
        // Funci�n........: PrintOneReport  -> Lanza la impresi�n de un informe, con la posible selecci�n entre varios layout
        //   Number.......: Integer con el n�mero del informe
        //   WithGUI......: Boolean que indica si se presenta o no la pantalla de opciones del informe
        //   RecordVariant: Variant con los registros a imprimir
        //----------------------------------------------------------------------------------------------------------------------------------------
        if pReportNumber = 0 then
            ERROR(txtQB000);

        //JAV 17/06/22; - QB 1.10.51 Se procesan los posibles layout del informe a imprimir, si solo hay uno se usa este, si no saca un selector para que se elija
        CustomReportLayout.RESET;
        CustomReportLayout.SETRANGE("Report ID", pReportNumber);

        number := CustomReportLayout.COUNT;

        if (CustomReportLayout.COUNT > 1) then begin
            CustomReportLayout.FINDSET(FALSE);
            number := 0;
            repeat
                number += 1;
                LayoutCode[number] := CustomReportLayout.Code;
                LayoutName[number] := CustomReportLayout.Description;

                if (Options <> '') then
                    Options += ',';

                Options += CustomReportLayout.Description;
            until CustomReportLayout.NEXT = 0;

            if (number > 1) then begin
                CustomReportLayout.CALCFIELDS("Report Name");
                Selected := STRMENU(Options, 0, STRSUBSTNO(txtQB003, CustomReportLayout."Report Name"));
            end;

            if Selected = 0 then
                exit;

            //ReportLayoutSelection.SetTempLayoutSelected(LayoutCode[Selected]);  //19457 PGM Comentada l�nea para que no se qued� en cach� el dise�o seleccionado.
        end;

        //JAV 17/06/22; - QB 1.10.51 Se a�ade el par�metro para indicar si tiene pantalla
        REPORT.RUN(pReportNumber, WithGUI, FALSE, RecordVariant);
    end;


    //     procedure GetReportSelected (ReportUsage@1000 :
    procedure GetReportSelected(ReportUsage: Integer): Integer;
    var
        //       RecordVariant@1100286000 :
        RecordVariant: Variant;
    begin
        //----------------------------------------------------------------------------------------------------------------------------------------
        // Funci�n........: GetReportSelected  -> Lanza los procesos de selecci�n del informe y retorna el n�mero seleccionado
        //   ReportUsage..: Integer con el n�mero del informe
        //----------------------------------------------------------------------------------------------------------------------------------------
        exit(PrintDocuments(ReportUsage, RecordVariant, FALSE, 0, TRUE));
    end;

    //     LOCAL procedure PrintDocuments (ReportUsage@1000 : Integer;RecordVariant@1001 : Variant;IsGUI@1002 : Boolean;pAmount@1100286001 : Decimal;pSelect@1100286007 :
    LOCAL procedure PrintDocuments(ReportUsage: Integer; RecordVariant: Variant; IsGUI: Boolean; pAmount: Decimal; pSelect: Boolean): Integer;
    var
        //       MinimalAmount@1100286002 :
        MinimalAmount: Decimal;
        //       number@1100286005 :
        number: Integer;
        //       NroReport@1100286000 :
        NroReport: ARRAY[50] OF Integer;
        //       Name@1100286004 :
        Name: ARRAY[50] OF Text;
        //       Options@1100286006 :
        Options: Text;
        //       Selected@1100286003 :
        Selected: Integer;
    begin
        //----------------------------------------------------------------------------------------------------------------------------------------
        // Funci�n........: PrintDocuments  -> Lanza la impresi�n de un informe con las selecciones por importe o por selector
        //   ReportUsage..: Integer con el n�mero del informe
        //   RecordVariant: Variant con los registros a imprimir
        //   IsGUI........: Boolean que indica si se presenta o no la pantalla de opciones del informe
        //   pAmount......: Decimal con el importe del report para su uso en el selector
        //   pSelect......: Boolean que indica si es TRUE que solo deseamos el n�mero del informe a imprimir
        //         RETORNA: Integer con el repo
        //----------------------------------------------------------------------------------------------------------------------------------------

        //Si no hay ning�n report incluyo los est�ndar
        QBReportSelections.RESET;
        QBReportSelections.SETRANGE(Usage, ReportUsage);
        if (QBReportSelections.ISEMPTY) then
            AddDefaultsReports;

        //Busco el report por su importe m�nimo
        QBReportSelections.RESET;
        QBReportSelections.SETRANGE(Usage, ReportUsage);
        QBReportSelections.SETFILTER("Report Caption", '<>0');
        QBReportSelections.SETFILTER("Minimal Amount", '<=%1', pAmount);
        if (QBReportSelections.FINDLAST) then
            MinimalAmount := QBReportSelections."Minimal Amount";

        //Busco todos los reports a imprimir con ese importe m�nimo que sean a elegir uno y se pregunta cual desea imprimir
        Selected := 1;
        number := 0;
        QBReportSelections.RESET;
        QBReportSelections.SETRANGE(Usage, ReportUsage);
        QBReportSelections.SETFILTER("Report Caption", '<>0');
        QBReportSelections.SETRANGE("Minimal Amount", MinimalAmount);
        QBReportSelections.SETRANGE(Selection, TRUE);
        if (QBReportSelections.FINDSET(FALSE)) then
            repeat
                //JAV 10/01/21: - QB 1.10.09 Pongo el caption adecuado al report, si se ha definido uno propio usamos este, si no el t�tulo del report
                if (QBReportSelections.Caption = '') then begin
                    QBReportSelections.CALCFIELDS("Report Caption");
                    QBReportSelections.Caption := FORMAT(QBReportSelections."Report ID") + ': ' + QBReportSelections."Report Caption";
                end;

                number += 1;
                NroReport[number] := QBReportSelections."Report ID";
                Name[number] := QBReportSelections.Caption;
                if (Options <> '') then
                    Options += ',';

                //JAV 10/01/21: - QB 1.10.09 Solo se presenta el nombre, no el n�mero + nombre
                //Options += QBReportSelections."Report Caption" + ': ' + QBReportSelections.Caption;
                Options += QBReportSelections.Caption;
            until QBReportSelections.NEXT = 0;

        if (number > 1) then begin
            Selected := STRMENU(Options, 0, txtQB001);
            if Selected = 0 then exit;
        end;

        //Busco todos los reports a imprimir con ese importe m�nimo y los voy lanzando
        number := 0;
        QBReportSelections.RESET;
        QBReportSelections.SETRANGE(Usage, ReportUsage);
        QBReportSelections.SETFILTER("Report Caption", '<>0');
        QBReportSelections.SETRANGE("Minimal Amount", MinimalAmount);
        if (QBReportSelections.FINDSET(FALSE)) then
            repeat
                if (not QBReportSelections.Selection) or (QBReportSelections."Report ID" = NroReport[Selected]) then begin
                    //Si solo queremos saber el report a usar, retornamos el primero
                    if (pSelect) then
                        exit(QBReportSelections."Report ID");
                    if (QBReportSelections.IsWebService) then
                        PrintWS(QBReportSelections."Report ID", QBReportSelections."SW Parameter", RecordVariant)
                    else
                        //JAV 17/06/22; - QB 1.10.51 Llamar a la funci�n que imprime un report en lugar de directamente al mismo, as� se activa siempre la funcionalidad de seleccion de layout
                        //REPORT.RUN(QBReportSelections."Report ID",IsGUI,FALSE,RecordVariant);
                        PrintOneReport(QBReportSelections."Report ID", IsGUI, RecordVariant);
                    number += 1;
                end;
            until QBReportSelections.NEXT = 0;

        if number = 0 then begin
            QBReportSelections.Usage := ReportUsage;
            ERROR(txtQB002, FORMAT(QBReportSelections.Usage));
        end;
    end;



    //     procedure PrintWS (ReportUsage@1100286004 : Integer;Parameter@1100286000 : Text;RecordVariant@1100286001 :
    procedure PrintWS(ReportUsage: Integer; Parameter: Text; RecordVariant: Variant)
    begin
        //----------------------------------------------------------------------------------------------------------------------------------------
        // EVENTO.........: PrintWS  -> Se lanza cuando el report a imprimir est� configurado para la impresi�n a trav�s del WebService de impresi�n externo
        //   ReportUsage..: Integer con el n�mero del informe
        //   Parameter....: Text con los par�metros que se le pasan al WS
        //   RecordVariant: Variant con los registros a imprimir
        //----------------------------------------------------------------------------------------------------------------------------------------
    end;

    /*begin
    //{
//      JAV Selector de informes para QuoBuilding. Los formatos que se usan son:
//
//          Q = Estudios
//            Q1 = Estudio: Oferta
//            Q2 = Estudio: Presupuesto Medici�n
//            Q3 = Estudio: Presupuesto Producto
//            Q4 = Estudio: Cuadro Descompuestos
//          J = Proyectos
//            J1 = Proyecto: Oferta
//            J2 = Proyecto: Relaci�n Valorada
//            J3 = Proyecto: Relaci�n Valorada Registrada
//            J4 = Proyecto: Medici�n
//            J5 = Proyecto: Medici�n registrada
//            J6 = Proyecto: Certificaci�n
//            J7 = Proyecto: Certificaci�n Registrada
//          P = Compras
//            P1 = Compras: Contrato (Pedido)
//            P2 = Compras: Albar�n/FRI
//            P3 = Compras: Proforma Proveedor
//          V = Ventas
//            V1 = Ventas: Albar�n
//          G = Cartera
//            G1 = Pagos Electr�nicos   -> Cancelado, ahora se saca de otra manera
//            G2 = Pagar�s
//            G3 = Carta
//          W = Web Services
//            W1 = Medici�n 1
//            W2 = Certificaci�n
//
//      JAV 10/01/21: - QB 1.10.09 Se a�ade el caption a presentar del report. Solo se incluyen reports est�ndar si no hay ninguno, as� no se incluyen los est�ndar si hay una configuraci�n propia.
//      JAV 17/06/22: - QB 1.10.51 Nuevo par�metro en la funci�n de impresi�n de un report para sacar la pantalla de opciones
//                                 Nuevo selector de layouts para los informes
//                                 Llamar a la funci�n que imprime un report en lugar de directamente al mismo, as� se activa siempre la funcionalidad de seleccion de layout
//      PGM 15/05/23: 19457 //19558 Comentada l�nea para que no se qued� en cach� el dise�o seleccionado. Funci�n "PrintOneReport"
//    }
    end.
  */
}







