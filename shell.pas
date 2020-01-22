program shell;
uses BaseUnix, Unix, strings;

type strArr = array[1..200] of string;

procedure prompt;
var i : integer;
begin

	writeln;
  i := BaseUnix.FpGetuid;
  if i = 0 then begin 
    write ('# ')
  end
  else begin
    write ('$ ');
  end; //if
end; //prompt

procedure inLine(var l: string);
begin
  readln(l);
end; //inLine

procedure getSeperateCommands(var str0 : string; var seperated : strArr; var argCount : integer;var ampersand : boolean );
var i,j : integer;
	currStr : string;
begin
	i := 1;
	j := 1;

	while i <> (length(str0) + 1) do
	begin
		if str0[i] <> ' ' then
		begin
			currStr := currStr + str0[i];
			if (str0[i+1] = ' ') OR ((i+1) = (length(str0) + 1)) then
			begin
				seperated[j] := currStr;
				inc(j);
				currStr := '';
			end;
		end;
		inc(i);
	end;
	argCount := j-1;

	if seperated[argcount] = '&' then
		begin
			seperated[argCount] := '';
			argCount := argCount - 1;
			ampersand := true;
		end;

end; //getSeperateCommands

procedure run(var commands: strArr; var argCount : integer);
var
  PP : PPchar;
  P0 : PChar;
  i : integer;
begin
	i:=1;
	GetMem(PP,argCount*SizeOf(Pchar));

	while i <= argCount do
	begin
		P0 := StrAlloc(length(commands[i])+1);
		StrPCopy(P0, commands[i]);
		PP[i-1] := P0;
		inc(i);
	end;

	PP[i-1] := Nil;
	Unix.FpExecVP(commands[1], PP);

end; //run

procedure main;
var
  ampersand : boolean;
  ln : string;
   argCount : integer;
  commands : strArr;
  pid : longint;
begin
  ampersand := false;

  prompt;
  inLine(ln);

  getSeperateCommands(ln, commands, argCount, ampersand);

  pid := BaseUnix.FpFork;

  if pid = 0 then
  	begin
    	run(commands, argCount);
  	end
  else
  	begin
		if ampersand = false then
			begin
				FpWait(pid);
			end
  	end;
main;
end;




begin

  main;

end.
