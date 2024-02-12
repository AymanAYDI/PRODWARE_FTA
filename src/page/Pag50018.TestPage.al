namespace Prodware.FTA;
page 50018 "TestPage"
{
    ApplicationArea = All;
    Caption = 'TestPage';
    PaGetype = Card;
    UsageCategory = Administration;

    actions
    {
        area(Processing)
        {
            action(TestCU)
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                trigger Onaction()
                var
                    // "Write Text File": Codeunit "Write Text File";TestP
                    "Customers Export": Codeunit "Customers Export";
                    "Export Items": Codeunit "Export Items";
                    "Export Sales Line Discount": Codeunit "Export Sales Line Discount";
                    "Export Sales Price": Codeunit "Export Sales Price";
                    "Export Purchase Line": Codeunit "Export Purchase Line";

                begin
                    // "Write Text File".Run();
                    // "Customers Export".Run();
                    "Export Items".Run();
                    // "Export Sales Line Discount".Run();
                    // "Export Sales Price".Run();
                    // "Export Purchase Line".Run();
                end;
            }
        }
    }
}
