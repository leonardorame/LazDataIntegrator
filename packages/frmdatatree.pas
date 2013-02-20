unit frmDataTree;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ComCtrls, Tree;

type

  { TdlgDataTree }

  TdlgDataTree = class(TForm)
    TreeView1: TTreeView;
  private
    procedure DrawNode(ANode: TFieldData; ATreeNode: TTreeNode);
  public
    class procedure Execute(ATree: TFieldData);
  end;

implementation

{$R *.lfm}

{ TdlgDataTree }

procedure TdlgDataTree.DrawNode(ANode: TFieldData; ATreeNode: TTreeNode);
var
  lNode: TFieldData;
  lTreeNode: TTreeNode;
begin
  lTreeNode := TreeView1.Items.AddChild(ATreeNode, ANode.Name);
  if ANode is TStringFieldData then
    TreeView1.Items.AddChild(lTreeNode, (ANode as TStringFieldData).Value )
  else
  if ANode is TIntegerFieldData then
    TreeView1.Items.AddChild(lTreeNode, IntToStr((ANode as TIntegerFieldData).Value));

  for lNode in ANode.SubItems do
  begin
    DrawNode(lNode, lTreeNode);
  end;
end;

class procedure TdlgDataTree.Execute(ATree: TFieldData);
begin
  with TdlgDataTree.Create(nil) do
  begin
    DrawNode(ATree, nil);
    ShowModal;
    Free;
  end;
end;

end.

