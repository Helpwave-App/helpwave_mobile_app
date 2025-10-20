import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../application/request_history_controller.dart';
import '../domain/request_model.dart';

class RequestHistoryScreen extends ConsumerWidget {
  const RequestHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestHistoryControllerProvider);
    final controller = ref.read(requestHistoryControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.requests_history_title.tr()),
      ),
      body: state.requests.when(
        data: (requests) => _buildRequestList(requests, context),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(LocaleKeys.requests_history_error.tr()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.fetchRequestHistory(),
                child: Text(LocaleKeys.requests_history_retry.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestList(List<Request> requests, BuildContext context) {
    if (requests.isEmpty) {
      return Center(
        child: Text(LocaleKeys.requests_history_empty.tr()),
      );
    }

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return ListTile(
          title: Text('Solicitud #${request.idRequest}'),
          subtitle: Text('Habilidad: ${request.skill}\nFecha: ${request.date}'),
          trailing: Text(request.volunteerName),
        );
      },
    );
  }
}
