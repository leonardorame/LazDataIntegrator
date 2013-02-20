unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, fgl;

type

  { TNodeData }

  TNode = class;

  TSubItems = specialize TFPGList<TNode>;

  TNode = class
  private
    FCaption: string;
    FSubItems: TSubItems;
  public
    constructor Create(ACaption: string);
    destructor Destroy; override;
    property Caption: string read FCaption write FCaption;
    property SubItems: TSubItems read FSubItems write FSubItems;
  end;


  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
  private
    procedure DrawTree(ABaseNode: TNode);
  public
    { public declarations }
  end;


var
  Form1: TForm1;

implementation

{ TNodeData }

constructor TNode.Create(ACaption: string);
begin
  FCaption:= ACaption;
  FSubItems := TSubItems.Create;
end;

destructor TNode.Destroy;
begin
  FSubItems.Free;
  inherited Destroy;
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  lNode: TNode;
  lSubNode: TNode;
  lItem: Integer;
begin
  lNode := TNode.Create('root');
  lItem := lNode.SubItems.Add(TNode.Create('a1'));
  lNode.SubItems[lItem].SubItems.Add(TNode.Create('a11'));

  lItem := lNode.SubItems.Add(TNode.Create('a2'));

  DrawTree(lNode);
end;

procedure TForm1.DrawTree(ABaseNode: TNode);

  procedure DrawNode(ANode: TNode; ATreeNode: ComCtrls.TTreeNode);
  var
    lNode: TNode;
    lTreeNode: ComCtrls.TTreeNode;
  begin
    lTreeNode := TreeView1.Items.AddChild(ATreeNode, ANode.Caption);

    for lNode in ANode.SubItems do
    begin
      DrawNode(lNode, lTreeNode);
    end;
  end;

begin
  DrawNode(ABaseNode, nil);
end;

end.





