program c03a04;

const
  PATH_FLORES = './data.flores.bin';
 
type
  String45 = String[45];

  TFlor = record
    id: Integer;
    nombre: String45;
  end;

  FFlores = file of TFlor;


//* HELPERS

procedure imprimir(t: TFlor);
begin
  WriteLn('{ id: ', t.id:4, ', nombre: ', t.nombre:12, ' }');
end;

procedure leer(var t: TFlor);
begin
  Write('id: '); ReadLn(t.id);
  if (t.id > 0) then begin
    Write('nombre: '); ReadLn(t.nombre);
  end;  
  WriteLn();
end;


//* CONSIGNAS

procedure agregarFlor(var f: FFlores; id: Integer; nombre: String45);
var cabecera, t: TFlor;
begin
  Reset(f);

  t.id := id;
  t.nombre := nombre;

  Read(f, cabecera);
  if (cabecera.id = 0) then begin
    Seek(f, FileSize(f));
    Write(f, t);
  end else begin
    Seek(f, cabecera.id * -1);  Read(f, cabecera);
    Seek(f, FilePos(f) - 1);    Write(f, t);
    Seek(f, 0);                 Write(f, cabecera);
  end;

  Close(f);
end;

procedure imprimir(var f: FFlores);
var t: TFlor;
begin
  Reset(f);
  while (not Eof(f)) do begin
    Read(f, t);
    if (t.id > 0) then imprimir(t);
  end;
  Close(f);
end;


//* OPCIONES

procedure opcionAgregarFlores(var f: FFlores);
var t: TFlor;
begin
  leer(t);
  while (t.id > 0) do begin
    agregarFlor(f, t.id, t.nombre);
    leer(t);
  end;
end;


//* PROGRAMA PRINCIPAL

var
  flores: FFlores;
  opcion: Char;
begin
  Assign(flores, PATH_FLORES);

  repeat
    WriteLn('Elija una opción');
    WriteLn('  1. Imprimir');
    WriteLn('  2. Agregar flores');
    WriteLn('  0. Salir');
    Write(' > '); ReadLn(opcion);
    WriteLn(); WriteLn();

    case opcion of
      '1': imprimir(flores);
      '2': opcionAgregarFlores(flores);
      '0': WriteLn('Saliendo del programa...');
      else WriteLn('Opción inválida');
    end;
    WriteLn(); WriteLn();
  until opcion = '0';
end.
