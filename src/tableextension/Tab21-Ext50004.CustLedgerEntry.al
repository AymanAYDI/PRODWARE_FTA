namespace Prodware.FTA;

using Microsoft.Sales.Receivables;
using Microsoft.CRM.Team;
using Microsoft.Foundation.PaymentTerms;
using Microsoft.Bank.BankAccount;
using Microsoft.Sales.Customer;
tableextension 50004 CustLedgerEntry extends "Cust. Ledger Entry" //21
{
    fields
    {
        field(50000; CPFLG1; Text[1])
        {
            Caption = 'Lettrage ORION';
            Description = 'FTA1.00';
        }
        field(50029; "Mobile Salesperson Code"; Code[10])
        {
            Caption = 'Mobile Salesperson Code';
            Description = 'FTA1.04';
            TableRelation = "Salesperson/Purchaser";

        }
        field(51000; "Payment Method Code2"; Code[10])
        {
            Caption = 'Payment Method Code';
            Description = 'REGLEMENT 01.08.2006 COR001 [13]';
            TableRelation = "Payment Method";
        }
        field(51001; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            Description = 'REGLEMENT 01.08.2006 COR001 [13]';
            TableRelation = "Payment Terms";
        }
    }
    keys
    {

        key(Key3; "Document No.", "Document Type", "Customer No.")
        {
        }

    }


    //Unsupported feature: Code Modification on "CopyFromGenJnlLine(PROCEDURE 6)".

    //procedure CopyFromGenJnlLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Customer No." := GenJnlLine."Account No.";
    "Posting Date" := GenJnlLine."Posting Date";
    "Document Date" := GenJnlLine."Document Date";
    "Document Type" := GenJnlLine."Document Type";
    "Document No." := GenJnlLine."Document No.";
    "External Document No." := GenJnlLine."External Document No.";
    Description := GenJnlLine.Description;
    "Currency Code" := GenJnlLine."Currency Code";
    "Sales (LCY)" := GenJnlLine."Sales/Purch. (LCY)";
    "Profit (LCY)" := GenJnlLine."Profit (LCY)";
    "Inv. Discount (LCY)" := GenJnlLine."Inv. Discount (LCY)";
    "Sell-to Customer No." := GenJnlLine."Sell-to/Buy-from No.";
    "Customer Posting Group" := GenJnlLine."Posting Group";
    "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
    "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
    "Dimension Set ID" := GenJnlLine."Dimension Set ID";
    "Salesperson Code" := GenJnlLine."Salespers./Purch. Code";
    "Source Code" := GenJnlLine."Source Code";
    "On Hold" := GenJnlLine."On Hold";
    "Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
    "Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
    "Due Date" := GenJnlLine."Due Date";
    "Pmt. Discount Date" := GenJnlLine."Pmt. Discount Date";
    "Applies-to ID" := GenJnlLine."Applies-to ID";
    "Journal Batch Name" := GenJnlLine."Journal Batch Name";
    "Reason Code" := GenJnlLine."Reason Code";
    "Direct Debit Mandate ID" := GenJnlLine."Direct Debit Mandate ID";
    "User ID" := USERID;
    "Bal. Account Type" := GenJnlLine."Bal. Account Type";
    "Bal. Account No." := GenJnlLine."Bal. Account No.";
    "No. Series" := GenJnlLine."Posting No. Series";
    "IC Partner Code" := GenJnlLine."IC Partner Code";
    Prepayment := GenJnlLine.Prepayment;
    "Recipient Bank Account" := GenJnlLine."Recipient Bank Account";
    "Message to Recipient" := GenJnlLine."Message to Recipient";
    "Applies-to Ext. Doc. No." := GenJnlLine."Applies-to Ext. Doc. No.";
    "Payment Method Code" := GenJnlLine."Payment Method Code";
    "Exported to Payment File" := GenJnlLine."Exported to Payment File";
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..17

    //>>FTA1.04
    "Mobile Salesperson Code" := GenJnlLine."Mobile Salesperson Code";
    //<<FTA1.04

    #18..38
    */
    //end;


    procedure getCustomerName(CodLCustNo: Code[20]): Text[50]
    var
        RecgLCustomer: Record Customer;
    begin
        IF RecgLCustomer.GET(CodLCustNo) THEN
            EXIT(RecgLCustomer.Name)
        ELSE
            EXIT('');
    end;
}

