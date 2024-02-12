namespace Prodware.FTA;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Ledger;
using Microsoft.Purchases.Vendor;
using System.IO;
using Microsoft.Foundation.Period;
using Microsoft.Inventory.BOM;
using System.Utilities;
report 50013 "Customer Sales ConsumptionAss"
{

    Caption = 'Customer Item Sales And Consumption';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.")
                                order(ascending);
            RequestFilterFields = "No.", Description, "Description 2", "Item Base", Blocked, "Vendor No.";
            dataitem(PurchEntry; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = field("No.");
                DataItemTableView = sorting("Source Type", "Source No.", "Item No.", "Variant Code", "Posting Date")
                                    where("Source Type" = filter(Vendor));

                trigger OnAfterGetRecord()
                begin
                    if not BooGViewPurchases then
                        CurrReport.Skip();
                    if TestItem("Item No.") then begin
                        AddBuffer(ValueEntryBufferPurch, NextEntryNo, "Item No.", Quantity, StartingDate);
                        for i := 1 to 12 do
                            if ("Posting Date" >= PeriodStartingDate[i]) and
                               ("Posting Date" <= PeriodEndingDate[i]) then
                                AddBuffer(ValueEntryBuffer2Purch, NextEntryNo2, "Item No.", Quantity, PeriodStartingDate[i]);
                    end;

                end;

                trigger OnPreDataItem()
                begin
                    PurchEntry.SetRange("Posting Date", StartingDate, EndingDate);
                end;
            }

            trigger OnPostDataItem()
            begin
                ValueEntryBufferPurch.Reset();
                ValueEntryBuffer2Purch.Reset();
                if ValueEntryBufferPurch.findFirst() then
                    repeat
                        if PrintToExcel and Item.Get(ValueEntryBufferPurch."Item No.") then begin
                            if Vendor.Get(Item."Vendor No.") then;
                            MakeExcelDataBodyForPurch();
                        end;
                    until ValueEntryBufferPurch.Next() = 0;
            end;

            trigger OnPreDataItem()
            begin
                //Message(ItemFilterTxt);
            end;
        }
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group";
            dataitem(SalesEntry; "Item Ledger Entry")
            {
                DataItemLink = "Source No." = field("No."),
                               "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                               "Global Dimension 2 Code" = field("Global Dimension 2 Filter");
                DataItemTableView = sorting("Source Type", "Source No.", "Item No.", "Variant Code", "Posting Date")
                                    where("Source Type" = const(Customer));

                trigger OnAfterGetRecord()
                begin
                    if TestItem("Item No.") then begin
                        AddBuffer(ValueEntryBuffer, NextEntryNo, "Item No.", Quantity, StartingDate);
                        for i := 1 to 12 do
                            if ("Posting Date" >= PeriodStartingDate[i]) and
                               ("Posting Date" <= PeriodEndingDate[i]) then
                                AddBuffer(ValueEntryBuffer2, NextEntryNo2, "Item No.", Quantity, PeriodStartingDate[i]);
                    end;
                    if "Assemble to Order" then begin
                        AssEntry.Get(SalesEntry."Applies-to Entry");
                        ConsumptionAssEntry.SetCurrentKey("Document Type", "Document No.", "Order Line No.", "Entry Type");
                        ConsumptionAssEntry.SetRange("Document Type", AssEntry."Document Type");
                        ConsumptionAssEntry.SetRange("Document No.", AssEntry."Document No.");
                        ConsumptionAssEntry.SetRange("Order Type", AssEntry."Order Type");
                        ConsumptionAssEntry.SetRange("Order No.", AssEntry."Order No.");
                        ConsumptionAssEntry.SetFilter("Entry Type", '%1', "Entry Type"::"Assembly Consumption");
                        ConsumptionAssEntry.SetRange(Positive, false);
                        if ConsumptionAssEntry.FindSet() then
                            repeat
                                if TestItem(ConsumptionAssEntry."Item No.") then begin
                                    AddBuffer(ValueEntryBuffer, NextEntryNo, ConsumptionAssEntry."Item No.", ConsumptionAssEntry.Quantity, StartingDate);
                                    for i := 1 to 12 do
                                        if ("Posting Date" >= PeriodStartingDate[i]) and
                                           ("Posting Date" <= PeriodEndingDate[i]) then
                                            AddBuffer(ValueEntryBuffer2, NextEntryNo2, ConsumptionAssEntry."Item No.", ConsumptionAssEntry.Quantity, PeriodStartingDate[i]);
                                end;
                            until ConsumptionAssEntry.Next() = 0;
                    end;
                end;

                trigger OnPostDataItem()
                begin

                    if ByCust then begin
                        ValueEntryBuffer.Reset();
                        ValueEntryBuffer2.Reset();
                        if ValueEntryBuffer.findFirst() then
                            repeat
                                if PrintToExcel and Item.Get(ValueEntryBuffer."Item No.") then begin
                                    if Vendor.Get(Item."Vendor No.") then;
                                    MakeExcelDataBody();
                                end;
                            until ValueEntryBuffer.Next() = 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SalesEntry.SetRange("Posting Date", StartingDate, EndingDate);

                    if ByCust then begin
                        ValueEntryBuffer.Reset();
                        ValueEntryBuffer.DeleteALL();
                        NextEntryNo := 1;

                        ValueEntryBuffer2.Reset();
                        ValueEntryBuffer2.DeleteALL();
                        NextEntryNo2 := 1
                    end;
                end;
            }

            trigger OnPostDataItem()
            begin
                if not ByCust then begin
                    ValueEntryBuffer.Reset();
                    ValueEntryBuffer2.Reset();
                    if ValueEntryBuffer.findFirst() then
                        repeat
                            if PrintToExcel and Item.Get(ValueEntryBuffer."Item No.") then begin
                                if Vendor.Get(Item."Vendor No.") then;
                                MakeExcelDataBody();
                            end;
                        until ValueEntryBuffer.Next() = 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                ValueEntryBuffer.Reset();
                ValueEntryBuffer.DeleteALL();
                NextEntryNo := 1;

                ValueEntryBuffer2.Reset();
                ValueEntryBuffer2.DeleteALL();
                NextEntryNo2 := 1
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(EndingDate; EndingDate)
                    {
                        Caption = 'Ending Date';
                    }
                    field(ByCustomer; ByCust)
                    {
                        Caption = 'By Customer';
                    }
                    field(BooGViewPurchases; BooGViewPurchases)
                    {
                        Caption = 'View purchases';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            PrintToExcel := true;
            ByCust := true;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Window.Close();
        if PrintToExcel then
            CreateExcelbook();
    end;

    trigger OnPreReport()
    begin
        CustFilterTxt := Customer.GetFilters;
        ItemFilterTxt := Item.GetFilters;
        ItemLedgEntryFilterTxt := SalesEntry.GetFilters;

        CalcDates();
        SalesEntry.SetRange("Posting Date", StartingDate, EndingDate);
        PeriodText := SalesEntry.GetFilter("Posting Date");

        ItemFilterRec.Reset();
        ItemFilterRec.Copy(Item);

        Window.Open(Text100);
        if PrintToExcel then
            MakeExcelInfo();
    end;

    var
        AssEntry: Record "Item Ledger Entry";
        ConsumptionAssEntry: Record "Item Ledger Entry";
        ExcelBuf: Record "Excel Buffer" temporary;
        ItemFilterRec: Record Item;
        ValueEntryBuffer2: Record "Value Entry" temporary;
        ValueEntryBuffer2Purch: Record "Value Entry" temporary;
        ValueEntryBuffer: Record "Value Entry" temporary;
        ValueEntryBufferPurch: Record "Value Entry" temporary;
        Vendor: Record Vendor;
        Window: Dialog;
        BooGViewPurchases: Boolean;
        ByCust: Boolean;
        PrintToExcel: Boolean;
        EndingDate: Date;
        PeriodEndingDate: array[12] of Date;
        PeriodStartingDate: array[12] of Date;
        StartingDate: Date;
        i: Integer;
        NextEntryNo2: Integer;
        NextEntryNo: Integer;
        CustFilterTxt: Text;
        ItemFilterTxt: Text;
        ItemLedgEntryFilterTxt: Text;
        PeriodName: array[12] of Text;
        PeriodText: Text[30];
        Text001: Label 'Data';
        Text002: Label 'Customer/Item Sales And Consumptions';
        Text003: Label 'Company Name';
        Text004: Label 'Report No.';
        Text005: Label 'Report Name';
        Text006: Label 'User ID';
        Text007: Label 'Date';
        Text008: Label 'Customer Filters';
        Text009: Label 'Entry Filters';
        Text010: Label 'Quantity';
        Text011: Label 'Average Quantity';
        Text012: Label 'Ending Date';
        Text013: Label 'Item Filters';
        Text100: Label 'Analysis Sales And Consumption...';

    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet();
        ExcelBuf.AddInfoColumn(Format(Text003), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(COMPANYNAME, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(Format(Text005), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Format(Text002), false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(Format(Text004), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(report::"Customer Sales ConsumptionAss", false, false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(Format(Text006), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(UserId, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(Format(Text007), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(TODAY, false, false, false, false, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(Format(Text012), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(EndingDate, false, false, false, false, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(Format(Text008), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(CustFilterTxt, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(Format(Text013), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(ItemFilterTxt, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(Format(Text009), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(ItemLedgEntryFilterTxt, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.ClearNewRow();
        MakeExcelDataHeader();
    end;

    local procedure MakeExcelDataHeader()
    begin

        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(Customer.FieldCaption("No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.FieldCaption(Name), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ValueEntryBuffer.FieldCaption("Item No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption(Description), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Vendor No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Vendor.TABLECAPTION, false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        for i := 1 to 12 do
            ExcelBuf.AddColumn(Format(PeriodName[i]), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Text010, false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Text011, false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody()
    begin
        ExcelBuf.NewRow();
        if ByCust then begin
            ExcelBuf.AddColumn(Customer."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(Customer.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        end else begin
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        end;
        ExcelBuf.AddColumn(ValueEntryBuffer."Item No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.Description, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item."Vendor No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Vendor.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        for i := 1 to 12 do begin
            ValueEntryBuffer2.SetRange("Item No.", ValueEntryBuffer."Item No.");
            ValueEntryBuffer2.SetRange("Posting Date", PeriodStartingDate[i]);
            if ValueEntryBuffer2.findFirst() then
                ExcelBuf.AddColumn(-ValueEntryBuffer2."Invoiced Quantity", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number)
            else
                ExcelBuf.AddColumn(0, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        end;
        ExcelBuf.AddColumn(-ValueEntryBuffer."Invoiced Quantity", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-ValueEntryBuffer."Invoiced Quantity" / 12, false, '', false, false, false, '0.000', ExcelBuf."Cell Type"::Number);
    end;

    procedure CreateExcelbook()
    begin
        // ExcelBuf.CreateBookAndOpenExcel(Text001, Text002, Text005, COMPANYNAME, UserId);
        ExcelBuf.CreateNewBook('Customers');
        ExcelBuf.WriteSheet('Customers Details', COMPANYNAME, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
        Error('');
    end;

    procedure InitializeRequest(NewPagePerCustomer: Boolean; PrintToExcelFile: Boolean)
    begin
        PrintToExcel := PrintToExcelFile;
    end;

    local procedure AddBuffer(var FromValueEntryBuffer: Record "Value Entry" temporary; var FromNextEntryNo: Integer; ItemNo: Code[20]; Qty: Decimal; PostingDate: Date)
    begin
        FromValueEntryBuffer.SetRange("Item No.", ItemNo);
        FromValueEntryBuffer.SetRange("Posting Date", PostingDate);
        if not FromValueEntryBuffer.findFirst() then begin
            FromValueEntryBuffer.Init();
            FromValueEntryBuffer."Entry No." := FromNextEntryNo;
            FromValueEntryBuffer."Posting Date" := PostingDate;
            FromValueEntryBuffer."Item No." := ItemNo;
            FromValueEntryBuffer.Insert();
            FromNextEntryNo := FromNextEntryNo + 1;
        end;
        FromValueEntryBuffer."Invoiced Quantity" += Qty;
        FromValueEntryBuffer.Modify();
    end;

    local procedure CalcDates()
    var
        DateRec: Record Date;
        PeriodFormMngt: codeunit PeriodPageManagement;
        i: Integer;
        PeriodLength: Option Day,Week,Month,Quarter,Year;
    begin
        Clear(PeriodName);
        if (EndingDate <> 0D) then begin
            PeriodLength := PeriodLength::Month;
            DateRec.Reset();
            DateRec.SetRange("Period Type", PeriodLength);
            DateRec.SetFilter("Period Start", '..%1', EndingDate);
            DateRec.FindLast();
            StartingDate := DateRec."Period Start";
            for i := -12 to -1 do begin
                PeriodStartingDate[-i] := DateRec."Period Start";
                PeriodEndingDate[-i] := NormalDate(DateRec."Period End");
                PeriodName[-i] := PeriodFormMngt.CreatePeriodFormat(DateRec."Period Type", DateRec."Period Start");
                DateRec.Next(-1);
            end;
            StartingDate := PeriodStartingDate[1];
            EndingDate := PeriodEndingDate[12];
        end;
    end;

    local procedure TestItem(ItemNo: Code[20]): Boolean
    begin
        ItemFilterRec."No." := ItemNo;
        exit(ItemFilterRec.Find('='));
    end;

    local procedure Fct_IsBOMItem(CodPitem: Code[20]): Boolean
    var
        RecLItem: Record Item;
    begin
        if RecLItem.Get(CodPitem) then begin
            RecLItem.CalcFields(RecLItem."Assembly BOM");
            exit(RecLItem."Assembly BOM");
        end
        else
            exit(true);
    end;

    procedure MakeExcelDataBodyForPurch()
    begin
        ExcelBuf.NewRow();
        if ByCust then begin
            ExcelBuf.AddColumn('Réceptions', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('Réceptions de marchandise', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        end else begin
            ExcelBuf.AddColumn('Réceptions', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('Réceptions de marchandise', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        end;
        ExcelBuf.AddColumn(ValueEntryBufferPurch."Item No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.Description, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item."Vendor No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Vendor.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        for i := 1 to 12 do begin
            ValueEntryBuffer2Purch.SetRange("Item No.", ValueEntryBufferPurch."Item No.");
            ValueEntryBuffer2Purch.SetRange("Posting Date", PeriodStartingDate[i]);
            if ValueEntryBuffer2Purch.findFirst() then
                ExcelBuf.AddColumn(-ValueEntryBuffer2Purch."Invoiced Quantity", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number)
            else
                ExcelBuf.AddColumn(0, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        end;
        ExcelBuf.AddColumn(-ValueEntryBufferPurch."Invoiced Quantity", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-ValueEntryBufferPurch."Invoiced Quantity" / 12, false, '', false, false, false, '0.000', ExcelBuf."Cell Type"::Number);
    end;
}

