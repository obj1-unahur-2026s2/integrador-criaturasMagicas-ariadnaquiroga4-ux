class Colonia {
  var coloniaActual
  var criaturas = []
  method conquistar() {} //lucha contra la colonia actual
  method poderOfensivo() {
    return criaturas.sum({c => c.poderOfensivo()})
  }
  method poderDefensivo() {}
  method areaUsurpadaPor(coloniaInvasora) {
    return coloniaInvasora.poderOfensivo() > self.poderDefensivo()
  }
  method vencedora(coloniaInvasora) {
    return coloniaInvasora.pierdeCantidadPoderMagicoCriaturas(0.85)
  }
  method pierdeCantidadPoderMagicoCriaturas(cantidad) {
    criaturas.forEach({c => c.perderCantidadPoderMagico(cantidad)})
  }
}
class Claros inherits Colonia {
  override method poderDefensivo() {
    self.poderOfensivo() + 100
  }
}
class Castillos inherits Colonia{
  method cantidadCriaturasFormidables() {
    return criaturas.count({c => c.formidable()})
  }
  override method poderDefensivo() {
    return self.cantidadCriaturasFormidables() * 200
  }
}

class Criaturas {
  var poderMagico
  var astucia
  var rolEnElParque
  method poderMagico() = poderMagico
  method poderOfensivo() {
    return poderMagico * 10 + rolEnElParque.poderOfensivoExtra()
  }
  method esAstuta() {}
  method formidable() {
    return self.esAstuta() or rolEnElParque.esExtraoridinaria()
  }
  method cambiarRol() {
    return rolEnElParque == rolEnElParque.pasarAlSiguienteRol()
  }
  method perderCantidadPoderMagico(cant) {
    poderMagico = poderMagico * cant
  }
}

class duendes inherits Criaturas{
  const reinoBosque
  override method poderOfensivo() {
    return super() * 1.1
  }
  override method esAstuta() = false
}
class hadas inherits Criaturas {
  const reinoCielos
  var klmVuela = 2
  method aumentarKilometros(nro) {
    return if(klmVuela < 25) {
      klmVuela = klmVuela + nro
    }
  }
  override method esAstuta() {
    return astucia > 50
  }
} //condicion adicion que puedan volar mas de 10 km

class Roles {
  var criatura
  method poderOfensivoExtra() {}
  method esExtraordinaria() {}
  method pasarAlSiguienteRol() {}
}
class Guardian inherits Roles{
  override method poderOfensivoExtra() {
    return 100
  }
  override method esExtraordinaria() {
    return criatura.poderMagico() > 50
  }
  override method pasarAlSiguienteRol(mascota) {
    return if(!mascota.tieneCuernos()) {
      Domador
      Domador.agregarMascota(mascota)
      Domador.edadMascota(1)
    }
  }
}
class Hechicero inherits Roles{
  override method esExtraordinaria() = true
  override method pasarAlSiguienteRol() = Guardian
}
class Domador inherits Roles{
  var mascotas = []
  var edadMascota
  var tieneCuernos = true
  method edadMascota(nro) = edadMascota == nro
  method tieneCuernos() = tieneCuernos
  method agregarMascota(mascota) {
    return mascotas.add(mascota)
  }
  override method poderOfensivoExtra() {
    self.cantidadMascotasConCuernos() * 150
  }
  method cantidadMascotasConCuernos() {
    return mascotas.count({tieneCuernos})
  }
  method mascotasVeterana() {
    return mascotas.all({m => m.edadMascota() >= 10})
  }
  override method esExtraordinaria() {
    return criatura.poderMagico() >= 15 and self.mascotasVeterana()
  }
  override method pasarAlSiguienteRol() {
    return if(self.cantidadMascotasConCuernos() >= 1) {
      Hechicero
    } else {
      "error"
    }
  }
}