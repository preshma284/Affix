Codeunit 7207272 "Function QB"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        Text000: TextConst ESP = 'Este m�duclo de QuoBuilding no est� activo.';
        Text001a: TextConst ENU = 'There must be a budget for jobs. Go to accounting settings and define it.', ESP = 'Debe existir el presupuesto para proyectos. Vaya a configuraci�n de contabilidad y def�nalo.';
        Text001b: TextConst ENU = 'There must be a quote for offers. Go to Quobuilding settings and define it.', ESP = 'Debe exitir el Presupuesto para ofertas. Vaya a configuraci�n de QuoBuilding y def�nalo.';
        Text002: TextConst ESP = 'Esta opci�n no est� operativa en este momento';
        Text014: TextConst ENU = 'There isn�t dimension for JV. Go to accounting setup and define it.', ESP = 'No existen una dimensi�n para UTE. Vaya a configuraci�n de contabilidad y def�nala.';

    LOCAL PROCEDURE "-------------------------------------------- Cliente que ejecuta el programa"();
    BEGIN
    END;

    PROCEDURE IsClient(pName: Text): Boolean;
    BEGIN
        //Retorna si el programa se est� ejecutando en una licencia del cliente o en la de CEI
        EXIT((IsCEI) OR (pName = GetClient));
    END;

    LOCAL PROCEDURE IsCEI(): Boolean;
    VAR
        QBGlobalConf: Record 7206985;
        Lista: Text;
        Txt: Text;
        i: Integer;
    BEGIN
        //Retorna si estamos ejecutando con el c�digo de CEI en el campo de personalizaci�n, esto hace que todas las personalziaciones aparezcan

        QBGlobalConf.GetGlobalConf('');
        EXIT(GetClientForVoice(QBGlobalConf."License No.") = 'CEI');
    END;

    LOCAL PROCEDURE GetClient(): Text;
    VAR
        QBGlobalConf: Record 7206985;
        Lista: Text;
        Txt: Text;
        i: Integer;
    BEGIN
        //Retorna la licencia del cliente desde QuoBuilding Setup o el nro de licencia

        //Buscamos el nro del cliente en la configuraci�n global
        QBGlobalConf.GetGlobalConf('');
        IF (QBGlobalConf."License No." <> '') THEN
            EXIT(GetClientForVoice(QBGlobalConf."License No."));

        //Si no hay nada en ese campo la sacamos seg�n el Voice
        EXIT(GetClientForVoice(SERIALNUMBER));
    END;

    PROCEDURE GetVoiceFromClient(pName: Text): Text;
    VAR
        QuoBuildingSetup: Record 7207278;
        Lista: Text;
        i: Integer;
    BEGIN
        //De un nombre de cliente retorna su nro de licencia

        pName := DELCHR(pName, '>');
        IF (pName = '') THEN
            EXIT('');

        Lista := GetClientList;
        i := STRPOS(Lista, pName);
        IF (i = 0) THEN
            EXIT('')
        ELSE
            EXIT(COPYSTR(Lista, i + 4, 7));
    END;

    LOCAL PROCEDURE GetClientForVoice(pVoice: Text): Text;
    VAR
        Lista: Text;
        i: Integer;
    BEGIN
        //A partir del n�mero de licencia retorna el cliente

        pVoice := DELCHR(pVoice, '>');
        IF (pVoice = '') THEN
            EXIT('');

        Lista := GetClientList;
        i := STRPOS(Lista, pVoice);
        IF (i = 0) THEN
            EXIT('')
        ELSE
            EXIT(COPYSTR(Lista, i - 4, 3));
    END;

    LOCAL PROCEDURE GetClientList(): Text;
    VAR
        Lista: Text;
        i: Integer;
    BEGIN
        //Montamos la lista de nombres de clientes y n�meros de licencia, formato "CCC NNNNNNN_"

        //CEI
        Lista := 'CEI 5275316_'; //CEI              La anterior de Quonext

        //NAV18
        Lista += 'VES 6900445_'; //Vesta            VESTA REHABILITACION, S.L.
        Lista += 'ELE        _'; //Elecnor          Elecnor, S.A.

        //BC 13
        Lista += 'ABL        _'; //Abolafio
        Lista += 'CPM 7253047_'; //CPM              CPM CONSTRUCCIONES PINTURA Y MANTENIMIENTO S.A.U.
        Lista += 'CUL 7571815_'; //Culmia           CULMIA DESARROLLOS INMOBILIARIOS, SLU
        Lista += 'INE 7104076_'; //Inesco           INESCO, S.A.
        Lista += 'JRM 5340904_'; //Jarama           COVIBAR SOLARCO, S.L.
        Lista += 'KAL 7104080_'; //Kalam            PROYECTOS Y REHABILITACIONES KALAM, S.A.
        Lista += 'ORT 7242501_'; //Ortiz
        Lista += 'OTR 7569809_'; //Otero            OTERO BUILDERS
        Lista += 'OSR 7050466_'; //OyS Roig         Obres y Seveis ROIG
        Lista += 'RCS 5380661_'; //Roig CyS         ROIG CONSTRUCIONES Y SERVICIOS, S.L.
        Lista += 'VAG        _'; //V�a �gora

        //No activos
        Lista += 'AND 7069167_'; //Andrasa          CONSTRUCCIONES Y REFORMAS ANDRASA
        Lista += 'ARP        _'; //Arpada
        Lista += 'LLO        _'; //La llave de Oro
        Lista += 'PER 5116809_'; //Perteo           PERTEO,INFRAESTRUCTURAS Y SERVICIOS, S.L.
        Lista += 'PUM        _'; //Pumsa
        Lista += 'SIN 5186459_'; //Sinaclo          SINACLO, S.A.
        Lista += 'SUK 5059183_'; //Sukia            CONSTRUCCIONES SUKIA S.A.

        EXIT(Lista);
    END;

    LOCAL PROCEDURE "-------------------------------------------- Accesos a los m¢dulos"();
    BEGIN
    END;

    PROCEDURE AccessToQuobuilding(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //Si tiene permiso para acceder a QB, y existe la configuraci�n de QB, y existe el registro de informaci�n empresa, y est� activo QB
        IF (QuoBuildingSetup.READPERMISSION) THEN
            IF (QuoBuildingSetup.GET) THEN
                EXIT(QuoBuildingSetup.Quobuilding);

        EXIT(FALSE);
    END;

    PROCEDURE IsQuoBuildingCompany(pCompany: Text): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //Si la empresa tiene marcado el acceso a QuoBuilding
        QuoBuildingSetup.CHANGECOMPANY(pCompany);
        IF (QuoBuildingSetup.GET) THEN
            EXIT(QuoBuildingSetup.Quobuilding)
        ELSE
            EXIT(FALSE);
    END;

    PROCEDURE AccessToBudgets(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //JAV 14/07/21: - QB 1.09.05 Retorna si est�n activos los presupuestos en QB
        IF (QuoBuildingSetup.READPERMISSION) THEN
            IF (QuoBuildingSetup.GET) THEN
                EXIT(QuoBuildingSetup."QPR Budgets");

        EXIT(FALSE);
    END;

    PROCEDURE AccessToRealEstate(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //JAV 17/11/21: - QB 1.09.28 Retorna si est� activo real Estate
        IF (QuoBuildingSetup.READPERMISSION) THEN
            IF (QuoBuildingSetup.GET) THEN
                EXIT(QuoBuildingSetup."RE Real Estate");

        EXIT(FALSE);
    END;

    PROCEDURE AccessToReestimates(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //Si est�n activas las reestimaciones en QB
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup.Reestimates);
        END;

        EXIT(FALSE);
    END;

    PROCEDURE AccessToChangeBaseVtos(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //Si est� activado el cambio de fecha de vencimiento
        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            QuoBuildingSetup.GET();
            EXIT(QuoBuildingSetup."Calc Due Date" <> QuoBuildingSetup."Calc Due Date"::Standar);
        END;
        EXIT(FALSE);
    END;

    PROCEDURE AccessToPaymentPhases(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //Si est� activado el m�dulo de Fases de Pago
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET();
            EXIT(QuoBuildingSetup."Use Payment Phases");
        END;
        EXIT(FALSE);
    END;

    PROCEDURE AccessToContratsControl(VAR pSee: Boolean; VAR pEdit: Boolean);
    VAR
        QuoBuildingSetup: Record 7207278;
        UserSetup: Record 91;
    BEGIN
        //JAV 30/06/19: - se a�ade el campo de no controlar en contratos y su manejo
        pSee := FALSE;
        pEdit := FALSE;
        IF (AccessToQuobuilding) THEN BEGIN
            IF (QuoBuildingSetup.GET()) THEN
                pSee := QuoBuildingSetup."Use Contract Control";

            IF (UserSetup.GET(USERID)) THEN
                pEdit := UserSetup."Control Contracts";
        END;
    END;

    PROCEDURE AccessToDragAndDrop(rID: RecordID): Boolean;
    VAR
        SiteSharepointDefinition: Record 7174651;
    BEGIN
        //Si est� activado el m�dulo de Drag & drop
        //JAV 05/06/22: - QB 1.10.48 Se condiciona a que est� activa la tabla, si no dar� errores de configuraci�n
        IF (NOT AccessToTable(7174650, 11)) THEN
            EXIT(FALSE);

        SiteSharepointDefinition.RESET;
        SiteSharepointDefinition.SETRANGE(IdTable, rID.TABLENO);
        EXIT(NOT SiteSharepointDefinition.ISEMPTY);
    END;

    PROCEDURE AccessToFacturae(): Boolean;
    BEGIN
        //Si est� activado el m�dulo de Facturaci�n electr�nica
        EXIT(AccessToTable(7174368, 2));
    END;

    PROCEDURE AccessToSII(): Boolean;
    VAR
        ms: Integer;
    BEGIN
        //Retorna si no est� activo QuoSII pero est� activado el SII estandar de Business Central
        IF (AccessToQuoSII) THEN
            EXIT(FALSE)
        ELSE
            EXIT(AccessToTable(10751, 2));
    END;

    PROCEDURE AccessToQuoSII(): Boolean;
    VAR
        CompanyInformation: Record 79;
    BEGIN
        //Si est� activado el m�dulo de QuoSII
        IF AccessToTablePermision(7174331) THEN BEGIN
            CompanyInformation.GET;
            EXIT(CompanyInformation."QuoSII Activate");
        END;

        EXIT(FALSE);
    END;

    PROCEDURE AccessToObralia(): Boolean;
    VAR
        PurchasesPayablesSetup: Record 312;
    BEGIN
        //Si est� activado el m�dulo de Obralia
        IF PurchasesPayablesSetup.GET THEN
            EXIT(PurchasesPayablesSetup."Obralia Activated");

        EXIT(FALSE);
    END;

    PROCEDURE AccessToServiceOrder(pError: Boolean): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
        active: Boolean;
    BEGIN
        //JAV 14/10/21: - QB 1.09.21 Nueva funci�n AccessToServiceOrder que retorna si est� activado el m�dulo de Pedidos de servicio
        active := FALSE;
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET();
            active := QuoBuildingSetup."Use Service Order";
        END;

        IF (pError) AND (NOT active) THEN
            ERROR(Text002)
        ELSE
            EXIT(active);
    END;

    PROCEDURE AccessToExternalWorkers();
    VAR
        txtQB000: TextConst ESP = 'El uso de partes de trabajadores externos no est� operativo.';
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF AccessToQuobuilding THEN BEGIN
            QuoBuildingSetup.GET();
            IF (QuoBuildingSetup."Use External Wookshet" = QuoBuildingSetup."Use External Wookshet"::No) THEN
                ERROR(txtQB000);
        END;
    END;

    PROCEDURE AccessToWSReports(): Boolean;
    VAR
        txtQB000: TextConst ESP = 'El uso de partes de trabajadores externos no est� operativo.';
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF AccessToQuobuilding THEN BEGIN
            QuoBuildingSetup.GET();
            EXIT(QuoBuildingSetup."Use WS for Reports");
        END;
        EXIT(FALSE);
    END;

    PROCEDURE AccessToComparativeReferences(): Boolean;
    VAR
        rRef: RecordRef;
    BEGIN
        //Indica si se accede a la tabla de Arpada de L�neas de referencia de los comprativos
        IF AccessToTablePermision(50010) THEN BEGIN
            rRef.OPEN(50010);
            IF (rRef.NAME = 'Comparative Quote Lines ref') THEN
                EXIT(TRUE);
        END;
        EXIT(FALSE);
    END;

    PROCEDURE AutomaticInvoiceSending(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //JAV 15/05/22: - QB 1.10.41 Se a�ade la funci�n AccessToInternalMail que retorna si est� activo el env�o de mail interno para facturas/abonos de venta
        IF AccessToQuobuilding THEN BEGIN
            QuoBuildingSetup.GET();
            EXIT(QuoBuildingSetup."Internal Shippind Sales Inv." <> QuoBuildingSetup."Internal Shippind Sales Inv."::No);
        END;
        EXIT(FALSE);
    END;

    LOCAL PROCEDURE "--"();
    BEGIN
    END;

    PROCEDURE AccessToTable(pTable: Integer; pField: Integer): Boolean;
    VAR
        rRef: RecordRef;
        fRef: FieldRef;
    BEGIN
        //Busca un campo booleano en una tabla y retorna su valor
        IF AccessToTablePermision(pTable) THEN BEGIN
            rRef.OPEN(pTable);
            IF rRef.FINDFIRST THEN BEGIN
                fRef := rRef.FIELD(pField);
                IF (FORMAT(fRef.VALUE) = FORMAT(TRUE)) THEN
                    EXIT(TRUE);
            END;
        END;

        EXIT(FALSE);
    END;

    [TryFunction]
    LOCAL PROCEDURE AccessToTablePermision(pFile: Integer);
    VAR
        Object: Record 2000000001;
        rRef: RecordRef;
        fRef: FieldRef;
    BEGIN
        //Verifico que existe la tabla y puedo acceder a ella
        Object.RESET;
        Object.SETRANGE(Type, Object.Type::Table);
        Object.SETRANGE(ID, pFile);
        IF Object.ISEMPTY THEN
            ERROR('No existe la tabla');

        rRef.OPEN(pFile);
        IF rRef.FINDFIRST THEN;
        rRef.CLOSE;
    END;

    PROCEDURE AccessToDebitRelations(): Boolean;
    VAR
        QBRelationshipSetup: Record 7207335;
    BEGIN
        //Si tiene permiso para acceder al m�dulo de relaciones, existe la configuraci�, y estan activas las de cobro
        IF (QBRelationshipSetup.READPERMISSION) THEN
            IF (QBRelationshipSetup.GET) THEN
                EXIT(QBRelationshipSetup."RC Use Debit Relations");

        EXIT(FALSE);
    END;

    PROCEDURE AccessToPaymentRelations(): Boolean;
    VAR
        QBRelationshipSetup: Record 7207335;
    BEGIN
        //Si tiene permiso para acceder al m�dulo de relaciones, existe la configuraci�, y estan activas las de pago
        IF (QBRelationshipSetup.READPERMISSION) THEN
            IF (QBRelationshipSetup.GET) THEN
                EXIT(QBRelationshipSetup."RP Use Payment Relations");

        EXIT(FALSE);
    END;

    PROCEDURE OpenPageDebitRelations();
    VAR
        QBRelationshipSetup: Record 7207335;
    BEGIN
        //Verificar si est� habilitado el m�dulo de relaciones de cobros
        AccessToModule(AccessToDebitRelations);
    END;

    PROCEDURE OpenPagePaymentRelations();
    VAR
        QBRelationshipSetup: Record 7207335;
    BEGIN
        //Verificar si est� habilitado el m�dulo de relaciones de pagos
        AccessToModule(AccessToPaymentRelations);
    END;

    LOCAL PROCEDURE AccessToModule(pAccess: Boolean): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //Dar un mensaje de  error si no est� habilitado el m�dulo y no se puede usar esa pantalla
        IF (NOT pAccess) THEN
            ERROR(Text002);
    END;

    LOCAL PROCEDURE "-------------------------------------------- Accesos a configuraci¢n de QB"();
    BEGIN
    END;

    PROCEDURE QB_AccessToReferentes(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Use Referents");
        END;
        EXIT(FALSE);
    END;

    PROCEDURE QB_UseShipmentTypeInVendor(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Use Shipment type in Vendor");
        END;
        EXIT(FALSE);
    END;

    PROCEDURE QB_UserSeriesForJob(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Series for Job");
        END;
        EXIT(FALSE);
    END;

    PROCEDURE QB_UserSeriesForSales(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Use Sales Series");
        END;
        EXIT(FALSE);
    END;

    PROCEDURE QB_SeePostingNo(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."See Posting No");
        END;
        EXIT(FALSE);
    END;

    PROCEDURE QB_UseExternalWookshet(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Use External Wookshet" <> QuoBuildingSetup."Use External Wookshet"::No);
        END;
        EXIT(FALSE);
    END;

    PROCEDURE QB_MantContractPricesInFact(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Mant. Contract Prices In Fact.");
        END;
        EXIT(FALSE);
    END;

    PROCEDURE QB_JobAccessControl(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Job access control");
        END;
        EXIT(FALSE);
    END;

    PROCEDURE QB_ControlBudgetDates(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //JAV 09/07/21: - QB 1.09.04 Nueva funci�n QB_ControlBudgetDates que retorna si est� activo el control de fechas de los presupuestos
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Use Date Budget Control");
        END;
        EXIT(FALSE);
    END;

    PROCEDURE QB_UseConfirmingLines(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Use Confirming Lines");
        END;
        EXIT(FALSE);
    END;

    PROCEDURE QB_UseFactoringLines(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Use Factoring Lines");
        END;
        EXIT(FALSE);
    END;

    PROCEDURE QB_UseReferents(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Use Referents");
        END;
        EXIT(FALSE);
    END;

    PROCEDURE ReturnDimReferents(): Code[20];
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Referents Dimension");
        END;
        EXIT('');
    END;

    PROCEDURE QB_MaxDifAmountInvoice(): Decimal;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Max. Dif. Amount Invoice");
        END;
        EXIT(0);
    END;

    PROCEDURE QB_NoDaysCalcDueDate(): Integer;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (AccessToQuobuilding) THEN BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."No. Days Calc Due Date");
        END;
        EXIT(0);
    END;

    LOCAL PROCEDURE "------------------------------------------- Accesos como Administrador de QB"();
    BEGIN
    END;

    PROCEDURE IsQBAdmin(): Boolean;
    VAR
        User: Record 2000000120;
        i: Integer;
    BEGIN
        //JAV 13/10/20: - QB 1.06.20 Nueva funci�n para ver si el usuario es adminitrador de QB
        //JAV 29/04/21: - QB 1.08.41
        //JAV 12/06/21: - QB 1.08.48
        IF User.GET(USERSECURITYID) THEN BEGIN
            i := STRPOS(User."Contact Email", '@');
            IF (i > 0) THEN
                EXIT(LOWERCASE(COPYSTR(User."Contact Email", i)) IN ['@quonext.com', '@cei-eu.com', '@ceieu.com']);
        END;

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE "------------------------------------------- Funciones para Dimensiones Principales"();
    BEGIN
    END;

    PROCEDURE ReturnDimCA(): Code[20];
    VAR
        QuoBuildingSetup: Record 7207278;
        Text000: TextConst ENU = 'There�s no dimension to analytic concept. Go to General Ledger Setup and define.', ESP = 'No existe una dimensi�n para Conceptos Anal�ticos. Vaya a configuraci�n de contabilidad y definala.';
        Text002: TextConst ENU = 'There�s no dimension to analytic concept. Do you want to continue?', ESP = 'No existe una dimensi�n para Conceptos Anal�ticos. �Desea continuar?';
    BEGIN
        /*{
              Funci�n que nos devuelva cual es el C�digo de dimensi�n asociada a los conceptos anal�ticos.
              Par�metros de entrada : Ninguno.
              Par�metros de salida : Valor del C�d. de dimensi�n.
              }*/
        //JAV 29/10/19: - Se amplian las devoluciones de las funciones de dimensiones de 10 a 20

        QuoBuildingSetup.GET;

        IF QuoBuildingSetup."Dimension for CA Code" = '' THEN
            IF NOT CONFIRM(Text002, FALSE) THEN
                ERROR(Text000)
            ELSE
                EXIT(QuoBuildingSetup."Dimension for CA Code");

        EXIT(QuoBuildingSetup."Dimension for CA Code")
    END;

    PROCEDURE LookUpCA(VAR CodeDim: Code[20]; Editable: Boolean): Boolean;
    VAR
        DimensionValue: Record 349;
        DimensionValue2: Record 349;
        DimensionValueList: Page 560;
    BEGIN
        /*{
              Funci�n que realiza el Lookup de un campo que sea Concepto anal�tico y no este tratado como una dimensi�n.
              Par�metros de entrada :
                - Cod. del valor de dimensi�n seleccionado, se pasa por VALOR.
                - Booleano que indica si el formulario se lanza editable o no editable.
              Par�metros de salida : Booleano que indica que el usuario selecciono un valor y salio del formulario por ok.
              }*/
        //JAV 17/06/22: QB 1.10.50 Ligero cambio en condiciones del IF para que sea mas claro el c�digo
        IF (NOT AccessToQuobuilding) AND (NOT AccessToBudgets) AND (NOT AccessToRealEstate) THEN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            EXIT(FALSE);

        DimensionValue2.RESET;
        DimensionValue2.FILTERGROUP(2);
        DimensionValue2.SETRANGE("Dimension Code", ReturnDimCA);
        DimensionValue2.FILTERGROUP(0);

        //Q8101 >>
        CLEAR(DimensionValueList);
        DimensionValueList.SETTABLEVIEW(DimensionValue2);
        IF DimensionValue.GET(ReturnDimCA, CodeDim) THEN
            DimensionValueList.SETRECORD(DimensionValue);
        //Q8101 <<

        DimensionValueList.EDITABLE(Editable);
        DimensionValueList.LOOKUPMODE(TRUE);
        IF DimensionValueList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            DimensionValueList.GETRECORD(DimensionValue);
            CodeDim := DimensionValue.Code;
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    END;

    PROCEDURE ValidateCA(CodeDim: Code[20]);
    VAR
        DimensionValue: Record 349;
        Text007: TextConst ENU = 'There�s no anality Concept %1', ESP = 'No existe el Concepto anal�tico %1';
    BEGIN
        /*{
              Funci�n que realiza el Validate del campo CA cuando no va por dimensiones.
              Par�metros de entrada:
                - Cod. del valor de dimensi�n seleccionado, se pasa por referencia.
              }*/
        IF CodeDim = '' THEN
            EXIT;

        IF NOT DimensionValue.GET(ReturnDimCA, CodeDim) THEN
            ERROR(Text007, CodeDim);
    END;

    PROCEDURE GetCA(Table: Integer; codeMast: Code[20]): Code[20];
    VAR
        recDefaultDim: Record 352;
    BEGIN
        /*{
              Funci�n que nos devuelve el C�digo de dimensi�n CA de la dimensi�n por defecto para un registro.
              Par�metrs de entrada :
                - N� Tabla
                - ID del registro
              Par�metros de salida: Valor del C�d. de dimensi�n.
              }*/
        IF recDefaultDim.GET(Table, codeMast, ReturnDimCA) THEN
            EXIT(recDefaultDim."Dimension Value Code")
        ELSE
            EXIT('');
    END;

    PROCEDURE ReturnDimDpto(): Code[20];
    VAR
        QuoBuildingSetup: Record 7207278;
        Text003: TextConst ENU = 'The department dimension must be defined. Go to accounting setup and define it.', ESP = 'Debe estar definida la dimensi�n para departamentos. Vaya a configuraci�n de contabilidad y def�nala.';
        Text004: TextConst ENU = 'There�s no dimension to departaments. Do you want to continue?', ESP = 'No existe una dimensi�n para departamentos. �Desea continuar?';
    BEGIN
        /*{
              Funci�n que nos devuelve cual es el C�dgio de dimensi�n asociada a los departamentos.
              Par�metros de entrada : Ninguno.
              Par�metros de salida: Valor del C�d. de dimensi�n.
              }*/
        //JAV 29/10/19: - Se amplian las devoluciones de las funciones de dimensiones de 10 a 20

        QuoBuildingSetup.GET;
        //JAV QB.1.12.21 Se arregla un error al recuperar el c�digo de la dimensi�n Departamento. Estaba mal la variable que mira la dimensi�n
        //IF QuoBuildingSetup."Dimension for Jobs Code" = '' THEN
        IF (QuoBuildingSetup."Dimension for Dpto Code" = '') AND (AccessToQuobuilding) THEN
            IF NOT CONFIRM(Text004, FALSE) THEN
                ERROR(Text003)
            ELSE
                EXIT(QuoBuildingSetup."Dimension for Dpto Code");

        EXIT(QuoBuildingSetup."Dimension for Dpto Code");
    END;

    PROCEDURE LookUpDpto(VAR codeDim: Code[20]; Editable: Boolean): Boolean;
    VAR
        recDimValue: Record 349;
        recDimValue2: Record 349;
        pageListDimValue: Page 560;
    BEGIN
        CLEAR(pageListDimValue);
        recDimValue2.RESET;
        recDimValue2.FILTERGROUP(2);
        recDimValue2.SETRANGE("Dimension Code", ReturnDimDpto);
        recDimValue2.FILTERGROUP(0);

        IF recDimValue.GET(ReturnDimDpto, codeDim) THEN
            pageListDimValue.SETRECORD(recDimValue);

        pageListDimValue.SETTABLEVIEW(recDimValue2);
        pageListDimValue.LOOKUPMODE(TRUE);
        IF pageListDimValue.RUNMODAL = ACTION::LookupOK THEN BEGIN
            pageListDimValue.GETRECORD(recDimValue);
            codeDim := recDimValue.Code;
            EXIT(TRUE);
        END ELSE BEGIN
            recDimValue.INIT;
            EXIT(FALSE);
        END;
    END;

    PROCEDURE ValidateDpto(codeDim: Code[20]);
    VAR
        recDimValue: Record 349;
        Text008: TextConst ENU = 'Departament %1 don''t exist', ESP = 'No existe el Departamento %1';
    BEGIN
        //Funci�n que realiza el validate de el C�d. departamento y no este tratado como una dimensi�n.
        //Par�metros de entrada :
        //  - C�d. del valor de dimensi�n seleccionado, se para por referencia

        IF codeDim = '' THEN
            EXIT;

        IF NOT recDimValue.GET(ReturnDimDpto, codeDim) THEN
            ERROR(Text008, codeDim);
    END;

    PROCEDURE GetDepartment(table: Integer; codeMas: Code[20]): Code[20];
    VAR
        recDefaultDim: Record 352;
    BEGIN
        IF recDefaultDim.GET(table, codeMas, ReturnDimDpto) THEN
            EXIT(recDefaultDim."Dimension Value Code")
        ELSE
            EXIT('');
    END;

    LOCAL PROCEDURE "------------------------------------------- Funciones para Dimensiones"();
    BEGIN
    END;

    PROCEDURE GetDimValueFromID(pDimension: Code[20]; pDimensionSetID: Integer): Code[20];
    VAR
        DimensionManagement: Codeunit 408;
        TempDimSetEntry: Record 480 TEMPORARY;
        DimensionValue: Record 349;
    BEGIN
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //JAV 26/04/22: - QB 1.10.37 Esta funci�n actualiza un valor de dimensi�n en un registro de una tabla que tenga campos para las dimensiones globales
        // Par�metros de entrada :
        //    pDimension        : C�digo de la dimensi�n
        //    pDimensionSetID   : Valor del ID de dimensones
        // Par�metros de salida : Valor de la dimension o blancos
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        //Montar la tabla auxiliar
        DimensionManagement.GetDimensionSet(TempDimSetEntry, pDimensionSetID);
        //Si est� entre las dimensiones y ha cambiado la eliminamos
        IF (TempDimSetEntry.GET(pDimensionSetID, pDimension)) THEN
            EXIT(TempDimSetEntry."Dimension Value Code");

        EXIT('');
    END;

    PROCEDURE SetDimensionIDWithGlobals(pDim: Code[20]; pValue: Code[20]; VAR GlobalDimension1: Code[20]; VAR GlobalDimension2: Code[20]; VAR DimensionSetID: Integer);
    VAR
        DimensionManagement: Codeunit 408;
        TempDimSetEntry: Record 480 TEMPORARY;
        DimensionValue: Record 349;
    BEGIN
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //JAV 26/04/22: - QB 1.10.37 Esta funci�n actualiza un valor de dimensi�n en un registro de una tabla que tenga campos para las dimensiones globales
        // Par�metros de entrada :
        //    pDim                : C�digo de la dimensi�n
        //    pValue              : Valor de la dimensi�n
        //    VAR GlobalDimension1: Campo con la dimensi�n 1 en la tabla
        //    VAR GlobalDimension2: Campo con la dimensi�n 2 en la tabla
        //    VAR DimensionID     : Campo con el dimension Set ID en la tabla
        // Par�metros de salida : ninguno
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        //Si es la dimensi�n 1 o la 2 la procesamos con su campo, si no cambiamos solo el DimensionSetID
        CASE GetPosDimensions(pDim) OF
            1:
                BEGIN
                    DimensionManagement.ValidateShortcutDimValues(1, pValue, DimensionSetID);
                    GlobalDimension1 := pValue;
                END;
            2:
                BEGIN
                    DimensionManagement.ValidateShortcutDimValues(2, pValue, DimensionSetID);
                    GlobalDimension2 := pValue;
                END;
            ELSE BEGIN
                SetDimensionID(pDim, pValue, DimensionSetID);
            END;
        END;
    END;

    PROCEDURE SetDimensionID(pDim: Code[20]; pValue: Code[20]; VAR DimensionSetID: Integer);
    VAR
        DimensionManagement: Codeunit 408;
        TempDimSetEntry: Record 480 TEMPORARY;
        DimensionValue: Record 349;
    BEGIN
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //JAV 26/04/22: - QB 1.10.37 Esta funci�n actualiza un valor de dimensi�nID en un registro de una tabla
        // Par�metros de entrada :
        //    pDim                : C�digo de la dimensi�n
        //    pValue              : Valor de la dimensi�n
        //    VAR DimensionID     : Campo con el dimension Set ID en la tabla
        // Par�metros de salida : ninguno
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        //Montar la tabla auxiliar
        DimensionManagement.GetDimensionSet(TempDimSetEntry, DimensionSetID);
        //Si est� entre las dimensiones y ha cambiado la eliminamos
        IF (TempDimSetEntry.GET(DimensionSetID, pDim)) THEN BEGIN
            IF (TempDimSetEntry."Dimension Value Code" <> pValue) THEN
                TempDimSetEntry.DELETE;
        END;
        //La a�adimos si no existe
        IF (pValue <> '') THEN BEGIN
            DimensionValue.GET(pDim, pValue);
            TempDimSetEntry."Dimension Code" := pDim;
            TempDimSetEntry."Dimension Value Code" := pValue;
            TempDimSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
            IF TempDimSetEntry.INSERT THEN;
        END;
        //Buscar el nuevo ID del grupo de dimensiones
        DimensionSetID := DimensionManagement.GetDimensionSetID(TempDimSetEntry);
    END;

    PROCEDURE GetPosDimensions(CodeDim: Code[20]): Integer;
    VAR
        QuoBuildingSetup: Record 7207278;
        Text004: TextConst ENU = 'There isn�t defined a dimension in General Ledger Setup for the Cod. %1', ESP = 'No exite definida una dimension en configuaci�n de contabilidad para el C�d. de dimensi�n %1';
        GeneralLedgerSetup: Record 98;
    BEGIN
        // Nos devuelve cual es la posici�n en la que est� configurada una determinada dimensi�n.
        // Par�metros de entrada :
        // C�d. de dimensi�n
        // Par�metros de salida : valor entero que nos dice la posici�n de la dimensi�n, es decir, si nos da un 1
        // Quiere decir que dicha dimensi�n esta en el global dimensi�n 1, etc..

        QuoBuildingSetup.GET;
        GeneralLedgerSetup.GET;
        CASE TRUE OF
            GeneralLedgerSetup."Shortcut Dimension 1 Code" = CodeDim:
                EXIT(1);
            GeneralLedgerSetup."Shortcut Dimension 2 Code" = CodeDim:
                EXIT(2);
            GeneralLedgerSetup."Shortcut Dimension 3 Code" = CodeDim:
                EXIT(3);
            GeneralLedgerSetup."Shortcut Dimension 4 Code" = CodeDim:
                EXIT(4);
            GeneralLedgerSetup."Shortcut Dimension 5 Code" = CodeDim:
                EXIT(5);
            GeneralLedgerSetup."Shortcut Dimension 6 Code" = CodeDim:
                EXIT(6);
            GeneralLedgerSetup."Shortcut Dimension 7 Code" = CodeDim:
                EXIT(7);
            GeneralLedgerSetup."Shortcut Dimension 8 Code" = CodeDim:
                EXIT(8);
        END;

        ERROR(Text004, CodeDim);
    END;

    PROCEDURE ReturnDimJobs(): Code[20];
    VAR
        QuoBuildingSetup: Record 7207278;
        Text001: TextConst ESP = 'No est� activo QuoBuilding, Presupuestos o Promociones';
        Text002: TextConst ENU = 'The dimension for jobs must be defined. Go to accounting setup and define it.', ESP = 'Debe estar definida la dimensi�n para proyectos. Vaya a configuraci�n y def�nala.';
    BEGIN
        /*{
              Funci�n que nos devuelve cual es el C�dgio de dimensi�n asociada a los proyectos.
              Par�metros de entrada : Ninguno.
              Par�metros de salida: Valor del Cod. de dimensi�n.
              }*/
        //JAV 29/10/19: - Se amplian las devoluciones de las funciones de dimensiones de 10 a 20

        //JAV 17/06/22: QB 1.10.50 Ligero cambio en condiciones del IF para que sea mas claro el c�digo
        IF (NOT AccessToQuobuilding) AND (NOT AccessToBudgets) AND (NOT AccessToRealEstate) THEN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
                                                                                                   //JAV 11/10/22: - QB 1.12.02 Se cambia para que no de problemas cuando la empresa no tiene activo nada
                                                                                                   //ERROR(Text001);
            EXIT('');


        QuoBuildingSetup.GET;
        IF QuoBuildingSetup."Dimension for Jobs Code" = '' THEN
            ERROR(Text002);

        EXIT(QuoBuildingSetup."Dimension for Jobs Code");
    END;

    PROCEDURE ReturnDimQuote(): Code[20];
    VAR
        QuoBuildingSetup: Record 7207278;
        Text001: TextConst ESP = 'No est� activo QuoBuilding';
        Text002: TextConst ENU = 'The dimension for jobs must be defined. Go to accounting setup and define it.', ESP = 'Debe estar definida la dimensi�n para Estudios. Vaya a configuraci�n de QuoBuilding y def�nala.';
    BEGIN
        /*{
              Funci�n que nos devuelve cual es el C�digo de dimensi�n asociada a las ofertas.
              Par�metros de entrada : Ninguno.
              Par�metros de salida: Valor del Cod. de dimensi�n.
              }*/
        //JAV 29/10/19: - Se amplian las devoluciones de las funciones de dimensiones de 10 a 20

        IF (NOT AccessToQuobuilding) THEN
            ERROR(Text001);

        QuoBuildingSetup.GET;
        IF QuoBuildingSetup."Dimension for Quotes" = '' THEN
            ERROR(Text002);

        EXIT(QuoBuildingSetup."Dimension for Quotes");
    END;

    PROCEDURE ReturnDimBudget(): Code[20];
    VAR
        Text001: TextConst ESP = 'No est� activa la gesti�n de Presupuestos';
        Text002: TextConst ENU = 'The bid dimension must be defined. Go to Quobuilding settings and set it up.', ESP = 'Debe estar definida la dimensi�n para presupuestos. Vaya a configuraci�n de Quobuilding y def�nala.';
        QuoBuildingSetup: Record 7207278;
    BEGIN
        /////////////////////////////////////////////////////////////////////////////////////////////////////
        // Funci�n que nos devuelve cual es el C�digo de la dimensi�n asociada a los presupuestos.
        // Par�metros de entrada : Ninguno.
        // Par�metros de salida: Valor del Cod. de dimensi�n.
        /////////////////////////////////////////////////////////////////////////////////////////////////////
        // JAV 14/07/21: - QB 1.09.05 Nueva funci�n para retornar la dimensi�n del presupuesto

        IF (NOT AccessToBudgets) THEN
            ERROR(Text001);

        QuoBuildingSetup.GET;
        IF (QuoBuildingSetup."QPR Dimension for Budget" = '') THEN
            ERROR(Text002);

        EXIT(QuoBuildingSetup."QPR Dimension for Budget");
    END;

    PROCEDURE ReturnDimRE(): Code[20];
    VAR
        Text001: TextConst ESP = 'No est� activa la gesti�n de Proyectos Inmobiliarios';
        Text002: TextConst ENU = 'The bid dimension must be defined. Go to Quobuilding settings and set it up.', ESP = 'Debe estar definida la dimensi�n para Proyectos Inmobiliarios. Vaya a configuraci�n de Real Estate y def�nala.';
        QuoBuildingSetup: Record 7207278;
    BEGIN
        /////////////////////////////////////////////////////////////////////////////////////////////////////
        // Funci�n que nos devuelve cual es el C�digo de la dimensi�n asociada a Poryectos de Real Estate.
        // Par�metros de entrada : Ninguno.
        // Par�metros de salida: Valor del Cod. de dimensi�n.
        /////////////////////////////////////////////////////////////////////////////////////////////////////
        // JAV 17/11/21: - QB 1.09.28 Nueva funci�n para retornar la dimensi�n del presupuesto

        IF (NOT AccessToRealEstate) THEN
            ERROR(Text001);

        QuoBuildingSetup.GET;
        IF (QuoBuildingSetup."RE Dimension for RE Proyect" = '') THEN
            ERROR(Text002);

        EXIT(QuoBuildingSetup."RE Dimension for RE Proyect");
    END;

    PROCEDURE ReturnDescDim(PCodeDim: Code[20]): Text[30];
    VAR
        Dimension: Record 348;
    BEGIN
        IF Dimension.GET(PCodeDim) THEN
            EXIT(Dimension."Code Caption")
        ELSE
            EXIT('');
    END;

    PROCEDURE ReturnDimJV(): Code[20];
    VAR
        QuoBuildingSetup: Record 7207278;
        Text014: TextConst ENU = 'There isn�t dimension for JV. Go to accounting setup and define it.', ESP = 'No existe una dimensi�n para UTE. Vaya a configuraci�n de contabilidad y def�nala.';
    BEGIN
        /*{
              Funci�n que nos devuleve cual es el C�digo de dimensi�n asociada a la UTE.
              Par�meros de entrada: Ninguno.
              Par�metros de salida: Vlor del Cod. de dimensi�n.
              }*/
        QuoBuildingSetup.GET;
        IF QuoBuildingSetup."Dimension for JV Code" = '' THEN
            ERROR(Text014);

        EXIT(QuoBuildingSetup."Dimension for JV Code");
    END;

    PROCEDURE ReturnDimReest(): Code[20];
    VAR
        QuoBuildingSetup: Record 7207278;
        Text005: TextConst ENU = 'It doesn''t exists a No. Reestimation Dimension. Go to General Ledger Setup and define one.', ESP = 'No existe una dimensi�n c�d. reestimaci�n. Vaya a configuraci�n de contabilidad y def�nala.';
        Text012: TextConst ESP = '@@@@@@';
    BEGIN
        QuoBuildingSetup.GET;
        IF QuoBuildingSetup.Reestimates THEN BEGIN
            IF QuoBuildingSetup."Dimension for Reestim. Code" = '' THEN
                ERROR(Text005);
            EXIT(QuoBuildingSetup."Dimension for Reestim. Code");
        END ELSE
            EXIT(Text012);
    END;

    PROCEDURE ReturnBudget(VAR Job: Record 167): Code[20];
    VAR
        QuoBuildingSetup: Record 7207278;
        BudgetCode: Code[20];
    BEGIN
        //Funcion que nos devuelve cual es el presupuesto relacionado con un registro de la tabla Job. Este valor se establece en QuoBuilding Setup.
        //Par�metros de entrada : Registro Job del que obtener el presupuesto
        //Par�metros de salida : Valor del C�d. de presupuestos.

        CASE Job."Card Type" OF
            Job."Card Type"::Estudio:
                BudgetCode := ReturnBudgetQuote;
            Job."Card Type"::"Proyecto operativo":
                BudgetCode := ReturnBudgetJobs;
        END;

        //Si ha cambiado el presupuesto, tengo que cambiarlo en la tabla para que sea consistente siempre
        IF (Job."Jobs Budget Code" <> BudgetCode) THEN BEGIN
            Job."Jobs Budget Code" := BudgetCode;
            Job.MODIFY(FALSE);
        END;

        EXIT(BudgetCode);
    END;

    PROCEDURE ReturnBudgetJobs(): Code[20];
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //Funcion que nos devuelve cual es el presupuesto para proyectos. Este valor se establece en QuoBuilding Setup.
        //Par�metros de entrada : Ninguno.
        //Par�metros de salida : Valor del C�d. de presupuestos.

        QuoBuildingSetup.GET;
        IF QuoBuildingSetup."Budget for Jobs" = '' THEN
            ERROR(Text001a);

        EXIT(QuoBuildingSetup."Budget for Jobs");
    END;

    PROCEDURE ReturnBudgetQuote(): Code[10];
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //Funcion que nos devuelve cual es el presupuesto para ofertas. Este valor se establece en QuoBuilding Setup.
        //Par�metros de entrada : Ninguno.
        //Par�metros de salida : Valor del C�d. de presupuestos.

        QuoBuildingSetup.GET;
        IF QuoBuildingSetup."Budget for Quotes" = '' THEN
            ERROR(Text001b);

        EXIT(QuoBuildingSetup."Budget for Quotes");
    END;

    PROCEDURE ReturnAnalysisView();
    BEGIN
    END;

    PROCEDURE ReturnDepartmentOrganization(DimSetID: Integer): Code[20];
    VAR
        DimensionValue: Record 349;
        QBDepartments: Record 7207002;
        Dep: Code[20];
    BEGIN
        //JAV 25/06/22: - QB 1.10.54 Retorna el departamento asociado al valor de la dimensi�n departamentos del registro a trav�s de su ID Dimension
        EXIT(ChangeDepartmentOrganization(GetDimValueFromID(ReturnDimDpto, DimSetID)));
    END;

    PROCEDURE ReturnDepartmentOrganizationByDefDim(pTable: Integer; pCode: Code[20]): Code[20];
    VAR
        DefaultDimension: Record 352;
        DimensionValue: Record 349;
        QBDepartments: Record 7207002;
        Dep: Code[20];
    BEGIN
        //JAV 25/06/22: - QB 1.10.54 Retorna el departamento asociado al valor de la dimensi�n departamentos del registro a trav�s de su dimensi�n por defecto
        IF (DefaultDimension.GET(pTable, pCode, ReturnDimDpto)) THEN
            EXIT(ChangeDepartmentOrganization(DefaultDimension."Dimension Value Code"))
        ELSE
            EXIT('');
    END;

    LOCAL PROCEDURE ChangeDepartmentOrganization(pDep: Code[20]): Code[20];
    VAR
        DimensionValue: Record 349;
        QBDepartments: Record 7207002;
        Dep: Code[20];
    BEGIN
        //Miro si el valor de dimensi�n est� asociado a un departamento de la organizaci�n, si no lo est� ser� el mismo c�digo
        IF (DimensionValue.GET(ReturnDimDpto, pDep)) THEN
            IF (DimensionValue."QB Department" <> '') THEN
                Dep := DimensionValue."QB Department";

        //Busco el departamento de la organizaci�n
        IF (QBDepartments.GET(Dep)) THEN
            pDep := QBDepartments.Code
        ELSE
            pDep := '';

        EXIT(pDep);
    END;

    LOCAL PROCEDURE "------------------------------------------- Funciones generales"();
    BEGIN
    END;

    PROCEDURE ShowDescriptionJob(JobCode: Code[20]): Text[80];
    VAR
        Job: Record 167;
    BEGIN
        IF Job.GET(JobCode) THEN
            EXIT(FORMAT(JobCode) + ' ' + Job.Description)
        ELSE
            EXIT('');
    END;

    PROCEDURE LookUpJV(VAR CodeDim: Code[20]; Editable: Boolean): Boolean;
    VAR
        DimensionValue2: Record 349;
        PageDimensionValues: Page 537;
        DimensionValue: Record 349;
    BEGIN
        /*{
              Funci�n que realiza el Lookup de un campo que sea UTE y no este tratado como una dimensi�n.
              Par�metros de entrada:
                - Cod. del valor de dimensi�n seleccionado, se pasa por referencia.
                - Booleano que indica si el formulario se lanza editable o No editable.
              Par�metros de salida: Booleano que indica que el usuario selecciono un valor y salio del formulario por ok.
              }*/
        CLEAR(PageDimensionValues);
        DimensionValue2.RESET;
        DimensionValue2.FILTERGROUP(2);
        DimensionValue2.SETRANGE("Dimension Code", ReturnDimJV);
        DimensionValue2.FILTERGROUP(0);

        IF DimensionValue.GET(ReturnDimJV, CodeDim) THEN
            PageDimensionValues.SETRECORD(DimensionValue);

        PageDimensionValues.SETTABLEVIEW(DimensionValue2);
        PageDimensionValues.EDITABLE(Editable);
        PageDimensionValues.LOOKUPMODE(TRUE);
        IF PageDimensionValues.RUNMODAL = ACTION::LookupOK THEN BEGIN
            PageDimensionValues.GETRECORD(DimensionValue);
            CodeDim := DimensionValue.Code;
            EXIT(TRUE);
        END ELSE BEGIN
            DimensionValue.INIT;
            EXIT(FALSE);
        END;
    END;

    PROCEDURE ValidateJV(codeDim: Code[20]);
    VAR
        DimensionValue: Record 349;
        Text015: TextConst ENU = 'The isn�t UTE %1', ESP = 'No existe la UTE %1';
    BEGIN
        /*{
              Funci�n que realiza el Validate del campo UTE cuando no va por dimensiones.
              Par�metros de entrada:
                - Cod. del valor de dimensi�n seleccionado, se pasa por referenca.
              }*/
        IF codeDim = '' THEN
            EXIT;

        IF NOT DimensionValue.GET(ReturnDimJV, codeDim) THEN
            ERROR(Text015, codeDim);
    END;

    PROCEDURE UpdateDimSet(DimCode: Code[20]; DimValueCode: Code[20]; VAR SetDimID: Integer);
    VAR
        DimensionValue: Record 349;
        DimensionSetEntry: Record 480 TEMPORARY;
        DimensionManagement: Codeunit 408;
    BEGIN
        //Actualiza el ID de diemnsiones a partir de una dimensi�n y su valor de dimensi�n
        IF DimCode = '' THEN
            EXIT;
        //Montar la tabla temporal
        DimensionManagement.GetDimensionSet(DimensionSetEntry, SetDimID);
        //Si ya existe un valor para esa dimensi�n lo elimino, as� si ahora est� en blanco ya no estar� en la lista
        IF DimensionSetEntry.GET(SetDimID, DimCode) THEN
            DimensionSetEntry.DELETE;
        //Inserto el nuevo valor de la dimensi�n en la temporal
        IF DimValueCode <> '' THEN BEGIN
            DimensionValue.GET(DimCode, DimValueCode);
            DimensionSetEntry."Dimension Set ID" := SetDimID;
            DimensionSetEntry."Dimension Code" := DimCode;
            DimensionSetEntry."Dimension Value Code" := DimValueCode;
            DimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
            DimensionSetEntry.INSERT;
        END;
        //Obtengo el ID a partir de la temporal
        SetDimID := DimensionManagement.GetDimensionSetID(DimensionSetEntry);
    END;

    PROCEDURE ValidateReest(codeDim: Code[20]);
    VAR
        DimensionValue: Record 349;
        Text011: TextConst ENU = 'Reestimate %1 doesn''t exists.', ESP = 'No existe Reestimaci�n %1';
    BEGIN
        IF codeDim = '' THEN
            EXIT;
        IF NOT DimensionValue.GET(ReturnDimReest, codeDim) THEN
            ERROR(Text011, codeDim);
    END;

    PROCEDURE LookUpReest(VAR codeDim: Code[20]; Editable: Boolean): Boolean;
    VAR
        DimensionValue: Record 349;
        DimensionValue2: Record 349;
        DimensionValueList: Page 560;
    BEGIN
        CLEAR(DimensionValueList);
        DimensionValue2.RESET;
        DimensionValue2.FILTERGROUP(2);
        DimensionValue2.SETRANGE("Dimension Code", ReturnDimReest);
        DimensionValue2.FILTERGROUP(0);
        IF DimensionValue.GET(ReturnDimReest, codeDim) THEN
            DimensionValueList.SETRECORD(DimensionValue);
        DimensionValueList.SETTABLEVIEW(DimensionValue2);
        DimensionValueList.EDITABLE(Editable);
        DimensionValueList.LOOKUPMODE(TRUE);
        IF DimensionValueList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            DimensionValueList.GETRECORD(DimensionValue);
            codeDim := DimensionValue.Code;
            EXIT(TRUE);
        END ELSE BEGIN
            DimensionValue.INIT;
            EXIT(FALSE);
        END;
    END;

    PROCEDURE UseCurrenciesInJobs(Type: Option "Job","Budget","RE"): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        QuoBuildingSetup.GET();
        CASE Type OF
            Type::Job:
                EXIT(QuoBuildingSetup."Use Currency in Jobs");
            Type::Budget:
                EXIT(QuoBuildingSetup."QPR Use Currency in Budgets");
            Type::RE:
                EXIT(QuoBuildingSetup."RE Use Currency in RE");
        END;
        EXIT(FALSE);
    END;

    PROCEDURE AccessToWithholding(): Boolean;
    VAR
        WithholdingMovements: Record 7207329;
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF QuoBuildingSetup.GET THEN
            EXIT(WithholdingMovements.READPERMISSION AND QuoBuildingSetup."QW Withholding");
    END;

    PROCEDURE AccessToRentalManagement(): Boolean;
    VAR
        RentalSetup: Record 7207346;
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF QuoBuildingSetup.GET THEN
            EXIT(RentalSetup.READPERMISSION AND QuoBuildingSetup."Rental Management");
    END;

    PROCEDURE CheckCharacters(TextFieldName: Text[250]; TextFieldValue: Text[250]);
    VAR
        LBooForbidCharac: Boolean;
        Text50000: TextConst ENU = 'The %1,\can not contain any of the following characters:\ %2', ESP = 'El %1,\no puede contener ning�no de los siguientes caracteres:\%2';
    BEGIN
        LBooForbidCharac := STRPOS(TextFieldValue, '+') <> 0;
        IF NOT LBooForbidCharac THEN
            LBooForbidCharac := STRPOS(TextFieldValue, '-') <> 0;
        IF NOT LBooForbidCharac THEN
            LBooForbidCharac := STRPOS(TextFieldValue, '*') <> 0;
        IF NOT LBooForbidCharac THEN
            LBooForbidCharac := STRPOS(TextFieldValue, '/') <> 0;
        IF NOT LBooForbidCharac THEN
            LBooForbidCharac := STRPOS(TextFieldValue, '^') <> 0;
        IF NOT LBooForbidCharac THEN
            LBooForbidCharac := STRPOS(TextFieldValue, '%') <> 0;
        IF NOT LBooForbidCharac THEN
            LBooForbidCharac := STRPOS(TextFieldValue, '[') <> 0;
        IF NOT LBooForbidCharac THEN
            LBooForbidCharac := STRPOS(TextFieldValue, ']') <> 0;
        IF NOT LBooForbidCharac THEN
            LBooForbidCharac := STRPOS(TextFieldValue, '@') <> 0;
        IF NOT LBooForbidCharac THEN
            LBooForbidCharac := STRPOS(TextFieldValue, '|') <> 0;
        IF NOT LBooForbidCharac THEN
            LBooForbidCharac := STRPOS(TextFieldValue, '&') <> 0;

        IF LBooForbidCharac THEN
            ERROR(Text50000, TextFieldName, '+,-,*,/,^,%,],[,@,&,|');
    END;

    PROCEDURE Translate(LanguageID: Integer; Type: Integer; ID: Integer; VAR Name: Text[80]);
    VAR
        WindowsLanguage: Record 2000000045;
        ApplicationManagement: Codeunit 43;
        ApplicationManagement2: Codeunit 50212;
        ObjectTranslation: Record 377;
    BEGIN
        IF LanguageID <> ApplicationManagement2.ApplicationLanguage THEN BEGIN

            // The selected WindowsLanguage
            IF ObjectTranslation.GET(Type, ID, LanguageID) THEN
                Name := ObjectTranslation.Description
            ELSE BEGIN
                // The primary WindowsLanguage of the selected WindowsLanguage
                IF (WindowsLanguage.GET(LanguageID)) AND
                   (WindowsLanguage."Primary Language ID" <> LanguageID) AND
                   (ObjectTranslation.GET(Type, ID, WindowsLanguage."Primary Language ID"))
                THEN
                    Name := ObjectTranslation.Description
                ELSE
                    // The global WindowsLanguage
                    IF (GLOBALLANGUAGE <> ApplicationManagement2.ApplicationLanguage) AND
                       (GLOBALLANGUAGE <> LanguageID)
                    THEN
                        IF ObjectTranslation.GET(Type, ID, GLOBALLANGUAGE) THEN
                            Name := ObjectTranslation.Description;
            END;
        END;
    END;

    PROCEDURE AllowReestimationMonth(pMonth: Integer): Boolean;
    VAR
        TxtMsgError01: TextConst ESP = 'Mes no v�lido';
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //JAV 20/07/21: - QB 1.09.11 Esta funci�n retorna si se puede reestimar el mes que le pasemos como par�metro
        IF AccessToQuobuilding THEN BEGIN
            QuoBuildingSetup.GET;
            IF (QuoBuildingSetup."Block Reestimations") THEN BEGIN
                CASE pMonth OF
                    1:
                        EXIT(QuoBuildingSetup."Allow in January");
                    2:
                        EXIT(QuoBuildingSetup."Allow in February");
                    3:
                        EXIT(QuoBuildingSetup."Allow in March");
                    4:
                        EXIT(QuoBuildingSetup."Allow in April");
                    5:
                        EXIT(QuoBuildingSetup."Allow in May");
                    6:
                        EXIT(QuoBuildingSetup."Allow in June");
                    7:
                        EXIT(QuoBuildingSetup."Allow in July");
                    8:
                        EXIT(QuoBuildingSetup."Allow in August");
                    9:
                        EXIT(QuoBuildingSetup."Allow in September");
                    10:
                        EXIT(QuoBuildingSetup."Allow in October");
                    11:
                        EXIT(QuoBuildingSetup."Allow in November");
                    12:
                        EXIT(QuoBuildingSetup."Allow in December");
                    ELSE
                        ERROR(TxtMsgError01);
                END;
            END ELSE
                EXIT(TRUE);
        END;
    END;

    PROCEDURE GetBankName(BankNo: Code[20]): Text;
    VAR
        BankAccount: Record 270;
    BEGIN
        //JAV 25/11/21: - QB 1.10.01 Retorna el nombre de un banco
        //Q9176 >>
        IF BankAccount.GET(BankNo) THEN
            EXIT(BankAccount.Name)
        ELSE
            EXIT('');
        //Q9176 <<
    END;

    PROCEDURE Job_IsBudget(JobNo: Code[20]): Boolean;
    VAR
        Job: Record 167;
    BEGIN
        //JAV 27/10/21: - QB 1.09.23 Retorna si un proyecto se controla por presupuestos a partir de su c�digo
        //JAV 18/12/21: - QB 1.10.09 Se modifica para que considere que el proyecto sea de Presupuestos o de Real Estate
        IF (JobNo <> '') THEN
            IF (Job.GET(JobNo)) THEN
                EXIT(Job."Card Type" IN [Job."Card Type"::Presupuesto, Job."Card Type"::Promocion, Job."Card Type"::Suelo]);  //JAV 06/05/22: - QB 1.10.40 Se a�ade Suelo

        EXIT(FALSE);
    END;

    PROCEDURE Job_AllowServiceOrder(JobNo: Code[20]): Boolean;
    VAR
        Job: Record 167;
    BEGIN
        //JAV 27/10/21: - QB 1.09.23 Retorna si un proyecto permite pedidos de servicio
        IF (AccessToServiceOrder(FALSE)) THEN
            IF (JobNo <> '') THEN
                IF (Job.GET(JobNo)) THEN
                    EXIT(Job."QB Allow Service Order");

        EXIT(FALSE);
    END;

    PROCEDURE Job_ByBudgetItem(JobNo: Code[20]): Boolean;
    VAR
        Job: Record 167;
    BEGIN
        //Q15977: - Devuelve si un proyecto se manipula mediante partidas presupuestarias
        //Hay que reemplazar esta funcion por Job_IsBudget que se usa mas veces
        IF (AccessToBudgets) THEN
            EXIT(Job_IsBudget(JobNo));

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE "------------------------------------------ Filtros de proyecto y centro de responsabilidad"();
    BEGIN
    END;

    PROCEDURE GetUserJobResponsibilityCenter(): Code[10];
    VAR
        CompanyInfo: Record 79;
        UserSetup: Record 91;
        UserLocation: Code[10];
        UserRespCenter: Code[10];
        HasGotSalesUserSetup: Boolean;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            IF NOT HasGotSalesUserSetup THEN BEGIN
                CompanyInfo.GET;
                UserRespCenter := CompanyInfo."Responsibility Center";
                UserLocation := CompanyInfo."Location Code";
                IF (UserSetup.GET(USERID)) AND (USERID <> '') THEN
                    IF UserSetup."Jobs Resp. Ctr. Filter" <> '' THEN
                        UserRespCenter := UserSetup."Jobs Resp. Ctr. Filter";
                HasGotSalesUserSetup := TRUE;
            END;
            EXIT(UserRespCenter);
        END;
    END;

    PROCEDURE UserAccessToAllJobs(): Boolean;
    VAR
        UserSetup: Record 91;
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //JAV 11/07/20: - Funci�n que retorna si el usuario accede a todos los proyectos o se deben filtrar los que tenga asociada responsabilidad
        //JAV 15/12/21: - QB 1.10.08 Si no est�n activos los m�dulos relacionados con proyectos, se debe tener acceso a todos los proyectos

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            QuoBuildingSetup.GET;
            IF NOT QuoBuildingSetup."Job access control" THEN
                EXIT(TRUE);
            IF UserSetup.GET(USERID) THEN
                EXIT(UserSetup."View all Jobs");

            EXIT(FALSE);  //Si hay control de accesos y el usuario no est� en la lista o no tiene permiso expreso, no debe ver todos los proyectos
        END ELSE
            EXIT(TRUE);   //Si no hay m�dulos espec�ficos de control de proyectos activos, no entra el control de usuarios.
    END;

    PROCEDURE GetJobFilter(VAR HasGotSalesUserSetup: Boolean; VAR UserRespCenter: Code[10]);
    VAR
        CompanyInformation: Record 79;
        UserSetup: Record 91;
    BEGIN
        //QBCodeunitPublisher.GetJobFilter(HasGotSalesUserSetup,UserRespCenter);
        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            IF NOT HasGotSalesUserSetup THEN BEGIN
                CompanyInformation.GET;
                UserRespCenter := CompanyInformation."Responsibility Center";
                //++ Esto no se usa    UserLocation := CompanyInformation."Location Code";
                IF (UserSetup.GET(USERID)) AND (USERID <> '') THEN
                    IF UserSetup."Jobs Resp. Ctr. Filter" <> '' THEN
                        UserRespCenter := UserSetup."Jobs Resp. Ctr. Filter";
                HasGotSalesUserSetup := TRUE;
            END;
        END;
    END;

    PROCEDURE GetUserJobsFilter(): Text;
    VAR
        QBJobResponsible: Record 7206992;
        filtro: Text;
        Vacio: TextConst ESP = '''''';
        tmpJob: Record 167 TEMPORARY;
    BEGIN
        //JAV 18/07/20: - Retorna la lista de proyectos a los que el usuario tiene acceso, si tiene acceso a todos retorna vacio
        //AML 200083Esto puede duplicar los filtros y se puede desbordar el campo.
        /*{
              filtro := '';
              IF (NOT UserAccessToAllJobs) THEN BEGIN
                filtro := Vacio + '|';  //Incluyo el proyecto vac�o
                QBJobResponsible.RESET;
                QBJobResponsible.SETRANGE("User ID", USERID);
                QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Job);    //JAV 23/10/20 - QB 1.07.00 Se a�ade que es para proyectos
                IF QBJobResponsible.FINDSET(FALSE) THEN
                  REPEAT
                    filtro += QBJobResponsible."Table Code" + '|';
                  UNTIL QBJobResponsible.NEXT = 0;
              END;
              filtro := DELCHR(filtro,'>','|');

              EXIT(filtro);
              }*/
        tmpJob.DELETEALL;

        filtro := '';
        IF (NOT UserAccessToAllJobs) THEN BEGIN
            QBJobResponsible.RESET;
            QBJobResponsible.SETRANGE("User ID", USERID);
            QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Job);    //JAV 23/10/20 - QB 1.07.00 Se a�ade que es para proyectos
            IF QBJobResponsible.FINDSET(FALSE) THEN
                REPEAT
                    tmpJob."No." := QBJobResponsible."Table Code";
                    IF tmpJob.INSERT THEN; //Por si se repite
                UNTIL QBJobResponsible.NEXT = 0;
            filtro := Vacio + '|';  //Incluyo el proyecto vac�o
            IF tmpJob.FINDSET THEN
                REPEAT
                    filtro += tmpJob."No." + '|';
                UNTIL tmpJob.NEXT = 0;
        END;
        filtro := DELCHR(filtro, '>', '|');

        EXIT(filtro);
    END;

    PROCEDURE SetUserJobsFilter(VAR Rec: Record 167);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la lista de proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobsJobLedgerEntryFilter(VAR Rec: Record 169);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la lista de movimientos de proyecto a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobsResLedgerEntryFilter(VAR Rec: Record 203);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la lista movimientos de recurso a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobSalesFilter(VAR Rec: Record 36);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la lista de documentos de venta seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("QB Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("QB Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobSalesShipmentHeaderFilter(VAR Rec: Record 110);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la lista de documentos de albaranes de venta seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobSalesInvoiceHeaderFilter(VAR Rec: Record 112);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la lista de documentos de facturas de venta seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobSalesCrMemoHeaderFilter(VAR Rec: Record 114);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la lista de documentos de abonos de venta seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobPurchasesFilter(VAR Rec: Record 38);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la lista de documentos de compra seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("QB Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("QB Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobPurchRcptHeaderFilter(VAR Rec: Record 120);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la lista de documentos de abonos de compra seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobPurchInvHeaderFilter(VAR Rec: Record 122);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la lista de documentos de compra seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobPurchCrMemoHdrFilter(VAR Rec: Record 124);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la lista de documentos de abonos de compra seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobComparativeFilter(VAR Rec: Record 7207412);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la lista de comparativos de compra seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobContractControlFilter(VAR Rec: Record 7206912);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la lista de control de contratos seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER(Proyecto);
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER(Proyecto, filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobWorksheetFilter(VAR Rec: Record 7207290);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la lista de partes de trabajo seg�n los proyectos a los que el usuario tiene acceso

        IF (Rec."Sheet Type" = Rec."Sheet Type"::"By Job") THEN BEGIN
            //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
            Rec.FILTERGROUP(2);
            filtro := Rec.GETFILTER("Job No.");
            Rec.FILTERGROUP(0);
            IF (filtro <> '') THEN
                EXIT;

            IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
                filtro := GetUserJobsFilter;
                IF (filtro <> '') THEN BEGIN
                    Rec.FILTERGROUP(1);
                    Rec.SETFILTER("Job No.", filtro);
                    Rec.FILTERGROUP(0);
                END;
            END;
        END;
    END;

    PROCEDURE SetUserJobOutputShipmentHeaderFilter(VAR Rec: Record 7207308);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la tabla de salidas de almac�n seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobPostedOutputShipmentHeaderFilter(VAR Rec: Record 7207310);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la tabla de salidas de almac�n registradas seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobMeasurementHeaderFilter(VAR Rec: Record 7207336);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la tabla de mediciones seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobHistMeasurementsFilter(VAR Rec: Record 7207338);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la tabla del hist�rico de mediciones seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobPostCertificationsFilter(VAR Rec: Record 7207341);
    VAR
        filtro: Text;
    BEGIN
        //JAV 18/07/20: - Filtra la tabla de certificaciones registradas seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobCarteraDocFilter(VAR Rec: Record 7000002);
    VAR
        filtro: Text;
    BEGIN
        //JAV 26/01/20: - Filtra la tabla de documentos en cartera seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobCostSheetHeaderFilter(VAR Rec: Record 7207433);
    VAR
        filtro: Text;
    BEGIN
        //CPA 03/02/22: - Q16275 Filtra la tabla de partes de costes seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobPostedCostsheetHeaderFilter(VAR Rec: Record 7207435);
    VAR
        filtro: Text;
    BEGIN
        //CPA 03/02/22: - Q16275 Filtra la tabla de Hco. partes de costes seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobPostedCertificationsHeaderFilter(VAR Rec: Record 7207341);
    VAR
        filtro: Text;
    BEGIN
        //CPA 03/02/22: - Q16275 Filtra la tabla de Hco. Certificaciones seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobPostedProdMeasureHeaderFilter(VAR Rec: Record 7207401);
    VAR
        filtro: Text;
    BEGIN
        //CPA 03/02/22: - Q16275 Filtra la tabla Hco. Mediciones seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE SetUserJobDetailedVendorLedgerEntriesFilter(Rec: Record 380);
    VAR
        filtro: Text;
    BEGIN
        //CPA 03/02/22: - Q16275 Filtra la tabla Hco. Mediciones seg�n los proyectos a los que el usuario tiene acceso

        //JAV 15/12/21: - QB 1.10.08 Si se ha entrado con un proyecto, no filtramos mas
        Rec.FILTERGROUP(2);
        filtro := Rec.GETFILTER("QB Job No.");
        Rec.FILTERGROUP(0);
        IF (filtro <> '') THEN
            EXIT;

        IF (AccessToQuobuilding OR AccessToBudgets OR AccessToRealEstate) THEN BEGIN   //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
            filtro := GetUserJobsFilter;
            IF (filtro <> '') THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("QB Job No.", filtro);
                Rec.FILTERGROUP(0);
            END;
        END;
    END;

    PROCEDURE LookupUserJobs(VAR pJobNo: Code[20]): Boolean;
    VAR
        Job: Record 167;
        Job2: Record 167;
        JobList: Page 89;
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //JAV 18/07/20: - Sacar una lista de proyectos filtrados por los que puede ver por el usuario
        Job.RESET;
        SetUserJobsFilter(Job);

        //JAV 26/10/21: - QB 1.09.23 Incluir proyectos operativos y presupuestos
        //JAV 15/12/21: - QB 1.10.08 Se amplian los posibles lugares donde est� activo el filtro
        Job.SETFILTER("Card Type", '%1|%2|%3|%4', Job."Card Type"::Promocion, Job."Card Type"::Suelo, Job."Card Type"::"Proyecto operativo", Job."Card Type"::Presupuesto);  //Por defecto no saco los estudios en documentos de compra //Q15977

        //JAV 28/04/22: - QB 1.10.38 Si pasamos con un proyecto, filtramos que solo se vean los de su mismo tipo
        //JAV 16/06/22: - QB 1.10.50 Se condiciona el filtro del proyecto del mismo tipo al nuevo check para filtrar proyectos del mismo tipo en compras
        IF (QuoBuildingSetup.GET) THEN
            IF (QuoBuildingSetup."Fiter Same Job Type") THEN
                IF (Job2.GET(pJobNo)) THEN
                    Job.SETRANGE("Card Type", Job2."Card Type");

        //JAV 16/06/22: - QB 1.10.50 Filtrar que no salgan por defecto los archivados
        Job.SETRANGE(Archived, FALSE);

        CLEAR(JobList);
        JobList.LOOKUPMODE(TRUE);
        JobList.SETTABLEVIEW(Job);
        IF Job2.GET(pJobNo) THEN  //JAV 03/03/22: - QB 1.10.22 Si se ha indicado un proyecto lo pongo como el proyecto activo de la lista
            JobList.SETRECORD(Job2);
        IF (JobList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
            JobList.GETRECORD(Job);
            pJobNo := Job."No.";
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    END;

    PROCEDURE CanUserAccessJob(pJob: Code[20]): Boolean;
    VAR
        QBJobResponsible: Record 7206992;
    BEGIN
        //JAV 18/07/20: - Retorna si un usuario tiene acceso al proyecto
        IF (UserAccessToAllJobs) THEN
            EXIT(TRUE);

        QBJobResponsible.RESET;
        QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Job);    //JAV 23/10/20 - QB 1.07.00 Se a�ade que es para proyectos
        QBJobResponsible.SETRANGE("Table Code", pJob);
        QBJobResponsible.SETRANGE("User ID", USERID);
        EXIT(NOT QBJobResponsible.ISEMPTY);
    END;

    //[Internal]
    PROCEDURE GetServerFileName(ClientFilePath: Text): Text;
    VAR
        ClientFileAttributes: DotNet FileAttributes;
        ServerFileName: Text;
        TempClientFile: Text;
        FileName: Text;
        FileExtension: Text;
        FileManagement: Codeunit 419;
        FileManagement1: Codeunit 50372;
        [RUNONCLIENT]
        ClientFileHelper: DotNet File;
        AllFilesDescriptionTxt: TextConst ENU = 'All Files (*.*)|*.*', ESP = 'Todos los archivos (*.*)|*.*';
        Text010: TextConst ENU = 'The file %1 has not been uploaded.', ESP = 'No se ha cargado el archivo %1.';
    BEGIN
        FileName := FileManagement.GetFileName(ClientFilePath);
        FileExtension := FileManagement.GetExtension(FileName);

        TempClientFile := FileManagement1.ClientTempFileName(FileExtension);
        ClientFileHelper.Copy(ClientFilePath, TempClientFile, TRUE);


        ServerFileName := FileManagement.ServerTempFileName(FileExtension);

        IF NOT UPLOAD('', FileManagement.Magicpath, AllFilesDescriptionTxt, FileManagement.GetFileName(TempClientFile), ServerFileName) THEN
            ERROR(Text010, ClientFilePath);

        ClientFileHelper.SetAttributes(TempClientFile, ClientFileAttributes.Normal);
        ClientFileHelper.Delete(TempClientFile);
        EXIT(ServerFileName);
    END;

    /*BEGIN
/*{
      JAV 15/08/19: - Se ajustan campos para las evaluaciones
      PGM 30/10/19: - Q8101 Se modifica el c�digo para que al hacer el lookup, se posicione en el valor actual al abrirse la pagina de dimensiones(siempre que exista ese valor en la tabla).
      JAV 29/10/19: - Se amplian las devoluciones de las funciones de dimensiones de 10 a 20
      JAV 06/11/19: - Se cambia al nuevo manejo de certificaciones de proveedores
      JAV 08/11/19: - Se pasa la funci�n ValidateEval a la CU de Calidad
      JAV 09/03/20: - Se incluyen desde la CU 5700 "User Setup Management" las funciones:
                      - GetAllJobFilter, renombrada como UserAccessToAllJobs
                      - GetJobFilter, GetFilterLevelUser, FilterLevel, GetLevelUserDefault
      JAV 13/10/20: - QB 1.06.20 Nueva funci�n para ver si el usuario es adminitrador de QB
      JAV 29/12/20: - QB 1.07.17 Nuevas funciones para filtrar proyectos en los formularios. Se elimina el Filter Level que ya no se usa.
      JAV 28/06/21: - QB 1.09.03 Se a�ade una nueva funci�n que retorna el c�digo del presupuesto anal�tico de un registro de Job
      JAV 09/07/21: - QB 1.09.04 Nueva funci�n QB_ControlBudgetDates que retorna si est� activo el control de fechas de los presupuestos
      JAV 14/10/21: - QB 1.09.21 Nueva funci�n AccessToServiceOrder que retorna si est� activado el m�dulo de Pedidos de servicio
      JAV 26/10/21: - QB 1.09.23 Se a�ade al filtro de proyectos los de presupuestos
      MCM 13/12/21: - Q15977 Se a�ade la opci�n de proyectos de tipo Promoci�n y suelo.
                             Se crea la funci�n Job_ByBudgetItem
      JAV 24/02/22: - QB 1.10.22 Se eliminan las funciones que ya no se usan: QB_ApprovalsPurchasesCircuits, QB_ApprovalsInvoicesCircuits
      CPA 02/02/22: - Q16275 Se Ampl�an los permisos de acceso del usuario por proyecto a otras tablas. Nuevas funciones:
                             SetUserJobCostsheetHeaderFilter
                             SetUserJobPostedCostsheetHeaderFilter
                             SetUserJobPostedCertificationsHeaderFilter
                             SetUserJobPostedProdMeasureHeaderFilter
                             SetUserJobDetailedVendorLedgerEntriesFilter
      JAV 15/05/22: - QB 1.10.41 Se a�ade la funci�n AutomaticInvoiceSending que retorna si est� activo el env�o de mail interno para facturas/abonos de venta
      JAV 16/06/22: - QB 1.10.50 Filtrar que no salgan por defecto los archivados
                                 Se condiciona el filtro del proyecto del mismo tipo al nuevo check para filtrar proyectos del mismo tipo en compras
                                 Ligero cambio en condiciones para que sea mas claro el c�digo
      JAV 25/06/22: - QB 1.10.54 Retorna el departamento asociado al valor de la dimensi�n departamentos del registro
      JAV 27/06/22: - QB 1.10.55 Se eliminan las funciones que se trasladar�n al m�dulo de anticipos
                                    "AccessToCustomerPrepayment", "AccessToCustomerPrepaymentError", "AccessToVendorPrepayment", "AccessToVendorPrepaymentError"
      JAV 11/10/22: - QB 1.12.02 Se corrige un error que daba a la entrada de la p�gina de movimientos contables cuando no est� activo QB, RE o QPR.');
      JAV 17/11/22: - QB 1.12.21 Se arregla un error al recuperar el c�digo de la dimensi�n Departamento
      AML 18/09/23: - Q20083 Cambio en el filtro de compras para evitar duplicidades.
    }
END.*/
}









