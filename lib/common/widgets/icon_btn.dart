import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.iconData,
  });

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onPressed,
      icon: Icon(
        widget.iconData,
      ),
    );
  }
}
