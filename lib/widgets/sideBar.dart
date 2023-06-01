import 'package:drum_pad_admin/widgets/sideBarButton.dart';
import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      color: const Color.fromARGB(255, 4, 107, 192),
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            child: const SideBarRow(Icons.fiber_new_rounded, 'Add Songs'),
          ),
        ],
      ),
    );
  }
}
