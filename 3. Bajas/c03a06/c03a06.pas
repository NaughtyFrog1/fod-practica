program c03a06;

const
  PATH_PRENDAS =   './data.prendas.bin';
  PATH_OBSOLETAS = './data.obsoletas.bin';
  PATH_AUXILIAR =  './data.auxilizar.bin';
 
type
  String25 = String[25];
  
  TPrenda = record
    id:          Integer;
    descripcion: String;
    colores:     String25;
    tipo:        String25;
    stock:       Integer;
    precio:      Real
  end;

  FPrendas =     file of TPrenda;
  FObsoletas =   file of Integer;


//* IMPRIMIR

procedure imprimirTodos(var f: FPrendas);
var t: TPrenda;
begin
  Reset(f);
  while (not Eof(f)) do begin
    Read(f, t);
    Write('{ ');
    Write('id: ', t.id:3, ', ');
    Write('tipo: ', t.tipo:12, ', ');
    Write('stock: ', t.stock:4, ', ');
    Write('precio: ', t.precio:4:2);
    WriteLn(' }');
  end;
  WriteLn();
  Close(f);
end;


//* DAR DE BAJA PRENDAS

procedure darDeBajaPrenda(var prendas: FPrendas; idObsoleta: Integer);
var t: TPrenda;
begin
  Seek(prendas, 0);
  Read(prendas, t);
  while (t.id <> idObsoleta) do Read(prendas, t);
  if (t.stock > 0) then begin
    t.stock := t.stock * -1;
    Seek(prendas, FilePos(prendas) - 1);
    Write(prendas, t);
  end;
end;

procedure darDeBajaPrendas(var prendas: FPrendas; var obsoletas: FObsoletas);
var idObsoleta: Integer;
begin
  Reset(prendas); Reset(obsoletas);
  while (not Eof(obsoletas)) do begin
    Read(obsoletas, idObsoleta);
    darDeBajaPrenda(prendas, idObsoleta);
  end;
  Close(prendas); Close(obsoletas);
end;


//* COMPACTAR EL ARCHIVO

procedure compactarPrendas(var prendas, aux: FPrendas);
var prenda: TPrenda;
begin
  Reset(prendas); Rewrite(aux);
  while (not Eof(prendas)) do begin
    Read(prendas, prenda);
    if (prenda.stock > 0) then Write(aux, prenda);
  end;

  Close(prendas); Close(aux);
  Erase(prendas);
  Rename(aux, PATH_PRENDAS);
end;


//* PROGRAMA PRINCIPAL

var
  prendas, aux: FPrendas;
  obsoletas: FObsoletas;
begin
  Assign(prendas, PATH_PRENDAS);
  Assign(aux, PATH_AUXILIAR);
  Assign(obsoletas, PATH_OBSOLETAS);

  imprimirTodos(prendas);

  darDeBajaPrendas(prendas, obsoletas);
  imprimirTodos(prendas);

  compactarPrendas(prendas, aux);
  imprimirTodos(aux);
end.

{
  - Archivo maestro no ordenado de prendas
  - Archivo detalle con codigo de prendas que quedaran obsoletas
  - Procedimiento que reciba ambos archivos y realice las bajas logicas poniendo
    el stock en negativo
  - Hacer las bajas físicas 
}
