
namespace Prodware.FTA;

using Microsoft.Purchases.Payables;
reportextension 50011 "SuggestVendorPayments" extends "Suggest Vendor Payments" //393
{
    dataset
    {

    }

    PROCEDURE GetVendLedgEntries2(Positive: Boolean; Future: Boolean);
    BEGIN
        VendLedgEntry.RESET;

        //VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Vendor Posting Group", "Due Date");

        VendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        VendLedgEntry.SETRANGE(Open, TRUE);
        VendLedgEntry.SETRANGE(Positive, Positive);
        VendLedgEntry.SETRANGE("Applies-to ID", '');
        //>>NAVEASY.001 [Multi_Collectif]
        VendLedgEntry.SETFILTER(VendLedgEntry."Applies-to ID", '%1', '');
        //<<NAVEASY.001 [Multi_Collectif]
        IF Future THEN BEGIN
            VendLedgEntry.SETRANGE("Due Date", LastDueDateToPayReq + 1, 31129999D);
            VendLedgEntry.SETRANGE("Pmt. Discount Date", PostingDate, LastDueDateToPayReq);
            VendLedgEntry.SETFILTER("Remaining Pmt. Disc. Possible", '<>0');
        END ELSE
            VendLedgEntry.SETRANGE("Due Date", 0D, LastDueDateToPayReq);
        IF SkipExportedPayments THEN
            VendLedgEntry.SETRANGE("Exported to Payment File", FALSE);
        VendLedgEntry.SETRANGE("On Hold", '');
        VendLedgEntry.SETFILTER("Currency Code", Vendor.GETFILTER("Currency Filter"));
        VendLedgEntry.SETFILTER("Global Dimension 1 Code", Vendor.GETFILTER("Global Dimension 1 Filter"));
        VendLedgEntry.SETFILTER("Global Dimension 2 Code", Vendor.GETFILTER("Global Dimension 2 Filter"));

        IF VendLedgEntry.FIND('-') THEN
            REPEAT
                SaveAmount;
                IF VendLedgEntry."Accepted Pmt. Disc. Tolerance" OR
                   (VendLedgEntry."Accepted Payment Tolerance" <> 0)
                THEN BEGIN
                    VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
                    VendLedgEntry."Accepted Payment Tolerance" := 0;
                    VendEntryEdit.RUN(VendLedgEntry);
                END;
            UNTIL VendLedgEntry.NEXT = 0;
    END;


}
