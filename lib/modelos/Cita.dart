class CitaModel {
  String id;
  String id_barberia;
  String hora_inicio;
  String minuto_inicio;
  String hora_final;
  String minuto_final;
  String fecha_cita;
  String servicios;
  String precio;
  String nombreBarberia;
  String direccionBarberia;
  String nombreBarbero;
  String estadoCita;
  bool value;

  CitaModel(
      this.id,
      this.id_barberia,
      this.hora_inicio,
      this.minuto_inicio,
      this.hora_final,
      this.minuto_final,
      this.fecha_cita,
      this.precio,
      this.servicios,
      this.nombreBarberia,
      this.direccionBarberia,
      this.nombreBarbero,
      this.estadoCita,
      this.value);
}
