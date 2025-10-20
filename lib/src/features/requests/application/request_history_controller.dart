import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/request_history_service.dart';
import '../domain/request_model.dart';

class RequestHistoryState {
  final AsyncValue<List<Request>> requests;

  RequestHistoryState({this.requests = const AsyncValue.loading()});

  RequestHistoryState copyWith({AsyncValue<List<Request>>? requests}) {
    return RequestHistoryState(
      requests: requests ?? this.requests,
    );
  }
}

class RequestHistoryController extends StateNotifier<RequestHistoryState> {
  final RequestHistoryService _requestHistoryService;

  RequestHistoryController(this._requestHistoryService) : super(RequestHistoryState()) {
    fetchRequestHistory();
  }

  Future<void> fetchRequestHistory() async {
    try {
      final requests = await _requestHistoryService.getRequestHistory();
      state = state.copyWith(requests: AsyncValue.data(requests));
    } catch (e) {
      state = state.copyWith(requests: AsyncValue.error(e, StackTrace.current));
    }
  }
}

final requestHistoryControllerProvider =
    StateNotifierProvider<RequestHistoryController, RequestHistoryState>(
  (ref) => RequestHistoryController(RequestHistoryService()),
);
