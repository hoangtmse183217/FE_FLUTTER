import 'package:flutter/material.dart';

// Một widget hiển thị một hàng cài đặt, tương tự như ListTile nhưng tùy biến hơn.
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isEditable;
  final Color? textColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.onTap,
    this.trailing,
    this.isEditable = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              Icon(icon, color: textColor ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor),
                ),
              ),
              if (value != null)
                Expanded(
                  flex: 1,
                  child: Text(
                    value!,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                  ),
                ),
              if (trailing != null)
                trailing!
              else if (isEditable)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
