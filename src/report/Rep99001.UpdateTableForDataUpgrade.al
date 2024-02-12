namespace Prodware.FTA;
report 99001 "Update Table For Data Upgrade"
{
    ProcessingOnly = true;

    dataset
    {
        // dataitem(DataItem1100267000; Table104076)
        // {

        //     trigger OnAfterGetRecord()
        //     var
        //         RecLItemUnitofMeasure: Record "5404";
        //     begin
        //         IF Table104076."Base Unit of Measure" = '' THEN BEGIN
        //             IF NOT RecLItemUnitofMeasure.Get("No.", 'PIECE') THEN BEGIN
        //                 RecLItemUnitofMeasure.Init();
        //                 RecLItemUnitofMeasure."Item No." := "No.";
        //                 RecLItemUnitofMeasure.Code := 'PIECE';
        //                 RecLItemUnitofMeasure.Insert();
        //             END;
        //             "Base Unit of Measure" := 'PIECE';
        //             Modify();
        //         END;
        //     end;
        // }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

