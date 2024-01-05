codeunit 99004 "FTA1.04"
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // FTA1.04
    // >>Customer Typology
    // Add a field "Customer Typology" to the Customer Table and Sales Header.
    // The field has to be visible and modifiable on the Customer Page and the Sales Quote Page (Header).
    // The field is linked to a look up table.
    // 
    // >>Mobile Salesperson Code
    // Add Field "Code commercial itinérant" to Customer Table, Sales Documents, Customer Ledger Entries,
    // Value Entries in the same way as Salesperson Code.
    // Add the field to Pages and Codeunits, but not Reports. Maybe Batch Jobs.
    // 
    // Type ID Name
    // T 18 Customer
    // T 21 Cust. Ledger Entry
    // T 36 Sales Header
    // T 81 Gen. Journal Line
    // T 83 Item Journal Line
    // T 110 Sales Shipment Header
    // T 112 Sales Invoice Header
    // T 114 Sales Cr.Memo Header
    // T 281 Phys. Inventory Ledger Entry
    // T 751 Standard General Journal Line
    // T 5107 Sales Header Archive
    // T 5802 Value Entry
    // T 6660 Return Receipt Header
    // T 50021 Customer Typology
    // R 295 Combine Shipments
    // C 1 ApplicationManagement
    // C 22 Item Jnl.-Post Line
    // C 80 Sales-Post
    // C 442 Sales-Post Prepayments
    // C 5063 ArchiveManagement
    // C 5817 Undo Posting Management
    // C 5895 Inventory Adjustment
    // C 99004 FTA1.04
    // P 21 Customer Card
    // P 22 Customer List
    // P 25 Customer Ledger Entries
    // P 41 Sales Quote
    // P 42 Sales Order
    // P 43 Sales Invoice
    // P 44 Sales Credit Memo
    // P 45 Sales List
    // P 61 Applied Customer Entries
    // P 130 Posted Sales Shipment
    // P 132 Posted Sales Invoice
    // P 134 Posted Sales Credit Memo
    // P 143 Posted Sales Invoices
    // P 144 Posted Sales Credit Memos
    // P 507 Blanket Sales Order
    // P 5159 Sales Order Archive
    // P 5161 Sales List Archive
    // P 5162 Sales Quote Archive
    // P 5802 Value Entries
    // P 9300 Sales Quotes
    // P 9301 Sales Invoice List
    // P 9302 Sales Credit Memos
    // P 9303 Blanket Sales Orders
    // P 9304 Sales Return Order List
    // P 9305 Sales Order List
    // P 9348 Sales Quote Archives
    // P 9349 Sales Order Archives
    // P 50021 Customer Typology List


    trigger OnRun()
    begin
    end;
}

