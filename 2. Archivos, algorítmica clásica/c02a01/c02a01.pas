program c02a01;

const
  VALOR_CORTE  = -1;
  PATH_DETALLE = 'data.detalle.bin';
  PATH_MAESTRO = 'data.maestro.bin';
 
type
  String25 = String[25];

  TComision = record
    id: Integer;
    nombre: String25;
    comision: Real;
  end;

  FComisiones = file of TComision;


//* HELPERS

procedure imprimirComisiones(var f: FComisiones);
var
  t: TComision;
begin
  Reset(f);
  while (not eof(f)) do begin
    Read(f, t);
    WriteLn(
      '{ id: ', t.id, 
      ', nombre: ', t.nombre, 
      ', comision: ', t.comision:0:2, 
      ' }'
    );
  end;
  WriteLn();
  Close(f);
end;


//* MERGE

procedure leer(var f: FComisiones; var t: TComision);
begin
  if (eof(f)) then t.id := -1 else Read(f, t);
end;


procedure mergeComisiones(var mae, det: FComisiones);
var
  regMae, regDet: TComision;
begin
  Rewrite(mae); Reset(det);

  leer(det, regDet);
  while (regDet.id <> VALOR_CORTE) do begin
    regMae.id := regDet.id;
    regMae.nombre := regDet.nombre;
    regMae.comision := 0;
    while (regMae.id = regDet.id) do begin
      regMae.comision += regDet.comision;
      leer(det, regDet);
    end;
    Write(mae, regMae);
  end;

  Close(mae); Close(det);
end;


var
  maestro, detalle: FComisiones;
begin
  Assign(maestro, PATH_MAESTRO);
  Assign(detalle, PATH_DETALLE);

  mergeComisiones(maestro, detalle);

  WriteLn('DETALLE');
  imprimirComisiones(detalle);
  WriteLn('MAESTRO');
  imprimirComisiones(maestro);
end.

{
  Archivo de comisiones de empleados, ordenados por id empleado, con repetición.
  Merge de comisiones

  ---

  [x] TComision
  [x] FComisiones
  [ ] mergeComisiones()
      [ ] leer()
}