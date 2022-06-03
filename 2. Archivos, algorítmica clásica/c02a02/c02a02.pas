program c02a02;

const
  VALOR_CORTE = -1;
  PATH_ALUMNOS = 'data.alumnos.bin';
  PATH_MATERIAS = 'data.materias.bin';
  PATH_ALUMNOS_FINALES_PENDIENTES = 'data.alumnos_finales_pendientes.txt';
 
type
  String25 = String[25];

  TAlumno = record
    id: Integer;
    nombre: String25;
    cursadas: Integer;
    materias: Integer;
  end;

  TMateria = record
    idAlumno: Integer;
    estado: Char;
  end;

  FAlumnos  = file of TAlumno;   // Maestro
  FMaterias = file of TMateria;  // Detalle


//* HELPERS


procedure leer(var f: FAlumnos; var t: TAlumno);
begin
  if (eof(f)) then t.id := VALOR_CORTE else Read(f, t);
end;

procedure leer(var f: FMaterias; var t: TMateria);
begin
  if (eof(f)) then t.idAlumno := VALOR_CORTE else Read(f, t);
end;


procedure writeAlumno(var txt: Text; t: TAlumno);
begin
  WriteLn(txt, t.id);
  WriteLn(txt, t.nombre);
  WriteLn(txt, t.cursadas);
  WriteLn(txt, t.materias);
  WriteLn(txt);
end;


//* CONSIGNAS

// 2.a
procedure actualizarMaterias(
  var alumnos: FAlumnos;
  var materias: FMaterias
);
var
  alumno: TAlumno;
  materia: TMateria;
begin
  Reset(alumnos); Reset(materias);

  leer(alumnos, alumno);
  while (alumno.id <> VALOR_CORTE) do begin
    leer(materias, materia);
    while (
      (materia.idAlumno <> VALOR_CORTE) and 
      (materia.idAlumno = alumno.id)
    ) do begin
      if (materia.estado = 'f') then alumno.materias += 1
      else if (materia.estado = 'c') then alumno.cursadas += 1;
      leer(materias, materia);
    end;
    Seek(alumnos, FilePos(alumnos) - 1);
    Write(alumnos, alumno);
    leer(alumnos, alumno);
  end;

  Close(alumnos); Close(materias);
end;


// 2.b
procedure exportarAlumnosFinalesPendientes(
  var alumnos: FAlumnos;
  var txt: Text
);
var
  t: TAlumno;
begin
  Reset(alumnos); Rewrite(txt);

  while (not eof(alumnos)) do begin
    Read(alumnos, t);
    if (t.cursadas - t.materias >= 4) then writeAlumno(txt, t);
  end;

  Close(alumnos); Close(txt);
end;


var
  alumnos: FAlumnos;    // Maestro
  materias: FMaterias;  // Detalle
  alumnosFinalesPendientes: Text;
  opcion: Char;
begin
  Assign(alumnos, PATH_ALUMNOS);
  Assign(materias, PATH_MATERIAS);
  Assign(alumnosFinalesPendientes, PATH_ALUMNOS_FINALES_PENDIENTES);
  
  repeat
    WriteLn('Seleccione una opción: ');
    WriteLn('  1. Actualizar materias');
    WriteLn('  2. Exportar alumnos con finales pendientes');
    WriteLn('  0. Salir');
    Write('> '); ReadLn(opcion);
    Write(#13#10#13#10);

    case opcion of
      '1': actualizarMaterias(alumnos, materias);
      '2': exportarAlumnosFinalesPendientes(alumnos, alumnosFinalesPendientes);
      '0': WriteLn('Saliendo del programa...');
      else WriteLn('Opción inválida'); 
    end;
  until opcion = '0';
end.

{
  [x] Archivo maestro con información de alumnos
  [x] Archivo detalle con información de un alumno sobre una materia
  [x] Todos los archivos ordenados por id alumno. El detalle puede tener 
      0 o más registros por cada alumno del maestro.

  [x] Menu de opciones
      [x] Si aprobó final se incrementa en uno la cantdiad de materias con
            final aprobado.
          Si aprobó cursada se incrementa en uno la cantidad de materias
            aprobadas sin final
      [x] Listar en un archivo de texto alumnos con más de cuatro materias
          aprobadas sin final
          [x] write para txt

}