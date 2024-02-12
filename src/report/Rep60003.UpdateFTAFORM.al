report 60003 "Update FTA-FORM+"
{
    DefaultLayout = RDLC;
    RDLCLayout = './UpdateFTAFORM.rdlc';

    dataset
    {
        // dataitem(DataItem110026700; Object)
        // {

        //     trigger OnAfterGetRecord()
        //     begin
        //         if not RecgPermission.Get('FTA-FORM+', RecgPermission."Object Type"::Page, ID) then begin
        //             RecgPermission.Init();
        //             RecgPermission."Role ID" := 'FTA-FORM+';
        //             RecgPermission."Object Type" := RecgPermission."Object Type"::Page;
        //             RecgPermission."Object ID" := ID;
        //             RecgPermission."Read Permission" := RecgPermission."Read Permission"::Yes;
        //             RecgPermission."Insert Permission" := RecgPermission."Insert Permission"::" ";
        //             RecgPermission."Modify Permission" := RecgPermission."Modify Permission"::" ";
        //             RecgPermission."Delete Permission" := RecgPermission."Delete Permission"::" ";

        //             RecgPermission."Execute Permission" := RecgPermission."Execute Permission"::Yes;
        //             RecgPermission.Insert();
        //         end;
        //     end;

        //     trigger OnPostDataItem()
        //     begin
        //         Message('Fini');
        //     end;

        //     trigger OnPreDataItem()
        //     begin
        //         RecgPermission.SetRange("Role ID", 'FTA-FORM+');
        //         SetRange(Type, Type::Page);
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

    var
        RecgPermission: Record Permission;
}

