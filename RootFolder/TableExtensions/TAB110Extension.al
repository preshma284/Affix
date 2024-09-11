tableextension 50130 "MyExtension50130" extends "Sales Shipment Header"
{

    DataCaptionFields = "No.", "Sell-to Customer Name";
    CaptionML = ENU = 'Sales Shipment Header', ESP = 'Hist�rico cab. albar�n venta';
    LookupPageID = "Posted Sales Shipments";
    DrillDownPageID = "Posted Sales Shipments";

    fields
    {
        field(7207275; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';
            Description = 'QB 1.00';


        }
        field(7207276; "Job Sale Doc. Type"; Option)
        {
            OptionMembers = "Standar","Equipament Advance","Advance by Store","Price Review";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Sale Doc. Type', ESP = 'Tipo doc. venta proyecto';
            OptionCaptionML = ENU = 'Standar,Equipament Advance,Advance by Store,Price Review', ESP = 'Estandar,Anticipo de maquinaria,Anticipo por acopios,Revisi�n precios';

            Description = 'QB 1.0 - QB28123';


        }
    }
    keys
    {
        // key(key1;"No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Order No.")
        //  {
        /* ;
  */
        // }
        // key(key3;"Bill-to Customer No.")
        //  {
        /* ;
  */
        // }
        // key(key4;"Sell-to Customer No.")
        //  {
        /* ;
  */
        // }
        // key(key5;"Posting Date")
        //  {
        /* ;
  */
        // }
    }
    fieldgroups
    {
        // fieldgroup(DropDown;"No.","Sell-to Customer No.","Sell-to Customer Name","Posting Date","Posting Description")
        // {
        // 
        // }
    }

    var
        //       SalesShptHeader@1000 :
        SalesShptHeader: Record 110;
        //       SalesCommentLine@1001 :
        SalesCommentLine: Record 44;
        //       CustLedgEntry@1002 :
        CustLedgEntry: Record 21;
        //       ShippingAgent@1004 :
        ShippingAgent: Record 291;
        //       DimMgt@1006 :
        DimMgt: Codeunit 408;
        //       ApprovalsMgmt@1011 :
        ApprovalsMgmt: Codeunit 1535;
        //       UserSetupMgt@1008 :
        UserSetupMgt: Codeunit 5700;
        //       TrackingInternetAddr@1007 :
        TrackingInternetAddr: Text;
        //       DocTxt@1003 :
        DocTxt: TextConst ENU = 'Shipment', ESP = 'Env�o';





    /*
    trigger OnDelete();    var
    //                CertificateOfSupply@1000 :
                   CertificateOfSupply: Record 780;
    //                PostSalesDelete@1001 :
                   PostSalesDelete: Codeunit 363;
                 begin
                   TESTFIELD("No. Printed");
                   LOCKTABLE;
                   PostSalesDelete.DeleteSalesShptLines(Rec);

                   SalesCommentLine.SETRANGE("Document Type",SalesCommentLine."Document Type"::Shipment);
                   SalesCommentLine.SETRANGE("No.","No.");
                   SalesCommentLine.DELETEALL;

                   ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);

                   if CertificateOfSupply.GET(CertificateOfSupply."Document Type"::"Sales Shipment","No.") then
                     CertificateOfSupply.DELETE(TRUE);
                 end;

    */



    // procedure SendProfile (var DocumentSendingProfile@1000 :
    procedure SendProfile(var DocumentSendingProfile: Record 60)
    var
        //       DummyReportSelections@1003 :
        DummyReportSelections: Record 77;
        //       IsHandled@1001 :
        IsHandled: Boolean;
    begin
        IsHandled := FALSE;
        OnBeforeSendProfile(DocumentSendingProfile, Rec, IsHandled);
        if IsHandled then
            exit;

        DocumentSendingProfile.Send(
         DummyReportSelections.Usage::"S.Shipment", Rec, "No.", "Sell-to Customer No.",
         DocTxt, FIELDNO("Sell-to Customer No."), FIELDNO("No."));
    end;


    //     procedure PrintRecords (ShowRequestForm@1000 :

    /*
    procedure PrintRecords (ShowRequestForm: Boolean)
        var
    //       ReportSelection@1001 :
          ReportSelection: Record 77;
    //       IsHandled@1002 :
          IsHandled: Boolean;
        begin
          WITH SalesShptHeader DO begin
            COPY(Rec);
            OnBeforePrintRecords(SalesShptHeader,ShowRequestForm,IsHandled);
            if IsHandled then
              exit;

            ReportSelection.PrintWithGUIYesNo(
              ReportSelection.Usage::"S.Shipment",SalesShptHeader,ShowRequestForm,FIELDNO("Bill-to Customer No."));
          end;
        end;
    */



    //     procedure EmailRecords (ShowDialog@1000 :

    /*
    procedure EmailRecords (ShowDialog: Boolean)
        var
    //       DocumentSendingProfile@1003 :
          DocumentSendingProfile: Record 60;
    //       DummyReportSelections@1001 :
          DummyReportSelections: Record 77;
    //       IsHandled@1002 :
          IsHandled: Boolean;
        begin
          OnBeforeEmailRecords(Rec,ShowDialog,IsHandled);
          if IsHandled then
            exit;

          DocumentSendingProfile.TrySendToEMail(
            DummyReportSelections.Usage::"S.Shipment",Rec,FIELDNO("No."),DocTxt,FIELDNO("Bill-to Customer No."),ShowDialog);
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
    procedure StartTrackingSite ()
        begin
          HYPERLINK(GetTrackingInternetAddr);
        end;
    */




    /*
    procedure ShowDimensions ()
        begin
          DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."));
        end;
    */




    /*
    procedure IsCompletlyInvoiced () : Boolean;
        var
    //       SalesShipmentLine@1008 :
          SalesShipmentLine: Record 111;
        begin
          SalesShipmentLine.SETRANGE("Document No.","No.");
          SalesShipmentLine.SETFILTER("Qty. Shipped not Invoiced",'<>0');
          if SalesShipmentLine.ISEMPTY then
            exit(TRUE);
          exit(FALSE);
        end;
    */




    /*
    procedure SetSecurityFilterOnRespCenter ()
        begin
          if UserSetupMgt.GetSalesFilter <> '' then begin
            FILTERGROUP(2);
            SETRANGE("Responsibility Center",UserSetupMgt.GetSalesFilter);
            FILTERGROUP(0);
          end;
        end;
    */




    /*
    procedure GetTrackingInternetAddr () : Text;
        var
    //       HttpStr@1001 :
          HttpStr: Text;
        begin
          HttpStr := 'http://';
          TESTFIELD("Shipping Agent Code");
          ShippingAgent.GET("Shipping Agent Code");
          TrackingInternetAddr := STRSUBSTNO(ShippingAgent."Internet Address","Package Tracking No.");

          if STRPOS(TrackingInternetAddr,HttpStr) = 0 then
            TrackingInternetAddr := HttpStr + TrackingInternetAddr;
          exit(TrackingInternetAddr);
        end;
    */




    /*
    procedure GetWorkDescription () : Text;
        var
          TempBlob : Codeunit "Temp Blob";
    Blob : OutStream;
    InStr : InStream;

    //       CR@1004 :
          CR: Text[1];
        begin
          CALCFIELDS("Work Description");
          if not "Work Description".HASVALUE then
            exit('');

          CR[1] := 10;
          // TempBlob.Blob := "Work Description";
    //To be tested

    TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
    Blob.Write("Work Description");
          // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
    //To be tested

    TempBlob.CreateInStream(InStr, TextEncoding::Windows);
    InStr.Read(CR);
    exit(CR);
        end;
    */



    //     LOCAL procedure OnBeforeEmailRecords (var SalesShipmentHeader@1000 : Record 110;SendDialog@1001 : Boolean;var IsHandled@1002 :

    /*
    LOCAL procedure OnBeforeEmailRecords (var SalesShipmentHeader: Record 110;SendDialog: Boolean;var IsHandled: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforePrintRecords (var SalesShipmentHeader@1000 : Record 110;ShowDialog@1001 : Boolean;var IsHandled@1002 :

    /*
    LOCAL procedure OnBeforePrintRecords (var SalesShipmentHeader: Record 110;ShowDialog: Boolean;var IsHandled: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeSendProfile (var DocumentSendingProfile@1000 : Record 60;var SalesShipmentHeader@1001 : Record 110;var IsHandled@1003 :


    LOCAL procedure OnBeforeSendProfile(var DocumentSendingProfile: Record 60; var SalesShipmentHeader: Record 110; var IsHandled: Boolean)
    begin
    end;

    /*begin
    end.
  */
}




