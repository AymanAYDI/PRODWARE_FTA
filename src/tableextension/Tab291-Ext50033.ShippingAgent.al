namespace Prodware.FTA;

using Microsoft.Foundation.Shipping;
using Microsoft.Purchases.Vendor;
tableextension 50033 ShippingAgent extends "Shipping Agent"//291
{
    fields
    {
        field(50000; "Shipping Costs"; enum "frais de port")
        {
            Caption = 'Frais de port';

        }
    }
    trigger OnDelete()
    var
        RecLVendor: Record Vendor;

        TexCdeTransp001: text;
    begin

        // IF (RecLVendor.GET(Code)) AND (RecLVendor."Vendor Type" = RecLVendor."Vendor Type"::Transport) THEN
        //     TexCdeTransp001 := (STRSUBSTNO(RecLVendor."No."));
        // ERROR(TexCdeTransp001)

    end;



}

