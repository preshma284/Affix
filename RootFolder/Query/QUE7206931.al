query 50115 "QB BI Certificaciones"
{
  
  
  elements
{

DataItem("Post_Certifications";"Post. Certifications")
{

               DataItemTableFilter="Cancel No."=FILTER(''),
                                   "Cancel By"=FILTER('');
Column("No";"No.")
{

}Column("PostingDate";"Posting Date")
{

}Column("MeasurementDate";"Measurement Date")
{

}DataItem("Hist_Certification_Lines";"Hist. Certification Lines")
{

DataItemLink="Document No."= "Post_Certifications"."No.";
Column("LineNo";"Line No.")
{

}Column("PieceworkNo";"Piecework No.")
{

}Column("Description";"Description")
{

}Column("Description2";"Description 2")
{

}Column("TermContractAmount";"Term Contract Amount")
{

}Column("ShortcutDimension1Code";"Shortcut Dimension 1 Code")
{

}Column("ShortcutDimension2Code";"Shortcut Dimension 2 Code")
{

}Column("CurrencyCode";"Currency Code")
{

}Column("ContractPrice";"Contract Price")
{

}Column("JobNo";"Job No.")
{

}Column("SalePrice";"Sale Price")
{

}Column("DimensionSetID";"Dimension Set ID")
{

}Column("AdjustmentRedetermPrices";"Adjustment Redeterm. Prices")
{

}Column("MeasurementAdjustment";"Measurement Adjustment")
{

}Column("PreviousRedeterminedPrice";"Previous Redetermined Price")
{

}Column("LastPriceRedetermined";"Last Price Redetermined")
{

}Column("CertificationType";"Certification Type")
{

}Column("CertificationDate";"Certification Date")
{

}Column("OLD_MeasurementNo";"OLD_Measurement No.")
{

}Column("CertifQuantityNotInv";"Certif. Quantity Not Inv.")
{

}Column("InvoicedQuantity";"Invoiced Quantity")
{

}Column("InvoicedCertif";"Invoiced Certif.")
{

}Column("CustomerNo";"Customer No.")
{

}Column("CodePieceworkPRESTO";"Code Piecework PRESTO")
{

}Column("CerttoCertificate";"Cert % to Certificate")
{

}Column("CertQuantitytoTerm";"Cert Quantity to Term")
{

}Column("CertQuantitytoOrigin";"Cert Quantity to Origin")
{

}Column("CertTermPEMamount";"Cert Term PEM amount")
{

}Column("CertTermPECamount";"Cert Term PEC amount")
{

}Column("CertTermREDamount";"Cert Term RED amount")
{

}Column("CertSourcePEMamount";"Cert Source PEM amount")
{

}Column("CertSourcePECamount";"Cert Source PEC amount")
{

}Column("CertSourceREDamount";"Cert Source RED amount")
{

}
}
}
}
  

    /*begin
    end.
  */
}








