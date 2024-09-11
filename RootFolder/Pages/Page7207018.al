page 7207018 "QB_IRPF Transference Format"
{
  ApplicationArea=All;

CaptionML=ESP='Formato Transferencia IRPF';
    SaveValues=true;
    MultipleNewLines=true;
    SourceTable=7206979;
    PageType=Worksheet;
    
  layout
{
area(content)
{
group("group4")
{
        
    field("FilterName";FilterName)
    {
        
                CaptionML=ESP='Nombre';
                
                          ;trigger OnLookup(var Text: Text): Boolean    VAR
                           IRPFStatementNames : Record 7206978;
                           pgIRPFStatementNames : Page 7207017;
                         BEGIN
                           CLEAR(pgIRPFStatementNames);
                           IRPFStatementNames.RESET();
                           //IRPFStatementNames.SETFILTER(QB_Declaration, FilterName);
                           pgIRPFStatementNames.LOOKUPMODE(TRUE);
                           pgIRPFStatementNames.SETTABLEVIEW(IRPFStatementNames);
                           IF pgIRPFStatementNames.RUNMODAL = ACTION::LookupOK THEN
                             BEGIN
                               pgIRPFStatementNames.GETRECORD(IRPFStatementNames);
                               FilterName := IRPFStatementNames.QB_Declaration;
                               OnAfterValidateFilterName();
                             END;
                         END;


    }

}
repeater("table")
{
        
    field("QB_IRPF Declaration";rec."QB_IRPF Declaration")
    {
        
    }
    field("QB_No.";rec."QB_No.")
    {
        
    }
    field("QB_Withholding Filter";rec."QB_Withholding Filter")
    {
        
                
                          ;trigger OnLookup(var Text: Text): Boolean    VAR
                           WithholdingGroup : Record 7207330;
                           LstWithholdingGroup : Page 7207401;
                         BEGIN
                           //CEI-15408-LCG-051021-INI
                           CLEAR(LstWithholdingGroup);
                           WithholdingGroup.RESET();
                           LstWithholdingGroup.SETTABLEVIEW(WithholdingGroup);
                           LstWithholdingGroup.SetParameters(TRUE,rec."QB_IRPF Declaration", rec."QB_No.");
                           LstWithholdingGroup.LOOKUPMODE(TRUE);
                           IF LstWithholdingGroup.RUNMODAL  IN [ACTION::LookupOK, ACTION::OK] THEN;
                             //CurrPage.UPDATE(FALSE);
                           //CEI-15408-LCG-051021-FIN
                         END;


    }
    field("QB_Position";rec."QB_Position")
    {
        
    }
    field("QB_Length";rec."QB_Length")
    {
        
    }
    field("QB_Withholding Field";rec."QB_Withholding Field")
    {
        
    }
    field("QB_IRPF Withh. Type Filter";rec."QB_IRPF Withh. Type Filter")
    {
        
    }
    field("QB_Application Type";rec."QB_Application Type")
    {
        
    }
    field("QB_Type";rec."QB_Type")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             CASE rec.QB_Type OF
                               Rec.QB_Type::Alphanumerical:
                                 BEGIN

                                 END;
                             END;
                           END;


    }
    field("QB_Subtype";rec."QB_Subtype")
    {
        
    }
    field("QB_Row Totaling";rec."QB_Row Totaling")
    {
        
                
                          ;trigger OnLookup(var Text: Text): Boolean    VAR
                           IRPFVATStatementLine : Record 7206979;
                           "pgIRPF Transference Format" : Page 7207018;
                         BEGIN
                           //CEI-15408-LCG-051021-INI
                           IF rec.QB_Type <> rec.QB_Type::"Row Totaling" THEN
                             EXIT;
                           CLEAR("pgIRPF Transference Format");
                           IRPFVATStatementLine.RESET();
                           IRPFVATStatementLine.SETRANGE("QB_IRPF Declaration", Rec."QB_IRPF Declaration");
                           //QRE-15408-LCG-181021-INI
                           //IRPFVATStatementLine.SETFILTER(QB_Type,'%1|%2',IRPFVATStatementLine.QB_Type::Numerical,IRPFVATStatementLine.QB_Type::Ask);
                           IRPFVATStatementLine.SETFILTER("QB_No.",'<>%1', Rec."QB_No.");
                           IRPFVATStatementLine.SETFILTER(QB_Subtype,'<>%1',0);
                           //QRE-15408-LCG-181021-FIN
                           "pgIRPF Transference Format".SETTABLEVIEW(IRPFVATStatementLine);
                            "pgIRPF Transference Format".SetParameters(TRUE,rec."QB_IRPF Declaration", rec."QB_No.");
                           "pgIRPF Transference Format".LOOKUPMODE(TRUE);
                           IF "pgIRPF Transference Format".RUNMODAL  IN [ACTION::LookupOK, ACTION::OK] THEN
                             CurrPage.UPDATE();
                           //CEI-15408-LCG-051021-FIN
                         END;


    }
    field("QB_Description";rec."QB_Description")
    {
        
    }
    field("QB_Print";rec."QB_Print")
    {
        
    }
    field("QB_Print with";rec."QB_Print with")
    {
        
    }
    field("QB_Value";rec."QB_Value")
    {
        
    }

}

}
}actions
{
area(Processing)
{

    action("Generate TXT File")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='Generate txt file',ESP='Generar archivo txt';
                      ToolTipML=ENU='Create a text file for the selected VAT declaration according to the transference format template defined for the VAT declaration. A window will show all the lines in the template where the Ask check box was selected, so that you can Rec.INSERT or Rec.MODIFY the content of the values to be included in the file for these elements.',ESP='Permite crear un archivo de texto para la declaraci�n de IVA seleccionada seg�n la plantilla de formato transferencia definida para la declaraci�n de IVA. Aparecer� una ventana con todas las l�neas de la plantilla en las que se activ� la casilla Preguntar, para que pueda insertar o modificar el contenido de los valores que desea incluir en el archivo para estos elementos.';
                      ApplicationArea=Basic,Suite;
                      Image=CreateDocument;
                      
                                
    trigger OnAction()    VAR
                                //  GenerateTXTFile : Report 7207397;
                               BEGIN
                                 //QRE+
                                //  GenerateTXTFile.RUNMODAL;
                                //  CLEAR(GenerateTXTFile);
                                 //QRE-
                               END;


    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Generate TXT File_Promoted"; "Generate TXT File")
                {
                }
            }
        }
}
  
trigger OnOpenPage()    BEGIN
                 GetFirstName();
               END;

trigger OnQueryClosePage(CloseAction: Action): Boolean    VAR
                       IRPFVATStatementLine : Record 7206979;
                       vFilter : Text[250];
                     BEGIN
                       //CEI-15408-LCG-051021-INI
                       IF FromIRPF THEN
                         IF CloseAction = ACTION::LookupOK THEN
                           BEGIN
                             IRPFVATStatementLine.RESET();
                             CurrPage.SETSELECTIONFILTER(IRPFVATStatementLine);
                             IF IRPFVATStatementLine.FINDSET THEN
                               REPEAT
                                 vFilter += FORMAT(IRPFVATStatementLine."QB_No.") +  '|';
                               UNTIL IRPFVATStatementLine.NEXT = 0;

                               IF (vFilter <> '') AND (vFilter <> '|') THEN
                                 BEGIN

                                   IRPFVATStatementLine.RESET;
                                   IF IRPFVATStatementLine.GET(Declaration,No) THEN
                                     BEGIN
                                       IRPFVATStatementLine."QB_Row Totaling":= COPYSTR(vFilter,1,STRLEN(vFilter)-1);
                                       WithholdingTreating.CalculateSumOfLines(IRPFVATStatementLine);
                                       IRPFVATStatementLine.MODIFY;
                                     END;
                                 END;
                           END;
                       //CEI-15408-LCG-051021-FIN
                     END;



    var
      WithholdingTreating : Codeunit 7207306;
      FilterName : Code[10];
      FromIRPF : Boolean;
      Declaration : Code[20];
      No : Integer;
      dec : Decimal;

    LOCAL procedure GetFirstName();
    var
      IRPFStatatementNames : Record 7206978;
    begin
      IRPFStatatementNames.RESET();
      if IRPFStatatementNames.FINDFIRST then
        begin
          FilterName := IRPFStatatementNames.QB_Declaration;
          OnAfterValidateFilterName();
        end;
    end;

    LOCAL procedure OnAfterValidateFilterName();
    begin
      Rec.FILTERGROUP(2);
      Rec.SETRANGE("QB_IRPF Declaration",FilterName);
      Rec.FILTERGROUP(0);
      if Rec.FINDSET() then;
      CurrPage.UPDATE(FALSE);
    end;

    procedure SetParameters(fIrpf : Boolean;pDeclaration : Code[10];pNo : Integer);
    begin
      FromIRPF := fIrpf;
      Declaration := pDeclaration;
      No := pNo;
    end;

    // begin
    /*{
      CEI-15408-LCG-051021- Crear page y a�adir campos
      CEI-15408-LCG-051021- Abrir page Withholding group para concatenar c�digos retenci�n.
      QRE-15408-LCG-181021- Me comentan que filtre por Subtipo distinto de 0.
    }*///end
}








