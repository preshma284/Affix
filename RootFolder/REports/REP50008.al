report 50008 "OTERO: Contrato Sum.Materiales"
{
  
  
    CaptionML=ENU='OTERO: Contrato Sum.Materiales',ESP='OTERO: Contrato Sum.Materiales';
    PreviewMode=PrintLayout;
    DefaultLayout=Word;
    WordMergeDataItem="Purchase Header";
  
  dataset
{

DataItem("Purchase Header";"Purchase Header")
{

               DataItemTableView=SORTING("Document Type","No.");
               ;
Column(PurchaseHeader_No;"Purchase Header"."No.")
{
//SourceExpr="Purchase Header"."No.";
}Column(PurchaseHeader_Date;FORMAT("Purchase Header"."Document Date"))
{
//SourceExpr=FORMAT("Purchase Header"."Document Date");
}Column(TotalAmount;TotalAmount)
{
//SourceExpr=TotalAmount;
}Column(TotalPending;TotalPending)
{
//SourceExpr=TotalPending;
}Column(TotalWithholdings;TotalWithholdings)
{
//SourceExpr=TotalWithholdings;
}Column(Work_PaymentMethodCode;"Purchase Header"."Payment Method Code")
{
//SourceExpr="Purchase Header"."Payment Method Code";
}Column(PaymentMethod_Description;PaymentMethod.Description)
{
//SourceExpr=PaymentMethod.Description;
}Column(Work_PaymentTermsCode;"Purchase Header"."Payment Terms Code")
{
//SourceExpr="Purchase Header"."Payment Terms Code";
}Column(PaymentTerms_Description;PaymentTerms.Description)
{
//SourceExpr=PaymentTerms.Description;
}Column(CurrentDay;CurrentDay)
{
//SourceExpr=CurrentDay;
}Column(CurrentMonth;CurrentMonth)
{
//SourceExpr=CurrentMonth;
}Column(CurrentYear;CurrentYear)
{
//SourceExpr=CurrentYear;
}Column(DocumentDay;DocumentDay)
{
//SourceExpr=DocumentDay;
}Column(DocumentMonth;DocumentMonth)
{
//SourceExpr=DocumentMonth;
}Column(DocumentYear;DocumentYear)
{
//SourceExpr=DocumentYear;
}Column(Company_Name;CompanyInformation.Name + ' ' + CompanyInformation."Name 2")
{
//SourceExpr=CompanyInformation.Name + ' ' + CompanyInformation."Name 2";
}Column(Company_Address;CompanyInformation.Address + ' ' + CompanyInformation."Address 2")
{
//SourceExpr=CompanyInformation.Address + ' ' + CompanyInformation."Address 2";
}Column(Company_City;CompanyInformation.City)
{
//SourceExpr=CompanyInformation.City;
}Column(Company_PhoneNo;CompanyInformation."Phone No.")
{
//SourceExpr=CompanyInformation."Phone No.";
}Column(Company_BankAccountNo;CompanyInformation."Bank Account No.")
{
//SourceExpr=CompanyInformation."Bank Account No.";
}Column(Company_VATRegistrationNo;CompanyInformation."VAT Registration No.")
{
//SourceExpr=CompanyInformation."VAT Registration No.";
}Column(Company_PostCode;CompanyInformation."Post Code")
{
//SourceExpr=CompanyInformation."Post Code";
}Column(Company_County;CompanyInformation.County)
{
//SourceExpr=CompanyInformation.County;
}Column(Company_EMail;CompanyInformation."E-Mail")
{
//SourceExpr=CompanyInformation."E-Mail";
}Column(Company_HomePage;CompanyInformation."Home Page")
{
//SourceExpr=CompanyInformation."Home Page";
}Column(Company_CountryRegionCode;CompanyInformation."Country/Region Code")
{
//SourceExpr=CompanyInformation."Country/Region Code";
}Column(Company_CompanyCode;QuoBuildingSetup."Company Code")
{
//SourceExpr=QuoBuildingSetup."Company Code";
}Column(Company_Notary;QuoBuildingSetup.Notary)
{
//SourceExpr=QuoBuildingSetup.Notary;
}Column(Company_NotaryCity;QuoBuildingSetup."Notary City")
{
//SourceExpr=QuoBuildingSetup."Notary City";
}Column(Company_NotarialProtocol;QuoBuildingSetup."Notarial Protocol")
{
//SourceExpr=QuoBuildingSetup."Notarial Protocol";
}Column(Company_EstablishmentDate;FORMAT(QuoBuildingSetup."Establishment Date"))
{
//SourceExpr=FORMAT(QuoBuildingSetup."Establishment Date");
}Column(Company_Representative;QuoBuildingSetup."Company Representative")
{
//SourceExpr=QuoBuildingSetup."Company Representative";
}Column(Company_RepresentativeAdress;QuoBuildingSetup."Representative Adress")
{
//SourceExpr=QuoBuildingSetup."Representative Adress";
}Column(Company_VATRegistrationNoRepresen;QuoBuildingSetup."VAT Registration No. Represen.")
{
//SourceExpr=QuoBuildingSetup."VAT Registration No. Represen.";
}Column(Company_CommercialRegister;QuoBuildingSetup."Commercial Register")
{
//SourceExpr=QuoBuildingSetup."Commercial Register";
}Column(Company_Sheet;QuoBuildingSetup."Commercial Register Sheet")
{
//SourceExpr=QuoBuildingSetup."Commercial Register Sheet";
}Column(Vendor_Name;Vendor.Name + ' ' + Vendor."Name 2")
{
//SourceExpr=Vendor.Name + ' ' + Vendor."Name 2";
}Column(Vendor_Address;Vendor.Address + ' ' + Vendor."Address 2")
{
//SourceExpr=Vendor.Address + ' ' + Vendor."Address 2";
}Column(Vendor_City;Vendor.City)
{
//SourceExpr=Vendor.City;
}Column(Vendor_PostCode;Vendor."Post Code")
{
//SourceExpr=Vendor."Post Code";
}Column(Vendor_County;Vendor.County)
{
//SourceExpr=Vendor.County;
}Column(Vendor_Fax;Vendor."Fax No.")
{
//SourceExpr=Vendor."Fax No.";
}Column(Vendor_RegSheet;Vendor."QB Reg. Sheet")
{
//SourceExpr=Vendor."QB Reg. Sheet";
}Column(Vendor_VATReg;Vendor."VAT Registration No.")
{
//SourceExpr=Vendor."VAT Registration No.";
}Column(Vendor_EstablishmentDate;FORMAT(Vendor."QB Establishment Date"))
{
//SourceExpr=FORMAT(Vendor."QB Establishment Date");
}Column(Vendor_Notary;Vendor."QB Before the notary")
{
//SourceExpr=Vendor."QB Before the notary";
}Column(Vendor_NotaryProtocolNo;Vendor."QB Protocol No.")
{
//SourceExpr=Vendor."QB Protocol No.";
}Column(Vendor_NotaryCity;Vendor."QB notary city")
{
//SourceExpr=Vendor."QB notary city";
}Column(Vendor_BusinessReg;Vendor."QB Business Registration")
{
//SourceExpr=Vendor."QB Business Registration";
}Column(Vendor_SS;Vendor."QB Seg.Soc. Number")
{
//SourceExpr=Vendor."QB Seg.Soc. Number";
}Column(Vendor_Rep1_Name;Contact1.Name + ' ' +Contact1."Name 2")
{
//SourceExpr=Contact1.Name + ' ' +Contact1."Name 2";
}Column(Vendor_Rep1_Address;Contact1.Address + ' ' + Contact1."Address 2")
{
//SourceExpr=Contact1.Address + ' ' + Contact1."Address 2";
}Column(Vendor_Rep1_City;Contact1.City)
{
//SourceExpr=Contact1.City;
}Column(Vendor_Rep1_PostCode;Contact1."Post Code")
{
//SourceExpr=Contact1."Post Code";
}Column(Vendor_Rep1_County;Contact1.County)
{
//SourceExpr=Contact1.County;
}Column(Vendor_Rep1_VATReg;Contact1."VAT Registration No.")
{
//SourceExpr=Contact1."VAT Registration No.";
}Column(Vendor_Rep2_Name2;Contact2.Name + ' ' +Contact2."Name 2")
{
//SourceExpr=Contact2.Name + ' ' +Contact2."Name 2";
}Column(Vendor_Rep2_Address;Contact2.Address + ' ' + Contact2."Address 2")
{
//SourceExpr=Contact2.Address + ' ' + Contact2."Address 2";
}Column(Vendor_Rep2_City;Contact2.City)
{
//SourceExpr=Contact2.City;
}Column(Vendor_Rep2_PostCode;Contact2."Post Code")
{
//SourceExpr=Contact2."Post Code";
}Column(Vendor_Rep2_County;Contact2.County)
{
//SourceExpr=Contact2.County;
}Column(Vendor_Rep2_VATReg;Contact2."VAT Registration No.")
{
//SourceExpr=Contact2."VAT Registration No.";
}Column(Vendor_RepPRL_Name;ContactPRL.Name + ' ' +ContactPRL."Name 2")
{
//SourceExpr=ContactPRL.Name + ' ' +ContactPRL."Name 2";
}Column(Vendor_RepPRL_Address;ContactPRL.Address + ' ' + ContactPRL."Address 2")
{
//SourceExpr=ContactPRL.Address + ' ' + ContactPRL."Address 2";
}Column(Vendor_RepPRL_City;ContactPRL.City)
{
//SourceExpr=ContactPRL.City;
}Column(Vendor_RepPRL_PostCode;ContactPRL."Post Code")
{
//SourceExpr=ContactPRL."Post Code";
}Column(Vendor_RepPRL_County;ContactPRL.County)
{
//SourceExpr=ContactPRL.County;
}Column(Vendor_RepPRL_VATRegistrationNo;ContactPRL."VAT Registration No.")
{
//SourceExpr=ContactPRL."VAT Registration No.";
}Column(Vendor_Attorney;ContactATT.Name + ' ' +ContactATT."Name 2")
{
//SourceExpr=ContactATT.Name + ' ' +ContactATT."Name 2";
}Column(Vendor_Attorney_VATRegistrationNo;ContactATT."VAT Registration No.")
{
//SourceExpr=ContactATT."VAT Registration No.";
}Column(Vendor_Attorney_MaritalStatus;ContactATT."QB Attorney Marital status")
{
//SourceExpr=ContactATT."QB Attorney Marital status";
}Column(Vendor_Attorney_PowerDate;FORMAT(ContactATT."QB Attorney seizure date"))
{
//SourceExpr=FORMAT(ContactATT."QB Attorney seizure date");
}Column(Vendor_Attorney_NotaryCity;ContactATT."QB Attorney notary City")
{
//SourceExpr=ContactATT."QB Attorney notary City";
}Column(Vendor_Attorney_Notary;ContactATT."QB Attorney notary")
{
//SourceExpr=ContactATT."QB Attorney notary";
}Column(Vendor_Attorney_ProtocolNo;ContactATT."QB Attorney protocol No.")
{
//SourceExpr=ContactATT."QB Attorney protocol No.";
}Column(Vendor_Attorney_Type;ContactATT."QB Attorney Type")
{
//SourceExpr=ContactATT."QB Attorney Type";
}Column(Job_No;Job."No.")
{
//SourceExpr=Job."No.";
}Column(Job_Description;Job.Description + Job."Description 2")
{
//SourceExpr=Job.Description + Job."Description 2";
}Column(Job_Address;Job."Job Address 1" + Job."Job Adress 2")
{
//SourceExpr=Job."Job Address 1" + Job."Job Adress 2";
}Column(Job_City;Job."Job City")
{
//SourceExpr=Job."Job City";
}Column(Job_Architect;Job.Architect)
{
//SourceExpr=Job.Architect;
}Column(Job_BillToName;Job."Bill-to Name")
{
//SourceExpr=Job."Bill-to Name";
}Column(Job_Name;DocumentDataContracts."Job Name")
{
//SourceExpr=DocumentDataContracts."Job Name";
}Column(Work_Delay;DocumentDataContracts."Work Delay")
{
//SourceExpr=DocumentDataContracts."Work Delay";
}Column(Work_Duration;DocumentDataContracts."Work Duration")
{
//SourceExpr=DocumentDataContracts."Work Duration";
}Column(Work_Performance;DocumentDataContracts."Work Performance")
{
//SourceExpr=DocumentDataContracts."Work Performance";
}Column(Work_Ofamount;DocumentDataContracts."Work % Of amount")
{
//SourceExpr=DocumentDataContracts."Work % Of amount";
}Column(Work_ObjetiveoftheContract;DocumentDataContracts."Work Objetive of the Contract")
{
//SourceExpr=DocumentDataContracts."Work Objetive of the Contract";
}Column(Work_TestingTerm;DocumentDataContracts."Work Testing Term")
{
//SourceExpr=DocumentDataContracts."Work Testing Term";
}Column(Work_PaymentDocumentDue;DocumentDataContracts."Work Payment Document Due")
{
//SourceExpr=DocumentDataContracts."Work Payment Document Due";
}Column(Work_FirstInstallmentofPenalty;DocumentDataContracts."Work First Installment Penalty")
{
//SourceExpr=DocumentDataContracts."Work First Installment Penalty";
}Column(Work_SecondInstallmentofPenalty;DocumentDataContracts."Work Second Installment Pen.")
{
//SourceExpr=DocumentDataContracts."Work Second Installment Pen.";
}Column(Work_ProvisionalReceiptDate;FORMAT(DocumentDataContracts."Work Provisional Receipt Date"))
{
//SourceExpr=FORMAT(DocumentDataContracts."Work Provisional Receipt Date");
}Column(Work_FinishDate;FORMAT(DocumentDataContracts."Work Finish Date"))
{
//SourceExpr=FORMAT(DocumentDataContracts."Work Finish Date");
}Column(Work_RedesignDate;FORMAT(DocumentDataContracts."Work Redesign Date"))
{
//SourceExpr=FORMAT(DocumentDataContracts."Work Redesign Date");
}Column(Work_RedesignHour;FORMAT(DocumentDataContracts."Work Redesign Hour"))
{
//SourceExpr=FORMAT(DocumentDataContracts."Work Redesign Hour");
}Column(Work_FaxReason;DocumentDataContracts."Work Fax Reason")
{
//SourceExpr=DocumentDataContracts."Work Fax Reason";
}Column(Work_ReturnTime;DocumentDataContracts."Work Return Time")
{
//SourceExpr=DocumentDataContracts."Work Return Time";
}Column(Work_TermExpirationReturn;DocumentDataContracts."Work Term Expiration Return")
{
//SourceExpr=DocumentDataContracts."Work Term Expiration Return";
}Column(Work_SecureAmount;DocumentDataContracts."Work Secure Amount")
{
//SourceExpr=DocumentDataContracts."Work Secure Amount";
}Column(Work_MaxFranchise;DocumentDataContracts."Work Max Franchise")
{
//SourceExpr=DocumentDataContracts."Work Max Franchise";
}Column(Work_AmountofEmployerLiability;DocumentDataContracts."Work Amt. Employer Liability")
{
//SourceExpr=DocumentDataContracts."Work Amt. Employer Liability";
}Column(Work_PenaltyforBreach;DocumentDataContracts."Work Penalty for Breach")
{
//SourceExpr=DocumentDataContracts."Work Penalty for Breach";
}Column(Work_ImportMaterialTransport;DocumentDataContracts."Work Import Material Transport")
{
//SourceExpr=DocumentDataContracts."Work Import Material Transport";
}Column(Work_MinimumPeriodofContract;DocumentDataContracts."Work Minimum Period Contract")
{
//SourceExpr=DocumentDataContracts."Work Minimum Period Contract";
}Column(Work_ImportContract;DocumentDataContracts."Work Import Contract")
{
//SourceExpr=DocumentDataContracts."Work Import Contract";
}Column(Work_WorkType;DocumentDataContracts."Work Work Type")
{
//SourceExpr=DocumentDataContracts."Work Work Type";
}Column(Work_StartDate;FORMAT(DocumentDataContracts."Work Start Date"))
{
//SourceExpr=FORMAT(DocumentDataContracts."Work Start Date");
}Column(Work_EndDate;FORMAT(DocumentDataContracts."Work End Date"))
{
//SourceExpr=FORMAT(DocumentDataContracts."Work End Date");
}Column(Work_WittholdingWarrantyAdd;DocumentDataContracts."Work % Withholding Aditional")
{
//SourceExpr=DocumentDataContracts."Work % Withholding Aditional";
}Column(Work_BillingMilestones;DocumentDataContracts."Work Billing Milestones")
{
//SourceExpr=DocumentDataContracts."Work Billing Milestones";
}Column(Work_WithholdingWarrantyPorc;WithholdingGroup."Percentage Withholding")
{
//SourceExpr=WithholdingGroup."Percentage Withholding";
}DataItem("Purchase Line";"Purchase Line")
{

               DataItemTableView=SORTING("Document Type","Document No.","Line No.");
DataItemLink="Document Type"= FIELD("Document Type"),
                            "Document No."= FIELD("No.");
Column(No;"Purchase Line"."No.")
{
//SourceExpr="Purchase Line"."No.";
}Column(Description;"Purchase Line".Description + "Purchase Line"."Description 2")
{
//SourceExpr="Purchase Line".Description + "Purchase Line"."Description 2";
}Column(UM;"Purchase Line"."Unit of Measure Code")
{
//SourceExpr="Purchase Line"."Unit of Measure Code";
}Column(Quantity;"Purchase Line".Quantity)
{
//SourceExpr="Purchase Line".Quantity;
}Column(UnitCost;"Purchase Line"."Unit Cost (LCY)")
{
//SourceExpr="Purchase Line"."Unit Cost (LCY)";
}Column(LineAmt;"Purchase Line"."Line Amount")
{
//SourceExpr="Purchase Line"."Line Amount";
}Column(PieceworkNo;"Purchase Line"."Piecework No.")
{
//SourceExpr="Purchase Line"."Piecework No.";
}Column(TxtAdicional;TxtAdicional )
{
//SourceExpr=TxtAdicional ;
}trigger OnAfterGetRecord();
    BEGIN 
                                  TxtAdicional := '';
                                  IF QBText.GET(QBText.Table::Contrato, '1', "Purchase Line"."Document No.", "Purchase Line"."Line No.") THEN
                                    TxtAdicional := QBText.GetCostText;
                                END;


}trigger OnAfterGetRecord();
    BEGIN 
                                  CompanyInformation.GET;
                                  QuoBuildingSetup.GET;
                                  QBPageSubscriber.FillContractData("Purchase Header");
                                  QBReportSubscriber.CalcPurchaseAmounts("Purchase Header", TotalAmount, TotalPending, TotalWithholdings);

                                  IF NOT Vendor.GET("Purchase Header"."Buy-from Vendor No.") THEN
                                    Vendor.INIT;

                                  IF NOT PaymentTerms.GET("Purchase Header"."Payment Terms Code") THEN
                                    PaymentTerms.INIT;

                                  IF NOT PaymentMethod.GET("Purchase Header"."Payment Method Code") THEN
                                    PaymentMethod.INIT;

                                  IF NOT Contact1.GET(Vendor."QB Representative 1") THEN
                                    Contact1.INIT;

                                  IF NOT Contact2.GET(Vendor."QB Representative 2") THEN
                                    Contact2.INIT;

                                  IF NOT ContactPRL.GET(Vendor."QB Representative PRL") THEN
                                    ContactPRL.INIT;

                                  IF NOT ContactATT.GET(Vendor."QB Attorney") THEN
                                    ContactATT.INIT;

                                  IF NOT Job.GET("Purchase Header"."QB Job No.") THEN
                                    Job.INIT;

                                  //JAV 30/10/21: - QB 1.09.26 Se simplifica el manejo de la tabla, ahora la clave es JOB+Documento
                                  IF NOT DocumentDataContracts.GET("Purchase Header"."QB Job No.", "Purchase Header"."No.") THEN
                                    DocumentDataContracts.INIT;

                                  CurrentDay    := DATE2DMY(TODAY,1);
                                  CurrentMonth  := FORMAT(TODAY,0,'<Month Text>');
                                  CurrentYear   := DATE2DMY(TODAY,3);

                                  DocumentDay   := DATE2DMY("Document Date",1);
                                  DocumentMonth := FORMAT("Document Date",0,'<Month Text>');
                                  DocumentYear  := DATE2DMY("Document Date",3);

                                  WithholdingGroup.RESET;
                                  WithholdingGroup.SETRANGE("Withholding Type",WithholdingGroup."Withholding Type"::"G.E");
                                  WithholdingGroup.SETRANGE(Code,"Purchase Header"."QW Cod. Withholding by GE");
                                  IF NOT WithholdingGroup.FINDFIRST THEN
                                    WithholdingGroup.INIT;
                                END;


}
}
  requestpage
  {

    layout
{
}
  }
  labels
{
}
  
    var
//       QuoBuildingSetup@1100286023 :
      QuoBuildingSetup: Record 7207278;
//       Vendor@1100286022 :
      Vendor: Record 23;
//       Contact1@1100286021 :
      Contact1: Record 5050;
//       Contact2@1100286020 :
      Contact2: Record 5050;
//       ContactPRL@1100286019 :
      ContactPRL: Record 5050;
//       ContactATT@1100286018 :
      ContactATT: Record 5050;
//       Job@1100286017 :
      Job: Record 167;
//       CompanyInformation@1100286016 :
      CompanyInformation: Record 79;
//       WithholdingGroup@1100286015 :
      WithholdingGroup: Record 7207330;
//       Currency@1100286014 :
      Currency: Record 4;
//       DocumentDataContracts@1100286013 :
      DocumentDataContracts: Record 7207391;
//       QBText@1100286012 :
      QBText: Record 7206918;
//       PaymentTerms@1100286024 :
      PaymentTerms: Record 3;
//       PaymentMethod@1100286025 :
      PaymentMethod: Record 289;
//       QBPageSubscriber@1100286011 :
      QBPageSubscriber: Codeunit 7207349;
//       QBReportSubscriber@1100286010 :
      QBReportSubscriber: Codeunit 7207351;
//       CurrentDay@1100286009 :
      CurrentDay: Integer;
//       CurrentMonth@1100286008 :
      CurrentMonth: Text;
//       CurrentYear@1100286007 :
      CurrentYear: Integer;
//       DocumentDay@1100286006 :
      DocumentDay: Integer;
//       DocumentMonth@1100286005 :
      DocumentMonth: Text;
//       DocumentYear@1100286004 :
      DocumentYear: Integer;
//       TxtAdicional@1100286003 :
      TxtAdicional: Text;
//       TotalAmount@1100286002 :
      TotalAmount: Decimal;
//       TotalPending@1100286001 :
      TotalPending: Decimal;
//       TotalWithholdings@1100286000 :
      TotalWithholdings: Decimal;

    /*begin
    {
      JDC 19/02/21: - Q12869 Modified DataItem "Purchase Header", "Purchase Line" adding "DataItemTableView"
                            Moved variable "TotalAmount" to DataItem "Purchase Header"
      HAN 08/03/21: - Q12932Added asignation of request page variables
      PGM 06/07/21: - Q12987 Modificado el trigger "Purchase Header - OnAfterGetRecord"
      JAV 30/10/21: - QB 1.09.26 Se simplifica el manejo de la tabla, ahora la clave es JOB+Documento
      PSM 12/01/22: - Q16120 A¤adir "Job_City" y "Work_BillingMilestones", format a Vendor_EstablishmentDate
      JAV 24/01/22: - Para los campos de tipo fecha se emplea FORMAT para que solo informe de fecha y no de fecha y hora
    }
    end.
  */
  
  
}



