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
                rec.CalcFields("Reserved Quantity");
                if rec."Outstanding Quantity" > rec."Reserved Quantity" then
                    rec.Mark(true);
            until rec.Next() = 0;
            rec.MarkedOnly(true);
            rec.FindSet();
        end;
    end;

    trigger OnClosePage()
    begin
        if OptGProcess = OptGProcess::NoAffected then begin
            repeat
                rec.CalcFields("Reserved Quantity");
                if rec."Outstanding Quantity" > rec."Reserved Quantity" then
                    rec.Mark(true);
            until rec.Next() = 0;
            rec.MarkedOnly(true);
            rec.FindSet();
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        DecGQtyNotAffected := rec."Outstanding Quantity" - rec."Reserved Quantity";
    end;

    trigger OnAfterGetCurrRecord()
    begin
        rec.CalcFields("Reserved Quantity");
        DecGQtyNotAffected := rec."Outstanding Quantity" - rec."Reserved Quantity";
    end;
}
