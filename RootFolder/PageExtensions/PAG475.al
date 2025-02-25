pageextension 50205 MyExtension475 extends 475//256
{
    layout
    {
        addafter("Description")
        {
            field("QB_GenPostingType"; rec."Gen. Posting Type")
            {

            }
        }

    }

    actions
    {


    }

    //trigger
    trigger OnAfterGetRecord()
    BEGIN
        QBPagePublisher.InitializeVATStatementPreviewLine(VATStatement, VATStmtName, Rec, Selection, PeriodSelection, FALSE, UseAmtsInAddCurr);

        VATStatement.CalcLineTotal(Rec, ColumnValue, 0);
        IF rec."Print with" = rec."Print with"::"Opposite Sign" THEN
            ColumnValue := -ColumnValue;
    END;


    //trigger

    var
        Text000: TextConst ENU = 'Drilldown is not possible when %1 is %2.', ESP = 'No se puede realizar el an lisis cuando %1 es %2.';
        GLEntry: Record 17;
        VATEntry: Record 254;
        VATStatement: Report 12;
        ColumnValue: Decimal;
        Selection: Option "Open","Closed","Open and Closed";
        PeriodSelection: Option "Before and Within Period","Within Period";
        UseAmtsInAddCurr: Boolean;
        QBPagePublisher: Codeunit 7207348;
        VATStmtName: Record 257;



    //procedure
    procedure UpdateForm(var VATStmtName: Record 257; NewSelection: Option "Open","Closed","Open and Closed"; NewPeriodSelection: Option "Before and Within Period","Within Period"; NewUseAmtsInAddCurr: Boolean);
    begin
        Rec.SETRANGE("Statement Template Name", VATStmtName."Statement Template Name");
        Rec.SETRANGE("Statement Name", VATStmtName.Name);
        VATStmtName.COPYFILTER("Date Filter", rec."Date Filter");
        Selection := NewSelection;
        PeriodSelection := NewPeriodSelection;
        UseAmtsInAddCurr := NewUseAmtsInAddCurr;
        CLEAR(VATStatement);//QB
        VATStatement.InitializeRequest(VATStmtName, Rec, ConvertOptionToEnum_VATStatementReportSelection(Selection), ConvertOptionToEnum_VATStatementReportSelection(PeriodSelection), FALSE, UseAmtsInAddCurr);
        CurrPage.UPDATE;
    end;

    procedure ConvertOptionToEnum_VATStatementReportSelection(optionValue: Option "Open","Closed","Open and Closed"): Enum "VAT Statement Report Selection" ;
   var
        enumVariable : Enum "VAT Statement Report Selection" ;
    begin
        case optionValue of    

            optionValue::"Open":
                enumVariable := enumVariable::"Open";    

            optionValue::"Closed":
                enumVariable := enumVariable::"Closed";    

            optionValue::"Open and Closed":
                enumVariable := enumVariable::"Open and Closed";

            else
                Error('Invalid Option Value: %1', optionValue);
        end;
        exit(enumVariable);
    end;

    // [Integration]
//Local procedure OnBeforeOpenPageVATEntryTotaling(var VATEntry : Record 254;var VATStatementLine : Record 256);
//    begin
//    end;

    //procedure
}

