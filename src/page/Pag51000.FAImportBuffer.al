namespace Prodware.FTA;
page 51000 "FA Import Buffer"
{
    // ----------------------------------------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ----------------------------------------------------------------------------------------------------------
    // 
    // //>>EASY1.00
    // FE_SNS_NSC137 :GR 23/10/2008 : Fixed Asset import
    //                                  - Create Form
    // 
    // ----------------------------------------------------------------------------------------------------------

    Caption = 'FA Import Buffer';
    Editable = false;
    PageType = List;
    SourceTable = "FA Import Buffer";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(repeater)
            {
                Caption = 'repeater';
                field("Fixed Asset No."; Rec."Fixed Asset No.")
                {
                    ToolTip = 'Specifies the value of the Fixed Asset No. field.';
                }
                field("Acquisition Date"; Rec."Acquisition Date")
                {
                    ToolTip = 'Specifies the value of the Acquisition Date field.';
                }
                field("Start Operation Date"; Rec."Start Operation Date")
                {
                    ToolTip = 'Specifies the value of the Start Operation Date field.';
                }
                field("FA description"; Rec."FA description")
                {
                    ToolTip = 'Specifies the value of the FA description field.';
                }
                field("FA Posting Group"; Rec."FA Posting Group")
                {
                    ToolTip = 'Specifies the value of the FA Posting Group field.';
                }
                field("Acquisition Value"; Rec."Acquisition Value")
                {
                    ToolTip = 'Specifies the value of the Acquisition Value field.';
                }
                field("Depreciation Time (year)"; Rec."Depreciation Time (year)")
                {
                    ToolTip = 'Specifies the value of the Depreciation Time (year) field.';
                }
                field("Depreciation Method"; Rec."Depreciation Method")
                {
                    ToolTip = 'Specifies the value of the Depreciation Method field.';
                }
                field("Depreciation cumulated Amount"; Rec."Depreciation cumulated Amount")
                {
                    ToolTip = 'Specifies the value of the Depreciation cumulated Amount field.';
                }
                field(Net; Rec.Net)
                {
                    ToolTip = 'Specifies the value of the Net field.';
                }
                field("Professional Tax"; Rec."Professional Tax")
                {
                    ToolTip = 'Specifies the value of the Professional Tax field.';
                }
                field("Tapering System Of Rate"; Rec."Tapering System Of Rate")
                {
                    ToolTip = 'Specifies the value of the Tapering System Of Rate field.';
                }
                field("Derogatory Amount"; Rec."Derogatory Amount")
                {
                    ToolTip = 'Specifies the value of the Derogatory Amount field.';
                }
                field("Retrospective Derog. Amount"; Rec."Retrospective Derog. Amount")
                {
                    ToolTip = 'Specifies the value of the Retrospective Derog. Amount field.';
                }
                field("Dimension 1 Code"; Rec."Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Dimension 1 Code field.';
                }
                field("Dimension 2 Code"; Rec."Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Dimension 2 Code field.';
                }
                field("Dimension 3 Code"; Rec."Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Dimension 3 Code field.';
                }
                field("Dimension 4 Code"; Rec."Dimension 4 Code")
                {
                    ToolTip = 'Specifies the value of the Dimension 4 Code field.';
                }
                field("Dimension 5 Code"; Rec."Dimension 5 Code")
                {
                    ToolTip = 'Specifies the value of the Dimension 5 Code field.';
                }
                field("Dimension 6 Code"; Rec."Dimension 6 Code")
                {
                    ToolTip = 'Specifies the value of the Dimension 6 Code field.';
                }
                field("Dimension 7 Code"; Rec."Dimension 7 Code")
                {
                    ToolTip = 'Specifies the value of the Dimension 7 Code field.';
                }
                field("Dimension 8 Code"; Rec."Dimension 8 Code")
                {
                    ToolTip = 'Specifies the value of the Dimension 8 Code field.';
                }
            }
            field(COUNT; Rec.COUNT())
            {
                Caption = 'Count';
                Editable = false;
                ToolTip = 'Specifies the value of the COUNT field.';
            }
        }
    }

    actions
    {
    }
}

