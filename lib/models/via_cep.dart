class ViaCep {
  String? cep;
  String? logradouro;
  String? complemento;
  String? bairro;
  String? localidade;
  String? uf;

  ViaCep({
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.localidade,
    this.uf,
  });

  // Factory constructor to create a ViaCep instance from a map
  factory ViaCep.fromJson(Map<String, dynamic> json) {
    return ViaCep(
      cep: json['cep'] as String?,
      logradouro: json['logradouro'] as String?,
      complemento: json['complemento'] as String?,
      bairro: json['bairro'] as String?,
      localidade: json['localidade'] as String?,
      uf: json['uf'] as String?,
    );
  }

  // Method to convert a ViaCep instance into a map
  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
      'bairro': bairro,
      'localidade': localidade,
      'uf': uf,
    };
  }
}
