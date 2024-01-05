// namespace Prodware.FTA;


// pageextension 50085 Debugger extends "Debugger"//9500
// {

//     layout
//     {
//         area(content)
//         {
//             part(CodeViewer; 9504)
//             {
//                 Caption = 'Code';
//                 Provider = Callstack;
//                 SubPageLink = Object Type=FIELD(Object Type),
//                               Object ID=FIELD(Object ID),
//                               Line No.=FIELD(Line No.),
//                               ID=FIELD(ID);
//             }
//         }
//         area(factboxes)
//         {
//             part(Watches;9503)
//             {
//                 Caption = 'Watches';
//                 Provider = Callstack;
//                 SubPageLink = Call Stack ID=FIELD(ID);
//             }
//             part(Callstack;9502)
//             {
//                 Caption = 'Call Stack';
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             separator()
//             {
//             }
//             group("Code Tracking")
//             {
//                 Caption = 'Code Tracking';
//                 action("Step Into")
//                 {
//                     Caption = 'Step Into';
//                     Enabled = BreakpointHit;
//                     Image = StepInto;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'F11';
//                     ToolTip = 'Execute the current statement. If the statement contains a function call, then execute the function and break at the first statement inside the function.';

//                     trigger OnAction()
//                     begin
//                         WaitingForBreak;
//                         DebuggerManagement.SetCodeTrackingAction;
//                         DEBUGGER.STEPINTO;
//                     end;
//                 }
//                 action("Step Over")
//                 {
//                     Caption = 'Step Over';
//                     Enabled = BreakpointHit;
//                     Image = StepOver;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'F10';
//                     ToolTip = 'Execute the current statement. If the statement contains a function call, then execute the function and break at the first statement outside the function.';

//                     trigger OnAction()
//                     begin
//                         WaitingForBreak;
//                         DebuggerManagement.SetCodeTrackingAction;
//                         DEBUGGER.STEPOVER;
//                     end;
//                 }
//                 action("Step Out")
//                 {
//                     Caption = 'Step Out';
//                     Enabled = BreakpointHit;
//                     Image = StepOut;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+F11';
//                     ToolTip = 'Execute the remaining statements in the current function and break at the next statement in the calling function.';

//                     trigger OnAction()
//                     begin
//                         WaitingForBreak;
//                         DebuggerManagement.SetCodeTrackingAction;
//                         DEBUGGER.STEPOUT;
//                     end;
//                 }
//             }
//             separator()
//             {
//             }
//             group("Running Code")
//             {
//                 Caption = 'Running Code';
//                 action(Continue)
//                 {
//                     Caption = 'Continue';
//                     Enabled = BreakpointHit;
//                     Image = Continue;
//                     Promoted = true;
//                     PromotedCategory = Category5;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'F5';
//                     ToolTip = 'Continue until the next break.';

//                     trigger OnAction()
//                     begin
//                         WaitingForBreak;
//                         DebuggerManagement.SetRunningCodeAction;
//                         DEBUGGER.CONTINUE;
//                     end;
//                 }
//                 action("Break")
//                 {
//                     Caption = 'Break';
//                     Enabled = BreakEnabled;
//                     Image = Pause;
//                     Promoted = true;
//                     PromotedCategory = Category5;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+Ctrl+B';
//                     ToolTip = 'Break at the next statement.';

//                     trigger OnAction()
//                     begin
//                         BreakEnabled := FALSE;
//                         DebuggerManagement.SetRunningCodeAction;
//                         DEBUGGER."BREAK";
//                     end;
//                 }
//                 action(Stop)
//                 {
//                     Caption = 'Stop';
//                     Enabled = BreakpointHit;
//                     Image = Stop;
//                     Promoted = true;
//                     PromotedCategory = Category5;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+F5';
//                     ToolTip = 'Stop the current activity in the session being debugged while continuing to debug the session.';

//                     trigger OnAction()
//                     begin
//                         WaitingForBreak;
//                         DebuggerManagement.SetRunningCodeAction;
//                         DEBUGGER.STOP;
//                     end;
//                 }
//             }
//             separator()
//             {
//             }
//             group("Breakpoints Group")
//             {
//                 Caption = 'Breakpoints';
//                 action(Toggle)
//                 {
//                     Caption = 'Toggle';
//                     Image = ToggleBreakpoint;
//                     Promoted = true;
//                     PromotedCategory = Category6;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'F9';
//                     ToolTip = 'Toggle a breakpoint at the current line.';

//                     trigger OnAction()
//                     begin
//                         CurrPage.CodeViewer.PAGE.ToggleBreakpoint;
//                     end;
//                 }
//                 action("Set/Clear Condition")
//                 {
//                     Caption = 'Set/Clear Condition';
//                     Image = ConditionalBreakpoint;
//                     Promoted = true;
//                     PromotedCategory = Category6;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+F9';
//                     ToolTip = 'Set or clear a breakpoint condition at the current line.';

//                     trigger OnAction()
//                     begin
//                         CurrPage.CodeViewer.PAGE.SetBreakpointCondition;
//                     end;
//                 }
//                 action("Disable All")
//                 {
//                     Caption = 'Disable All';
//                     Image = DisableAllBreakpoints;
//                     Promoted = true;
//                     PromotedCategory = Category6;
//                     ToolTip = 'Disable all breakpoints in the breakpoint list. You can edit the list by using the Breakpoints action.';

//                     trigger OnAction()
//                     var
//                         DebuggerBreakpoint: Record "2000000100";
//                     begin
//                         DebuggerBreakpoint.MODIFYALL(Enabled,FALSE,TRUE);
//                     end;
//                 }
//                 action(Breakpoints)
//                 {
//                     Caption = 'Breakpoints';
//                     Image = BreakpointsList;
//                     Promoted = true;
//                     PromotedCategory = Category6;
//                     RunObject = Page 9505;
//                                     ToolTip = 'Edit the breakpoint list for all objects.';
//                 }
//                 action("Break Rules")
//                 {
//                     Caption = 'Break Rules';
//                     Image = BreakRulesList;
//                     Promoted = true;
//                     PromotedCategory = Category6;
//                     PromotedIsBig = true;
//                     ToolTip = 'Change settings for break rules. The debugger breaks code execution for certain configurable rules as well as for breakpoints.';

//                     trigger OnAction()
//                     var
//                         DebuggerBreakRulesPage: Page "9509";
//                     begin
//                         DebuggerBreakRulesPage.SetBreakOnError(BreakOnError);
//                         DebuggerBreakRulesPage.SetBreakOnRecordChanges(BreakOnRecordChanges);
//                         DebuggerBreakRulesPage.SetSkipCodeunit1(SkipCodeunit1);

//                         IF DebuggerBreakRulesPage.RUNMODAL = ACTION::OK THEN BEGIN
//                           BreakOnError := DebuggerBreakRulesPage.GetBreakOnError;
//                           DEBUGGER.BREAKONERROR(BreakOnError);
//                           BreakOnRecordChanges := DebuggerBreakRulesPage.GetBreakOnRecordChanges;
//                           DEBUGGER.BREAKONRECORDCHANGES(BreakOnRecordChanges);
//                           SkipCodeunit1 := DebuggerBreakRulesPage.GetSkipCodeunit1;
//                           DEBUGGER.SKIPSYSTEMTRIGGERS(SkipCodeunit1);

//                           SaveConfiguration;
//                         END;
//                     end;
//                 }
//             }
//             separator()
//             {
//             }
//             group(Show)
//             {
//                 Caption = 'Show';
//                 Image = View;
//                 action(Variables)
//                 {
//                     Caption = 'Variables';
//                     Enabled = BreakpointHit;
//                     Image = VariableList;
//                     Promoted = true;
//                     PromotedCategory = Category7;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'Shift+Ctrl+V';
//                     ToolTip = 'View the list of variables in the current scope.';

//                     trigger OnAction()
//                     var
//                         DebuggerCallstack: Record "2000000101";
//                         DebuggerVariable: Record "2000000102";
//                     begin
//                         CurrPage.Callstack.PAGE.GetCurrentCallstack(DebuggerCallstack);

//                         DebuggerVariable.FILTERGROUP(2);
//                         DebuggerVariable.SETRANGE("Call Stack ID",DebuggerCallstack.ID);
//                         DebuggerVariable.FILTERGROUP(0);

//                         PAGE.RUNMODAL(PAGE::"Debugger Variable List",DebuggerVariable);
//                     end;
//                 }
//                 action(LastErrorMessage)
//                 {
//                     Caption = 'Last Error';
//                     Enabled = ShowLastErrorEnabled;
//                     Image = PrevErrorMessage;
//                     Promoted = true;
//                     PromotedCategory = Category7;
//                     PromotedIsBig = true;
//                     ToolTip = 'View the last error message shown by the session being debugged.';

//                     trigger OnAction()
//                     var
//                         DebuggerManagement: Codeunit "9500";
//                         LastErrorMessage: Text;
//                         IsLastErrorMessageNew: Boolean;
//                     begin
//                         LastErrorMessage := DebuggerManagement.GetLastErrorMessage(IsLastErrorMessageNew);

//                         IF LastErrorMessage = '' THEN
//                           LastErrorMessage := DEBUGGER.GETLASTERRORTEXT;

//                         MESSAGE(STRSUBSTNO(Text005Msg,LastErrorMessage));
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         IF BreakpointHit THEN BEGIN
//           CurrPage.Callstack.PAGE.GetCurrentCallstack(DebuggerCallstack);
//           WITH DebuggerCallstack DO BEGIN
//             IF ID <> 0 THEN
//               DataCaption := STRSUBSTNO(Text003Cap,"Object Type","Object ID","Object Name")
//             ELSE
//               DataCaption := Text004Cap;
//           END;
//         END;
//     end;

//     trigger OnClosePage()
//     begin
//         IF DEBUGGER.DEACTIVATE THEN;
//         SetAttachedSession := FALSE;
//     end;

//     trigger OnFindRecord(Which: Text): Boolean
//     var
//         DebuggedSession: Record "2000000110";
//         IsBreakOnErrorMessageNew: Boolean;
//         BreakOnErrorMessage: Text;
//     begin
//         IF NOT DEBUGGER.ISACTIVE AND (Which = '=') THEN
//           MESSAGE(Text007Msg);

//         IF NOT DEBUGGER.ISACTIVE THEN BEGIN
//           CurrPage.CLOSE;
//           EXIT(FALSE);
//         END;

//         BreakpointHit := DEBUGGER.ISBREAKPOINTHIT;

//         IF BreakpointHit THEN BEGIN
//           BreakOnErrorMessage := DebuggerManagement.GetLastErrorMessage(IsBreakOnErrorMessageNew);

//           IF IsBreakOnErrorMessageNew AND (BreakOnErrorMessage <> '') THEN
//             MESSAGE(STRSUBSTNO(Text002Msg,BreakOnErrorMessage));

//           ShowLastErrorEnabled := (BreakOnErrorMessage <> '') OR (DEBUGGER.GETLASTERRORTEXT <> '');

//           BreakEnabled := FALSE;
//           IF NOT SetAttachedSession THEN BEGIN
//             DebuggedSession."Session ID" := DEBUGGER.DEBUGGEDSESSIONID;
//             DebuggerManagement.SetDebuggedSession(DebuggedSession);
//             SetAttachedSession := TRUE;
//           END;
//         END ELSE BEGIN
//           IsBreakOnErrorMessageNew := FALSE;
//           ShowLastErrorEnabled := FALSE;
//           DataCaption := Text004Cap;
//         END;

//         EXIT(TRUE);
//     end;

//     trigger OnInit()
//     begin
//         BreakOnError := TRUE;
//         BreakpointHit := DEBUGGER.ISBREAKPOINTHIT;
//         BreakEnabled := NOT BreakpointHit;
//     end;

//     trigger OnOpenPage()
//     var
//         DebuggedSession: Record "2000000110";
//     begin
//         DebuggerManagement.GetDebuggedSession(DebuggedSession);
//         IF DebuggedSession."Session ID" = 0 THEN
//           DEBUGGER.ACTIVATE
//         ELSE BEGIN
//           DEBUGGER.ATTACH(DebuggedSession."Session ID");
//           SetAttachedSession := TRUE;
//         END;

//         IF UserPersonalization.GET(USERSECURITYID) THEN BEGIN
//           BreakOnError := UserPersonalization."Debugger Break On Error";
//           BreakOnRecordChanges := UserPersonalization."Debugger Break On Rec Changes";
//           SkipCodeunit1 := UserPersonalization."Debugger Skip System Triggers";
//         END;

//         IF BreakOnError THEN
//           DEBUGGER.BREAKONERROR(TRUE);
//         IF BreakOnRecordChanges THEN
//           DEBUGGER.BREAKONRECORDCHANGES(TRUE);
//         IF SkipCodeunit1 THEN
//           DEBUGGER.SKIPSYSTEMTRIGGERS(TRUE);

//         DebuggerManagement.ResetActionState;
//     end;

//     var
//         DebuggerCallstack: Record "2000000101";
//         UserPersonalization: Record "2000000073";
//         DebuggerManagement: Codeunit "9500";
//         [InDataSet]
//         BreakEnabled: Boolean;
//         [InDataSet]
//         BreakpointHit: Boolean;
//         [InDataSet]
//         BreakOnError: Boolean;
//         Text002Msg: Label 'Break On Error Message:\ \%1', Comment='Message shown when Break On Error occurs. Include the original error message.';
//         [InDataSet]
//         BreakOnRecordChanges: Boolean;
//         SkipCodeunit1: Boolean;
//         DataCaption: Text[100];
//         [InDataSet]
//         ShowLastErrorEnabled: Boolean;
//         Text003Cap: Label '%1 %2 : %3', Comment='DataCaption when debugger is broken in application code. Example: Codeunit 1:  Application Management';
//         Text004Cap: Label 'Waiting for break...', Comment='DataCaption when waiting for break';
//         SetAttachedSession: Boolean;
//         Text005Msg: Label 'Last Error Message:\ \%1';
//         Text007Msg: Label 'The session that was being debugged has closed. The Debugger Page will close.';

//     local procedure SaveConfiguration()
//     begin
//         IF UserPersonalization.GET(USERSECURITYID) THEN BEGIN
//           UserPersonalization."Debugger Break On Error" := BreakOnError;
//           UserPersonalization."Debugger Break On Rec Changes" := BreakOnRecordChanges;
//           UserPersonalization."Debugger Skip System Triggers" := SkipCodeunit1;
//           UserPersonalization.MODIFY;
//         END;
//     end;

//     [Scope('Internal')]
//     procedure WaitingForBreak()
//     begin
//         BreakEnabled := TRUE;
//         CurrPage.Callstack.PAGE.ResetCallstackToTop;
//     end;
// }

