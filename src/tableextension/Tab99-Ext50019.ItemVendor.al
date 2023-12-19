tableextension 50019 ItemVendor extends "Item Vendor" //99
{
    fields
    {
        modify("Item No.")
        {
            TableRelation = Item where("Quote Associated" = filter(false));
        }
    }
}

