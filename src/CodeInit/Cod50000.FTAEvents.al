codeunit 50000 "FTA_Events"
{
    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeOnInsert', '', false, false)]
    local procedure TAB27_OnBeforeOnInsert(var Item: Record Item; var IsHandled: Boolean; xRecItem: Record Item)
    var
        "**FTA1.00": Integer;
        CduLTemplateMgt: Codeunit 8612;
        RecRef: RecordRef;
        RecLTemplateHeader: Record 8618;
        OptLItemBase: Enum "ItemBase";
        toto1: Text[30];
        RecLItem: Record 27;
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        case Item."Item Base" of
            Item."Item Base"::Transitory:
                begin
                    GetInvtSetup();
                    //TODO: TABLE inventory setup not migrated yet
                    //InvtSetup.TESTFIELD("Transitory Item Nos.");
                    //NoSeriesMgt.InitSeries(InvtSetup."Transitory Item Nos.",xRec."No. Series",0D,"No.","No. Series");
                    Item."Item Base" := Item."Item Base"::Transitory;
                end;
            Item."Item Base"::"Transitory Kit":
                begin
                    GetInvtSetup();
                    //    InvtSetup.TESTFIELD("Transitory Kit Item Nos.");
                    //    NoSeriesMgt.InitSeries(InvtSetup."Transitory Kit Item Nos.",xRec."No. Series",0D,"No.","No. Series");
                    Item."Item Base" := Item."Item Base"::"Transitory Kit";
                end;
            Item."Item Base"::"Bored blocks":
                begin
                    GetInvtSetup();
                    //TODO: TABLE inventory setup not migrated yet
                    //    InvtSetup.TESTFIELD("Bored blocks Item Nos.");
                    //    NoSeriesMgt.InitSeries(InvtSetup."Bored blocks Item Nos.",xRec."No. Series",0D,"No.","No. Series");
                    Item."Item Base" := Item."Item Base"::"Bored blocks";
                end;
            else begin
                if Item."No." = '' then begin
                    GetInvtSetup();
                    InvtSetup.TESTFIELD("Item Nos.");
                    NoSeriesMgt.InitSeries(InvtSetup."Item Nos.", xRecItem."No. Series", 0D, Item."No.", Item."No. Series");
                end;
            end;
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeValidateNo', '', false, false)]
    local procedure OnBeforeValidateNo(var IsHandled: Boolean; var Item: Record Item; xItem: Record Item; InventorySetup: Record "Inventory Setup"; var NoSeriesMgt: Codeunit NoSeriesManagement)
    var
        "**FTA1.00": Integer;
        CduLTemplateMgt: Codeunit 8612;
        RecRef: RecordRef;
        RecLTemplateHeader: Record 8618;
    begin
        if Item.GETFILTER("Item Base") = '<>Standard' then begin
            GetInvtSetup();
            //TODO:fIELD spe InvtSetup.TESTFIELD("Transitory Item Nos.");
            //TODO:fIELD spe   NoSeriesMgt.InitSeries(InvtSetup.tr, xRec."No. Series", 0D, "No.", "No. Series");
            Item."Item Base" := Item."Item Base"::Transitory;
            //RecRef.GETTABLE(Rec);
            //TemplateMgt.UpdateFromTemplateSelection(RecRef);
            //InvtSetup.TESTFIELD("Template Item Transitory Code");
            //RecLTemplateHeader.GET(InvtSetup."Template Item Transitory Code");
            //CduLTemplateMgt.UpdateRecord(RecLTemplateHeader,RecRef);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Description', false, false)]
    local procedure OnAfterValidateEvent(CurrFieldNo: Integer; var Rec: Record Item; var xRec: Record Item)
    begin
        Rec.Get(CurrFieldNo);
        Rec."Search Description" := DELCHR(Rec."Search Description", '=', '/,- +-#*.\{}><[]()@":=');
    end;

    local procedure GetInvtSetup()
    var

    begin

        if not HasInvtSetup then begin
            InvtSetup.GET();
            HasInvtSetup := true;
        end;
    end;

    var
        InvtSetup: Record "Inventory Setup";
        HasInvtSetup: Boolean;

}
