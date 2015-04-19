unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms,
  Controls, Graphics, Dialogs, ComCtrls,
  frame_diod_embed,
  readfile,
  Tools;


const DiodsCount = 12;
const ColCount = 3;
const LineCount = 4;

const DiodDimX = 180;
const DiodDimY = 140;

type
  { TFormMain }

  TFormMain = class(TForm)
    HeaderControl1: THeaderControl;
    StatusBar1: TStatusBar;
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure HeaderControl1SectionClick(HeaderControl: TCustomHeaderControl;
      Section: THeaderSection);
  private
      { private declarations }
  public


    { public declarations }
  end;


  type TDiods = record
      pFrame  : TFrame1;
      Num     : integer;
      V       : real;
      T       : real;

  end;

type Txy = record
    x: integer;
    y: integer;
    end;


var
  FormMain: TFormMain;
  Diods : array[0..23] of TDiods;
  DiodsCreated : boolean = false;

  FormMainCoordinates: Txy ;


implementation

{$R *.lfm}

{ TFormMain }

procedure Init();
begin

  FormMainCoordinates.x :=0 ;
  FormMainCoordinates.y :=0 ;

end;

procedure DiodPosColLine( DiodNum: integer; var ColNum: integer; var LineNum: integer);
begin

  ColNum :=  ( ( DiodNum - 1)   div LineCount ) + 1 ;
  LineNum :=  ( ( DiodNum - 1 )  mod LineCount ) + 1 ;


end;

procedure DiodPosXY( DiodNum:integer; var x: integer; var y: integer);
var
    SpacesX: integer;
    SpacesY: integer;
    ColNum, LineNum: integer;
begin

  with   FormMainCoordinates do
  begin
       SpacesX := ( x - ( ColCount * DiodDimX ) ) div ( ColCount + 1 );
       SpacesY := ( y - ( LineCount * DiodDimY ) ) div ( LineCount + 1 ) ;

  end;

  ColNum :=0; LineNum:=0;
  DiodPosColLine(DiodNum, ColNum, LineNum);

  x :=  max ( SpacesX * ColNum  +  ( ColNum - 1 ) * DiodDimX , 30);
  y :=  max ( SpacesY * LineNum +  ( LineNum - 1 ) * DiodDimY , 30);


end;

procedure CreateDiods()   ;

var i, x, y : integer;
begin



  if DiodsCreated then exit;


  x:=0;  y:=0;

  for i:= 0 to ( DiodsCount - 1 ) do
    begin
         DiodPosXY (i + 1, x, y ) ;
         Diods[i].pFrame        :=  TFrame1.Create(nil);
         Diods[i].pFrame.Parent :=  FormMain;
         Diods[i].pFrame.Left   :=  x;
         Diods[i].pFrame.Top    :=  y ;
         Diods[i].pFrame.DiodNum.Caption := IntToStr ( i + 1  ) ;

         //Diods[0].pFrame.Visible := True;
         //Diods[0].pFrame.Show;
    end;

    DiodsCreated := True;

end;


procedure DeleteDiods();
var i:integer;
begin
  if not DiodsCreated then exit;

  for i:= 0 to ( DiodsCount - 1 ) do
    begin
         Diods[i].pFrame.Free;

    end;

  DiodsCreated := false;

end;


procedure DataGet();
var
    i     :integer;
begin
  // файл или девайс
  //SetLength(str, 2000);

  datafile_get();

  for i:= 0 to ( DiodsCount - 1 ) do
  begin
       Diods[i].V                 := DiodParamFromStr( i + 1, 'V' );
       Diods[i].T                 := DiodParamFromStr( i + 1, 'T' );
       Diods[i].pFrame.Volt.Text  := FloatToStr(Diods[i].V);
       Diods[i].pFrame.Temp.Text  := FloatToStr(Diods[i].T);

  end;

end;

procedure TFormMain.HeaderControl1SectionClick(
  HeaderControl: TCustomHeaderControl; Section: THeaderSection);
begin

  //if FormMainCoordinates.x =0  then       // всегда, окно меняется
     with FormMainCoordinates do
          begin
               x:= FormMain.Width;
               y:= FormMain.Height;
          end;

  StatusBar1.Panels [0].Text := 'режим: ' + IntToStr (Section.Index) ;

     // надо обрабатывать секцию

  case    Section.Index of
  0:  CreateDiods()  ;
  1:    ;
  2:    ;
  3:  DeleteDiods()  ;
  4:  DataGet()  ;
  5:  Application.Terminate  ;
  end;



end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  // надо макс окно, + получить размеры

  Init();

  FormMain.WindowState:=wsMaximized;

  //FormMain.Refresh;               -- ?? глючит

  StatusBar1.Panels [0].Text := 'Form x,y: ' + IntToStr (FormMain.Width)  + ' x ' + IntToStr(FormMain.Height) ;

end;

procedure TFormMain.FormResize(Sender: TObject);
begin

    with FormMainCoordinates do
          begin
               x:= FormMain.Width;
               y:= FormMain.Height;
          end;

    DeleteDiods()  ;
    CreateDiods()  ;

end;

procedure TFormMain.FormClick(Sender: TObject);
begin

    StatusBar1.Panels [0].Text := 'Form x,y: ' + IntToStr (FormMain.Width)  + ' x ' + IntToStr(FormMain.Height) ;


end;

end.

