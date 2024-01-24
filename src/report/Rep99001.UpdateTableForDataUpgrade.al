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
        //             IF NOT RecLItemUnitofMeasure.GET("No.", 'PIECE') THEN BEGIN
        //                 RecLItemUnitofMeasure.INIT();
        //                 RecLItemUnitofMeasure."Item No." := "No.";
        //                 RecLItemUnitofMeasure.Code := 'PIECE';
        //                 RecLItemUnitofMeasure.INSERT();
        //             END;
        //             "Base Unit of Measure" := 'PIECE';
        //             MODIFY();
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

