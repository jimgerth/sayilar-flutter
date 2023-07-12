import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sayilar/main.dart';
import 'package:sayilar/model/brightness.dart';

/// An [AppBar] for the [Sayilar] app.
class SayilarAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Create a new [SayilarAppBar].
  const SayilarAppBar({
    super.key,
    required this.title,
  });

  /// The title to be shown by this app bar.
  final String title;

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        BlocBuilder<BrightnessBloc, Brightness>(
          builder: (context, brightness) {
            return IconButton(
              icon: Icon(brightness.next.icon),
              tooltip: brightness.next.tooltip(context),
              onPressed: () => BlocProvider.of<BrightnessBloc>(context).add(
                brightness.next,
              ),
            );
          },
        ),
      ],
    );
  }
}
