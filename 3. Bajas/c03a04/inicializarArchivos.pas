program inicializarArchivos;

const
  PATH_FLORES = './data.flores.bin';
 
type
  String45 = String[45];

  TFlor = record
    id: Integer;
    nombre: String45;
  end;

  FFlores = file of TFlor;


function setFlor(id: Integer; nombre: String45): TFlor;
var t: TFlor;
begin
  t.id := id;
  t.nombre := nombre;
  setFlor := t;
end;


//* PROGRAMA PRINCIPAL

var
  flores: FFlores;
begin
  Assign(flores, PATH_FLORES);
  Rewrite(flores);

  Write(flores, setFlor(-13, ''));            //  0
  Write(flores, setFlor(  3, 'Rosa'));        //  1
  Write(flores, setFlor(  8, 'Tulipan'));     //  2
  Write(flores, setFlor(-11, ''));            //  3
  Write(flores, setFlor(  2, 'Girasol'));     //  4
  Write(flores, setFlor(  4, 'Orquidea'));    //  5
  Write(flores, setFlor(  7, 'Clavel'));      //  6
  Write(flores, setFlor(  0, ''));            //  7
  Write(flores, setFlor(  9, 'Lirio'));       //  8
  Write(flores, setFlor(  5, 'Calendula'));   //  9
  Write(flores, setFlor(  1, 'Narciso'));     // 10
  Write(flores, setFlor( -7, ''));            // 11
  Write(flores, setFlor(  6, 'Petunia'));     // 12
  Write(flores, setFlor( -3, ''));            // 13


  Close(flores);
end.
