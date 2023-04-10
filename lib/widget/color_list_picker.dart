import 'package:flutter/material.dart';

class ColorListPicker extends StatefulWidget {
  final Color? currentColor;
  final double radius;
  final void Function(Color? color) onTap;

  const ColorListPicker({
    this.currentColor,
    this.radius = 36,
    required this.onTap,
    super.key,
  });

  @override
  State<ColorListPicker> createState() => _ColorListPickerState();
}

class _ColorListPickerState extends State<ColorListPicker> {
  Color? selectedColor;

  @override
  void initState() {
    super.initState();

    selectedColor = widget.currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getRow([
          _getCircle(null),
          _getCircle(Colors.amber),
          _getCircle(Colors.green),
          _getCircle(Colors.redAccent.shade700),
        ]),
        _getSizedBox(),
        _getRow([
          _getCircle(Colors.pinkAccent.shade200),
          _getCircle(Colors.indigo.shade700),
          _getCircle(Colors.purple.shade600),
          _getCircle(Colors.brown.shade600),
        ]),
      ],
    );
  }

  Row _getRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }

  Widget _getCircle(Color? color) {
    Widget? child;
    // Border? border;

    if (color == null) {
      child = Icon(
        Icons.block,
        color: color == selectedColor ? Colors.red : Colors.grey.shade500,
        size: widget.radius,
      );
    } else if (color == selectedColor) {
      child = Icon(
        Icons.check,
        color: Colors.white,
        size: widget.radius / 1.5,
      );
    }

    return InkWell(
      child: Container(
        width: widget.radius,
        height: widget.radius,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
          // border: border,
        ),
        child: child,
      ),
      onTap: () {
        widget.onTap(color);

        setState(() {
          selectedColor = color;
        });
      },
    );
  }

  SizedBox _getSizedBox() => const SizedBox(height: 32);
}
