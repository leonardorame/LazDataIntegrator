unit baseoutputadaptor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, tree;

type

  { TBaseOutputAdaptor }

  TBaseOutputAdaptor = class(TComponent)
  private
  public
    procedure Execute(ATree: TFieldData); virtual;
  end;

implementation

{ TBaseOutputAdaptor }

procedure TBaseOutputAdaptor.Execute(ATree: TFieldData);
begin
  raise Exception.Create('TBaseOutputAdaptor.Execute must be overriden.');
end;

end.

