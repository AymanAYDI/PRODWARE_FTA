namespace Prodware.FTA;
page 50027 "Item Comment Detail Modify"
{
    // //>>FTA1.00
    // FTA:AM  31.03.2023  Create page

    AutoSplitKey = true;
    Caption = 'Modification nomenclature';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Item Comment Detail";
    SourceTableView = SORTING("Parent Entry No.", "Entry No.")
                      WHERE("Comment Type" = CONST(Modify));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Parent Entry No."; Rec."Parent Entry No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Parent Entry No. field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Comment Type"; Rec."Comment Type")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Comment Type field.';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Comment Type" := Rec."Comment Type"::Modify;
    end;
}

