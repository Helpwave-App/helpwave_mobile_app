import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/constants/providers.dart';
import '../data/level_service.dart';
import '../domain/level_progress.dart';

class LevelProgressController extends AsyncNotifier<LevelProgressModel> {
  late final LevelService _service;

  @override
  Future<LevelProgressModel> build() async {
    _service = ref.read(levelServiceProvider);
    return await _service.getLevelProgress();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.getLevelProgress());
  }
}
