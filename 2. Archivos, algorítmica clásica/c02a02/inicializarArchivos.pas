program inicializarArchivos;

const
  VALOR_CORTE = -1;
  PATH_ALUMNOS = 'data.alumnos.bin';
  PATH_MATERIAS = 'data.materias.bin';
 
type
  String25 = String[25];

  TAlumno = record
    id: Integer;
    nombre: String25;
    cursadas: Integer;
    finales: Integer;
  end;

  TMateria = record
    idAlumno: Integer;
    estado: Char;
  end;

  FAlumnos  = file of TAlumno;   // Maestro
  FMaterias = file of TMateria;  // Detalle


procedure inicializarAlumnos(var f: FAlumnos);
var
  t: TAlumno;
begin
  Rewrite(f);
  t.id := 1;  t.nombre := 'Ramirez';   t.cursadas := 0;  t.finales := 0;  Write(f, t);
  t.id := 2;  t.nombre := 'Gonzalez';  t.cursadas := 0;  t.finales := 0;  Write(f, t);
  t.id := 3;  t.nombre := 'Perez';     t.cursadas := 0;  t.finales := 0;  Write(f, t);
  t.id := 4;  t.nombre := 'Romero';    t.cursadas := 0;  t.finales := 0;  Write(f, t);
  t.id := 5;  t.nombre := 'Sanchez';   t.cursadas := 0;  t.finales := 0;  Write(f, t);
  Close(f);
end;


procedure inicializarMaterias(var f: FMaterias);
var
  t: TMateria;
begin
  Rewrite(f);

  // 4 cursadas - 2 finales
  t.idAlumno := 1;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 1;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 1;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 1;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 1;  t.estado := 'f';  Write(f, t);
  t.idAlumno := 1;  t.estado := 'f';  Write(f, t);

  // 6 cursadas - 2 finales
  t.idAlumno := 2;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 2;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 2;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 2;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 2;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 2;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 2;  t.estado := 'f';  Write(f, t);
  t.idAlumno := 2;  t.estado := 'f';  Write(f, t);

  // 6 cursadas - 5 finales
  t.idAlumno := 4;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 4;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 4;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 4;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 4;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 4;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 4;  t.estado := 'f';  Write(f, t);
  t.idAlumno := 4;  t.estado := 'f';  Write(f, t);
  t.idAlumno := 4;  t.estado := 'f';  Write(f, t);
  t.idAlumno := 4;  t.estado := 'f';  Write(f, t);
  t.idAlumno := 4;  t.estado := 'f';  Write(f, t);

  // 3 cursadas - 1 final
  t.idAlumno := 5;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 5;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 5;  t.estado := 'c';  Write(f, t);
  t.idAlumno := 5;  t.estado := 'f';  Write(f, t);

  Close(f);
end;


var
  alumnos: FAlumnos;
  materias: FMaterias;
begin
  Assign(alumnos, PATH_ALUMNOS);
  Assign(materias, PATH_MATERIAS);

  WriteLn();WriteLn();
  WriteLn('Inicializando alumnos');
  inicializarAlumnos(alumnos);
  WriteLn('Inicializando materias');
  inicializarMaterias(materias);

  WriteLn();
  WriteLn('Todos los archivos han sido inicializados satisfactoriamente');
end.