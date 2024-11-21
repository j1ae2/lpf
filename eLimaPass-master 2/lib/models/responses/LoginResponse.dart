class LoginResponse {
  String id;
  String tarjeta;

  LoginResponse({
    required this.id,
    required this.tarjeta,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        id: json["id"],
        tarjeta: json["tarjeta"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tarjeta": tarjeta,
      };
}
