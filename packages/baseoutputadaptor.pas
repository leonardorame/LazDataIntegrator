unit baseoutputadaptor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, tree;

type

  { TBaseOutputAdaptor }

  TBaseOutputAdaptor = class(TComponent)
  private
    FTree: TFieldData;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PopulateTree; virtual;
    procedure Execute(ATree: TFieldData); virtual;
    property Tree: TFieldData read FTree;
  end;

implementation

{ TBaseOutputAdaptor }

procedure TBaseOutputAdaptor.PopulateTree;
begin
  raise Exception.Create('TBaseOutputAdaptor.PopulateTree must be overriden.');
end;

constructor TBaseOutputAdaptor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // each OutputAdaptor has its own FTree
  FTree := TFieldData.Create('root');
end;

destructor TBaseOutputAdaptor.Destroy;
begin
  FTree.Free;
  inherited Destroy;
end;

procedure TBaseOutputAdaptor.Execute(ATree: TFieldData);
begin
  raise Exception.Create('TBaseOutputAdaptor.Execute must be overriden.');
end;

end.

