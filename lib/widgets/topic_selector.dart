import 'package:flutter/material.dart';

import 'package:sayilar/widgets/topics/topic.dart';

/// A widget for selecting one of several [Topic]s from a list.
class TopicSelector extends StatelessWidget {
  /// Create a new [TopicSelector].
  ///
  /// This can be supplied with either a simple list of [topics], or with a list
  /// of [topicGroups], where each sublist constitutes a grouping of the topics
  /// within it. When topics are supplied in groups, each group will be visually
  /// separated from the other groups.
  TopicSelector({
    super.key,
    List<Topic>? topics,
    List<List<Topic>>? topicGroups,
  })  : assert(
          (topics != null) ^ (topicGroups != null),
          'Either `topics` or `topicGroups` must be given, not both.',
        ),
        topicGroups = topicGroups ?? [topics!];

  /// All of the selectable [Topic]s, possibly divided into groups.
  final List<List<Topic>> topicGroups;

  /// Build a horizontal line for separating groups of topics.
  Widget _buildSeparator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 12.0,
      ),
      child: Container(
        width: 100.0,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.0,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: topicGroups
            .map(
              (group) => group.map(
                (topic) => topic.buildButton(context),
              ),
            )
            .expand(
              (groupButtons) => [
                ...groupButtons,
                // Add a separator after the topic buttons of each group.
                _buildSeparator(context),
              ],
            )
            .toList()
          // Remove the unneeded final separator, that was temporarily added
          // after the topic buttons of the last group.
          ..removeLast(),
      ),
    );
  }
}
