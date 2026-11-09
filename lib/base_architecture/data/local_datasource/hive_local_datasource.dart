import 'package:hive_ce/hive_ce.dart';

import '../../core/base_entity.dart';
import '../../core/master_object.dart';
import '../../state_management/bloc/api_state.dart';
import 'local_datasource.dart';

//LocalDataSource

class HiveLocalDataSourceImpl<
  T extends MasterObject,
  E extends BaseEntity<T, E>
>
    extends LocalDataSource<T, E> {
  final Box<E> _box;

  final E Function() entityFactory;

  HiveLocalDataSourceImpl({required this.entityFactory, required Box<E> box})
    : _box = box;

  Box<E> getBox() => _box;

  @override
  Future<void> clear() async {
    try {
      final box = _box; //
      await box.clear();
    } catch (e) {
      throw ApiFailure('Failed to clear cache: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final box = _box; //
      return box.delete(id);
    } catch (e) {
      throw ApiFailure('Failed to delete item from cache: $e');
    }
  }

  @override
  Future<List<T>> getAll() async {
    try {
      final box = _box; //
      return box.values.map((e) => e.toModel()).toList();
    } catch (e) {
      throw ApiFailure('Failed to get all items from cache: $e');
    }
  }

  @override
  Future<T?> getById(String id) async {
    try {
      final box = _box;
      final entity = box.get(id);
      return entity?.toModel();
    } catch (e) {
      throw ApiFailure('Failed to get item by id from cache: $e');
    }
  }

  @override
  Future<void> save(T model) async {
    try {
      final box = _box; //
      final entity = entityFactory().fromModel(model);
      return box.put(model.id, entity);
    } catch (e) {
      throw ApiFailure('Failed to save item to cache: $e');
    }
  }
}
