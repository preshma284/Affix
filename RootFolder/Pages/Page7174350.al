page 7174350 "DP Setup"
{
  ApplicationArea=All;

CaptionML=ENU='Non Deductible VAT Setup',ESP='Configuraci¢n IVA no deducible';
    SourceTable=7174350;
    PageType=Card;
    
  layout
{
area(content)
{
group("group4")
{
        
                CaptionML=ESP='General';
group("group5")
{
        
                CaptionML=ESP='Versi¢n';
    field("QBGlobalConf.DP Version";QBGlobalConf."DP Version")
    {
        
                CaptionML=ESP='Versi¢n';
                Editable=false;
                
                          ;trigger OnLookup(var Text: Text): Boolean    BEGIN
                           CLEAR(QBVersionChanges);
                           QBVersionChanges.SetProduct('Prorrata IVA');
                           QBVersionChanges.RUNMODAL;
                         END;


    }

}
group("group7")
{
        
                CaptionML=ESP='Prorrata';
    field("DP Use Prorrata";rec."DP Use Prorrata")
    {
        
                Enabled=edProrrata;
                
                            ;trigger OnValidate()    BEGIN
                             SetEditables;
                           END;


    }
    field("DP Dimension Associated";rec."DP Dimension Associated")
    {
        
                Enabled=seeProrrata;
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


    }

}
group("group10")
{
        
                CaptionML=ESP='IVA no Deducible';
    field("DP Use Non Deductible";rec."DP Use Non Deductible")
    {
        
                Editable=edNonDeductible;
                
                            ;trigger OnValidate()    BEGIN
                             SetEditables;
                           END;


    }

}

}
    part("part1";7174351)
    {
        
                Visible=seeProrrata;
    }

}
}actions
{
area(Processing)
{

    action("Dimension")
    {
        
                      CaptionML=ESP='Dimensi¢n Asociada';
                      RunObject=Page 537;
RunPageLink="Dimension Code"=FIELD("DP Dimension Associated");
                      Promoted=true;
                      Enabled=seeDimension;
                      PromotedIsBig=true;
                      Image=DefaultDimension;
                      PromotedCategory=Process 
    ;
    }

}
}
  trigger OnOpenPage()    BEGIN
                 IF NOT Rec.GET() THEN BEGIN
                   Rec.INIT;
                   Rec.INSERT;
                 END;

                 //Conf. Global
                 QBGlobalConf.GetGlobalConf('');
               END;

trigger OnAfterGetRecord()    BEGIN
                       SetEditables;
                     END;



    var
      edProrrata : Boolean;
      edNonDeductible : Boolean;
      seeProrrata : Boolean;
      seeDimension : Boolean;
      QBGlobalConf : Record 7206985;
      rQBVersionChanges : Record 7206921;
      QBVersionChanges : Page 7207301;

    

LOCAL procedure SetEditables();
    begin
      edProrrata      := (not rec."DP Use Non Deductible");
      edNonDeductible := (not rec."DP Use Prorrata");
      seeProrrata     := (Rec."DP Use Prorrata");
      seeDimension    := (Rec."DP Dimension Associated" <> '');
    end;

    // begin
    /*{
      JAV 21/06/22: - DP 1.00.00 Nueva p gina para el manejo de las prorratas. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
      JAV 14/07/22: - DP 1.00.04 Se cambia el caption del campo 10 y se a¤ade el 20 para el IVA no deducible general
    }*///end
}









