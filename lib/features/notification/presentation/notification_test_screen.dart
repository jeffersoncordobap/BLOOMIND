import 'package:flutter/material.dart';
import 'package:bloomind/core/services/notification_service.dart';

class NotificationTestScreen extends StatelessWidget {
  const NotificationTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba de notificaciones'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final granted = await NotificationService.instance
                    .requestNotificationPermission();

                if (granted) {
                  await NotificationService.instance.showInstantNotification();

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notificación inmediata enviada'),
                    ),
                  );
                } else {
                  if (!context.mounted) return;

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Permiso requerido'),
                      content: const Text(
                        'Las notificaciones están desactivadas. '
                            'Actívalas en la configuración de la app para recibir recordatorios.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await NotificationService.instance
                                .openNotificationSettings();
                          },
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
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 5));
                await NotificationService.instance.showInstantNotification();

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notificación lanzada tras 5 segundos'),
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