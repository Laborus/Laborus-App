import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/generics/base64_image.dart';
import 'package:laborus_app/core/components/list/notification_tile.dart';
import 'package:laborus_app/core/model/users/person_model.dart';
import 'package:laborus_app/core/providers/request_provider.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:laborus_app/core/components/list/generic_list_builder_separated.dart';
import 'package:laborus_app/core/utils/theme/font_size.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  @override
  void initState() {
    super.initState();
    // Fetch pending connections when the tab is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConnectionRequestProvider>(context, listen: false)
          .fetchPendingConnections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = // Get the current user's ID from your auth provider
        Provider.of<UserProvider>(context, listen: false).user?.id ?? '';
    return Consumer<ConnectionRequestProvider>(
      builder: (context, connectionProvider, child) {
        if (connectionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (connectionProvider.error != null) {
          return Center(
            child: Text(
              'Error: ${connectionProvider.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  children: [
                    Text(
                      'Notificações',
                      style: TextStyle(
                        fontSize: AppFontSize.xxLarge,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${connectionProvider.pendingRequests.length}',
                      style: TextStyle(
                        fontSize: AppFontSize.xxLarge,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              GenericListBuilderSeparated(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                itemCount: connectionProvider.pendingRequests.length,
                separatorBuilder: (context, index) => const SizedBox(height: 1),
                itemBuilder: (context, index) {
                  final request = connectionProvider.pendingRequests[index];

                  return FutureBuilder<PersonModel?>(
                    future: connectionProvider
                        .getUserDetails(request.sender?.id ?? ''),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError || !snapshot.hasData) {
                        return const ListTile(
                          title: Text('Erro ao carregar o remetente'),
                        );
                      }

                      final sender = snapshot.data!;
                      return NotificationTile(
                        leading: Base64ImageWidget(
                          base64String: sender.profileImage,
                          width: 40,
                          height: 40,
                        ),
                        title: Text(
                          '${sender.name} enviou uma solicitação de conexão',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                        trailing: Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () =>
                                  connectionProvider.respondToConnectionRequest(
                                      request.id, 'accept'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () =>
                                  connectionProvider.respondToConnectionRequest(
                                      request.id, 'reject'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to format time ago
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Agora há pouco';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutos atrás';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} horas atrás';
    } else {
      return '${difference.inDays} dias atrás';
    }
  }
}
