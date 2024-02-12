namespace Prodware.FTA;

using System.Utilities;
using System.Reflection;
using System.Security.AccessControl;
report 60001 "Update FTA-TABLES"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateFTATABLES.rdl';

    dataset
    {
        // dataitem(DataItem110026700; Object)

        // {

        //     trigger OnAfterGetRecord()
        //     begin
        //         if not RecgPermission.GET('FTA-TABLES', RecgPermission."Object Type"::Table, ID) then begin
        //             RecgPermission.INIT();
        //             RecgPermission."Role ID" := 'FTA-TABLES';
        //             RecgPermission."Object Type" := RecgPermission."Object Type"::Table;
        //             RecgPermission."Object ID" := ID;
        //             RecgPermission."Read Permission" := RecgPermission."Read Permission"::Yes;
        //             RecgPermission."Insert Permission" := RecgPermission."Insert Permission"::Yes;
        //             RecgPermission."Modify Permission" := RecgPermission."Modify Permission"::Yes;
        //             RecgPermission."Delete Permission" := RecgPermission."Delete Permission"::Yes;
        //             RecgPermission."Execute Permission" := RecgPermission."Execute Permission"::Yes;
        //             RecgPermission.INSERT();
        //         end;
        //     end;

        //     trigger OnPostDataItem()
        //     begin
        //         MESSAGE('Fini');
        //     end;

        //     trigger OnPreDataItem()
        //     begin
        //         RecgPermission.SETRANGE("Role ID", 'FTA-TABLES');
        //         SETRANGE(Type, Type::Table);
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

