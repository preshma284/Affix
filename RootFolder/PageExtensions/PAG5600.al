pageextension 50230 MyExtension5600 extends 5600//5600
{
layout
{
addafter("Last Date Modified")
{
    field("QB_AssetAllocationJob";rec."Asset Allocation Job")
    {
        
}
    field("QB_PieceworkCode";rec."Piecework Code")
    {
        
}
} addafter("DepreciationTableCode")
{
//     field("UseHalfYearConvention";FADepreciationBook."Use Half-Year Convention")
//     {
        
//                 CaptionML=ENU='Use Half-Year Convention',ESP='Usar convenio de medio a¤o';
//                 ToolTipML=ENU='Specifies that the Half-Year Convention is to be applied to the selected depreciation method.',ESP='Especifica que se debe aplicar el convenio de medio a¤o al m‚todo de amortizaci¢n seleccionado.';
//                 ApplicationArea=FixedAssets;
//                 Importance=Additional;
                
//                             ;trigger OnValidate()    BEGIN
//                              LoadDepreciationBooks;
//                              FADepreciationBook.VALIDATE("Use Half-Year Convention");
//                              SaveSimpleDepriciationBook(xRec."No.");
//                            END;


// }
}

}

actions
{
addafter("Attachments")
{
    action("QB_AnaliticalDistribution")
    {
        
                      CaptionML=ENU='Job Distribution',ESP='Distribuci¢n Por Proyecto';
                      ToolTipML=ESP='Distribuci¢n de la amortizaci¢n por Proyecto/UO-Partida Presupuestaria';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Track;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 pgAnaliticalDistr : Page 7206996;
                               BEGIN
                                 pgAnaliticalDistr.SetFA(rec."No.");
                                 pgAnaliticalDistr.RUNMODAL;

                                 CurrPage.UPDATE(TRUE);
                               END;


}
group("QB_MaintenanceLists")
{
        
                      CaptionML=ENU='Maintenance Lists',ESP='Mantenimiento';
                      Image=FixedAssets ;
    action("QB_AssetsMaintenance")
    {
        CaptionML=ENU='Assets Maintenance',ESP='Mantenimiento Activos fijos';
                      RunObject=Page 50054;
RunPageLink="No."=field("No.");
                      Promoted=true;
                      Image=FixedAssetLedger;
                      PromotedCategory=Process;
}
    action("QB_TechnicalDetails")
    {
        CaptionML=ENU='Technical Details',ESP='Ficha t‚cnica';
                      RunObject=Page 50055;
RunPageLink="Asset No."=field("No.");
                      Image=FixedAssetLedger;
}
    action("QB_Certificatios")
    {
        CaptionML=ENU='Certificatios',ESP='Certificaciones';
                      RunObject=Page 50056;
RunPageLink="Asset No."=field("No.");
                      Image=FixedAssetLedger;
}
    action("QB_Status Control")
    {
        CaptionML=ENU='Status Control',ESP='Control de estado';
                      RunObject=Page 50057;
RunPageLink="Asset No."=field("No.");
                      Image=FixedAssetLedger;
}
}
}

}

//trigger

//trigger

var
      FADepreciationBook : Record 5612;
      FADepreciationBookOld : Record 5612;
      FAAcquireWizardNotificationId : GUID;
      NoFieldVisible : Boolean;
      Simple : Boolean;
      AddMoreDeprBooksLbl : TextConst ENU='Add More Depreciation Books',ESP='Agregar m s libros de amortizaci¢n';
      Acquirable : Boolean;
      ShowAddMoreDeprBooksLbl : Boolean;
      BookValue : Decimal;

    
    

//procedure
//Local procedure ShowAcquireNotification();
//    var
//      ShowAcquireNotification : Boolean;
//    begin
//      ShowAcquireNotification :=
//        (not Acquired) and rec.FieldsForAcquitionInGeneralGroupAreCompleted and AtLeastOneDepreciationLineIsComplete;
//      if ( ShowAcquireNotification and ISNULLGUID(FAAcquireWizardNotificationId)  )then begin
//        Acquirable := TRUE;
//        rec.ShowAcquireWizardNotification;
//      end ELSE
//        Acquirable := FALSE;
//    end;
//Local procedure AtLeastOneDepreciationLineIsComplete() : Boolean;
//    var
//      FADepreciationBookMultiline : Record 5612;
//    begin
//      if ( Simple  )then
//        exit(FADepreciationBook.RecIsReadyForAcquisition);
//
//      exit(FADepreciationBookMultiline.LineIsReadyForAcquisition(rec."No."));
//    end;
//Local procedure SaveSimpleDepriciationBook(FixedAssetNo : Code[20]);
//    var
//      FixedAsset : Record 5600;
//    begin
//      if ( not SimpleDepreciationBookHasChanged  )then
//        exit;
//
//      if ( Simple and FixedAsset.GET(FixedAssetNo)  )then begin
//        if ( FADepreciationBook."Depreciation Book Code" <> ''  )then
//          if ( FADepreciationBook."FA No." = ''  )then begin
//            FADepreciationBook.VALIDATE("FA No.",FixedAssetNo);
//            FADepreciationBook.INSERT(TRUE)
//          end ELSE
//            FADepreciationBook.MODIFY(TRUE)
//      end;
//    end;
//Local procedure SetDefaultDepreciationBook();
//    var
//      FASetup : Record 5603;
//    begin
//      if ( FADepreciationBook."Depreciation Book Code" = ''  )then begin
//        FASetup.GET;
//        FADepreciationBook.VALIDATE("Depreciation Book Code",FASetup."Default Depr. Book");
//        SaveSimpleDepriciationBook(rec."No.");
//        LoadDepreciationBooks;
//      end;
//    end;
//Local procedure SetDefaultPostingGroup();
//    var
//      FASubclass : Record 5608;
//    begin
//      if ( FADepreciationBook."FA Posting Group" <> ''  )then
//        exit;
//
//      if ( FASubclass.GET(rec."FA Subclass Code")  )then;
//      FADepreciationBook.VALIDATE("FA Posting Group",FASubclass."Default FA Posting Group");
//      SaveSimpleDepriciationBook(rec."No.");
//    end;
//Local procedure SimpleDepreciationBookHasChanged() : Boolean;
//    begin
//      exit(FORMAT(FADepreciationBook) <> FORMAT(FADepreciationBookOld));
//    end;
//Local procedure LoadDepreciationBooks();
//    begin
//      CLEAR(FADepreciationBookOld);
//      FADepreciationBookOld.SETRANGE("FA No.",rec."No.");
//      if ( FADepreciationBookOld.COUNT <= 1  )then begin
//        if ( FADepreciationBookOld.FINDFIRST  )then begin
//          FADepreciationBookOld.CALCFIELDS("Book Value");
//          ShowAddMoreDeprBooksLbl := TRUE
//        end;
//        Simple := TRUE;
//      end ELSE
//        Simple := FALSE;
//    end;
//Local procedure SetNoFieldVisible();
//    var
//      DocumentNoVisibility : Codeunit 1400;
//    begin
//      NoFieldVisible := DocumentNoVisibility.FixedAssetNoIsVisible;
//    end;
//Local procedure GetBookValue() : Decimal;
//    begin
//      if ( FADepreciationBook."Disposal Date" > 0D  )then
//        exit(0);
//      exit(FADepreciationBook."Book Value");
//    end;

//procedure
}

