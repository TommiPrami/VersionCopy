unit VersionUnit.Commandline.Utils;

interface

uses
  VersionUnit.Types;

  function ParseCommandLine(var ACopyItem: TCopyItem; out AErrorString: string): Boolean;

implementation

uses
  System.SysUtils;

function ParseCommandLine(var ACopyItem: TCopyItem; out AErrorString: string): Boolean;
const
  COMMAND_LINE_EXAMPLE = 'VersionCopy.exe [Path\]SourceFileName DestinationPath';
var
  LExitCode: Integer;
begin
  LExitCode := 0;

  if ParamCount >= 1 then
    ACopyItem.ParseSourceFullFilename(ParamStr(1))
  else
  begin
    LExitCode := 1;
    AErrorString := COMMAND_LINE_EXAMPLE + ' - Sourcefilename commandline parameter missing';
  end;

  if ParamCount >= 2 then
    ACopyItem.DestinationPath := IncludeTrailingPathDelimiter(ParamStr(2))
  else
  begin
    LExitCode := 2;
    AErrorString := COMMAND_LINE_EXAMPLE + ' - DestinationPath commandline parameter missing';
  end;

  if not FileExists(ACopyItem.SourceFullFilename) then
  begin
    LExitCode := 3;
    AErrorString := Format('Source filename not found: "%s"', [ACopyItem.SourceFullFilename]);
  end;

  if not DirectoryExists(ACopyItem.DestinationPath) then
  begin
    LExitCode := 4;
    AErrorString := Format('Destination path not found: "%s"', [ACopyItem.DestinationPath]);
  end;

  Result := AErrorString.IsEmpty;

  if not Result then
    ExitCode := LExitCode
  else
    ACopyItem.DestinationFullFilename := ACopyItem.DestinationPath + ACopyItem.SourceFilename;
end;

end.
