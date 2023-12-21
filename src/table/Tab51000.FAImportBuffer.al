table 51000 "FA Import Buffer"
{

    Caption = 'FA Import Buffer';

    fields
    {
        field(1; "Fixed Asset No."; Code[20])
        {
            Caption = 'Fixed Asset No.';
            NotBlank = true;
        }
        field(2; "Acquisition Date"; Date)
        {
            Caption = 'Acquisition Date';
        }
        field(3; "FA description"; Text[100])
        {
            Caption = 'FA description';
        }
        field(4; "FA Posting Group"; Code[10])
        {
            Caption = 'FA Posting Group';
        }
        field(5; "Acquisition Value"; Decimal)
        {
            Caption = 'Acquisition Value';
        }
        field(6; "Depreciation Method"; Option)
        {
            Caption = 'Depreciation Method';
            Description = 'FE_SNS_NSC137 :MA';
            OptionCaption = 'Straight-Line,Declining-Balance 1,Declining-Balance 2,DB1/SL,DB2/SL,User-Defined,Manual';
            OptionMembers = "Straight-Line","Declining-Balance 1","Declining-Balance 2","DB1/SL","DB2/SL","User-Defined",Manual;
        }
        field(7; "Depreciation Time (year)"; Decimal)
        {
            Caption = 'Depreciation Time (year)';
        }
        field(8; "Depreciation cumulated Amount"; Decimal)
        {
            Caption = 'Depreciation cumulated Amount';
        }
        field(9; Net; Decimal)
        {
            Caption = 'Net';
        }
        field(10; "Professional Tax"; Option)
        {
            Caption = 'Professional Tax';
            OptionCaption = 'No Tax,Fixed Asset for more than 30 years 1,Fixed Asset for more than 30 years 2,Fixed Asset less than 30 years';
            OptionMembers = "No Tax","Fixed Asset for more than 30 years 1","Fixed Asset for more than 30 years 2","Fixed Asset less than 30 years";
        }
        field(11; "Tapering System Of Rate"; Decimal)
        {
            Caption = 'Tapering System Of Rate';
        }
        field(12; "Derogatory Amount"; Decimal)
        {
            Caption = 'Derogatory Amount';
        }
        field(13; "Retrospective Derog. Amount"; Decimal)
        {
            Caption = 'Retrospective Derogatory Amount ';
        }
        field(14; "Start Operation Date"; Date)
        {
            Caption = 'Start Operation Date';
        }
        field(20; "Dimension 1 Code"; Code[20])
        {
            Caption = 'Dimension 1 Code';
        }
        field(21; "Dimension 2 Code"; Code[20])
        {
            Caption = 'Dimension 2 Code';
        }
        field(22; "Dimension 3 Code"; Code[20])
        {
            Caption = 'Dimension 3 Code';
        }
        field(23; "Dimension 4 Code"; Code[20])
        {
            Caption = 'Dimension 4 Code';
        }
        field(24; "Dimension 5 Code"; Code[20])
        {
            Caption = 'Dimension 5 Code';
        }
        field(25; "Dimension 6 Code"; Code[20])
        {
            Caption = 'Dimension 6 Code';
        }
        field(26; "Dimension 7 Code"; Code[20])
        {
            Caption = 'Dimension 7 Code';
        }
        field(27; "Dimension 8 Code"; Code[20])
        {
            Caption = 'Dimension 8 Code';
        }
        field(30; "Serial No."; Text[30])
        {
            Caption = 'Serial No.';
            Description = 'FE_SNS_NSC137 :MA';
        }
        field(32; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
            Description = 'FE_SNS_NSC137 :MA';
        }
        field(35; "Fiscal Depreciation Method"; Option)
        {
            Caption = 'Fiscal Depreciation Method';
            Description = 'FE_SNS_NSC137 :MA';
            OptionCaption = 'Straight-Line,Declining-Balance 1,Declining-Balance 2,DB1/SL,DB2/SL,User-Defined,Manual';
            OptionMembers = "Straight-Line","Declining-Balance 1","Declining-Balance 2","DB1/SL","DB2/SL","User-Defined",Manual;
        }
        field(36; "Fisc. Depreciation Time (year)"; Decimal)
        {
            Caption = 'Fiscal Depreciation Time (year)';
            Description = 'FE_SNS_NSC137 :MA';
        }
        field(37; "Fiscal Tapering System Of Rate"; Decimal)
        {
            Caption = 'Fiscal Tapering System Of Rate';
            Description = 'FE_SNS_NSC137 :MA';
        }
    }

    keys
    {
        key(Key1; "Fixed Asset No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

