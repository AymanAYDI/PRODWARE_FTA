namespace Prodware.FTA;
page 50026 "Item Comment Detail Comment"
{
    // //>>FTA1.00
    // FTA:AM  31.03.2023  Create page

    AutoSplitKey = true;
    Caption = 'Commentaires';
    DelayedInsert = true;
    MultipleNewLines = true;
    PaGetype = ListPart;
    SourceTable = "Item Comment Detail";
    SourceTableView = sorting("Parent Entry No.", "Entry No.")
                      where("Comment Type" = const(Comment));
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
        Rec."Comment Type" := Rec."Comment Type"::Comment;
    end;
}

