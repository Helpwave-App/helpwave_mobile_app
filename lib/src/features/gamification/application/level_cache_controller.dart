import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/level_service.dart';
import '../domain/level_model.dart';

class LevelCacheController extends StateNotifier<Map<int, Level>> {
  final LevelService _service;

  LevelCacheController(this._service) : super({});

  Future<Level> getLevel(int idLevel) async {
    if (state.containsKey(idLevel)) {
      return state[idLevel]!;
    }

    final level = await _service.fetchLevel(idLevel);
    state = {...state, idLevel: level};
    return level;
  }
}
