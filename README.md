# Algorítmica clásica sobre archivos




## Actualización

Se actualiza un archivo maestro a partir de un conjunto de archivos detalles.



### Un maestro, un detalle. Sin repetición

- **Precondiciones:**
  - Cada registro del detalle modifica a un registro en el maestro.
  - Solo aparecerán datos en el detalle que también existan en el maestro.
  - Cada elemento del detalle es modificado por un único registro del detalle.
  - No todos los registros del maestro son modificados.
  - Ambos archivos están ordenados por el mismo criterio


```
actualizarMaestro(maestro, detalle) {
  Reset(maestro); Reset(detalle);

  while (not Eof(detalle)) {
    Read(maestro, regMaestro); Read(detalle, regDetalle);
    Buscar el registro maestro que coincida con el detalle;
    Modificar la información del registro maestro;
    Actualizar el archivo maestro;
  }

  Close(maestro); Close(detalle);
}
```



### Un maestro, un detalle. Con repetición

- **Precondiciones:**
  - *Cada registro del detalle modifica a un registro en el maestro.*
  - *Solo aparecerán datos en el detalle que también existan en el maestro.*
  - **Cada elemento del detalle es modificado por varios registro del detalle.**
  - *No todos los registros del maestro son modificados.*
  - *Ambos archivos están ordenados por el mismo criterio*

```
leer(detalle, regDetalle) {
  if (Eof(detalle)) regDetalle.id = VALOR_CORTE 
  else Read(detalle, regDetalle);
}

actualizarMaestro(maestro, detalle) {
  Reset(maestro); Reset(detalle);

  leer(detalle, regDetalle);
  while (regDetalle.id <> VALOR_CORTE) {
    Buscar el registro maestro que coincida con el detalle;
    while (regMaestro.id = regDetalle.id) {
      actualizar información en el registro maestro;
      leer(detalle, regDetalle);
    }
    Actualizar el archivo maestro;
  }

  Close(maestro); Close(detalle);
}
```



### Un Maestro, *N* detalles. Con repetición

- **Precondiciones:**
  - *Cada registro del detalle modifica a un registro en el maestro.*
  - *Solo aparecerán datos en el detalle que también existan en el maestro.*
  - *Cada elemento del detalle es modificado por varios registro del detalle.*
  - *No todos los registros del maestro son modificados.*
  - *Todos los archivos están ordenados por el mismo criterio*
  - **Los *N* archivos detalles están guardados en un vector**

```
leer(detalle, regDetalle) {
  if (Eof(detalle)) regDetalle.id = VALOR_CORTE 
  else Read(detalle, regDetalle);
}

inicializar(detalles, regsDetalles) {
  for i := 1 to N do leer(detalles[i], regsDetalles[i]);
}

getMinimo(detalles, regsDetalles, min) {
  Buscar el registro detalle menor;
  actualizar el valor de min con el nuevo valor;
  leer(detalles[minPos], regsDetalles[minPos]);
}

// Detalles es un vector con N archivos detalle
actualizarMaestro(maestro, detalles) {
  Reset(maestro); Reset(detalles);

  inicializar(detalles, regsDetalles);
  getMinimo(detalles, regsDetalles, min);

  while (min.id <> VALOR_CORTE) {
    Buscar el registro maestro que coincide con el detalle.
    while (regDetalle.id = min.id) {
      actualizar información registro maestro;
      getMinimo(detalles, regsDetalles, min);
    }
    Actualizar el archivo maestro;
  }

  Close(maestro); Close(detalles)
}
```
- Al buscar el registro detalle menor en `getMinimo`, deben tenerse en cuenta todos los criterios de ordenación del archivo.
- `VALOR_CORTE` tiene que ser un valor muy alto.




## Merge

Se genera un nuevo archivo maestro a partir de la información distribuida en varios archivos detalles.



### Merge N archivos. Sin repetición

```
mergeSinRepeticion(maestro, detalles) {
  Rewrite(maestro); Reset(detalles);

  inicializar(detalles, regsDetalles);
  getMinimo(detalles, regsDetalles, min);
  
  while (min.id <> VALOR_CORTE) {
    Write(maestro, min);
    minimo(detalles, regsDetalles, min);
  }

  Close(maestro); Close(detalles);
}
```



### Merge N archivos. Con repetición

```
mergeConRepeticion(maestro, detalles) {
  Rewrite(maestro); Reset(detalles);

  inicializar(detalles, regsDetalles);
  getMinimo(detalles, regsDetalles, min);

  while (min.id <> VALOR_CORTE) {
    regMaestro = información que se repite en los detalles;
    while (regMaestro.id = min.id) {
      regMaestro += información que se procesa para cada detalle;
      getMinimo(detalles, regsDetalles, min);
    }
    Write(regMaestro, maestro);
  }

  Close(maestro); Close(detalles);
}
```




## Corte de control

Proceso mediante el cual la información de un archivo es representada en forma organizada de acuerdo al criterio de orden del archivo.

```
CorteDeControl(archivo) {
  Reset(archivo);

  leer(archivo, reg);
  inicializar accTotal;

  while (reg.provincia <> VALOR_CORTE) {
    inicializar acumulador provincia, accProv;

    while (provActual = reg.prov) {
      iniciar accCiudad;

      while ((provActual = reg.prov) and (ciudadActual = reg.ciudad)) {
        inicializar accSucursal;

        while (
          (provActual = reg.prov) and
          (ciudadActual = reg.ciudad) and
          (sucursalActual = reg.sucursal)
        ) {
          procesar accSucursal;
          leer(archivo, reg);
        }
        procesar accCiudad;
      }
      procesar accProv;
    }
    procesar accTotal;
  }

  Close(archivo);
}
```
- Como los identificadores pueden estar repetidos entre las sucursales, ciudades y provincias; tenemos que ir "pasando" las condiciones a todos los cortes de control.





# Bajas

- **Baja física:** reemplazar el elemento del archivo por otro, reduciendo la cantidad de elementos y recuperando espacio físico.
- **Baja lógica:** marcar un elemento como borrado, sigue ocupando espacio en el archivo.




## Procedimientos



### Truncate

```
Truncate(f);
```

Trunca `f` en la posición actual del puntero del archivo.

El archivo tiene que estar abierto



### Rename

```
Rename(f, nuevoNombre);
```
Cambia el nombre asignado al archivo `f` por `nuevoNombre`.

El archivo tiene que estar asignado y cerrado.



### Erase

```
Erase(f);
```
Elimina `f` del disco.

El archivo tiene que estar asignado y cerrado.




## Archivos de longitud fija



### Baja física


#### Sin mantener el orden

```
bajaFisica(archivo, elemento) {
  Reset(archivo);

  Buscar el elemento a eliminar;
  Guardar la posición del elemento;
  Leer el último elemento del archivo;
  Escribir el último elemento del archivo en la posición guardada;
  Volver al último elemento del archivo;

  Truncate(archivo);
}
```
- `Truncate` pone una marca de EOF en la posición del puntero del archivo.


#### Manteniendo el orden

```
bajaFisica(archivo, id) {
  Reset(archivo);

  // Avanzar hasta encontrar el elemento a eliminar
  leer(archivo, t);
  while (t.id <> id) leer(archivo, t);

  // Leer el registro siguiente
  leer(archivo, t);

  // Desplazar todos los registros hacia la izquierda
  while (t.id <> VALOR_CORTE) {
    Seek(archivo, FilePos(archivo) - 2);  // Volvemos a la posición del registro a eliminar
    Write(archivo, t);
    Seek(archivo, FilePos(archivo) + 1);
    leer(archivo, t);
  }

  Truncate(archivo);
}
```



### Baja lógica

Se crea una **lista encadenada invertida** con los registros dados de baja. El primer registro del archivo se utiliza como un **registro de cabecera**.

- Bajas 
  - El registro de cabecera guarda el NRR del último registro borrado, o 0 si no hay registros borrados.
  - Al borrar un registro se guarda su NRR en el registro de cabecera y el que estaba allí se guarda en el registro borrado (generando la lista encadenada invertida).
- Altas
  - Los elementos se insertan el el NRR indicado por el registro de cabecera y este se actualiza con el NRR al que apuntaba el otro registro
  - Si el registro de cabecera es 0, no hay lugares disponibles, se inserta al final del archivo.

```
NRR:            0    1    2    3    4    5    6    7    8    9   10  

             |  0 |  1 |  6 |  2 |  7 |  3 |  8 |  4 |  9 |  5 | 10 |
                ^

BORRAR 2:    | -3 |  1 |  6 |  0 |  7 |  3 |  8 |  4 |  9 |  5 | 10 |
                ^              ^

BORRAR 8:    | -6 |  1 |  6 |  0 |  7 |  3 | -3 |  4 |  9 |  5 | 10 |
                ^              ^              ^

BORRAR 6:    | -2 |  1 | -6 |  0 |  7 |  3 | -3 |  4 |  9 |  5 | 10 |
                ^         ^    ^              ^

INSERTAR 21: | -6 |  1 | 21 |  0 |  7 |  3 | -3 |  4 |  9 |  5 | 10 |
                ^         ·    ^              ^

INSERTAR 32: | -3 |  1 | 21 |  0 |  7 |  3 | 32 |  4 |  9 |  5 | 10 |
                ^         ·    ^              ·

INSERTAR 15: |  0 |  1 | 21 | 15 |  7 |  3 | 32 |  4 |  9 |  5 | 10 |
                ^         ·    ·              ·
```

Después de insertar el 15, el registro de cabecera vuelve a quedar en 0, si se quisieran insertar nuevos elementos habrá que hacerlo al final del archivo.





# Árboles




## Árboles Binarios

> No es una solución viable para representar el índice de un archivo

En un **árbol binario** cada nodo puede tener a lo sumo dos hijos. Generalmente se ordena poniendo los hijos menores a la izquierda y los mayores a la derecha.

```pascal
type
  TArbolBinario = record
    dato: <tipo de dato>;
    izq: Integer;  // NRR hijo izquierdo
    der: Integer;  // NRR hijo derecho
  end;

  FIndiceBinario = file of TArbolBinario;

```



### Búsqueda

Se realiza partiendo del nodo raíz y se recorre hacia las hojas. Se chequea un nodo; si es el deseado, la búsqueda finaliza, en caso contrario se busca hacia la izquierda o hacia la derecha según corresponda. Es de  $ O(\log_2(n)) $.



### Inserción

1. Agregar el nuevo elemento de datos al final del archivo.
2. Buscar al padre de dicho elemento. Se recorre el archivo desde la raíz hasta llegar a una hoja.
3. Actualizar al padre, haciendo referencia a la dirección del nuevo hijo.

- **Performance**
  - Lecturas:   $ \log_2(n) $
  - Escrituras: $ 2 $



### Eliminación

Para poder eliminar un elemento de un árbol, este debe estar en un nodo terminal. Si no lo está, debe intercambiarse con el menor de sus descendientes (no hijos) mayores.

- **Performance**
  - Lecturas:   $ \log_2(n) $.  *(Localizar el elemento y su descendiente mayor).*
  - Escrituras: $ 2 $          *(Promover el descendiente mayor y borrar la hoja).*



### Probleamas

Un árbol binario es muy difícil de mantener balanceado, y si no lo está, la búsqueda deja de ser de $ O(\log_2(n)) $ y, en el peor de los casos, puede llegar a ser de $ O(n) $.




## Árboles AVL

> No es una solución viable para representar el índice de un archivo

Los **árboles balanceados en altura** son árboles binarios donde la diferencia máxima entre las alturas de dos subárboles cualqueira no pueden superar un delta determinado.

Si al insertar un dato se pierde el balanceo, entonces se debe **rebalancear el árbol**. Esta operación requiere muchos accesos a disco.




## Paginación de árboles binarios

Se divide un árbol binario en páginas que contienen un conjunto de nodos que están ubicados en direcciones físicas cercanas.

Al buscar un dato, se transfiere a memoria principal toda una página, reduciendo la cantidad de accesos a disco. Si el dato no se encuentra en esa página se trae otra página, referenciada por una de las hojas del subárbol recorrido.



### Performance

$$ \log_{k+1}(n) $$

- $k$ cantidad de nodos por páginas
- $n$ cantidad de claves del archivo



### Creación

El contenido de cada página debe estar relacionado. Cada elemento debe estar contenido en la página que le corresponde, no en el primer lugar disponible.



### Problemas

Reacomodar el árbol y mantener su balanceo interno es muy costoso de implementar y en cuanto a performance.





# Árboles balanceados




## Árboles B

Los **árboles B** son árboles multicamino que se mantienen balanceados a bajo costo.



### Propiedades

- Cada nodo tiene como máximo $M$ descendientes y $M - 1$ elementos.
- La raíz no tiene hijos o tiene al menos dos.
- Un nodo con $n$ hijos tiene $n - 1$ elementos
- Las hojas tienen como mínimo $[M/2]-1$ elementos y $[M/2]$ como máximo.
- Los nodos que no son terminales ni son la raíz tienen como mínimo $[M/2]$ elementos
- Todas las hojas están al mismo nivel.



### Definición

```
const
	ORDEN = 255;  // M
type
	TArbolB = record
		hijos: array[1..ORDEN] of Integer;
	  claves: array[1..ORDEN - 1] of <tipo de dato>;
		nroRegistros: Integer;
	end;

	FArbolB = file of TArbolB;
```
- **`hijos`** arreglo que contiene la dirección de los hijos.
- **`claves`** arreglo que contiene las claves que forman el índice del árbol.
- **`nroRegistros`** indica la dimensión lógica del nodo, la cantidad de elementos que tiene el nodo.



### Creación - Inserción

Los **árboles B** se construyen desde las hojas hacia la raíz. Los valores siempre se insertan en las hojas, los nodos no terminales obtienen sus valores cuando se promociona una clave por overflow.

Se comienza desde la raíz y se compara la nueva clave con las claves de la raíz, si es menor se trae el nodo a la izquierda y si es mayor, se trae el nodo a la derecha. Esto se repite hasta llegar a una hoja, donde el nuevo elemento se inserta de forma ordenada en el nodo.

Si al llegar un nuevo elemento a un nodo este está lleno, se produce **overflow**.


#### Overflow

1. Se crea un nuevo nodo.
2. La primera mitad de las claves se mantienen en el nodo viejo.
3. La segunda mitad se trasladan al nodo nuevo.
4. La menor de las claves de la segunda mitad se promociona al nodo padre.

Si al promocionar al nodo padre se produce overflow, se repite el proceso a partir de ese nodo. Esto se puede propagar hasta llegar a la raíz, aumentando en uno la altura del árbol.


#### Performance

$H$: altura del árbol.

- **Mejor caso** (sin overflow)
  - Lecturas:   $H$
  - Escrituras: $1$
- **Peor caso** (overflow hasta la raíz)
  - Lecturas:   $H$
  - Escrituras: $2H+1$



### Búsqueda

La búsqueda comienza por la raíz y se va bifurcando hacia los nodos terminales mientras no se encuentre el elemento.


#### Performance

- **Mejor caso** (el dato está en la raíz)
  - Lecturas:   $1$
- **Peor caso**
  - Lecturas:   $H$


#### Performance en relación a $H$ y $n$

$H$: altura del árbol
$n$: cantidad de datos
$M$: orden del árbol

$$ H < 1 + \log_{[M/2]}(\frac{n+1}{2}) $$



### Eliminación

El elemento a borrar debe estar en un nodo terminal. Si no lo esta se debe intercambiar con la menor de sus claves mayores.

Si al eliminar un elemento, el nodo queda con menos elementos que la cantidad mínima $([M/2] - 1)$, se produce **underflow**.


#### Underflow

Se trabaja con los nodos hermanos adyacentes. Primero se intenta redistribuir y si esto no es posible, se concatena.

##### Redistribución

Un nodo hermano adyacente cede elementos al nodo en underflow. Cada nodo queda lo más equivalentemente cargado posible. En el nodo padre podría degradarse al elemento separador y cambiarlo por uno más adecuado.

No modifica la cantidad de nodos, por lo que no hay posibilidad de propagar cambios en el resto del árbol; pero no siempre es posible de aplicar, ya que es necesario disponer de un nodo hermano adyacente con elementos suficientes para compartir.

##### Concatenación

Se concatena el nodo con un nodo hermano adyacente y se degrada del nodo padre al elemento separador entre ambos nodos.

Si al concatenar se genera underflow en el nodo padre, se debe redistribuir o concatenar. Esto puede propagarse hasta la raíz, disminuyendo en uno la cantidad de niveles del árbol.


#### Performance

- **Mejor caso**
  - Lecturas:   $H$
  - Escrituras: $1$
- **Peor caso**
  - Lecturas:   $2H-1$
  - Escrituras: $2H-1$



### Modificación

Se elimina el elemento a modificar y se hace un alta del elemento modificado. El performance es la suma de ambas operaciones.




## Árboles B*

Los **árboles B\*** son similares a los árboles B. Pero, en caso de overlow, antes de dividir se intenta redistribuir. Esto genera árboles más chatos y más densos, mejorando el performance.

Cuando en el overflow no es posible redistribuir y el nodo y su nodo hermano adyacente están completos, se genera un tercer nodo nuevo y los tres nodos quedan llenos en $2/3$ partes.

Las operaciones de **búsqueda, eliminación y modificación** son las mismas que en los árboles B.



### Propiedades

- *Cada nodo tiene como máximo $M$ descendientes y $M - 1$ elementos.*
- *La raíz no tiene hijos o tiene al menos dos.*
- *Un nodo con $n$ hijos tiene $n - 1$ elementos*
- **Las hojas tienen como mínimo $[(2M-1)/3]-1$ elementos y $M-1$ como máximo.**
- **Los nodos que no son terminales ni son la raíz tienen como mínimo $[(2M-1)/3]$ elementos**
- *Todas las hojas están al mismo nivel.*

La propiedad que indica la cantidad mínima de elementos tiene una excepción. Cuando el árbol B* tiene un solo nivel (la raíz) y esta se completa, no es posible redistribuir. Entonces al dividir el nodo raíz y generar dos nodos hijos estos solo completarán su espacio a la mitad en lugar de en 2/3.



### Creación

Existen tres políticas que determinan que nodo hermano adyacente tener en cuenta en caso de overflow:
- **Política de un lado:** A la hora de redistribuir se considera solo uno de los nodos hermanos adyacentes. Si no es posible redistribuir, ambos nodos se dividen generando dos nodos tercios llenos.
  - Política izquierda
  - Política derecha
- **Política de un lado u otro lado:** Primero se intenta redistribuir con un nodo hermano adyacente y si no es posible, se intenta con el otro. Si la distribución no es posible, se dividen dos nodos llenos a tres nodos dos tercios llenos.
  - Izquierda o derecha
  - Derecha o izquierda
- **Política de un lado y otro lado:** Primero se intenta redistribuir hacia un lado, si no es posible se intenta con el otro. Cuando los tres nodos están completos se toman los tres nodos y se dividen generando cuatro nodos con tres cuartas partes completas.
  - Esta alternativa completa más cada nodo del árbol, lo que genera árboles de menor altura, pero necesita de un mayor número de operaciones de E/S sobre disco para poder ser implementada.

En cualquiera de las políticas, si se tratase de un nodo hoja de un extremo del árbol, debe intentarse redistribuir con el hermano adyacente que posea.


#### Performance

En el caso de overflow todas las políticas requieren como mínimo **$2$ lecturas** *(el nodo en overflow y un adyacente)* y **$3$ escrituras** *(cada nodo hijo y el padre)*.

En la división, la política de un lado y de un lado u otro lado necesitan de **$4$ escrituras** *(el nodo padre, los dos nodos completos y el nuevo nodo)*.

La política de un lado y el otro lado genera **$4$ escrituras** *(los $3$ nodos terminales, se deben tener en cuenta el nodo padre y el nuevo nodo generado)*.




## Árboles B+

Conservan la propiedad de acceso aleatorio rápido de los árboles B y además permiten un recorrido secuencial rápido.

- **Conjunto índice:** proporciona acceso indizado a los registros. Todas las claves se encuentran en las hojas, y en la raíz y los nodos internos se duplican las claves que sean necesarias para definir los caminos de búsqueda.
- **Conjunto secuencia:** contiene todos los registros del archivo. Las hojas se vinculan para facilitar el recorrido secuencial rápido.



### Propiedades

- *Cada nodo tiene como máximo $M$ descendientes y $M-1$ elementos.*
- *La raíz no tiene hijos o tiene al menos dos.*
- *Un nodo con $n$ hijos tiene $n-1$ elementos*
- *Las hojas tienen como mínimo $[M/2]-1$ elementos y $M-1$ como máximo.*
- *Los nodos que no son terminales ni son la raíz tienen como mínimo $[M/2]$ elementos*
- *Todas las hojas están al mismo nivel.*
- **Los nodos terminales representan un conjunto de datos y son enlazados entre ellos formando una lista.**



### Creación - Inserción

El proceso de creación e inserción es muy similar al de los árboles B. Los elementos siempre se insertan en nodos terminales. Si se produce overflow, el nodo se divide y se promociona una copia (esa es la única diferencia) del menor de los elementos mayores al padre. La promoción de una copia es únicamente al dividir un nodo terminal, para los demás nodos se promociona el elemento en sí (que ya es una copia).



### Búsqueda

Es similar a la búsqueda en árboles B, pero como todos los datos se encuentran en las hojas, debe recorrerse hasta el último nivel del árbol.



### Eliminación

Las claves se eliminan únicamente en las hojas. Las claves en los nodos no terminales no se modifican por más que sean una copia de la clave eliminada.

En caso de underflow primero se intenta una redistribución y si no es posible, una concatenación. Se utilizan las mismas políticas que en los árboles B (política de un lado, un lado otro lado y, un lado y otro lado).



### Modificación

Al igual que en el árbol B, se da de baja el anterior y se da de alta el modificado.




## Arboles B+ de prefijos simples

En un árbol B+ de prefijo simples los separadores representados por la mínima expresión posible de la clave que permita decidir si la búsqueda se realiza hacia la izquierda o hacia la derecha.





# Definiciones - Árboles

- **Árbol balanceado:** en un árbol balanceado, la cantidad de nodos desde la raíz hasta cada una de las hojas es la misma

- **Nodos hermanos:** nodos que tienen el mismo nodo padre

- **Nodos hermanos adyacentes:** nodos hermanos que además dependen de punteros consecutivos en el padre.
