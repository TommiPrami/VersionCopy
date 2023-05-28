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

      AErrorString := Format('Exception %s occured while copying file "%s" with error message: "%S" ', [E.ClassName,
        ACopyItem.SourceFullFilename, E.Message])
    end;
  end;
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

      if LCompareResult > 0 then
      begin
        WriteLn('  - Source file newer, [Source=' +  LCopyItem.SourceVersion + '] > [Destination='  + LCopyItem.DestinationVersion + ']');

        if DoCopy(LCopyItem, LErrorString) then
          WriteLn('  - Source file copied successfully to: "' + LCopyItem.DestinationPath + '"');
      end
      else if LCompareResult < 0 then
        WriteLn('  - Destination file newer, [Source=' +  LCopyItem.SourceVersion + '] < [Destination='  + LCopyItem.DestinationVersion + ']')
      else
        WriteLn('  - Versions are equal, [Source=' +  LCopyItem.SourceVersion + '] == [Destination='  + LCopyItem.DestinationVersion + ']');
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

// If debug version, wait for user input
{$IFDEF DEBUG}
  ReadLn;
{$ENDIF}
end.
