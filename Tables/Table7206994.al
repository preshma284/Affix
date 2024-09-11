table 7206994 "QBU Approvals Setup"
{
  
  
  ;
  fields
{
    field(1;"Primary Key";Code[10])
    {
        CaptionML=ENU='Primary Key',ESP='Clave primaria';


    }
    field(10;"Due Date for Approvals";DateFormula)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Due Date for Approvals',ESP='Vencimiento de las Aprobaciones';
                                                   Description='QB 1.10.36 JAV 21/04/22 [TT] Este campo indica cuando vencen las aprobaciones pendientes, se indica como "nD" donde n es el n£mero de d¡as deseado seguida de la letra D. Si se deja en blanco vencen el mismo d¡a que se emiten.';


    }
    field(11;"Delegate After";Option)
    {
        OptionMembers="Never","1 day","2 days","5 days";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Delegate After',ESP='Delegar tras';
                                                   OptionCaptionML=ENU='Never,1 day,2 days,5 days',ESP='Nunca,1 d¡a,2 d¡as,5 d¡as';
                                                   
                                                   Description='QB 1.10.36 JAV 21/04/22 [TT] Este campo indica cuantos d¡as debe estar vencida una aprobaci¢n para que se pasen autom¤aticamente al delegado del usuario.';


    }
    field(12;"Show Confirmation Message";Boolean)
    {
        InitValue=true;
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Show Confirmation Message',ESP='Mostrar mensaje de confirmaci¢n';
                                                   Description='QB 1.10.36 JAV 21/04/22 [TT] Este campo indica si desea que al solicitar aprobaci¢n se muestre un mensaje de confirmaci¢n al usuario.';


    }
    field(13;"Send Mail For Approved";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Send Mail Approved',ESP='Enviar Mail de Aprobaci¢n';
                                                   Description='QB 1.10.36 JAV 26/04/22 [TT] Si marca este campo, se remitir  un mail al remitente de la aprobaci¢n cuando el documento se haya aprobado';


    }
    field(20;"Tasks Circuits No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("JobTask")));
                                                   CaptionML=ESP='N§ de circuitos para Tareas';
                                                   Description='QB 1.11.02 JAV 12/08/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(46;"Approvals Payments Checks";Integer)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ Check adicionales pagos';
                                                   Description='QB 1.04      JAV 24/05/20: [TT] Cuantos checks hay que marcar en los documentos para la aprobaci¢n del pago de las facturas';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals Payments Caption 1" <> '') THEN
                                                                  "Approvals Payments Checks" := 1;
                                                                IF ("Approvals Payments Caption 2" <> '') THEN
                                                                  "Approvals Payments Checks" := 2;
                                                                IF ("Approvals Payments Caption 3" <> '') THEN
                                                                  "Approvals Payments Checks" := 3;
                                                                IF ("Approvals Payments Caption 4" <> '') THEN
                                                                  "Approvals Payments Checks" := 4;
                                                                IF ("Approvals Payments Caption 5" <> '') THEN
                                                                  "Approvals Payments Checks" := 5;

                                                                SaveCheckText; //Guardar los textos
                                                              END;


    }
    field(47;"Approvals Payments Caption 1";Text[50])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Additional Check 1',ESP='Check Adicional 1';
                                                   Description='QB 1.04      JAV 24/05/20: [TT] Descripci¢n asociada al checks adcional 1 que hay que marcar en los documentos para la aprobaci¢n del pago de las facturas';

trigger OnValidate();
    BEGIN 
                                                                VALIDATE("Approvals Payments Checks");
                                                              END;


    }
    field(48;"Approvals Payments Caption 2";Text[50])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Additional Check 2',ESP='Check Adicional 2';
                                                   Description='QB 1.04      JAV 24/05/20: [TT] Descripci¢n asociada al checks adcional 2 que hay que marcar en los documentos para la aprobaci¢n del pago de las facturas';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals Payments Caption 2" <> '') THEN BEGIN 
                                                                  IF ("Approvals Payments Caption 1" = '') THEN
                                                                    ERROR(Text003, 1);
                                                                END;

                                                                VALIDATE("Approvals Payments Checks");
                                                              END;


    }
    field(49;"Approvals Payments Caption 3";Text[50])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Additional Check 3',ESP='Check Adicional 3';
                                                   Description='QB 1.04      JAV 24/05/20: [TT] Descripci¢n asociada al checks adcional 3 que hay que marcar en los documentos para la aprobaci¢n del pago de las facturas';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals Payments Caption 3" <> '') THEN BEGIN 
                                                                  IF ("Approvals Payments Caption 1" = '') THEN
                                                                    ERROR(Text003, 1);
                                                                  IF ("Approvals Payments Caption 2" = '') THEN
                                                                    ERROR(Text003, 2);
                                                                END;

                                                                VALIDATE("Approvals Payments Checks");
                                                              END;


    }
    field(50;"Approvals Payments Caption 4";Text[50])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Additional Check 4',ESP='Check Adicional 4';
                                                   Description='QB 1.04      JAV 24/05/20: [TT] Descripci¢n asociada al checks adcional 4 que hay que marcar en los documentos para la aprobaci¢n del pago de las facturas';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals Payments Caption 4" <> '') THEN BEGIN 
                                                                  IF ("Approvals Payments Caption 1" = '') THEN
                                                                    ERROR(Text003, 1);
                                                                  IF ("Approvals Payments Caption 2" = '') THEN
                                                                    ERROR(Text003, 2);
                                                                  IF ("Approvals Payments Caption 3" = '') THEN
                                                                    ERROR(Text003, 3);
                                                                END;

                                                                VALIDATE("Approvals Payments Checks");
                                                              END;


    }
    field(51;"Approvals Payments Caption 5";Text[50])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Additional Check 5',ESP='Check Adicional 5';
                                                   Description='QB 1.04      JAV 24/05/20: [TT] Descripci¢n asociada al checks adcional 5 que hay que marcar en los documentos para la aprobaci¢n del pago de las facturas';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals Payments Caption 5" <> '') THEN BEGIN 
                                                                  IF ("Approvals Payments Caption 1" = '') THEN
                                                                    ERROR(Text003, 1);
                                                                  IF ("Approvals Payments Caption 2" = '') THEN
                                                                    ERROR(Text003, 2);
                                                                  IF ("Approvals Payments Caption 3" = '') THEN
                                                                    ERROR(Text003, 3);
                                                                  IF ("Approvals Payments Caption 4" = '') THEN
                                                                    ERROR(Text003, 4);
                                                                END;

                                                                VALIDATE("Approvals Payments Checks");
                                                              END;


    }
    field(55;"Manual. App. Payments Request";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Solicitud Ap.Pagos Manual';
                                                   Description='QB 1.04      JAV 22/07/20: [TT] Si la aprobaci¢n de pagos de facturas se debe lanzar manualmente';


    }
    field(57;"Send App. Comparative to Order";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Pasar la aprobaci¢n del comparativo a pedido';
                                                   Description='QB 1.10.22 JAV 27/02/22 [TT] Si est  marcado al crear un pedido desde un comparativo, pasa a este el estado de aporbaci¢n para no repetirla dos veces';


    }
    field(58;"Evaluation Order";Option)
    {
        OptionMembers="CA/Job","Job/CA";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Evaluation Order',ESP='àrden de Evaluaci¢n';
                                                   OptionCaptionML=ENU='CA/Job,Job/CA',ESP='Partida Presupuestaria/Proyecto,Proyecto/Partida Presupuestaria';
                                                   
                                                   Description='QB 1.10.22 JAV 02/03/22 [TT] En que orden se van a evaluar las condiciones de los circuitos de aprobaci¢n';


    }
    field(59;"User Approve";Option)
    {
        OptionMembers="Charge","All";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='User Approve One Time',ESP='El usuario aprueba';
                                                   OptionCaptionML=ENU='By Position,One time onlyl',ESP='Por cargo,Una sola vez';
                                                   
                                                   Description='QB 1.10.22 JAV 02/03/22 [TT] Si se indicapor cargo el usuario debe aprobar todas las veces que est‚ en la cadena de aprobaci¢n, si  se indica una vez ya aprueba todas las veces que aparezca';


    }
    field(72;"Send App. Prepayment to Doc.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Pasar la Aprobaci¢n del Anticipo al Documento';
                                                   Description='QB 1.10.29 JAV 31/03/22 [TT] Si est  marcado al crear un documento desde un anticipo, pasa a este el estado de aporbaci¢n para no repetirla dos veces';


    }
    field(100;"Approvals 00 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Approvation type for document',ESP='Flujo activo para Aprobaciones Vencidas';
                                                   Description='QB 1.10.34 JAV 03/04/22 [TT] Indica si est  activo el flujo de trabajo relacionado con el env¡o de notificaciones por aprobaciones vencidas';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals 01 Enabled") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 01 No");
                                                                  IF ("Approvals 01 No" = 0) THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;


    }
    field(101;"Approvals 01 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Approvation type for document',ESP='Aprobaci¢n activa para Versiones de Estudio';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals 01 Enabled") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 01 No");
                                                                  IF ("Approvals 01 No" = 0) THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;


    }
    field(102;"Approvals 02 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n activa para Comparativos';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals 02 Enabled") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 03 No");
                                                                  IF ("Approvals 02 No" = 0) THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;


    }
    field(103;"Approvals 03 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n activa  para Pedidos Compra';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals 03 Enabled") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 03 No");
                                                                  IF ("Approvals 03 No" = 0) THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;


    }
    field(104;"Approvals 04 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n activa para Facturas de Compra';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals 04 Enabled") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 04 No");
                                                                  IF ("Approvals 04 No" = 0) THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;


    }
    field(105;"Approvals 05 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n activa para Certificaciones';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals 05 Enabled") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 05 No");
                                                                  IF ("Approvals 05 No" = 0) THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;


    }
    field(106;"Approvals 06 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n activa para Pagos';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals 06 Enabled") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 06 No");
                                                                  IF ("Approvals 06 No" = 0) THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;


    }
    field(107;"Approvals 07 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n activa para Notas de Gasto';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals 07 Enabled") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 07 No");
                                                                  IF ("Approvals 07 No" = 0) THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;


    }
    field(108;"Approvals 08 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n activa para Hojas de Horas';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals 08 Enabled") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 08 No");
                                                                  IF ("Approvals 08 No" = 0) THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;


    }
    field(109;"Approvals 09 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n activa para Traspasos entre Proyectos';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals 09 Enabled") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 09 No");
                                                                  IF ("Approvals 09 No" = 0) THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;


    }
    field(110;"Approvals 10 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n activa para Abonos de Compra';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals 10 Enabled") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 10 No");
                                                                  IF ("Approvals 10 No" = 0) THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;


    }
    field(111;"Approvals 11 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n activa para Presupuestos';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals 11 Enabled") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 11 No");
                                                                  IF ("Approvals 11 No" = 0) THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;


    }
    field(112;"Approvals 12 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n activa para Anticipos';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnLookup();
    BEGIN 
                                                              IF ("Approvals 12 Enabled") THEN BEGIN 
                                                                CALCFIELDS("Approvals 12 No");
                                                                IF ("Approvals 12 No" = 0) THEN
                                                                  ERROR(Text001);
                                                              END;
                                                            END;


    }
    field(113;"Approvals 13 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n activa para Pago Cert.Vencido';
                                                   Description='QB 1.10.54 JAV 26/06/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnLookup();
    BEGIN 
                                                              IF ("Approvals 13 Enabled") THEN BEGIN 
                                                                CALCFIELDS("Approvals 13 No");
                                                                IF ("Approvals 13 No" = 0) THEN
                                                                  ERROR(Text001);
                                                              END;
                                                            END;


    }
    field(114;"Approvals 14 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n activa para Retenciones';
                                                   Description='QB 1.12.26 JAV 13/12/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals 20 Enabled") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 20 No");
                                                                  IF ("Approvals 20 No" = 0) THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;


    }
    field(120;"Approvals 20 Enabled";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n activa para àrdenes de Pago';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica si est  activa la aprobaci¢n para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF ("Approvals 20 Enabled") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 20 No");
                                                                  IF ("Approvals 20 No" = 0) THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;


    }
    field(201;"Approvals 01 Type";Option)
    {
        OptionMembers="Job","Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Approvation type for document',ESP='Tipo de aprobaci¢n para Versiones de Estudio';
                                                   OptionCaptionML=ENU='By Job,By Department,By User',ESP='Por Proyecto,Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Approvals 01 Type" <> xRec."Approvals 01 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 01 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 01 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 01 No");
                                                                END;
                                                              END;


    }
    field(202;"Approvals 02 Type";Option)
    {
        OptionMembers="Job","Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n para Comparativos';
                                                   OptionCaptionML=ENU='By Job,By Department,By User',ESP='Por Proyecto,Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Approvals 02 Type" <> xRec."Approvals 02 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 02 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 02 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 02 No");
                                                                END;
                                                              END;


    }
    field(203;"Approvals 03 Type";Option)
    {
        OptionMembers="Job","Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n para Pedidos Compra';
                                                   OptionCaptionML=ENU='By Job,By Department,By User',ESP='Por Proyecto,Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Approvals 03 Type" <> xRec."Approvals 03 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 03 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 03 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 03 No");
                                                                END;
                                                              END;


    }
    field(204;"Approvals 04 Type";Option)
    {
        OptionMembers="Job","Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n para Facturas de Compra';
                                                   OptionCaptionML=ENU='By Job,By Department,By User',ESP='Por Proyecto,Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Approvals 04 Type" <> xRec."Approvals 04 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 04 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 04 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 04 No");
                                                                END;
                                                              END;


    }
    field(205;"Approvals 05 Type";Option)
    {
        OptionMembers="Job","Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n para Certificaciones';
                                                   OptionCaptionML=ENU='By Job,By Department,By User',ESP='Por Proyecto,Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Approvals 05 Type" <> xRec."Approvals 05 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 05 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 05 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 05 No");
                                                                END;
                                                              END;


    }
    field(206;"Approvals 06 Type";Option)
    {
        OptionMembers="Job","Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n para Pagos';
                                                   OptionCaptionML=ENU='By Job,By Department,By User',ESP='Por Proyecto,Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Approvals 06 Type" <> xRec."Approvals 06 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 06 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 06 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 06 No");
                                                                END;
                                                              END;


    }
    field(207;"Approvals 07 Type";Option)
    {
        OptionMembers="Job","Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n para Notas de Gasto';
                                                   OptionCaptionML=ENU='By Job,By Department,By User',ESP='Por Proyecto,Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Approvals 07 Type" <> xRec."Approvals 07 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 07 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 07 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 07 No");
                                                                END;
                                                              END;


    }
    field(208;"Approvals 08 Type";Option)
    {
        OptionMembers="Job","Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n para Hojas de Horas';
                                                   OptionCaptionML=ENU='By Job,By Department,By User',ESP='Por Proyecto,Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Approvals 08 Type" <> xRec."Approvals 08 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 08 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 08 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 08 No");
                                                                END;
                                                              END;


    }
    field(209;"Approvals 09 Type";Option)
    {
        OptionMembers="Job","Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n para Traspasos entre Proyectos';
                                                   OptionCaptionML=ENU='By Job,By Department,By User',ESP='Por Proyecto,Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Approvals 09 Type" <> xRec."Approvals 09 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 09 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 09 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 09 No");
                                                                END;
                                                              END;


    }
    field(210;"Approvals 10 Type";Option)
    {
        OptionMembers="Job","Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n para Abonos de Compra';
                                                   OptionCaptionML=ENU='By Job,By Department,By User',ESP='Por Proyecto,Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Approvals 10 Type" <> xRec."Approvals 10 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 10 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 10 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 10 No");
                                                                END;
                                                              END;


    }
    field(211;"Approvals 11 Type";Option)
    {
        OptionMembers="Job","Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n para Presupuestos';
                                                   OptionCaptionML=ENU='By Job,By Department,By User',ESP='Por Proyecto,Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Approvals 11 Type" <> xRec."Approvals 11 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 11 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 11 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 11 No");
                                                                END;
                                                              END;


    }
    field(212;"Approvals 12 Type";Option)
    {
        OptionMembers="Job","Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n para Anticipos';
                                                   OptionCaptionML=ENU='By Job,By Department,By User',ESP='Por Proyecto,Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Approvals 12 Type" <> xRec."Approvals 12 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 12 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 12 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 12 No");
                                                                END;
                                                              END;


    }
    field(213;"Approvals 13 Type";Option)
    {
        OptionMembers="Job","Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n para Pago Cert.Vencido';
                                                   OptionCaptionML=ENU='By Job,By Department,By User',ESP='Por Proyecto,Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.10.54 JAV 26/06/22 [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                //JAV 26/06/22: - QB 1.10.54 Se a¤aden pagos con cetificado vencido, tipo 13
                                                                IF (Rec."Approvals 13 Type" <> xRec."Approvals 13 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 13 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 13 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 13 No");
                                                                END;
                                                              END;


    }
    field(214;"Approvals 14 Type";Option)
    {
        OptionMembers="Job","Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n para Retenciones';
                                                   OptionCaptionML=ENU='By Job,By Department,By User',ESP='Por Proyecto,Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.12.26 JAV 13/12/22 [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                //JAV 13/12/22: - QB 1.12.26 Nuevo circuito para retenciones
                                                                IF (Rec."Approvals 14 Type" <> xRec."Approvals 14 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 14 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 14 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 14 No");
                                                                END;
                                                              END;


    }
    field(220;"Approvals 20 Type";Option)
    {
        OptionMembers="Department","User";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n para àrdenes de Pago';
                                                   OptionCaptionML=ENU=',By Department,By User',ESP=',Por Departamento,Por Usuario';
                                                   
                                                   Description='QB 1.10.29 JAV 03/04/22 QB 1,10,53 JAV 25/06/22 Se elimina el tipo departamento que no se puede usar con las ¢rdenes de pago [TT] Indica el tipo de aprobaci¢n que se utilizar  para este tipo de documentos';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Approvals 20 Type" <> xRec."Approvals 20 Type") THEN BEGIN 
                                                                  CALCFIELDS("Approvals 20 No");
                                                                  //JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje
                                                                  IF (Rec."Approvals 20 No" <> 0) THEN
                                                                    MESSAGE(Text002, "Approvals 20 No");
                                                                END;
                                                              END;


    }
    field(301;"Approvals 01 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("JobBudget")));
                                                   CaptionML=ENU='Approvation type for document',ESP='N§ de circuitos para Versiones de Estudio';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(302;"Approvals 02 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("Comparative")));
                                                   CaptionML=ESP='N§ de circuitos para Comparativos';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(303;"Approvals 03 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("PurchaseOrder")));
                                                   CaptionML=ESP='N§ de circuitos para Pedidos Compra';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(304;"Approvals 04 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("PurchaseInvoice")));
                                                   CaptionML=ESP='N§ de circuitos para Facturas de Compra';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(305;"Approvals 05 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("Certification")));
                                                   CaptionML=ESP='N§ de circuitos para Certificaciones';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(306;"Approvals 06 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("Payments")));
                                                   CaptionML=ESP='N§ de circuitos para Pagos';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(307;"Approvals 07 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("ExpenseNote")));
                                                   CaptionML=ESP='N§ de circuitos para Notas de Gasto';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(308;"Approvals 08 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("WorkSheet")));
                                                   CaptionML=ESP='N§ de circuitos para Hojas de Horas';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(309;"Approvals 09 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("Transfers")));
                                                   CaptionML=ESP='N§ de circuitos para Traspasos entre Proyectos';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(310;"Approvals 10 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("PurchaseCrMemo")));
                                                   CaptionML=ESP='N§ de circuitos para Abonos de Compra';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(311;"Approvals 11 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("Budget")));
                                                   CaptionML=ESP='N§ de circuitos para Presupuestos';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(312;"Approvals 12 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("Prepayment")));
                                                   CaptionML=ESP='N§ de circuitos para Anticipos';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(313;"Approvals 13 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("Prepayment")));
                                                   CaptionML=ESP='N§ de circuitos para Pago Cert.Vencido';
                                                   Description='QB 1.10.54 JAV 26/06/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(314;"Approvals 14 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("Withholding")));
                                                   CaptionML=ESP='N§ de circuitos para Retenciones';
                                                   Description='QB 1.12.26 JAV 13/12/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos';


    }
    field(320;"Approvals 20 No";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Count("QB Approval Circuit Header" WHERE ("Document Type"=CONST("PaymentOrder")));
                                                   CaptionML=ESP='N§ de circuitos para àrdenes de Pago';
                                                   Description='QB 1.10.29 JAV 03/04/22 [TT] Indica el n£mero de circuitos de aprobaci¢n definidos para este tipo de documentos' ;


    }
}
  keys
{
    key(key1;"Primary Key")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Text001@1100286000 :
      Text001: TextConst ESP='No ha definido circitos de aprobaci¢n para este documento, no se puede activar el flujo';
//       Text002@1100286001 :
      Text002: TextConst ESP='Ha cambiado el tipo, debe revisar manualmente los %1 circutos de aprobaci¢n que tiene definidos.';
//       Text003@1100286002 :
      Text003: TextConst ESP='No ha definido texto para el check %1';

    LOCAL procedure SaveCheckText ()
    var
//       QBTablesSetup@1100286000 :
      QBTablesSetup: Record 7206903;
//       CarteraDoc@1100286004 :
      CarteraDoc: Record 7000002;
//       i@1100286001 :
      i: Integer;
//       base@1100286003 :
      base: Integer;
//       Txt@1100286002 :
      Txt: ARRAY [5] OF Text;
    begin
      //---------------------------------------------------------------------------------------------------------------
      //JAV 04/04/22: - QB 1.10.31 Guardar los textos de los 5 checks que van en configuraci¢n de tablas
      //---------------------------------------------------------------------------------------------------------------
      Txt[1] := Rec."Approvals Payments Caption 1";
      Txt[2] := Rec."Approvals Payments Caption 2";
      Txt[3] := Rec."Approvals Payments Caption 3";
      Txt[4] := Rec."Approvals Payments Caption 4";
      Txt[5] := Rec."Approvals Payments Caption 5";

      base := CarteraDoc.FIELDNO("Approval Check 1") - 1;  //Quitamos 1 porque el bucle empieza en 1 no en cero
      FOR i:=1 TO 5 DO begin
        if QBTablesSetup.GET(DATABASE::"Cartera Doc.", base+i,'') then begin
          if (Txt[i] = '') then
            QBTablesSetup.DELETE
          else begin
            QBTablesSetup."New Caption" := Txt[i];
            QBTablesSetup.MODIFY;
          end;
        end else if (Txt[i] <> '') then begin
          QBTablesSetup.INIT;
          QBTablesSetup.Table := DATABASE::"Cartera Doc.";
          QBTablesSetup."Field No." := base+i;
          QBTablesSetup."New Caption" := Txt[i];
          QBTablesSetup.INSERT;
        end;
      end;
    end;

    procedure GetCkeckText ()
    var
//       QBTablesSetup@1100286004 :
      QBTablesSetup: Record 7206903;
//       CarteraDoc@1100286003 :
      CarteraDoc: Record 7000002;
//       i@1100286002 :
      i: Integer;
//       base@1100286001 :
      base: Integer;
//       txt@1100286000 :
      txt: ARRAY [5] OF Text;
    begin
      //---------------------------------------------------------------------------------------------------------------
      //JAV 04/04/22: - QB 1.10.31 Leer los textos de los 5 checks que van en configuraci¢n de tablas
      //---------------------------------------------------------------------------------------------------------------
      CLEAR(txt);
      base := CarteraDoc.FIELDNO("Approval Check 1") - 1;  //Quitamos 1 porque el bucle empieza en 1 no en cero
      FOR i:=1 TO 5 DO begin
        if QBTablesSetup.GET(DATABASE::"Cartera Doc.", base+i,'') then
          txt[i] := QBTablesSetup."New Caption";
      end;

      Rec."Approvals Payments Caption 1" := txt[1];
      Rec."Approvals Payments Caption 2" := txt[2];
      Rec."Approvals Payments Caption 3" := txt[3];
      Rec."Approvals Payments Caption 4" := txt[4];
      Rec."Approvals Payments Caption 5" := txt[5];
    end;

    /*begin
    //{
//      JAV 04/04/22: - QB 1.10.31 Nueva tabla de configuraci¢n de aprobaciones, se copian los campos desde QuoBuilding Setup y se eliminan de all¡
//      JAV 10/04/22: - QB 1.10.34 Se a¤ade el campo 100 "Approvals 00 Enabled" para activar el Flujo para Aprobaciones Vencidas
//      JAV 25/06/22: - QB 1.10.54 Si no hay circuitos no dar el mensaje de revisar los circuitos
//                                 Se a¤aden pagos con cetificado vencido, tipo 13
//      JAV 13/12/22: - QB 1.12.26 Nuevo circuito para retenciones
//    }
    end.
  */
}







