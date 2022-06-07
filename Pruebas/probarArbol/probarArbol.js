const $orden = document.querySelector('#orden')
const $btnCrear = document.querySelector('#crearArbol')
const $numeroAInsertar = document.querySelector('#numeroAInsertar')
const $btnNumeroAInsertar = document.querySelector('#insertar')
const $numeroAEliminar = document.querySelector('#numeroAEliminar')
const $btnNumeroAEliminar = document.querySelector('#eliminar')

const $btnOperacion = document.createElement('button')
$btnOperacion.style.cssText =
  'position: fixed; bottom: 50px; right: 50px; font-size: 16px; padding: 12px 24px; cursor: pointer;'
$btnOperacion.innerText = 'Cargar Operaciones'
$btnOperacion.disabled = true
document.body.appendChild($btnOperacion)

let pilaOperaciones = []
let intervalCheckEstadoBtnOperacion

function enviarOperacion(operacion) {
  parsedNumber = parseInt(operacion.slice(1), 10)
  if (operacion[0] === '+') {
    $numeroAInsertar.value = parsedNumber
    $btnNumeroAInsertar.click()
  } else if (operacion[0] === '-') {
    $numeroAEliminar.value = parsedNumber
    $btnNumeroAEliminar.click()
  }
}

function handleClick(interval) {
  if (pilaOperaciones.length === 0) {
    pilaOperaciones = prompt('Ingrese las operaciones separadas por coma')
      .split(',')
      .map((operacion) => operacion.trim())
    
    // Deshabilita el botón durante las animaciones y lo vuelve a habiliar
    // cuando terminan
    interval = setInterval(() => {
      $btnOperacion.disabled = $btnNumeroAInsertar.disabled
    }, 500)

    $btnOperacion.innerText = `Enviar ${pilaOperaciones[0]}`
  } else {
    $btnOperacion.disabled = true
    enviarOperacion(pilaOperaciones.shift())

    if (pilaOperaciones.length === 0) {
      $btnOperacion.innerText = 'Cargar Operaciones'
      clearInterval(interval)
    } else {
      $btnOperacion.innerText = `Enviar ${pilaOperaciones[0]}`
    }
  }
}

$btnCrear.addEventListener('click', () => {
  if (parseInt($orden.value, 10) >= 4) $btnOperacion.disabled = false
})

$btnOperacion.addEventListener('click', () =>
  handleClick(intervalCheckEstadoBtnOperacion)
)

/*
  EJEMPLO:

  Operaciones ejercicio 14: +11, +50, +340, +350, +77, +400, +402, +360, -400, +500, +520, +410, +420, +530, -500, +80, -400
  
  Todas las operaciones, excepto las dos últimas, son para generar el árbol que
  está al inicio de la consigna. 
  
  En este caso la numeración de los nodos no coincide, pero sirve para ver como
  va quedando la estructura del árbol.


  OPERACIONES:
  - *14: +11, +50, +340, +350, +77, +400, +402, +360, -400, +500, +520, +410, +420, +530, -500, +80, -400

  - !15: +23, + 67, +66, +45, +89, +120, +110, +52, +70, +15, -45, -52, +22, +19, -66, -22, -19, - 23, -89
  
  * La numeración de los nodos no coincide
  ! No es posible utilizar HEA ya que las políticas no coinciden con el ejercicio
*/
