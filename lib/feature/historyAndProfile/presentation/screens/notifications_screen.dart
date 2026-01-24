import 'package:flutter/material.dart';
import 'package:ridetohealthdriver/core/widgets/loading_shimmer.dart';
import 'package:get/get.dart';
import 'package:ridetohealthdriver/core/extensions/text_extensions.dart';
import 'package:ridetohealthdriver/feature/auth/domain/model/get_notification_response_model.dart';
import 'package:ridetohealthdriver/feature/home/controllers/home_controller.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final HomeController homeController;

  @override
  void initState() {
    super.initState();
    homeController = Get.find<HomeController>();
    homeController.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3442),
      body: SafeArea(
        child: GetBuilder<HomeController>(
          builder: (controller) {
            final notifications =
                controller.getNotificationResponseModel.data?.notifications ??
                [];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(color: Colors.white),
                      const Text(
                        'Notifications',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(width: 50),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: RefreshIndicator(
                      color: Colors.white,
                      backgroundColor: const Color(0xFF3A4252),
                      onRefresh: controller.getNotifications,
                      child: Builder(
                        builder: (_) {
                          if (controller.isNotificationsLoading) {
                            return const Center(
                              child: LoadingShimmer(color: Colors.white),
                            );
                          }
                          if (controller.notificationsError != null) {
                            return ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                const SizedBox(height: 60),
                                Center(
                                  child: Text(
                                    controller.notificationsError ??
                                        'Something went wrong',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            );
                          }
                          if (notifications.isEmpty) {
                            return ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 60),
                                Center(
                                  child: Text(
                                    'No notifications yet',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ],
                            );
                          }
                          return ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: notifications.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, index) {
                              final item = notifications[index];
                              return _NotificationTile(item: item);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;

  const _NotificationTile({required this.item});

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d, h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3A4252),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFB10706),
            child: Icon(Icons.notifications, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title ?? 'Notification',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.message ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatDate(item.createdAt),
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
