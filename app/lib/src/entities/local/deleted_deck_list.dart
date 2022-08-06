import 'package:memento_studio/objectbox.g.dart';

@Entity()
class DeletedDeckList {
  @Id()
  late int storageId;
  final List<String> idList;

  DeletedDeckList({
    this.idList = const [],
    this.storageId = 0,
  });
}