program c03a08;

const
  PATH_DISTRIBUCIONES = './data.distribuciones.bin';
  VALOR_CORTE = 'zzzz';
 
type
  String25 = String[25];
  StringKernel = String[8];

  TDistribucion = record
    nombre: String25;
    lanzamiento: Integer;
    kernel: StringKernel;
    desarrolladores: Integer;
    descripcion: String;
  end;

  FDistribuciones = file of TDistribucion;


//* HELPERS

procedure leer(var f: FDistribuciones; var t: TDistribucion);
begin
  if (Eof(f)) then t.nombre := VALOR_CORTE else Read(f, t);
end;

procedure leer(var t: TDistribucion);
begin
  Write('nombre: '); ReadLn(t.nombre);
  Write('lanzamiento: '); ReadLn(t.lanzamiento);
  Write('kernel: '); ReadLn(t.kernel);
  Write('desarrolladores: '); ReadLn(t.desarrolladores);
  Write('descripcion: '); ReadLn(t.descripcion);
  WriteLn();
end;

procedure imprimirTodo(var f: FDistribuciones);
var t: TDistribucion;
begin
  Reset(f);
  while (not Eof(f)) do begin
    Read(f, t);
    if (t.desarrolladores > 0) then begin
      Write('{ ');
      Write('nombre: ', t.nombre:10, ', ');
      Write('lanzamiento: ', t.lanzamiento:4, ', ');
      Write('kernel: ', t.kernel:8, ', ');
      Write('desarrolladores: ', t.desarrolladores:4, ', ');
      Write('descripcion: ', t.descripcion:20);
      WriteLn(' }');
    end else begin
      Write('< ');
      Write('nombre: ', t.nombre:10, ', ');
      Write('lanzamiento: ', t.lanzamiento:4, ', ');
      Write('kernel: ', t.kernel:8, ', ');
      Write('desarrolladores: ', t.desarrolladores:4, ', ');
      Write('descripcion: ', t.descripcion:20);
      WriteLn(' >');
    end;
  end;
  WriteLn(); WriteLn();
  Close(f);
end;


//* CONSIGNAS

function existeDistribucion(var f: FDistribuciones; nombre: String25): Boolean;
var t: TDistribucion;
begin
  Reset(f);
  leer(f, t);
  while (
    (t.nombre <> VALOR_CORTE) and 
    (not ((t.nombre = nombre) and (t.desarrolladores > 0)))
  ) do leer(f, t);
  Close(f);
  existeDistribucion := (t.nombre = nombre);
end;

procedure altaDistribucion(var f: FDistribuciones);
var t, cabecera: TDistribucion;
begin
  leer(t);
  if (not existeDistribucion(f, t.nombre)) then begin
    Reset(f);

    leer(f, cabecera);
    if (cabecera.desarrolladores = 0) then begin
      Seek(f, FileSize(f));
      Write(f, t);
    end else begin
      Seek(f, cabecera.desarrolladores * -1); 
      leer(f, cabecera);
      
      Seek(f, FilePos(f) - 1);
      Write(f, t);
      
      Seek(f, 0);
      Write(f, cabecera);
    end;

    Close(f);
    WriteLn('Distribución agregada correctamente');
  end
  else WriteLn('Ya existe la distribución');
end;

procedure bajaDistribucion(var f: FDistribuciones);
var
  t, cabecera: TDistribucion;
  nombreBorrar: String25;
begin
  Write('nombre: '); ReadLn(nombreBorrar);
  if (existeDistribucion(f, nombreBorrar)) then begin
    Reset(f);

    // Leer cabecera
    leer(f, cabecera);

    // Buscar registro a eliminar
    leer(f, t);
    while (
      not ((t.nombre = nombreBorrar) and (t.desarrolladores > 0))
    ) do leer(f, t);
    Seek(f, FilePos(f) - 1);

    // Copiar valor del registro de cabecera en el nuevo registro
    t.desarrolladores := FilePos(f) * -1;
    Write(f, cabecera);
    
    // Actualizar registro de cabecera
    Seek(f, 0);
    Write(f, t);

    Close(f);
    WriteLn('Distribución eliminada correctamente');
  end
  else WriteLn('La distribución no existe');
end;


var
  distribuciones: FDistribuciones;
  opc: Char;
begin
  Assign(distribuciones, PATH_DISTRIBUCIONES);
  repeat
    WriteLn('Elija una opción:');
    WriteLn('  1. Imprimir todo');
    WriteLn('  2. Alta');
    WriteLn('  3. Baja');
    WriteLn('  0. Salir');
    Write('> '); ReadLn(opc);
    WriteLn(); WriteLn();

    case opc of
      '1': imprimirTodo(distribuciones);
      '2': altaDistribucion(distribuciones);
      '3': bajaDistribucion(distribuciones);
      '0': WriteLn('Saliendo del programa...');
      else WriteLn('Opción incorrecta');
    end;
    WriteLn(); WriteLn();
  until opc = '0';
end.

{
  - Archivo con distribuciones de linux
  - nombre como clave primaria
  - Mantener el archivo con bajas lógicas y listas invertidas


  - ExsiteDistribución: Recibe un nombre y devuleve true si existe, false en caso contrario
  
  - Alta distribución: lee los datos de una nueva distribución y la agrega reutilizando el espacio
      - Verificar que no exista usando ExisteDistribución.
      - Si ya existe informar "Ya existe la distribución"
  
  - Baja distribución: baja lógicamente una distribución cuyo nombre se lee por teclado.
      - Se utiliza el campo de cantidad de desarrolladores para mantener la lista invertida
      - Si no existe informar "Distribución no existente"

  ---

  [x] TDistribucion
  [x] FDistribuciones
  [x] existeDistribucion
  [x] altaDistribucion
      [x] leerDistribucion
  [x] BajaDistribucion
  [x] imprimirTodo

  [x] Menu para invocar a los procedimientos de la consigna y para imprimirTodo
}