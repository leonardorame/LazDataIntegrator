unit frmDataTree;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, ButtonPanel, StdCtrls,
  Tree,
  baseoutputadaptor,
  baseinputadaptor;

type

  { TdlgDataTree }

  TdlgDataTree = class(TForm)
    ButtonPanel1: TButtonPanel;
    cmbAdaptors: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    TreeView1: TTreeView;
    TreeView2: TTreeView;
    procedure cmbAdaptorsChange(Sender: TObject);
  private
    FTree: TFieldData;
    FInputAdaptor: TBaseInputAdaptor;
    procedure Initialize;
    procedure FillCmbAdaptors;
    procedure DrawNode(ANode: TFieldData; ATreeView: TTreeView; ATreeNode: TTreeNode);
  public
    class procedure Execute(ATree: TFieldData; AInputAdaptor: TBaseInputAdaptor);
  end;

implementation

{$R *.lfm}

{ TdlgDataTree }

procedure TdlgDataTree.cmbAdaptorsChange(Sender: TObject);
var
  lOutputAdaptor: TBaseOutputAdaptor;
begin
  lOutputAdaptor := cmbAdaptors.Items.Objects[cmbAdaptors.ItemIndex] as TBaseOutputAdaptor;
  lOutputAdaptor.PopulateTree;
  DrawNode(lOutputAdaptor.Tree, TreeView2, nil);
end;

procedure TdlgDataTree.Initialize;
begin
  DrawNode(FTree, TreeView1, nil);
  FillCmbAdaptors;
end;

procedure TdlgDataTree.FillCmbAdaptors;
var
  I: Integer;
  lAdaptor: TOutputAdaptorItem;
begin
  cmbAdaptors.Items.Clear;
  for I := 0 to FInputAdaptor.OutputAdaptors.Count - 1 do
  begin
    lAdaptor := FInputAdaptor.OutputAdaptors[I];
    cmbAdaptors.Items.AddObject(lAdaptor.Adaptor.Name, lAdaptor.Adaptor);
  end;
  if cmbAdaptors.Items.Count > 0 then
  begin
    cmbAdaptors.ItemIndex := 0;
    cmbAdaptorsChange(Self);
  end;
end;

procedure TdlgDataTree.DrawNode(ANode: TFieldData; ATreeView: TTreeView;ATreeNode: TTreeNode);
var
  lNode: TFieldData;
  lTreeNode: TTreeNode;
begin
  lTreeNode := ATreeView.Items.AddChild(ATreeNode, ANode.Name);
  if ANode is TStringFieldData then
    ATreeView.Items.AddChild(lTreeNode, (ANode as TStringFieldData).Value )
  else
  if ANode is TIntegerFieldData then
    ATreeView.Items.AddChild(lTreeNode, IntToStr((ANode as TIntegerFieldData).Value));

  for lNode in ANode.SubItems do
  begin
    DrawNode(lNode, ATreeView, lTreeNode);
  end;
end;

class procedure TdlgDataTree.Execute(ATree: TFieldData; AInputAdaptor: TBaseInputAdaptor);
begin
  with TdlgDataTree.Create(nil) do
  begin
    FTree := ATree;
    FInputAdaptor := AInputAdaptor;
    Initialize;
    ShowModal;
    Free;
  end;
end;

end.

