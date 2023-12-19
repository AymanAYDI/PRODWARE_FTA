namespace Prodware.FTA;

using Microsoft.Sales.Comment;
tableextension 50012 SalesCommentLine extends "Sales Comment Line" //44
{
    fields
    {
        field(50000; "Comment type"; enum "Comment type")
        {
            Caption = 'Type';
        }
    }
}

