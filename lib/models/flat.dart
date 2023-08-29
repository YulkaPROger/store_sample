import 'package:store_sample/models/room.dart';

class Flat {
  final List<Room> rooms;
  double get totalArea {
    var  total = 0.0;
    for (var i in rooms){
      total += i.square;
    }
    return total;
  }

  Flat({required this.rooms,});
}
