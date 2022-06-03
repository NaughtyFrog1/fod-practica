program c03a03;

const
  PATH_NOVELAS = './data.novelas.bin';
  PATH_TXT = './data.novelas.txt';
 
type
  String25 = String[25];

  TNovela = record
    id: Integer;
    nombre: String25;
    genero: String25;
    duracion: Integer;
  end;

  FNovelas = file of TNovela;


//* HELPERS

procedure escribir(var txt: Text; t: TNovela);
begin
  WriteLn(txt, t.id);
  WriteLn(txt, t.nombre);
  WriteLn(txt, t.genero);
  WriteLn(txt, t.duracion);
  WriteLn(txt);
end;

procedure imprimir(t: TNovela);
begin
  Write('{ ');
  Write('id: ', t.id:3, ', ');
  Write('nombre: ', t.nombre:25, ', ');
  Write('genero: ', t.genero:10, ', ');
  Write('duración: ', t.duracion:2);
  WriteLn(' }');
end;

procedure leer(var t: TNovela);
begin
  Write('id: '); ReadLn(t.id);
  Write('nombre: '); ReadLn(t.nombre);
  Write('genero: '); ReadLn(t.genero);
  Write('duracion: '); ReadLn(t.duracion);
  WriteLn();
end;

procedure leer(var t: TNovela; id: Integer);
begin
  WriteLn('id:', id);
  Write('nombre: '); ReadLn(t.nombre);
  Write('genero: '); ReadLn(t.genero);
  Write('duracion: '); ReadLn(t.duracion);
  WriteLn();
end;

function setNovela(
  id: Integer;
  nombre: String25;
  genero: String25;
  duracion: Integer
): TNovela;
var t: TNovela;
begin
  t.id := id;
  t.nombre := nombre;
  t.genero := genero;
  t.duracion := duracion;
  setNovela := t;
end;


//* OPCIONES

// Opción 1
procedure opcionCrearArchivo(var f: FNovelas);
var opcion: Char;
begin  
  repeat
    WriteLn('¿Seguro que desea crear el archivo de novelas? y/n'); 
    Write('> '); ReadLn(opcion);
    WriteLn();
  until (opcion = 'y') or (opcion = 'n');
  WriteLn();

  if (opcion = 'y') then begin
    Rewrite(f);
    WriteLn('Creando archivo de novelas...');
    
    // Crear cabecera del archivo
    Write(f, setNovela(0, '', '', 0));

    // Crear novelas
    Write(f, setNovela( 1, 'Brooklyn Nine-Nine', 'Sitcom',   8));
    Write(f, setNovela( 6, 'The Sopranos',       'Mafia',    6));
    Write(f, setNovela( 2, 'The Good Place',     'Sitcom',   4));
    Write(f, setNovela( 7, 'Arcane',             'Fantasia', 1));
    Write(f, setNovela( 3, 'The Office',         'Sitcom',   9));
    Write(f, setNovela( 8, 'Okupas',             'Realidad', 1));
    Write(f, setNovela( 4, 'Community',          'Sitcom',   6));
    Write(f, setNovela( 9, 'El reino',           'Politica', 1));
    Write(f, setNovela( 5, 'Seinfeld',           'Sitcom',   9));
    Write(f, setNovela(10, 'Breaking Bad',       'Drama',    5));

    WriteLn('Archivo de novelas creado');
    Close(f);
  end else WriteLn('Operación abortada');
  WriteLn(); WriteLn();
end;

// Opción 2
procedure opcionAgregarNovela(var novelas: FNovelas);
var
  novela, cabecera: TNovela;
begin
  Reset(novelas);
  
  leer(novela);
  Read(novelas, cabecera);
  if (cabecera.id = 0) then begin
    Seek(novelas, FileSize(novelas));
    Write(novelas, novela);
  end else begin
    Seek(novelas, cabecera.id * -1);      Read(novelas, cabecera);
    Seek(novelas, FilePos(novelas) - 1);  Write(novelas, novela);
    Seek(novelas, 0);                     Write(novelas, cabecera);
  end;

  Close(novelas);
end;

// Opción 3
procedure opcionModificarNovela(var novelas: FNovelas);
var 
  novela: TNovela;
  id: Integer;
begin
  Reset(novelas);

  // Leer id novela a buscar
  Write('id: '); ReadLn(id);

  // Buscar novela
  Read(novelas, novela);
  while ((not Eof(novelas)) and (novela.id <> id)) do Read(novelas, novela);

  if (novela.id = id) then begin
    imprimir(novela);
    leer(novela, id);

    Seek(novelas, FilePos(novelas) - 1);
    Write(novelas, novela);
  end
  else WriteLn('No se encontró la novela');
  WriteLn(); WriteLn(); 

  Close(novelas);
end;

// Opción 4
procedure opcionEliminarNovela(var novelas: FNovelas);
var
  novela, cabecera: TNovela;
  id: Integer;
begin
  Reset(novelas);

  // Leer id novela a buscar
  Write('id: '); ReadLn(id);

  // Guardar registro de cabecera
  Read(novelas, cabecera);

  // Buscar novela
  if (not Eof(novelas)) then Read(novelas, novela);
  while ((not Eof(novelas)) and (novela.id <> id)) do Read(novelas, novela);

  // Si existe, borrar novela
  if (novela.id = id) then begin
    imprimir(novela);

    Seek(novelas, FilePos(novelas) - 1);
    novela.id := FilePos(novelas) * -1;   // Guardar NRR
    Write(novelas, cabecera);

    Seek(novelas, 0);
    Write(novelas, novela);
    WriteLn('Novela eliminada correctamente');
  end
  else WriteLn('No se encontró la novela');
  WriteLn(); WriteLn();

  Close(novelas);
end;

// Opción 5
procedure opcionExportarNovelas(var novelas: FNovelas; var txt: Text);
var t: TNovela;
begin
  Reset(novelas); Rewrite(txt);
  while (not Eof(novelas)) do begin
    Read(novelas, t);
    escribir(txt, t);
  end;
  Close(novelas); Close(txt);
end;


//* OPCIONES PRUEBAS

// Opción a
procedure opcionImprimirTodo(var f: FNovelas);
var t: TNovela;
begin
  Reset(f);
  while (not Eof(f)) do begin
    Read(f, t);
    imprimir(t);
  end;
  Close(f);
end;

// Opción b
procedure opcionImprimir(var f: FNovelas);
var t: TNovela;
begin
  Reset(f);
  while (not Eof(f)) do begin
    Read(f, t);
    if (t.id > 0) then imprimir(t);
  end;
  Close(f);
end;

//* PROGRAMA PRINCIPAL

var
  novelas: FNovelas;
  txt: Text;
  opcion: Char;
begin
  Assign(novelas, PATH_NOVELAS);
  Assign(txt, PATH_TXT);

  repeat
    WriteLn('Elija una opción: ');
    WriteLn('  1. Crear archivo de novelas');
    WriteLn('  2. Dar de alta una novela');
    WriteLn('  3. Modificar una novela');
    WriteLn('  4. Eliminar una novela');
    WriteLn('  5. Exportar novelas');
    WriteLn('  <------------------------->');
    WriteLn('  a. Imprimir todo');
    WriteLn('  b. Imprimir');
    WriteLn('  0. Salir');
    Write('> '); ReadLn(opcion);
    WriteLn(); WriteLn(); WriteLn();

    case opcion of
      '1': opcionCrearArchivo(novelas);
      '2': opcionAgregarNovela(novelas);
      '3': opcionModificarNovela(novelas);
      '4': opcionEliminarNovela(novelas);
      '5': opcionExportarNovelas(novelas, txt);
      'a': opcionImprimirTodo(novelas);
      'b': opcionImprimir(novelas);
      '0': WriteLn('Saliendo del programa...');
      else WriteLn('Opción incorrecta');
    end;
    WriteLn(); WriteLn(); WriteLn();
  until (opcion = '0');
end.

{
  - Programa que genere archivo de novelas filamadas

  [x] a.   Crear el archivo a partir de datos ingresados por teclado
  [x] b.1. Dar de alta una novela, insertar reasignando el espacio.
  [x] b.2. Modificar los datos de una novela
  [x] b.3. Eliminar una novela

  - Utilizar la técnica de lista invertida para recuperar espacio
  - Usar el campo id como enlace
  - El campo de enlace de la lista se debe especificar los números de registros
    referenciados con signo negativo

  [ ] exportar novelas
  [x] imprimir todo
  [x] imprimir
}