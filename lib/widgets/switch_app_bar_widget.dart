import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class SwitchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function toggle;

  const SwitchAppBar({super.key, required this.toggle});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _MyAppBar createState() => _MyAppBar();
}

class _MyAppBar extends State<SwitchAppBar> {
  bool isOn = true;

  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Color?> trackColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Track color when the switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.black;
        }
        // Otherwise return null to set default track color
        // for remaining states such as when the switch is
        // hovered, focused, or disabled.
        return null;
      },
    );
    final MaterialStateProperty<Color?> overlayColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Material color when switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber.withOpacity(0.54);
        }
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey.shade400;
        }
        // Material color when switch is disabled.

        // Otherwise return null to set default material color
        // for remaining states such as when the switch is
        // hovered, or focused.
        return null;
      },
    );

    return NewGradientAppBar(
      title: const Text(
        'Rescue Robot',
        style: TextStyle(
            color: Colors.amberAccent,
            fontSize: 25,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(3.0, 3.0),
                blurRadius: 10.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              Shadow(
                offset: Offset(8.0, 8.0),
                blurRadius: 8.0,
                color: Color.fromARGB(125, 0, 0, 255),
              ),
            ]),
      ),
      gradient: const LinearGradient(
        colors: [
          Colors.cyan,
          Colors.indigo,
        ],
      ),
      actions: [
        Switch(
            value: isOn,
            overlayColor: overlayColor,
            trackColor: trackColor,
            thumbColor: const MaterialStatePropertyAll<Color>(Colors.white),
            onChanged: (val) {
              widget.toggle();
              setState(() {
                print("Switch Bar: $isOn");
                isOn = val;
              });
            }),
      ],
    );
  }
}
