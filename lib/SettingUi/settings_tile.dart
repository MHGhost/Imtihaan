
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {

  final IconData icon;
  final String title;
  final String? trailingText;
  final IconData? trailingIcon;
  final VoidCallback onTap;

  const SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingText,
    this.trailingIcon,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: trailingText != null
          ? Text(
        trailingText!,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      )
          : trailingIcon != null
          ? Icon(trailingIcon, color: Colors.grey)
          : const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }
}
