import 'package:flutter/material.dart';
import 'package:bloomind/core/services/notification_service.dart';

class NotificationTestScreen extends StatelessWidget {
  const NotificationTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Prueba de notificaciones'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                minimumSize: const Size(200, 50),
              ),
              onPressed: () async {
                final granted = await NotificationService.instance
                    .requestNotificationPermission();

                if (granted) {
                  await NotificationService.instance.showInstantNotification();

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Notificación inmediata enviada',
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      backgroundColor: colorScheme.surfaceVariant,
                    ),
                  );
                } else {
                  if (!context.mounted) return;

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: colorScheme.surface,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: Text(
                        'Permiso requerido',
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      content: Text(
                        'Las notificaciones están desactivadas. '
                        'Actívalas en la configuración de la app para recibir recordatorios.',
                        style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.8)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await NotificationService.instance
                                .openNotificationSettings();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                          child: const Text('Abrir ajustes'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Notificación inmediata'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                minimumSize: const Size(200, 50),
              ),
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 5));
                await NotificationService.instance.showInstantNotification();

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Notificación lanzada tras 5 segundos',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    backgroundColor: colorScheme.surfaceVariant,
                  ),
                );
              },
              child: const Text('Prueba en 5 segundos'),
            ),
          ],
        ),
      ),
    );
  }
}