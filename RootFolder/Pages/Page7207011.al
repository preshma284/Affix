page 7207011 "QB Items by Location"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Items by Location', ESP = 'Productos por almac�n';
    Description = '[SourceTableView = WHERE(Plant Item=CONST(Yes))]';
    SaveValues = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;
    SourceTable = 27;
    DataCaptionExpression = '';
    SourceTableView = WHERE("QB Plant Item" = CONST(true));
    PageType = ListPlus;

    layout
    {
        area(content)
        {
            group("group5")
            {

                CaptionML = ENU = 'Options', ESP = 'Opciones';
                field("ShowInTransit"; ShowInTransit)
                {

                    CaptionML = ENU = 'Show Items in Transit', ESP = 'Muestra prods. en tr�ns.';
                    ToolTipML = ENU = 'Specifies the items in transit between locations.', ESP = 'Especifica los productos en tr�nsito entre ubicaciones.';
                    ApplicationArea = Advanced;

                    ; trigger OnValidate()
                    BEGIN
                        ShowInTransitOnAfterValidate;
                    END;


                }
                field("ShowColumnName"; ShowColumnName)
                {

                    CaptionML = ENU = 'Show Column Name', ESP = 'Muestra nombre columna';
                    ToolTipML = ENU = 'Specifies that the names of columns are shown in the matrix window.', ESP = 'Especifica que los nombres de las columnas se muestran en la ventana de la matriz.';
                    ApplicationArea = Location;

                    ; trigger OnValidate()
                    BEGIN
                        ShowColumnNameOnAfterValidate;
                    END;


                }
                field("MATRIX_CaptionRange"; MATRIX_CaptionRange)
                {

                    CaptionML = ENU = 'Column Set', ESP = 'Conjunto de columnas';
                    ToolTipML = ENU = 'Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Rec.NEXT Set or Previous Set.', ESP = 'Especifica el rango de valores que se muestran en la ventana de la matriz, por ejemplo, el periodo total. Para modificar el contenido de este campo, elija la opci�n Conjunto siguiente o Conjunto anterior.';
                    ApplicationArea = Location;
                    Editable = FALSE;
                }

            }
            part("MatrixForm"; 7207012)
            {

                ApplicationArea = Location;
            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                CaptionML = ENU = 'Previous Set', ESP = 'Conjunto anterior';
                ToolTipML = ENU = 'Go to the previous set of data.', ESP = 'Permite desplazarse al conjunto de datos anterior.';
                ApplicationArea = Location;
                Image = PreviousSet;

                trigger OnAction()
                BEGIN
                    SetColumns(MATRIX_SetWanted::Previous);
                END;


            }
            action("action2")
            {
                CaptionML = ENU = 'Next Set', ESP = 'Conjunto siguiente';
                ToolTipML = ENU = 'Go to the Rec.NEXT set of data.', ESP = 'Permite desplazarse al conjunto de datos siguiente.';
                ApplicationArea = Location;
                Image = NextSet;


                trigger OnAction()
                BEGIN
                    SetColumns(MATRIX_SetWanted::NEXT);
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
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
    }




    trigger OnInit()
    BEGIN
        TempMatrixLocation.GetLocationsIncludingUnspecifiedLocation(FALSE, FALSE);
        TempMatrixLocation.SETRANGE("QB View Item Disponibility", TRUE);
    END;

    trigger OnOpenPage()
    BEGIN
        SetColumns(MATRIX_SetWanted::Initial);
    END;



    var
        TempMatrixLocation: Record 14 TEMPORARY;
        MatrixRecords: ARRAY[32] OF Record 14;
        MatrixRecordRef: RecordRef;
        MATRIX_SetWanted: Option "Initial","Previous","Same","Next";
        ShowColumnName: Boolean;
        ShowInTransit: Boolean;
        MATRIX_CaptionSet: ARRAY[32] OF Text[80];
        MATRIX_CaptionRange: Text[100];
        MATRIX_PKFirstRecInCurrSet: Text[80];
        MATRIX_CurrSetLength: Integer;
        UnspecifiedLocationCodeTxt: TextConst ENU = 'UNSPECIFIED', ESP = 'SIN ESPECIFICAR';

    //[Internal]
    procedure SetColumns(SetWanted: Option "Initial","Previous","Same","Next");
    var
        MatrixMgt: Codeunit 9200;
        CaptionFieldNo: Integer;
        CurrentMatrixRecordOrdinal: Integer;
    begin
        TempMatrixLocation.SETRANGE("Use As In-Transit", ShowInTransit);

        CLEAR(MATRIX_CaptionSet);
        CLEAR(MatrixRecords);
        CurrentMatrixRecordOrdinal := 1;

        MatrixRecordRef.GETTABLE(TempMatrixLocation);
        MatrixRecordRef.SETTABLE(TempMatrixLocation);

        if ShowColumnName then
            CaptionFieldNo := TempMatrixLocation.FIELDNO(Name)
        ELSE
            CaptionFieldNo := TempMatrixLocation.FIELDNO(Code);

        MatrixMgt.GenerateMatrixData(MatrixRecordRef, SetWanted, ARRAYLEN(MatrixRecords), CaptionFieldNo, MATRIX_PKFirstRecInCurrSet,
          MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrSetLength);

        if MATRIX_CaptionSet[1] = '' then begin
            MATRIX_CaptionSet[1] := UnspecifiedLocationCodeTxt;
            MATRIX_CaptionRange := STRSUBSTNO('%1%2', MATRIX_CaptionSet[1], MATRIX_CaptionRange);
        end;

        if MATRIX_CurrSetLength > 0 then begin
            TempMatrixLocation.SETPOSITION(MATRIX_PKFirstRecInCurrSet);
            TempMatrixLocation.FIND;
            repeat
                MatrixRecords[CurrentMatrixRecordOrdinal].COPY(TempMatrixLocation);
                CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
            until (CurrentMatrixRecordOrdinal > MATRIX_CurrSetLength) or (TempMatrixLocation.NEXT <> 1);
        end;

        UpdateMatrixSubform;
    end;

    LOCAL procedure ShowColumnNameOnAfterValidate();
    begin
        SetColumns(MATRIX_SetWanted::Same);
    end;

    LOCAL procedure ShowInTransitOnAfterValidate();
    begin
        SetColumns(MATRIX_SetWanted::Initial);
    end;

    LOCAL procedure UpdateMatrixSubform();
    begin
        CurrPage.MatrixForm.PAGE.Load(MATRIX_CaptionSet, MatrixRecords, TempMatrixLocation, MATRIX_CurrSetLength);
        CurrPage.MatrixForm.PAGE.SETRECORD(Rec);
        CurrPage.UPDATE;
    end;

    // begin//end
}








