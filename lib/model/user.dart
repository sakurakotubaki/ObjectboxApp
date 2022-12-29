import 'package:objectbox/objectbox.dart';

// ユーザークラスを作成
@Entity()
class User {
  User({this.name});
  int id = 0;
  String? name;
}
