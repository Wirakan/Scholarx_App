import 'package:flutter/material.dart';
import '../../models/notification_model.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({
    super.key,
    required this.notification,
  });

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final isToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;

    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');

    if (isToday) {
      return 'ส่งวันนี้ เวลา $hour:$minute น.';
    } else {
      return 'ส่งเมื่อ ${dt.day}/${dt.month}/${dt.year} เวลา $hour:$minute น.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF4500)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'รายละเอียดแจ้งเตือน',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              children: [
                _buildIcon(),
                const SizedBox(height: 20),
                _buildTitle(),
                const SizedBox(height: 8),
                _buildTimestamp(),
                const SizedBox(height: 24),
                _buildContentCard(),
              ],
            ),
          ),
        ),
        _buildBottomButton(context),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: notification.iconColor.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        notification.icon,
        size: 44,
        color: notification.iconColor,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      notification.title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTimestamp() {
    return Text(
      _formatTime(notification.createdAt),
      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFF9E9E9E),
      ),
    );
  }

  Widget _buildContentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        notification.body,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF424242),
          height: 1.7,
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () {
            // TODO: navigate to application history
          },
          icon: const Icon(Icons.history, color: Colors.white),
          label: const Text(
            'ดูประวัติใบสมัคร',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}