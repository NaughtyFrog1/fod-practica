program inicializarArchivos;

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


function generarAsistente(
  nro: Integer;
  nombre: String25;
  dni: StringDni
): TAsistente;
var t: TAsistente;
begin
  t.nro := nro;
  t.nombre := nombre;
  t.dni := dni;
  generarAsistente := t;
end;


var
  f: FAsistentes;
begin
  Assign(f, PATH_ASISTENTES);
  Rewrite(f);

  Write(f, generarAsistente(1234,  'Juan',       '12345678'));
  Write(f, generarAsistente( 420,  'Ivan',       '43518321'));
  Write(f, generarAsistente( 702,  'Lucas',      '01235182'));
  Write(f, generarAsistente(1400,  'Pedro',      '23658152'));
  Write(f, generarAsistente(1000,  'Julian',     '15621500'));
  Write(f, generarAsistente( 804,  'Agustina',   '12351821'));
  Write(f, generarAsistente(1825,  'Juana',      '35612215'));
  Write(f, generarAsistente( 100,  'Lucia',      '29315321'));
  Write(f, generarAsistente(1702,  'Valentina',  '32465841'));
  Write(f, generarAsistente(  12,  'Jose',       '23862120'));

  Close(f);
end.
