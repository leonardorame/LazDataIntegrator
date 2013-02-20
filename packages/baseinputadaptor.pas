unit baseinputadaptor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, tree, baseoutputadaptor, ComponentEditors, dialogs;

type

  { TOutputAdaptorItem }

  TOutputAdaptorItem = class(TCollectionItem)
  private
    FAdaptor: TBaseOutputAdaptor;
    FEnabled: boolean;
  public
    function GetDisplayName: string; override;
  published
    property Adaptor: TBaseOutputAdaptor read FAdaptor write FAdaptor;
    property Enabled: boolean read FEnabled write FEnabled;
  end;

  { TOutputAdaptors }

  TOutputAdaptors = class(TOwnedCollection)
  private
    function GetItem(AIndex: Integer): TOutputAdaptorItem;
  public
    function Add: TOutputAdaptorItem;
    property Items[AIndex: Integer]: TOutputAdaptorItem read GetItem; default;
  end;

  { TBaseInputAdaptor }

  TBaseInputAdaptor = class(TComponent)
  private
    FOutputAdaptors: TOutputAdaptors;
    FTree: TFieldData;
    procedure SetOutputAdaptors(AValue: TOutputAdaptors);
  protected
    procedure DoBefore; virtual;
    procedure DoAfter;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute;
    property Tree: TFieldData read FTree;
  published
    property OutputAdaptors: TOutputAdaptors read FOutputAdaptors write SetOutputAdaptors;
  end;

  { TBaseInputAdaptorComponentEditor }

  TBaseInputAdaptorComponentEditor = class(TComponentEditor)
  protected
    procedure DoShowEditor;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function  GetVerb(Index: Integer): String; override;
    function  GetVerbCount: Integer; override;
  end;

implementation

{ TOutputAdaptorItem }

function TOutputAdaptorItem.GetDisplayName: string;
begin
  if FAdaptor <> nil then
    Result := FAdaptor.Name
  else
    Result := '';
end;

{ TOutputAdaptors }

function TOutputAdaptors.GetItem(AIndex: Integer): TOutputAdaptorItem;
begin
  Result := TOutputAdaptorItem(inherited GetItem(AIndex));
end;

function TOutputAdaptors.Add: TOutputAdaptorItem;
begin
  Result := TOutputAdaptorItem(inherited Add);
end;

{ TBaseInputAdaptorComponentEditor }

procedure TBaseInputAdaptorComponentEditor.DoShowEditor;
var
  lComponent: TBaseInputAdaptor;
begin
  lComponent := (GetComponent as TBaseInputAdaptor);
  lComponent.Execute;
end;

procedure TBaseInputAdaptorComponentEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: DoShowEditor;
  end;
end;

function TBaseInputAdaptorComponentEditor.GetVerb(Index: Integer): String;
begin
  Result := 'Execute...';
end;

function TBaseInputAdaptorComponentEditor.GetVerbCount: Integer;
begin
  Result:=1;
end;

{ TBaseInputAdaptor }

procedure TBaseInputAdaptor.SetOutputAdaptors(AValue: TOutputAdaptors);
begin
  ShowMEssagE('before');
  FOutputAdaptors.Assign(AValue);
  ShowMEssagE('After');
end;

procedure TBaseInputAdaptor.DoBefore;
begin
  // implemented in ancestor
end;

procedure TBaseInputAdaptor.DoAfter;
var
  I: Integer;
begin
  for I := 0 to FOutputAdaptors.Count - 1 do
  begin
    if FOutputAdaptors[I].Enabled then
      FOutputAdaptors[I].Adaptor.Execute(FTree);
  end;
end;

procedure TBaseInputAdaptor.Execute;
begin
  DoBefore;
  DoAfter;
end;

constructor TBaseInputAdaptor.Create(AOwner: TComponent);
begin
  inherited;
  FTree := TStringFieldData.Create('root');
  FOutputAdaptors := TOutputAdaptors.Create(Self, TOutputAdaptorItem);
end;

destructor TBaseInputAdaptor.Destroy;
begin
  FOutputAdaptors.Free;
  FTree.Free;
  inherited Destroy;
end;

end.

