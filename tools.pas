unit Tools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function min  ( a: integer; b: integer) : integer;
function max  ( a: integer; b: integer) : integer;

function hexValue ( ch: char) : integer;
function midstr2 ( str: string; start:integer ; count : integer; var StrOut: shortstring) : integer;

implementation


function min  ( a: integer; b: integer) : integer;
begin
  if a<b then  Result:= a
     else   Result:= b;
end;

function max  ( a: integer; b: integer) : integer;
begin
  if a>b then  Result:= a
     else   Result:= b;
end;


function hexValue ( ch: char) : integer;
begin
  case ch of
  '0': Result:=0;
  '1': Result:=1;
  '2': Result:=2;
  '3': Result:=3;
  '4': Result:=4;
  '5': Result:=5;
  '6': Result:=6;
  '7': Result:=7;
  '8': Result:=8;
  '9': Result:=9;
  'A','a': Result:=10;
  'B','b': Result:=11;
  'C','c': Result:=12;
  'D','d': Result:=13;
  'E','e': Result:=14;
  'F','f': Result:=15;
  end;
end;

function midstr2 ( str: string; start:integer ; count : integer; var StrOut : shortstring) : integer;
var i: integer;
begin
     for i:= start to count do
     begin
       StrOut[i - start + 1]:=str[i] ;

     end;

     StrOut[0]:= chr(count);

end;


end.

