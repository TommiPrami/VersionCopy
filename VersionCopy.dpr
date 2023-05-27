program VersionCopy;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  VersionUnit.Utils in 'VersionUnit.Utils.pas',
  VersionUnit.Types in 'VersionUnit.Types.pas',
  VersionUnit.Commandline.Utils in 'VersionUnit.Commandline.Utils.pas';

var
  LCopyItem: TCopyItem;
  LErrorString: string;
begin
  try
    if ParseCommadLine(LCopyItem, LErrorString) then
    begin
      LCopyItem.SourceVersion := GetFileVersion(LCopyItem.SourceFullFilename);
      LCopyItem.DestinationVersion := GetFileVersion(LCopyItem.DestinationFullFilename);


      var LCompareResult := CompareVersionNumbers(LCopyItem.SourceVersion, LCopyItem.DestinationVersion);

      if LCompareResult < 0 then
      begin
        WriteLn('  - Source file newer, Source=' +  LCopyItem.SourceVersion + ' > Destination='  + LCopyItem.DestinationVersion);

      end
      else if LCompareResult > 0 then
        WriteLn('  - Destination file newer, Source=' +  LCopyItem.SourceVersion + ' < Destination='  + LCopyItem.DestinationVersion)
      else
        WriteLn('  - Versions are equal, Source=' +  LCopyItem.SourceVersion + ' =
        + Destination='  + LCopyItem.DestinationVersion);
    end
    else
    begin
      WriteLn('');
      WriteLn('ERROR: ');
      WriteLn('  ' +  LErrorString);
      WriteLn('');
    end;

{$IFDEF DEBUG}
    ReadLn;;
{$ENDIF}
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      ExitCode := 666;
    end;
  end;
end.
