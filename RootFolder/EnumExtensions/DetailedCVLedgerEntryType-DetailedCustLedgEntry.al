

// value(0; "") { Caption = ''; }
// value(1; "Initial Entry") { Caption = 'Initial Entry'; }
// value(2; "Application") { Caption = 'Application'; }
// value(3; "Unrealized Loss") { Caption = 'Unrealized Loss'; }
// value(4; "Unrealized Gain") { Caption = 'Unrealized Gain'; }
// value(5; "Realized Loss") { Caption = 'Realized Loss'; }
// value(6; "Realized Gain") { Caption = 'Realized Gain'; }
// value(7; "Payment Discount") { Caption = 'Payment Discount'; }
// value(8; "Payment Discount (VAT Excl.)") { Caption = 'Payment Discount (VAT Excl.)'; }
// value(9; "Payment Discount (VAT Adjustment)") { Caption = 'Payment Discount (VAT Adjustment)'; }
// value(10; "Appln. Rounding") { Caption = 'Appln. Rounding'; }
// value(11; "Correction of Remaining Amount") { Caption = 'Correction of Remaining Amount'; }
// value(12; "Payment Tolerance") { Caption = 'Payment Tolerance'; }
// value(13; "Payment Discount Tolerance") { Caption = 'Payment Discount Tolerance'; }
// value(14; "Payment Tolerance (VAT Excl.)") { Caption = 'Payment Tolerance (VAT Excl.)'; }
// value(15; "Payment Tolerance (VAT Adjustment)") { Caption = 'Payment Tolerance (VAT Adjustment)'; }
// value(16; "Payment Discount Tolerance (VAT Excl.)") { Caption = 'Payment Discount Tolerance (VAT Excl.)'; }
// value(17; "Payment Discount Tolerance (VAT Adjustment)") { Caption = 'Payment Discount Tolerance (VAT Adjustment)'; }


//OptionString=,Initial Entry,Application,Unrealized Loss,Unrealized Gain,Realized Loss,
// Realized Gain,Payment Discount,Payment Discount (VAT Excl.),Payment Discount (VAT Adjustment),
// Appln. Rounding,Correction of Remaining Amount,Payment Tolerance,Payment Discount Tolerance,
// Payment Tolerance (VAT Excl.),Payment Tolerance (VAT Adjustment),Payment Discount Tolerance (VAT Excl.),
// Payment Discount Tolerance (VAT Adjustment),,,,Rejection,Redrawal,Expenses }

enumextension 50104 "DetailedCVLedgerEntryTypeEnum" extends "Detailed CV Ledger Entry Type"
{
    value(18; "Settlement") { Caption = 'Settlement'; }

    value(24; " ") { Caption = ' '; }
    // value(100; "Rejection") { Caption = 'Rejection'; }
    // value(101; "Redrawal") { Caption = 'Redrawal'; }
    // value(102; "Expenses") { Caption = 'Expenses'; }
}

