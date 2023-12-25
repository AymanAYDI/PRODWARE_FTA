page 50008 "Purchase Assignment"
{
    Caption = 'Purchase Assignment';
    PageType = Document;
    SourceTable = "Purchase Line";

    layout
    {
        area(content)
        {
            repeater(Repeater)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Buy-from Vendor No. field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
                field("Order Date"; Rec."Order Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Order Date field.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Outstanding Quantity field.';
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Reserved Quantity field.';
                }
                field(DecGQtyNotAffected; DecGQtyNotAffected)
                {
                    Caption = 'Qty Not Assigned';
                    DecimalPlaces = 0 : 5;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Qty Not Assigned field.';
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Requested Receipt Date field.';
                }
                field("Promised Receipt Date"; Rec."Promised Receipt Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Promised Receipt Date field.';
                }
            }
            part(ReserveSubform; "Reservation Entries FTA")
            {
                Editable = false;
                SubPageLink = "Source ID" = field("Document No."),
                "Source Ref. No." = field("Line No."),
                "Reservation Status" = const(Reservation),
                "Source Type" = const(39);
                toolTip = 'Specifies the value of the No field.';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CALCFIELDS("Reserved Quantity");
        DecGQtyNotAffected := Rec."Outstanding Quantity" - Rec."Reserved Quantity";
        OnAfterGetCurrRecord();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord();
    end;

    var
        DecGQtyNotAffected: Decimal;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        Rec.CALCFIELDS("Reserved Quantity");
        DecGQtyNotAffected := Rec."Outstanding Quantity" - Rec."Reserved Quantity";
    end;
}

