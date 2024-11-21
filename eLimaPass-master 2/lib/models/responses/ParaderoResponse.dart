import '../entities/Paradero.dart';

class ParaderoResponse {
  final List<Paradero> paraderos;

  ParaderoResponse({
    required this.paraderos,
  });

  factory ParaderoResponse.fromJson(List<dynamic> json) {
    List<Paradero> paraderosList =
        json.map((i) => Paradero.fromJson(i)).toList();

    return ParaderoResponse(
      paraderos: paraderosList,
    );
  }
}
