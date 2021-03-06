unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  IdTCPServer, IdCustomTCPServer, IdContext;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    IdTCPServer1: TIdTCPServer;
    Memo1: TMemo;
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IdTCPServer1Connect(AContext: TIdContext);
    procedure IdTCPServer1Disconnect(AContext: TIdContext);
    procedure IdTCPServer1Execute(AContext: TIdContext);
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

function ServerReceiveFile(AContext: TIdContext; ServerFilename: String;
  var ClientFilename: String): Boolean;
var
  AStream: TFileStream;
begin
  try
    Result := True;
    AStream := TFileStream.Create(ServerFilename, fmCreate + fmShareDenyNone);
    try
      AContext.Connection.IOHandler.ReadStream(AStream, -1, True);
    finally
      FreeAndNil(AStream);
    end;
  except
    Result := False;
  end;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  IdTCPServer1.Active := CheckBox1.Checked;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    IdTCPServer1.Bindings.Add.IP   := '127.0.0.1';
  IdTCPServer1.Bindings.Add.Port := 6000;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  IdTCPServer1.Active := False;
end;

procedure TForm1.IdTCPServer1Connect(AContext: TIdContext);
begin
  Memo1.Lines.Add('A Client connected');
end;

procedure TForm1.IdTCPServer1Disconnect(AContext: TIdContext);
begin
 Memo1.Lines.Add('A Client disconnected');
end;

procedure TForm1.IdTCPServer1Execute(AContext: TIdContext);
var
  LSize: LongInt;
  file1, file2 :  String;
begin
  Memo1.Lines.Add('Server  starting  .... ' );
  AContext.Connection.IOHandler.ReadTimeout := 9000;
  //AContext.Connection.IOHandler.ReadTimeout := 100000;
  file1:= Edit1.Text;
  if ( ServerReceiveFile(AContext, file1, file2) = False ) then
  begin
   Memo1.Lines.Add('Cannot get file from client, Unknown error occured');
    Exit;
  end
  else
  begin
    Memo1.Lines.Add('Server  done, client file -> ' + file2 );
  end;
  Memo1.Lines.Add('File received' );
end;

end.

