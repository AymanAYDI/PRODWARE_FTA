namespace Prodware.FTA;

using Microsoft.Assembly.Document;
tableextension 50043 AssembletoOrderLink extends "Assemble-to-Order Link" //904
{
    //TODO: procedure AsmReopenIfReleased not migrated
    //Unsupported feature: Code Modification on "AsmReopenIfReleased(PROCEDURE 54)".

    //procedure AsmReopenIfReleased();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF AsmHeader.Status <> AsmHeader.Status::Released THEN
      EXIT;
    IF NOT CONFIRM(Text006,FALSE,AsmHeader.Status::Open) THEN
      ItemCheckAvail.RaiseUpdateInterruptedError;
    ReleaseAssemblyDoc.Reopen(AsmHeader);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF AsmHeader.Status <> AsmHeader.Status::Released THEN
      EXIT;

    //>>FTA SOBI APA 080116
    //IF NOT CONFIRM(Text006,FALSE,AsmHeader.Status::Open) THEN
    //  ItemCheckAvail.RaiseUpdateInterruptedError;
    //<<FTA SOBI AOA 080116
    ReleaseAssemblyDoc.Reopen(AsmHeader);
    */
    //end;
}

