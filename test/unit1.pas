unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, pqconnection, FileUtil, Forms,
  Controls, Graphics, Dialogs, StdCtrls, DataSetInputAdaptor, XMLOutputAdaptor;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    DataSetInputAdaptor1: TDataSetInputAdaptor;
    IBConnection1: TIBConnection;
    PQConnection1: TPQConnection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    XMLOutputAdaptor1: TXMLOutputAdaptor;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  DataSetInputAdaptor1.Execute;
 // IBConnection1.Connected:= True;
end;

end.

