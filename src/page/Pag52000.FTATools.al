namespace Prodware.FTA;

using Microsoft.Sales.Document;
page 52000 "FTA Tools"
{
    ApplicationArea = All;
    Caption = 'FTA Tools';
    PageType = NavigatePage;
    UsageCategory = Administration;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(content)
        {
            grid(General)
            {
                ShowCaption = false;
                fixed(FixedPart)
                {
                    group("Group Caption")
                    {
                        ShowCaption = false;
                        field("Item Copy"; ItemCopyCaption)
                        {
                            Caption = 'run Item Copy Report';
                            ToolTip = 'run Item Copy Report';
                            ApplicationArea = All;
                            Editable = false;
                            ShowCaption = false;
                            Style = StrongAccent;
                            StyleExpr = true;
                            trigger OnDrillDown()
                            begin
                                Report.run(Report::"Item copy");
                            end;
                        }
                        field("Bill FTA"; BillFtaCaption)
                        {
                            Caption = 'run Bill FTA Report';
                            ToolTip = 'run Bill FTA Report';
                            ApplicationArea = All;
                            Editable = false;
                            ShowCaption = false;
                            Style = StrongAccent;
                            StyleExpr = true;
                            trigger OnDrillDown()
                            begin
                                Report.run(Report::"Bill FTA");
                            end;
                        }
                        field("Delete Invoiced Sales Orders"; DeleteInvoicedSalesOrdersCaption)
                        {
                            Caption = 'run Delete Invoiced Sales Orders';
                            ToolTip = 'run Delete Invoiced Sales Orders';
                            ApplicationArea = All;
                            Editable = false;
                            ShowCaption = false;
                            Style = StrongAccent;
                            StyleExpr = true;
                            trigger OnDrillDown()
                            begin
                                Report.run(Report::"Delete Invoiced Sales Orders");
                            end;
                        }


                    }
                }
            }
        }
    }
    var
        ItemCopyCaption: Label 'run Item Copy Report';
        BillFtaCaption: Label 'run Bill FTA';
        DeleteInvoicedSalesOrdersCaption: Label 'run Delete Invoiced Sales Orders';

}
