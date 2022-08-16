import 'package:memento_studio/src/entities.dart';
import 'package:memento_studio/src/repositories.dart';
import 'package:objectbox/objectbox.dart';

import '../../utils.dart';

/// {@category Repositórios}
/// Repositório de lista de baralhos deletados
class ObjectBoxDeletedDeckList implements DeletedDeckListRepository {
  final Box<DeletedDeckList> _deletedDeckListBox;

  ObjectBoxDeletedDeckList(ObjectBox objectBox)
      : _deletedDeckListBox = objectBox.store.box<DeletedDeckList>();

  /// Adiciona id de baralho deletado
  @override
  Future<void> addId(String id) async {
    if (_deletedDeckListBox.isEmpty()) {
      _deletedDeckListBox.putAsync(
        DeletedDeckList(
          idList: [id],
        ),
      );
    } else {
      var deletedDeckList = _deletedDeckListBox.getAll().first;

      deletedDeckList.idList.add(id);

      _deletedDeckListBox.putAsync(deletedDeckList);
    }
  }

  /// Limpa lista de baralhos deletados
  @override
  Future<void> clearList() async {
    _deletedDeckListBox.removeAll();
  }

  /// Lê lista de baralhos deletados
  @override
  Future<List<String>> readList() async {
    var list = _deletedDeckListBox.getAll();

    if (list.isNotEmpty) {
      return list.first.idList;
    } else {
      return <String>[];
    }
  }
}
