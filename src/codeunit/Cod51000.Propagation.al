codeunit 51000 Propagation
{
    trigger OnRun()
    begin
    end;


    procedure "PurchQuoteHead->PurchOrderHead"(PurchQuoteHeader: Record "Purchase Header"; PurchOrderHeader: Record "Purchase Header")
    begin
    end;


    procedure "GenJournalLine->CustLedgEntry"(RecGenJournalLine: Record "Gen. Journal Line"; var RecCustLedgerEntry: Record "Cust. Ledger Entry")
    begin
    end;


    procedure "GenJournalLine->DCustLedgEntry"(RecGenJournalLine: Record "Gen. Journal Line"; var RecDCustLedgerEntry: Record "Detailed Cust. Ledg. Entry")
    begin
    end;


    procedure "GenJnlLine->DCustLedgEntryBuf"(RecGenJournalLine: Record "Gen. Journal Line"; var RecDCVLedgerEntry: Record "Detailed CV Ledg. Entry Buffer")
    begin
        RecDCVLedgerEntry."Payment Method Code" := RecGenJournalLine."Payment Method Code";
    end;


    procedure "GenJournalLine->InvPostBuffer"(RecGenJournalLine: Record "Gen. Journal Line"; var RecInvPostBuffer: array[2] of Record "Invoice Post. Buffer" temporary)
    begin
    end;


    procedure "Customer->SalesHeader"(RecCustomer: Record "Customer"; var RecSalesHeader: Record "Sales Header")
    begin
    end;


    procedure "Customer->GenJournalLine"(RecCustomer: Record "Customer"; var RecGenJnlLine: Record "Gen. Journal Line")
    begin
    end;


    procedure "Item->SalesLine"(RecItem: Record Item; var RecSalesLine: Record "Sales Line")
    begin
    end;


    procedure "Item->ItemJnlLine"(RecItem: Record Item; var RecItemJnlLine: Record "Item Journal Line")
    begin
    end;


    procedure "Item->ServInvLine"(RecItem: Record Item; var RecServInvLine: Record "Service Line")
    begin
    end;


    procedure "SalesHeader->GenJournalLine"(RecSalesHeader: Record "Sales Header"; var RecGenJournalLine: Record "Gen. Journal Line")
    begin
    end;


    procedure "SalesHeader->SalesLine"(RecSalesHeader: Record "Sales Header"; var RecSalesLine: Record "Sales Line")
    begin
    end;


    procedure "SalesLine->ItemJournalLine"(RecSalesLine: Record "Sales Line"; var RecItemJnlLine: Record "Item Journal Line")
    begin
    end;


    procedure "ItemJournalLine->ItemLedgEntry"(RecItemJnlLine: Record "Item Journal Line"; var RecItemLedgerEntry: Record "Item Ledger Entry")
    begin
    end;


    procedure "ItemJournalLine->ValueEntry"(RecItemJnlLine: Record "Item Journal Line"; var RecValueEntry: Record "Value Entry")
    begin
    end;


    procedure "Item->ServiceItem"(RecItem: Record Item; var RecServItem: Record "Service Item")
    begin
    end;


    procedure "ServiceItem->ServiceItemLine"(RecServItem: Record "Service Item"; var RecServItemLine: Record "Service Item Line")
    begin
    end;


    procedure "ServiceLine->ServLedgEntry"(RecServInvLine: Record "Service Line"; var RecServLedgerEntry: Record "Service Ledger Entry")
    begin
    end;


    procedure "ServiceHeader->ServiceLine"(RecServHeader: Record "Service Header"; var RecServInvoice: Record "Service Line")
    begin
    end;


    procedure "ServiceLine->SalesLine"(RecServiceInvoice: Record "Service Line"; var RecSalesLine: Record "Sales Line")
    begin
    end;


    procedure "Contact->ServItem"(RecContact: Record Contact; var RecServItem: Record "Service Item")
    begin
    end;


    procedure "PaymentClass->PaymentHeader"(RecPaymentClass: Record "Payment Class"; var RecPaymentHeader: Record "Payment Header")
    begin
    end;


    procedure "PaymentHeader->PaymentLine"(RecPaymentHeader: Record "Payment Header"; var RecPaymentLine: Record "Payment Line")
    begin
    end;


    procedure "VendBankAccount->PaymentLine"(RecVendBankAcc: Record "Vendor Bank Account"; var RecPaymentLine: Record "Payment Line")
    begin
    end;
}

