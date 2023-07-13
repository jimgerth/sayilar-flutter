import 'package:flutter/material.dart';

import 'package:sayilar/extensions/format_bold.dart';
import 'package:sayilar/widgets/sayilar_app_bar.dart';

/// An abstract base class for any coherent unit of browsable content.
///
/// A topic describes any coherent unit of content that can be summarized in a
/// succinct [title] (with an optional [icon] and [subtitle]) and that can be
/// somehow browsed into to reveal its entire content.
///
/// Per default, a simple button is provided for any implementing class via
/// [buildButton], which will browse into the topic by pushing a page onto the
/// nearest [Navigator] once tapped. The page will show the content built by
/// [buildBody], which has to be implemented by any implementing class.
abstract class Topic {
  /// Create a new [Topic].
  const Topic({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  /// An optional iconic representation for this topic.
  final IconData? icon;

  /// A succinct title for this topic.
  final String title;

  /// An optional, more descriptive subtitle for this topic.
  final String? subtitle;

  /// Build the full screen body containing all of the content of this topic.
  Widget buildBody(BuildContext context);

  /// Build a button representing this topic and browsing into its content.
  Widget buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ({label, onPressed}) {
        return icon != null
            ? ElevatedButton.icon(
                icon: Icon(
                  icon,
                  size: IconTheme.of(context).size != null
                      ? IconTheme.of(context).size! *
                          MediaQuery.of(context).textScaleFactor
                      : null,
                ),
                label: label,
                onPressed: onPressed,
              )
            : ElevatedButton(
                child: label,
                onPressed: onPressed,
              );
      }(
        label: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (subtitle != null) Text(subtitle!).formatBold(),
            ],
          ),
        ),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: SayilarAppBar(
                title: title,
              ),
              body: Center(
                child: buildBody(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
