import 'package:flutter/material.dart';
import '/student/models/notification_model.dart';
import '/shared/application_repository.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onBack;

  const NotificationDetailScreen({
    super.key,
    required this.notification,
    this.onBack,
  });

  Color _statusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return const Color(0xFFFF6B35);
      case ApplicationStatus.reviewing:
        return const Color(0xFFFF6B35);
      case ApplicationStatus.approved:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
    }
  }

  IconData _statusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Icons.assignment_outlined;
      case ApplicationStatus.reviewing:
        return Icons.assignment_outlined;
      case ApplicationStatus.approved:
        return Icons.check_circle_outline_rounded;
      case ApplicationStatus.rejected:
        return Icons.cancel_outlined;
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final isToday =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;

    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');

    if (isToday) {
      return 'ส่งวันนี้ เวลา $hour:$minute น.';
    } else {
      return 'ส่งเมื่อ ${dt.day}/${dt.month}/${dt.year + 543} เวลา $hour:$minute น.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(notification.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(context),
      body: _buildBody(context, color),
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
        onPressed: onBack ?? () => Navigator.pop(context),
      ),
      title: const Text(
        'รายละเอียดการแจ้งเตือน',
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

  Widget _buildBody(BuildContext context, Color color) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              children: [
                _buildIcon(color),
                const SizedBox(height: 20),
                _buildTitle(),
                const SizedBox(height: 8),
                _buildTimestamp(),
                const SizedBox(height: 24),
                _buildContentCard(color),
              ],
            ),
          ),
        ),
        _buildBottomButton(context),
      ],
    );
  }

  Widget _buildIcon(Color color) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(_statusIcon(notification.status), size: 44, color: color),
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
      style: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContentCard(Color color) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel('สถานะ'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              notification.statusLabel,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionLabel('ชื่อทุน'),
          const SizedBox(height: 6),
          Text(
            notification.scholarshipName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionLabel('รายละเอียด'),
          const SizedBox(height: 6),
          Text(
            notification.message,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF424242),
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF9E9E9E),
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
        onPressed: () {},
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
Widget _buildBottomButton(BuildContext context) {
  return Container(
    color: const Color(0xFFF5F5F5),
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
    child: SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.history),
        label: const Text(
          'ดูประวัติใบสมัคร',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6B35),
          disabledBackgroundColor: const Color(0xFFFF6B35),
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
    ),
  );
}
