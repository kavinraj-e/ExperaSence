import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({Key? key}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('ExpiraSense'),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }
}
