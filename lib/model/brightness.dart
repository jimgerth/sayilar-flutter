import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

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
  static const Brightness first = Brightness.system;

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

/// A [HydratedBloc] keeping track of and storing the current [Brightness].
class BrightnessBloc extends HydratedBloc<Brightness, Brightness> {
  /// Create a new [BrightnessBloc].
  BrightnessBloc() : super(Brightness.first) {
    on<Brightness>(
      (brightness, emit) => emit(brightness),
    );
  }

  /// Serialize the current [Brightness] into JSON format.
  @override
  Map<String, dynamic> toJson(Brightness state) => {
        'brightness': state.name,
      };

  /// Parse a [Brightness] from the stored JSON data.
  ///
  /// If no [Brightness] could be parsed from the stored JSON data, this
  /// defaults back to [Brightness.first].
  @override
  Brightness fromJson(Map<String, dynamic> json) =>
      Brightness.values.singleWhereOrNull(
        (value) => value.name == json['brightness'],
      ) ??
      Brightness.first;
}
