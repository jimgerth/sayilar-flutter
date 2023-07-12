import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/translations.dart';

/// The different possible brightness settings for the app.
enum Brightness {
  /// Use the system's brightness setting to determine the app's brightness.
  system(Icons.settings_suggest),

  /// Set the app's brightness to dark.
  dark(Icons.dark_mode),

  /// Set the app's brightness to light.
  light(Icons.light_mode);

  /// Create a new [Brightness] variant.
  const Brightness(this.icon);

  /// An iconic representation for this brightness variant.
  final IconData icon;

  /// The first brightness variant to be used for the app on startup.
  static Brightness first = Brightness.system;

  /// Return the brightness variant coming after `this` one.
  Brightness get next {
    const List<Brightness> values = Brightness.values;
    return values[(values.indexOf(this) + 1) % values.length];
  }

  /// A short tooltip indicating this brightness variant's function.
  String tooltip(BuildContext context) => switch (this) {
        system => Translations.of(context).systemBrightnessTooltip,
        dark => Translations.of(context).darkModeTooltip,
        light => Translations.of(context).lightModeTooltip,
      };
}
