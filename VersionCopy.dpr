program VersionCopy;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.IOUtils,
  System.SysUtils,
  VersionUnit.Utils in 'VersionUnit.Utils.pas',
  VersionUnit.Types in 'VersionUnit.Types.pas',
  VersionUnit.Commandline.Utils in 'VersionUnit.Commandline.Utils.pas';

function DoCopy(const ACopyItem: TCopyItem; var AErrorString: string): Boolean;
begin
  try
    TFile.Copy(ACopyItem.SourceFullFilename, ACopyItem.DestinationFullFilename, True);

    Result := True;
  except
    on E: Exception do
    begin
      Result := False;

      AErrorString := Format('Exception %s occurred while copying file "%s" with error message: "%S" ', [E.ClassName,
        ACopyItem.SourceFullFilename, E.Message])
    end;
  end;
end;

function MessageByCompareResult(const ACopyItem: TCopyItem; const ACompareResult: Integer): string;
begin
  if ACompareResult > 0 then
    Result := '  - Source file newer, [Source=' +  ACopyItem.SourceVersion + '] > [Destination='  + ACopyItem.DestinationVersion + ']'
  else if ACompareResult < 0 then
    Result := '  - Destination file newer, [Source=' +  ACopyItem.SourceVersion + '] < [Destination='  + ACopyItem.DestinationVersion + ']'
  else
    Result := '  - Versions are equal, [Source=' +  ACopyItem.SourceVersion + '] == [Destination='  + ACopyItem.DestinationVersion + ']';
end;

var
  LCopyItem: TCopyItem;
  LErrorString: string;
  LCompareResult: Integer;
begin
  try
    if ParseCommadLine(LCopyItem, LErrorString) then
    begin
      LCopyItem.SourceVersion := GetFileVersion(LCopyItem.SourceFullFilename);
      LCopyItem.DestinationVersion := GetFileVersion(LCopyItem.DestinationFullFilename);

      LCompareResult := CompareVersionNumbers(LCopyItem.SourceVersion, LCopyItem.DestinationVersion);
      WriteLn(MessageByCompareResult(LCopyItem, LCompareResult));

      if (LCompareResult > 0) and DoCopy(LCopyItem, LErrorString) then
        WriteLn('  - Source file copied successfully to: "' + LCopyItem.DestinationPath + '"');
    end
    else
    begin
      WriteLn('');
      WriteLn('ERROR: ');
      WriteLn('  ' +  LErrorString);
      WriteLn('');
    end;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      ExitCode := 666;
    end;
  end;

{$IFDEF DEBUG}
  // If debug version, wait for user input
  WriteLn('');
  WriteLn('Press enter to exit');

  ReadLn;
{$ENDIF}
end.
