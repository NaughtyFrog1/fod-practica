program pruebasStrings;

var
  str, emptyStr: String[10];
  i: Integer;
begin
  emptyStr := '';
  str :=      'ABC D';
  //           12345

  WriteLn(); WriteLn();

  WriteLn('str: "', str, '"');
  WriteLn('Length(str): ', Length(str));
  WriteLn();
  WriteLn('emptyStr: "', emptyStr, '"');
  WriteLn('Length(emptyStr): ', Length(emptyStr));

  WriteLn(); WriteLn();

  // for i := -21 to -10 do WriteLn('str[', i, ']:  "',   str[i], '",  ', Ord(str[i]));
  // for i :=  -9 to  -1 do WriteLn('str[', i, ']:   "',  str[i], '",  ', Ord(str[i]));
  // for i :=   0 to   9 do WriteLn('str[', i, ']:    "', str[i], '",  ', Ord(str[i]));
  // for i :=  10 to  21 do WriteLn('str[', i, ']:   "',  str[i], '",  ', Ord(str[i]));
  for i := 1 to Length(str) do WriteLn('str[', i, ']:  "',  str[i], '",  ', Ord(str[i]));

  WriteLn(); WriteLn();

  str := '@' + str;
  WriteLn('str: ', str);
  WriteLn();
  Delete(str, 1, 1);
  WriteLn('str: ', str);
end.

{
  - Los strings empiezan por 1.

  - Si se intenta acceder a una poscición inválida del string, no da error.
    str[-4], str[280] -> No dan error

  - Length(str) devuelve la longitud del string. 0 si es vacío.

  - Delete(str, start, end)
    Elimina los caracteres desde `start` hasta `end` (inclusive)
}