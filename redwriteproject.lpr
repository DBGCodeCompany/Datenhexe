program redwriteproject;

uses
classes,sysutils;

var
  bits,rbits:array of boolean;
  rbytes,bytes:array of byte;
  onebyte:byte;
  i,n,le:integer;
  filestream:TFilestream;

  type
    Tarrayofbool=array of boolean;
    Tarrayofbyte=array of byte;


  function bitstostr(bitdata:array of boolean):string;
  var
    i:integer;
    begin
      result:='';
      for i:=0 to high(bitdata)do begin
        if bitdata[i]=true then result:=result+'1' else result:=result+'0';
      end;
    end;

function potenz(basis,exponent:byte):byte;
var
  i:byte;
  begin
    if exponent=0 then result:=1
    else begin
      result:=1;
      for i:=1 to exponent do result:=result*basis;
      end;
    end;

function deztobin(dezi:Tarrayofbyte):Tarrayofbool;
var
  i,n,rest:byte;
  thebits:array of boolean;
  begin
    setlength(thebits,length(dezi)*8);
    for i:=0 to high(dezi) do begin
      if dezi[i]<>0 then  begin
      rest:=dezi[i];
      n:=0;
      repeat
        if ((rest mod 2)=1) then thebits[7*(i+1)-n]:=true
        else thebits[7*(i+1)-n]:=false;
        rest:=rest div 2;
        inc(n);
        until rest=0;
      end
      else writeln('Fehler, byte war null!');
    end;
    result:=copy(thebits);
  end;

begin
  writeln('Bitte länge der zu erstellenden daten angeben: ');
  readln(le);
{-----------------------erstellen----------------------------------------------}
  setlength(bits,le);
  i:=0;
  repeat
    bits[i]:=true;
    i:=i+2;
  until i>=le ;
  i:=1;
  repeat
    bits[i]:=false;
    i:=i+2;
  until i>=le ;
  {--------------------ergänzen-----------------------------------------}
  i:=0;
  if length(bits) mod 8<>0 then begin
  repeat
    setlength(bits,length(bits)+1);
    bits[high(bits)]:=false;
    inc(i);
  until length(bits) mod 8=0;
  end;
  writeln(inttostr(i)+' Nullen ergänzt');
 {------------------speichern--------------------------------------------------}
  writeln('Länge von bits: '+inttostr(length(bits)));
  filestream:=TFilestream.create('boldaten.leo',fmCreate);
  try
  Filestream.WriteBuffer(bits,SizeOf(bits));
  except
    Writeln('Fehler beim schreiben der Datei.');
  end;
  filestream.free;
  {----------------laden-------------------------------------------------------}
  filestream:=TFilestream.create('boldaten.leo',fmOpenRead);
  try
  setlength(rbits,filestream.size);
  filestream.ReadBuffer(rbits,filestream.size);
  except
    Writeln('Fehler beim lesen der Datei.');
  end;
  filestream.free;

  Writeln('Länge von rbits: '+inttostr(length(rbits)));
  writeln('RBits: '+bitstostr(rbits));
  {-------------------in bytes schreiben---------------------------------------}
  setlength(bytes,0);
  i:=-1;
  repeat
    inc(i);
    setlength(bytes,length(bytes)+1);
    onebyte:=0;
    for n:=0 to 7 do begin
      if bits[i+n]=true then begin
        onebyte:=onebyte+potenz(2,n);
        end;
      end;
    bytes[i]:=onebyte;
    until length(bits)-((i+1)*8)<=0;
  writeln('Länge von bytes: '+inttostr(length(bytes)));
  writeln('Zur kontrolle bytes[1]: '+inttostr(bytes[1]));
 {-------------------speichern-----------------------------------------------}
  filestream:=TFilestream.create('kompdaten.leo',fmCreate);
  try
  Filestream.WriteBuffer(bytes,SizeOf(bytes));
  except
    Writeln('Fehler beim schreiben der Datei kompdaten.');
  end;
  filestream.free;
  {----------------laden-------------------------------------------------------}
  filestream:=TFilestream.create('kompdaten.leo',fmOpenRead);
  try
  setlength(rbytes,filestream.size);
  filestream.ReadBuffer(rbytes,filestream.size);
  except
    Writeln('Fehler beim lesen der Datei kompdaten.');
  end;
  filestream.free;

  Writeln('Länge von rbytes: '+inttostr(length(rbytes)));
  writeln('Zur kontrolle rbytes[1]: '+inttostr(rbytes[1]));
  rbits:=deztobin(rbytes);
  writeln('Länge von rbits: '+inttostr(length(rbits)));
  writeln('rbits: '+bitstostr(rbits));

  readln;

end.

