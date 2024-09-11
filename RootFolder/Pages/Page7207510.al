page 7207510 "Subform. Bill of Item Data Pro"
{
    CaptionML = ENU = 'Bill of Item', ESP = 'Descompuestos';
    InsertAllowed = false;
    SourceTable = 7207384;
    DelayedInsert = true;
    PopulateAllFields = true;
    SourceTableView = SORTING("Cod. Cost database", "Cod. Piecework", "Order No.", "Use", "Type", "No.");
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                IndentationColumn = rec.Identation;
                IndentationControls = "Order No.";
                ShowAsTree = true;
                field("Order No."; rec."Order No.")
                {

                    StyleExpr = stLine;
                }
                field("Father Code"; rec."Father Code")
                {

                    Visible = false;
                    StyleExpr = stLine;
                }
                field("Identation"; rec."Identation")
                {

                    StyleExpr = stLine;
                }
                field("Type"; rec."Type")
                {

                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        SetStyles;
                    END;


                }
                field("No."; rec."No.")
                {

                    StyleExpr = stLine;
                }
                field("Reduce No. <> 0"; rec."Reduce No." <> 0)
                {

                    CaptionML = ESP = 'Reducido';
                    Editable = false;
                }
                field("Has Additional Text"; rec."Has Additional Text")
                {

                    StyleExpr = stLine;
                }
                field("Presto Code"; rec."Presto Code")
                {

                    Visible = false;
                    StyleExpr = stLine;
                }
                field("Description"; rec."Description")
                {

                    StyleExpr = stLine;
                }
                field("Description 2"; rec."Description 2")
                {

                    StyleExpr = stLine;
                }
                field("Diferencia"; rec."Diferencia")
                {

                }
                field("Concep. Analytical Direct Cost"; rec."Concep. Analytical Direct Cost")
                {

                    StyleExpr = stLine;
                }
                field("Units of Measure"; rec."Units of Measure")
                {

                    StyleExpr = stLine;
                }
                field("Bill of Item Units"; rec."Bill of Item Units")
                {

                    Visible = False;
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Quantity By"; rec."Quantity By")
                {

                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                field("Base Unit Cost"; rec."Base Unit Cost")
                {

                    Enabled = edBase;
                    StyleExpr = stLine3;
                }
                field("Direct Unit Cost"; rec."Direct Unit Cost")
                {

                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                field("Piecework Cost"; rec."Piecework Cost")
                {

                    Editable = false;
                    StyleExpr = stLine;
                }
                field("Received from Percentajes"; rec."Received from Percentajes")
                {

                }
                field("Total Qty"; rec."Total Qty")
                {

                    StyleExpr = stLine2;
                }
                field("Total Price"; rec."Total Price")
                {

                    StyleExpr = stLine2;
                }
                field("Total Cost"; rec."Total Cost")
                {

                    StyleExpr = stLine2;
                }
                field("Cod. Piecework"; rec."Cod. Piecework")
                {

                    Visible = false;
                    StyleExpr = stLine;
                }
                field("Cod. Cost database"; rec."Cod. Cost database")
                {

                    // DecimalPlaces = 2 : 6;
                    Visible = false;
                    StyleExpr = stLine;
                }
                field("Received Price"; rec."Received Price")
                {

                }
                field("Rendimiento Original"; rec."Rendimiento Original")
                {

                }
                field("Factor"; rec."Factor")
                {

                    CaptionML = ENU = 'Factor original';
                    Editable = false;
                }
                field("Factor UO"; rec."Factor UO")
                {

                    Editable = false

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("Reducir")
            {

                CaptionML = ESP = 'Reducir';
                // ActionContainerType =NewDocumentItems;
                Image = CollapseDepositLines;
                action("ReducirA")
                {

                    CaptionML = ESP = 'Autom�tico';
                    Image = CollapseDepositLines;

                    trigger OnAction()
                    BEGIN
                        Reduce(OPTReduce::Auto, Rec.Use);
                    END;


                }
                action("ReducirP")
                {

                    CaptionML = ESP = 'A Producto';
                    Image = CollapseDepositLines;

                    trigger OnAction()
                    BEGIN
                        Reduce(OPTReduce::Item, Rec.Use);
                    END;


                }
                action("ReducirR")
                {

                    CaptionML = ESP = 'A Recurso';
                    Image = CollapseDepositLines;

                    trigger OnAction()
                    BEGIN
                        Reduce(OPTReduce::Resource, Rec.Use);
                    END;


                }
                action("ReducirCancel")
                {

                    CaptionML = ESP = 'Cancelar';
                    Image = CollapseDepositLines;

                    trigger OnAction()
                    BEGIN
                        CancelReduce();
                    END;


                }

            }
            action("Nuevo")
            {

                CaptionML = ENU = 'New', ESP = 'Nuevo';
                Image = New;

                trigger OnAction()
                BEGIN
                    New(TRUE);
                END;


            }
            action("NuevoHijo")
            {

                CaptionML = ENU = 'New Bellow', ESP = 'Nuevo Hijo';
                Image = NewOrder;

                trigger OnAction()
                BEGIN
                    New(FALSE);
                END;


            }
            action("AditionalText")
            {

                CaptionML = ESP = 'Texto Adicional';
                RunObject = Page 7206929;
                RunPageLink = "Table" = CONST("Preciario"), "Key1" = FIELD("Cod. Cost database"), "Key2" = FIELD("Cod. Piecework"), "Key3" = FIELD("No.");
                Image = Text
    ;
            }

        }
    }
    trigger OnInit()
    BEGIN
        Rec.FILTERGROUP(1);
        txtTitle := Rec.GETFILTER(Use);
        Rec.FILTERGROUP(0);
    END;

    trigger OnClosePage()
    BEGIN
        IF (Modi) THEN BEGIN
            Piecework.GET(Rec."Cod. Cost database", Rec."Cod. Piecework");
            Piecework.CalculateLine();
        END;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetStyles;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec."Bill of Item Units" := 1;
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        Modi := TRUE;
        //CurrPage.SAVERECORD;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.UPDATE;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        SetStyles;
    END;



    var
        Text001: TextConst ENU = 'not valid type %1', ESP = 'No es v�lido el tipo %1';
        CostDatabase: Record 7207271;
        Piecework: Record 7207277;
        CostDatabaseCode: Text;
        Modi: Boolean;
        txtTitle: Text;
        stLine: Text;
        stLine2: Text;
        stLine3: Text;
        seeBase: Boolean;
        edBase: Boolean;
        OPTReduce: Option "Auto","Item","Resource";

    LOCAL procedure SetStyles();
    begin
        //Columna de precio base
        Rec.FILTERGROUP(4);
        CostDatabaseCode := Rec.GETFILTER("Cod. Cost database");
        Rec.FILTERGROUP(0);

        seeBase := FALSE;
        if (CostDatabaseCode <> '') then begin
            CostDatabase.GET(CostDatabaseCode);
            CASE Rec.Use OF
                Rec.Use::Cost:
                    seeBase := (CostDatabase."CI Cost" <> 0);
                Rec.Use::Sales:
                    seeBase := (CostDatabase."CI Sales" <> 0);
            end;
        end;
        edBase := seeBase;

        //Estilos
        if (rec.Type = rec.Type::"Posting U.") then begin
            stLine := 'Strong';
            stLine2 := 'Strong';
            stLine3 := 'Strong';
        end ELSE begin
            stLine := 'Standard';
            stLine2 := 'Favorable';
            if (edBase) then
                stLine3 := 'Standard'
            ELSE
                stLine3 := 'Subordinate';
        end;
    end;

    LOCAL procedure New(pSameLevel: Boolean);
    var
        BillofItemData: Record 7207384;
        BillofItemData2: Record 7207384;
        newCode: Code[20];
        newFather: Code[20];
    begin
        //JAV 28/11/22: - QB 1.12.24 Crear un nuevo descompuestos, al mismo nivel o por debajo del actual

        BillofItemData.RESET;
        BillofItemData.SETRANGE("Cod. Cost database", rec."Cod. Cost database");
        BillofItemData.SETRANGE("Cod. Piecework", rec."Cod. Piecework");

        if (pSameLevel) then begin
            //Buscamos un registro al mismo nivel del registro actual
            BillofItemData.SETRANGE("Father Code", rec."Father Code");
            if (BillofItemData.FINDLAST) then
                newCode := INCSTR(BillofItemData."Order No.")
            ELSE
                newCode := '01';    //No hay ninguno al mismo nivel, lo que solo es posible si no hay ning�n descompuesto

            newFather := Rec."Father Code";
        end ELSE begin
            //Buscamos un registro al nivel siguiente al actual
            BillofItemData.SETFILTER("Order No.", '%1..%2', rec."Order No." + '00', rec."Order No." + '99');
            if (BillofItemData.FINDLAST) then
                newCode := INCSTR(BillofItemData."Order No.")
            ELSE
                newCode := Rec."Order No." + '01';    //No hay ninguno por tanto es el primer hijo

            newFather := Rec."Order No.";
        end;

        Rec.INIT;
        Rec."Cod. Cost database" := Rec."Cod. Cost database";
        Rec."Cod. Piecework" := Rec."Cod. Piecework";
        Rec."Order No." := newCode;
        Rec.Use := Rec.Use;
        Rec.Identation := (STRLEN(newCode) / 2) - 1;
        Rec."Father Code" := newFather;
        Rec.Type := Rec.Type::Item;  //Pongo producto por defecto
        Rec."Bill of Item Units" := 1;
        Rec.INSERT;

        CurrPage.UPDATE(FALSE);
    end;

    LOCAL procedure Reduce(pType: Option; pUse: Option);
    var
        BillofItemData: Record 7207384;
        QBBillofItemDataRed: Record 7207398;
        nProd: Integer;
        nRec: Integer;
        RedNro: Integer;
        Txt: Text;
    begin
        //JAV 05/12/22: - Reducir niveles, todo lo que est� por debajo se elimina y se cambia la l�nea actual

        //Si la l�nea no es de tipo auxiliar, buscamos su padre
        if (Rec.Type <> Rec.Type::"Posting U.") then begin
            BillofItemData.RESET;
            BillofItemData.SETRANGE("Cod. Cost database", rec."Cod. Cost database");
            BillofItemData.SETRANGE("Cod. Piecework", rec."Cod. Piecework");
            BillofItemData.SETRANGE(Use, pUse);
            BillofItemData.SETFILTER("Order No.", rec."Father Code");
            if (not BillofItemData.FINDFIRST) then
                ERROR('La unidad no es auxiliar o no tiene una auxiliar por encima');
            Rec := BillofItemData;
            Rec.MODIFY(FALSE);
        end;

        //Si es autom�tico, miramos que todo lo que hay por debajo sea producto o recurso y cambiamos el tipo al adecuado
        if (pType = OPTReduce::Auto) then begin
            nProd := 0;
            nRec := 0;
            BillofItemData.RESET;
            BillofItemData.SETRANGE("Cod. Cost database", rec."Cod. Cost database");
            BillofItemData.SETRANGE("Cod. Piecework", rec."Cod. Piecework");
            BillofItemData.SETRANGE(Use, pUse);
            BillofItemData.SETFILTER("Order No.", rec."Order No." + '*');
            if (BillofItemData.FINDSET) then
                repeat
                    CASE BillofItemData.Type OF
                        BillofItemData.Type::Item:
                            nProd += 1;
                        BillofItemData.Type::Resource:
                            nRec += 1;
                        BillofItemData.Type::Percentage:
                            if (rec."Total Cost" <> 0) then
                                ERROR('Tiene porcentuales no repartidos, no puede reducir');
                    end;
                until (BillofItemData.NEXT = 0);
            if (nProd <> 0) and (nRec <> 0) then
                ERROR('Tiene %1 l�neas de tipo producto y %2 de tipo recurso, no puede usar el autom�tico', nProd, nRec);
            if (nProd <> 0) then
                pType := OPTReduce::Item;
            if (nRec <> 0) then
                pType := OPTReduce::Resource;
        end;

        //Guardamos la l�nea para poder deshacer, buscar n�mero y guardar
        QBBillofItemDataRed.LOCKTABLE;
        QBBillofItemDataRed.RESET;
        QBBillofItemDataRed.SETCURRENTKEY("Reduce No.");
        if (QBBillofItemDataRed.FINDLAST) then
            RedNro := QBBillofItemDataRed."Reduce No." + 1
        ELSE
            RedNro := 1;
        repeat
        //Cambiamos el registro y guardamos todo lo que est� por debajo de todos los registros del preciario que tienen el mismo c�digo
        Txt := 'Se ha reducido: Option "Auto","Item","Resource"\  Partida ' + BillofItemData."Cod. Piecework" + ' Descompuesto ' + BillofItemData."Order No." + ' ' + BillofItemData."No.";
        until (BillofItemData.NEXT = 0);

        COMMIT; //Desbloqueamos
        MESSAGE(Txt);
    end;

    LOCAL procedure ReduceOne(pCodCostDatabase: Code[20]; pPiecework: Code[20]; pOrderNo: Code[20]; pRedNro: Integer; pType: Option; pUse: Option);
    var
        BillofItemData: Record 7207384;
        BillofItemData2: Record 7207384;
        QBBillofItemDataRed: Record 7207398;
        nProd: Integer;
        nRec: Integer;
        NewNo: Integer;
    begin
        //JAV 05/12/22: - Reducir niveles de una unidad concreta. Todo lo que est� por debajo se guarda aparte y se cambia la l�nea actual

        BillofItemData.RESET;
        BillofItemData.SETRANGE("Cod. Cost database", pCodCostDatabase);
        BillofItemData.SETRANGE("Cod. Piecework", pPiecework);
        BillofItemData.SETRANGE(Use, pUse);
        BillofItemData.SETFILTER("Order No.", pOrderNo + '*');                          //El propio registro y los que est�n por debajo
        if (BillofItemData.FINDSET(TRUE)) then
            repeat
                //Guardamos la l�nea en la tabla de agrupaciones para poder deshacer y la eliminamos
                QBBillofItemDataRed.TRANSFERFIELDS(BillofItemData);
                QBBillofItemDataRed."Reduce No." := pRedNro;
                QBBillofItemDataRed.INSERT;
                BillofItemData.DELETE;

                //Si es la l�nea que se agrupa, cambiamos su tipo y la  guardamos
                if (BillofItemData."Order No." = pOrderNo) then begin
                    BillofItemData2 := BillofItemData;
                    CASE pType OF
                        OPTReduce::Item:
                            BillofItemData2.Type := BillofItemData2.Type::Item;
                        OPTReduce::Resource:
                            BillofItemData2.Type := BillofItemData2.Type::Resource;
                    end;
                    BillofItemData2."Reduce No." := pRedNro;
                    BillofItemData2.INSERT;
                end;
            until (BillofItemData.NEXT = 0);
    end;

    LOCAL procedure CancelReduce();
    var
        BillofItemData: Record 7207384;
        QBBillofItemDataRed: Record 7207398;
    begin
        //JAV 05/12/22: - Cancelar la reducci�n de niveles

        //Si la l�nea no est� reducida, dar error
        if (Rec."Reduce No." = 0) then
            ERROR('La unidad no ha sido reducida.');

        //Recuperamos todo lo que est� guardado
        QBBillofItemDataRed.RESET;
        QBBillofItemDataRed.SETCURRENTKEY("Reduce No.");
        QBBillofItemDataRed.SETRANGE("Reduce No.", rec."Reduce No.");
        if (CONFIRM('Se recuperar�n %1 l�neas, �desea continuar?', TRUE, QBBillofItemDataRed.COUNT)) then begin
            Rec.DELETE;
            if (QBBillofItemDataRed.FINDSET(TRUE)) then
                repeat
                    BillofItemData.TRANSFERFIELDS(QBBillofItemDataRed);
                    BillofItemData."Reduce No." := 0;
                    BillofItemData.INSERT;
                    QBBillofItemDataRed.DELETE;
                until (QBBillofItemDataRed.NEXT = 0);
        end;
    end;

    // begin
    /*{
      JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3. Se a�aden los campos 40 a 45 y el 66.
      AML 24/03/23 Q18285 A�adido campo diferencia
    }*///end
}







