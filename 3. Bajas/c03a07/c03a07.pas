program c03a07;

const
  VALOR_CORTE = '999999';
  PATH_AVES = './data.aves.bin';
 
type
  String25 = String[25];
  StringId = String[6];

  TAve = record
    id: StringId;
    nombre: String25;
    familia: String25;
    descripcion: String;
    zona: String25;
  end;

  FAves = file of TAve;


//* TESTS

procedure imprimirTodos(var f: FAves);
var t: TAve;
begin
  Reset(f);
  while (not Eof(f)) do begin
    Read(f, t);
    Write('{ ');
    Write('id: ', t.id, ', ');
    Write('nombre: ', t.nombre, ', ');
    // Write('familia: ', t.familia, ', ');
    // Write('descripcion: ', t.descripcion, ', ');
    // Write('zona: ', t.zona);
    WriteLn(' }');
  end;
  WriteLn();
  Close(f);
end;

procedure leer(var t: TAve);
begin
  Write('id: '); ReadLn(t.id);
  if (t.id <> '500000') then begin
    Write('nombre: '); ReadLn(t.nombre);
    // Write('familia: '); ReadLn(t.familia);
    // Write('descripcion: '); ReadLn(t.descripcion);
    // Write('zona: '); ReadLn(t.zona);
  end;
  WriteLn();
end;

procedure crearAves(var f: FAves);
var t: TAve;
begin
  Rewrite(f);
  leer(t);
  while (t.id <> '500000') do begin
    Write(f, t);
    leer(t);
  end;
  Close(f);
end;


//* BORRAR AVES LÓGICAMENTE

procedure leer(var f: FAves; var t: TAve);
begin
  if (Eof(f)) then t.id := VALOR_CORTE else Read(f, t);
end;

procedure borrarAve(var f: FAves; idBorrar: StringId; var ok: Boolean);
var t: TAve;
begin
  Reset(f);

  leer(f, t);
  while ((t.id <> VALOR_CORTE) and (t.id <> idBorrar)) do leer(f, t);

  if (t.id = idBorrar) then begin
    ok := True;
    t.id := '***';
    Seek(f, FilePos(f) - 1);
    Write(f, t);
  end
  else ok := False;
  
  Close(f);
end;

procedure borrarAves(var f: FAves);
var
  idBorrar: StringId;
  ok: Boolean;
begin
  Write('id (500000): '); ReadLn(idBorrar);
  while (idBorrar <> '500000') do begin
    borrarAve(f, idBorrar, ok);
    if (not ok) then WriteLn('El ave no está en el archivo');
    WriteLn();
    Write('id (500000): '); ReadLn(idBorrar);
  end;
end;


//* COMPACTAR ARCHIVO

procedure compactar(var f: FAves);
var
  posBorrar: Integer;
  t: TAve;
begin
  Reset(f);

  leer(f, t);
  while (t.id <> VALOR_CORTE) do begin
    // Buscar registro a borrar
    while ((t.id <> VALOR_CORTE) and (t.id <> '***')) do leer(f, t);

    if (t.id = '***') then begin
      posBorrar := FilePos(f) - 1;
      
      // Buscar último registro válido
      Seek(f, FileSize(f) - 1);
      leer(f, t);
      while (t.id = '***') do begin
        Seek(f, FilePos(f) - 2);
        leer(f, t);
      end;
      Seek(f, FilePos(f) - 1);

      if (posBorrar > FilePos(f)) then begin
        Seek(f, posBorrar);
        Truncate(f);
      end
      else begin
        Truncate(f);
        Seek(f, posBorrar);
        Write(f, t);
      end;
    end;
  end;

  Close(f);
end;


//* PROGRAMA PRINCIPAL

var
  aves: FAves;
begin
  Assign(aves, PATH_AVES);

  WriteLn('crearAves');
  crearAves(aves);
  WriteLn(); WriteLn();

  WriteLn('imprimirTodos');
  imprimirTodos(aves);
  WriteLn(); WriteLn();

  WriteLn('borrarAves');
  borrarAves(aves);
  WriteLn(); WriteLn();

  WriteLn('imprimirTodos');
  imprimirTodos(aves);
  WriteLn(); WriteLn();

  compactar(aves);
  imprimirTodos(aves);
end.


{
  - Archivo desordenado que almacena información de aves
  - Eliminar especies leidas por teclado
    - Procedimiento que marque los registros a borrar
    - Procedimiento que compacte el archivo, quitando los registros marcados
      - Copiar el último registro del archivo en la posición a borar y truncar  
}