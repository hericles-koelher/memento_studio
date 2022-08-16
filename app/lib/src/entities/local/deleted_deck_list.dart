import 'package:objectbox/objectbox.dart';

/// {@category Entidades}
/// Modelo de lista de baralho deletado utilizado no armazenamento
/// local para a sincronização de baralhos deletados no servidor
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
