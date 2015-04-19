unit frame_diod_embed;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls;

type

  { TFrame1 }

  TFrame1 = class(TFrame)
    Image1: TImage;
    DiodNum: TLabel;
    Volt: TLabeledEdit;
    Temp: TLabeledEdit;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

end.

