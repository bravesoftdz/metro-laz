unit readfile;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  //strutils,
  Tools;

function datafile_get() : boolean;
function DiodParamFromStr(DiodNum: integer; ParamType : char) : integer;


type  TFormatInStrDiod = packed record

  Name     : string[3];
  V        : string[4];
  T        : string[4];
  Status    : string[2];

end;


 TFormatInStr = packed record

  StartCode   : string[5];
  DiodParam   : string[156];   //DiodParam   : array[12] of TDiodParam; //array[12] of string[13];
  Vcom        : string[4];
  StopCode    : string[3];


end;

 var
      ReadBuffer       : array[0..255] of char;


implementation


function ReadBuffer_str(start: integer; count: integer) : string;
var str: string;
     i: integer;
begin
  str:='';

  for i:= start to start + count - 1 do
  begin
       str:=str +   ReadBuffer[i];

  end;
  Result:= str;

end;

function datafile_get() : boolean;

var    F                : file of char;
       ch1              : char;
       i                : integer;


begin

  AssignFile(F, 'test001.txt');
  ReSet(F);

  i:=1;   // вроде в паскале с единицы ))

  while not eof(F)  and (i < 255) do
  begin
       read(F,ch1);
       ReadBuffer[i] :=  ch1;
       i:= i + 1;

  end;

  CloseFile(F);

  Result:=   true;

end;


function StrHexToInt(str: string) :integer;
var
         val1: integer;
         i: integer;
         dimension: integer;

begin

  val1:=0;
  dimension := Length(str);

  for i:= 1 to dimension  do
  begin
       case  i of
       1: val1 := val1 +          hexValue(str[dimension - i + 1]);
       2: val1 := val1 + 16 *     hexValue(str[dimension - i + 1]);
       3: val1 := val1 + 256 *    hexValue(str[dimension - i + 1]);
       4: val1 := val1 + 4096 *   hexValue(str[dimension - i + 1]);
       end;


  end;

  Result:= val1;
end;

function DiodParamFromStr(DiodNum: integer; ParamType : char) : integer;
var  PFormatInStr              : ^TFormatInStr;
     PFormatInStrDiod          : ^TFormatInStrDiod;
     str1 , str2               : string ;
     StartOffset               : integer;


begin
     //PFormatInStr := @str;
     //PFormatInStrDiod := @(PFormatInStr^.DiodParam);
     //str1:=     PFormatInStrDiod^.V;
  {
  case  ParamType of
  'V' : Result:=  StrHexToInt(PFormatInStrDiod^.V);
  'T' : Result:=  StrHexToInt(PFormatInStrDiod^.T);
  'S' : Result:=  StrHexToInt(PFormatInStrDiod^.Status);
  else
    Result:=0;
  end;
  }

    StartOffset:= 5 + (DiodNum - 1 ) * 13 + 1;

      case  ParamType of
     'V' : Result:=  StrHexToInt(ReadBuffer_str( StartOffset + 3, 4) );
     'T' : Result:=  StrHexToInt(ReadBuffer_str( StartOffset + 7, 4) ) ;
     'S' : Result:=  StrHexToInt(ReadBuffer_str( StartOffset + 11, 2) ) ;
     else
       Result:=0;
     end;



end;

end.

