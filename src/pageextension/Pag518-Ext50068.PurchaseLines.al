namespace Prodware.FTA;
using Microsoft.Purchases.Document;
pageextension 50068 "PurchaseLines" extends "Purchase Lines" //518
{
    layout
    {
        addafter(Quantity)
        {
            field(DecGQtyNotAffected; DecGQtyNotAffected)
            {
                Caption = 'Quantity Not Affected';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the DecGQtyNotAffected field.';
            }

            field("Requested Receipt Date"; rec."Requested Receipt Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Requested Receipt Date field.';
            }
            field("Promised Receipt Date"; rec."Promised Receipt Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Promised Receipt Date field.';
            }
        }
    }
    var
        OptGProcess: enum "Option Process";
        DecGQtyNotAffected: Decimal;
        CodGNo: Code[20];

    procedure FctGetParm(CodPNo: Code[20]; OptPProcess: enum "Option Process");
    begin
        OptGProcess := OptPProcess;
        CodGNo := CodPNo;
    end;

    trigger OnOpenPage()
    begin
        if OptGProcess = OptGProcess::NoAffected then begin
            repeat
                rec.CALCFIELDS("Reserved Quantity");
                if rec."Outstanding Quantity" > rec."Reserved Quantity" then
                    rec.MARK(true);
            until rec.NEXT() = 0;
            rec.MARKEDONLY(true);
            rec.FINDSET();
        end;
    end;

    trigger OnClosePage()
    begin
        if OptGProcess = OptGProcess::NoAffected then begin
            repeat
                rec.CALCFIELDS("Reserved Quantity");
                if rec."Outstanding Quantity" > rec."Reserved Quantity" then
                    rec.MARK(true);
            until rec.NEXT() = 0;
            rec.MARKEDONLY(true);
            rec.FINDSET();
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        DecGQtyNotAffected := rec."Outstanding Quantity" - rec."Reserved Quantity";
    end;

    trigger OnAfterGetCurrRecord()
    begin
        rec.CALCFIELDS("Reserved Quantity");
        DecGQtyNotAffected := rec."Outstanding Quantity" - rec."Reserved Quantity";
    end;
}
