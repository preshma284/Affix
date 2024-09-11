table 7206986 "QBU Approval Circuit Header"
{


    CaptionML = ENU = 'Approval Circuit Header', ESP = 'Circuito de Aprobaci�n';
    LookupPageID = "QB Approval Circuit List";
    DrillDownPageID = "QB Approval Circuit List";

    fields
    {
        field(1; "Circuit Code"; Code[20])
        {
            CaptionML = ENU = 'Job No.', ESP = 'C�digo del Circuito';


        }
        field(10; "Description"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Descripci�n';


        }
        field(11; "Document Type"; Option)
        {
            OptionMembers = "Comparative","PurchaseOrder","PurchaseInvoice","PurchaseCrMemo","Payments","PaymentOrder","Budget","JobBudget","Certification","ExpenseNote","WorkSheet","Transfers","PaymentDue","Prepayment","JobTask","Withholding";

            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo de Documento';
            OptionCaptionML = ENU = 'Comparative,Purchase Order,Purchase Invoice,Purchase Cr.Memo,Payments,Payment Order,Budget,Job Budget,Certification,Expense Note,WorkSheet,Transfers Jobs,Payment w Certificate Due,Prepayments,Job Tasks,Withholding', ESP = 'Comparativos,Pedidos de compra,Facturas de Compra,Abonos de Compra,Pagos,�rdenes de Pago,Presupuestos,Estudios,Certificaciones,Hojas de gastos,Hojas de Horas,Traspasos entre Proyectos,Pagos con Certificado Vencido,Anticipos,Tareas de Proyecto,Retenciones';


            trigger OnValidate();
            VAR
                //                                                                 QBApprovalsSetup@1100286000 :
                QBApprovalsSetup: Record 7206994;
            BEGIN
                //JAV 04/04/22: - QB 1.10.31 Se cambia a la nueva tabla de configuraci�n de aprobaciones, y se fuerza el tipo de aprobaci�n seg�n el documento
                QBApprovalsSetup.GET();
                CASE "Document Type" OF
                    "Document Type"::Comparative:
                        "Approval By" := QBApprovalsSetup."Approvals 02 Type";
                    "Document Type"::PurchaseInvoice:
                        "Approval By" := QBApprovalsSetup."Approvals 04 Type";
                    "Document Type"::PurchaseCrMemo:
                        "Approval By" := QBApprovalsSetup."Approvals 10 Type";
                    "Document Type"::Payments:
                        "Approval By" := QBApprovalsSetup."Approvals 06 Type";
                    "Document Type"::PaymentOrder:
                        "Approval By" := QBApprovalsSetup."Approvals 20 Type";
                    "Document Type"::Budget:
                        "Approval By" := QBApprovalsSetup."Approvals 11 Type";
                    "Document Type"::JobBudget:
                        "Approval By" := QBApprovalsSetup."Approvals 01 Type";
                    "Document Type"::Certification:
                        "Approval By" := QBApprovalsSetup."Approvals 05 Type";
                    "Document Type"::ExpenseNote:
                        "Approval By" := QBApprovalsSetup."Approvals 07 Type";
                    "Document Type"::WorkSheet:
                        "Approval By" := QBApprovalsSetup."Approvals 08 Type";
                    "Document Type"::Transfers:
                        "Approval By" := QBApprovalsSetup."Approvals 09 Type";
                    //"Document Type"::PaymentDue      : "Approval By" := QBApprovalsSetup."Approvals 13 Type";    // Este va con el de cartera, no se debe usar aqu�
                    "Document Type"::Withholding:
                        "Approval By" := QBApprovalsSetup."Approvals 14 Type";      //JAV 13/12/22: - QB 1.12.26 Se a�ade el tipo para Retenciones
                    "Document Type"::Prepayment:
                        "Approval By" := QBApprovalsSetup."Approvals 12 Type";
                END;
            END;


        }
        field(12; "Approval By"; Option)
        {
            OptionMembers = "Job","Department","User";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Aprobaci�n por';
            OptionCaptionML = ENU = 'By Job,By Department,By User', ESP = 'Por Proyecto,Por Departamento,Por Usuario';

            Description = 'QB 1.10.26 - JAV 21/03/22 Tipo de condicionantes de la aprobaci�n';
            Editable = false;


        }
        field(20; "Job No."; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proyecto';


        }
        field(21; "CA"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Partida Presupuestaria';


        }
        field(22; "Department"; Code[20])
        {
            TableRelation = "QB Department";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Departamento';


        }
    }
    keys
    {
        key(key1; "Circuit Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       UserSetup@7001100 :
        UserSetup: Record 91;
        //       Text005@1100286000 :
        Text005: TextConst ENU = 'You cannot have approval limits less than zero.', ESP = 'No puede tener l�mites de aprobaci�n inferiores a cero.';
        //       QBApprovalCircuitLines@1100286001 :
        QBApprovalCircuitLines: Record 7206987;



    trigger OnDelete();
    begin
        QBApprovalCircuitLines.RESET;
        QBApprovalCircuitLines.SETRANGE("Circuit Code", Rec."Circuit Code");
        QBApprovalCircuitLines.DELETEALL;
    end;

    trigger OnRename();
    begin
        //JAV 20/04/22: - QB 1.10.36 Al renombrar la cabecera, hacerlo con las l�neas
        QBApprovalCircuitLines.RESET;
        QBApprovalCircuitLines.SETRANGE("Circuit Code", xRec."Circuit Code");
        //if ExternalsWorksheetLines.FINDSET(TRUE, FALSE) then
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        if (QBApprovalCircuitLines.FINDSET(TRUE)) then
            repeat
                QBApprovalCircuitLines.RENAME(Rec."Circuit Code", QBApprovalCircuitLines."Line Code");
            until (QBApprovalCircuitLines.NEXT = 0);
    end;



    // procedure CopyFrom (pType@1100286005 : Option;pFrom@1100286006 : Code[20];pTo@1100286000 :
    procedure CopyFrom(pType: Option; pFrom: Code[20]; pTo: Code[20])
    var
        //       oResponsible@1100286007 :
        oResponsible: Record 7206992;
        //       dResponsible@1100286002 :
        dResponsible: Record 7206992;
    begin
        //JAV 19/11/21: - QB 1.09.28 Copiar los responsables de un proyecto a otro

        //Los responsables
        oResponsible.RESET;
        oResponsible.SETRANGE(Type, pType);
        oResponsible.SETRANGE("Table Code", pFrom);
        if (oResponsible.FINDSET) then
            repeat
                dResponsible := oResponsible;
                dResponsible."Table Code" := pTo;
                dResponsible.INSERT;
            until oResponsible.NEXT = 0;
    end;

    /*begin
    //{
//      JAV 12/07/19: - Se quita de la clave principal el cargo, dejando solo proyecto y usuario, y se a�ade una segunda clave solo usuario.
//      JAV 28/07/19: - Se a�aden campos 10, 12, 13, 14 y 15 para aprobaciones de compras y comparativos
//      JAV 09/09/19: - Se a�ade el campo 9 "Internal Id" para identificar los registros un�vocamente
//                    - Se a�ade la key "Job No.","Level","Internal Id"
//      JAV 09/03/20: - Se a�aden campos para los grupos y su inicializaci�n
//      JAV 01/09/21: - QB 1.09.90 Se a�aden campos 110, 111 y 112 mas una nueva key con el 110 para Aprobaci�n de Presupuestos
//      JAV 27/02/22: - QB 1.10.22 Cambio en el sistema de aprobaciones, se cambia la tabla por completo
//      JAV 21/03/22: - QB 1.10.26 Se a�ade el campo 12 "Approval By" para el tipo de condicionantes de la aprobaci�n proyecto o departamento
//      JAV 04/04/22: - QB 1.10.31 Se cambia a la nueva tabla de configuraci�n de aprobaciones, se hace no editable el tipo de aprobaci�n que se fuerza seg�n el tipo del documento
//      JAV 20/04/22: - QB 1.10.36 Al renombrar la cabecera, hacerlo con las l�neas
//      JAV 24/06/22: - QB 1.10.54 Se cambia la tabla asociada al departamento por la nueva QB Departments
//      JAV 11/08/22: - QB 1.11.02 Se amplian los tipos de documento con Tareas de Proyecto
//      JAV 13/12/22: - QB 1.12.26 Se a�ade el tipo para Retenciones en "Document Type"
//    }
    end.
  */
}







