program c03a02;

const
  PATH_ASISTENTES = './data.asistentes.bin';
  
 
type
  String25 = String[25];
  StringDni = String[8];

  TAsistente = record
    nro: Integer;
    nombre: String25;
    dni: StringDni;
  end;

  FAsistentes = file of TAsistente;


//* IMPRIMIR

procedure imprimir(t: TAsistente);
begin
  WriteLn('{ nro: ', t.nro:4, ', nombre: ', t.nombre:10, ', dni: ', t.dni, ' }');
end;

procedure imprimir(var f: FAsistentes);
var t: TAsistente;
begin
  Reset(f);
  while (not Eof(f)) do begin
    Read(f, t);
    if (t.nombre[1] <> '@') then imprimir(t);
  end;
  WriteLn();
  Close(f);
end;

procedure imprimirTodos(var f: FAsistentes);
var t: TAsistente;
begin
  Reset(f);
  while (not Eof(f)) do begin
    Read(f, t);
    imprimir(t);
  end;
  WriteLn();
  Close(f);
end;


//* BAJAS

procedure eliminarAsistentesNroMenor(var f: FAsistentes; nro: Integer);
var t: TAsistente;
begin
  Reset(f);
  while (not Eof(f)) do begin
    Read(f, t);
    if (t.nro < nro) and (t.nombre[1] <> '@') then begin
      t.nombre := '@' + t.nombre;
      Seek(f, FilePos(f) - 1);
      Write(f, t);
    end;
  end;
  Close(f);
end;



var
  asistentes: FAsistentes;
begin
  Assign(asistentes, PATH_ASISTENTES);

  imprimirTodos(asistentes);
  eliminarAsistentesNroMenor(asistentes, 1000);
  imprimir(asistentes);
end.

{
  - Generar un archivo con registros de longitud fija de 
    asistentes a un congreso
  - Eliminar lógicamente los asistentes con nro de asistente inferior a 1000
  - Hacerlo insertando un caracter especial delante de algún campo string
}