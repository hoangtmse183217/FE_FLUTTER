import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;
  final bool isEditable;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    required this.onTap,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: value != null ? Text(value!) : null,
      trailing: isEditable
          ? const Icon(Icons.arrow_forward_ios, size: 16)
          : null,
    );
  }
}