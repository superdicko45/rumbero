class SettingsModelResponse {
  
  bool muestraEventos;
  bool error;

  SettingsModelResponse({this.muestraEventos});

  SettingsModelResponse.fromJson(Map<String, dynamic> json) {

    muestraEventos = json['muestra_eventos'] == 1 ? true : false;
  }  

  SettingsModelResponse.withError()
      : muestraEventos = true,
        error = true;
}