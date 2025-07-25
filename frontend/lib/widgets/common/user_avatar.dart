import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';

class UserAvatar extends StatelessWidget {
  final User user;
  final double size;

  const UserAvatar({
    super.key,
    required this.user,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final avatarUrl = user.avatarUrl;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: (avatarUrl != null && avatarUrl.isNotEmpty)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: Image.network(
                avatarUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(context),
              ),
            )
          : _buildInitialsAvatar(context),
    );
  }

  Widget _buildInitialsAvatar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final initials = _getInitials(user.username);

    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.35,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return parts.take(2).map((e) => e.substring(0, 1).toUpperCase()).join();
  }
}
