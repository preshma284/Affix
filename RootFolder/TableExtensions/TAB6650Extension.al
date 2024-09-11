tableextension 50203 "MyExtension50203" extends "Return Shipment Header"
{

    DataCaptionFields = "No.", "Buy-from Vendor Name";
    CaptionML = ENU = 'Return Shipment Header', ESP = 'Cabecera env�o devoluci�n';
    LookupPageID = "Posted Return Shipments";
    DrillDownPageID = "Posted Return Shipments";

    fields
    {
        field(7207276; "Job No."; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job No.', ESP = 'Nï¿½ proyecto';
            Description = 'QB 1.00 - QB2514';


        }
        field(7207295; "QB Contract No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST("Order"));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Order to Cancel', ESP = 'N� Contrato';
            Description = 'BS::20789';

            trigger OnLookup();
            VAR
                //                                                               QBPageSubscriber@100000000 :
                QBPageSubscriber: Codeunit 7207349;
            BEGIN
            END;


        }
        field(7207700; "QB Stocks New Functionality"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'New_Functionality', ESP = 'Nueva Funcionalidad Stocks';
            Description = 'QB_ST01';


        }
    }
    keys
    {
        // key(key1;"No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Return Order No.")
        //  {
        /* ;
  */
        // }
        // key(key3;"Buy-from Vendor No.")
        //  {
        /* ;
  */
        // }
        // key(key4;"Pay-to Vendor No.")
        //  {
        /* ;
  */
        // }
    }
    fieldgroups
    {
    }

    var
        //       ReturnShptHeader@1000 :
        ReturnShptHeader: Record 6650;
        //       PurchCommentLine@1001 :
        PurchCommentLine: Record 43;
        //       VendLedgEntry@1002 :
        VendLedgEntry: Record 25;
        //       PostCode@1005 :
        PostCode: Record 225;
        //       DimMgt@1004 :
        DimMgt: Codeunit 408;
        //       ApprovalsMgmt@1006 :
        ApprovalsMgmt: Codeunit 1535;
        //       UserSetupMgt@1007 :
        UserSetupMgt: Codeunit 5700;
        //       Text001@1008 :
        Text001: TextConst ENU = 'Posted Document Dimensions', ESP = 'Dimensiones del documento registrado';





    /*
    trigger OnDelete();    var
    //                CertificateOfSupply@1000 :
                   CertificateOfSupply: Record 780;
    //                PostPurchDelete@1001 :
                   PostPurchDelete: Codeunit 364;
                 begin
                   LOCKTABLE;
                   PostPurchDelete.DeletePurchShptLines(Rec);

                   PurchCommentLine.SETRANGE("Document Type",PurchCommentLine."Document Type"::"Posted Return Shipment");
                   PurchCommentLine.SETRANGE("No.","No.");
                   PurchCommentLine.DELETEALL;

                   ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);

                   if CertificateOfSupply.GET(CertificateOfSupply."Document Type"::"Return Shipment","No.") then
                     CertificateOfSupply.DELETE(TRUE);
                 end;

    */



    // procedure PrintRecords (ShowRequestForm@1000 :

    /*
    procedure PrintRecords (ShowRequestForm: Boolean)
        var
    //       ReportSelection@1001 :
          ReportSelection: Record 77;
        begin
          WITH ReturnShptHeader DO begin
            COPY(Rec);
            ReportSelection.PrintWithGUIYesNoVendor(
              ReportSelection.Usage::"P.Ret.Shpt.",ReturnShptHeader,ShowRequestForm,FIELDNO("Buy-from Vendor No."));
          end;
        end;
    */




    /*
    procedure Navigate ()
        var
    //       NavigateForm@1000 :
          NavigateForm: Page 344;
        begin
          NavigateForm.SetDoc("Posting Date","No.");
          NavigateForm.RUN;
        end;
    */




    /*
    procedure ShowDimensions ()
        begin
          DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1,%2 %3',TABLECAPTION,"No.",Text001));
        end;
    */




    /*
    procedure SetSecurityFilterOnRespCenter ()
        begin
          if UserSetupMgt.GetPurchasesFilter <> '' then begin
            FILTERGROUP(2);
            SETRANGE("Responsibility Center",UserSetupMgt.GetPurchasesFilter);
            FILTERGROUP(0);
          end;
        end;

        /*begin
        //{
    //      AML 23/03/22 QB_ST01 Campo NewFunctionality
    //      BS::20789 AML 22/1/24 Control de contratos
    //    }
        end.
      */
}




