import 'package:flutter/material.dart';

import 'package:sayilar/widgets/topic_selector.dart';
import 'package:sayilar/widgets/topics/topic.dart';

/// A [Topic] for encapsulating and presenting other [Topic]s.
class DirectoryTopic extends Topic {
  /// Create a new [DirectoryTopic].
  ///
  /// This can be supplied with either a simple list of [topics], or with a list
  /// of [topicGroups], where each sublist constitutes a grouping of the topics
  /// within it. When topics are supplied in groups, each group will be visually
  /// separated from the other groups. See [TopicSelector] for more information.
  const DirectoryTopic({
    super.icon,
    required super.title,
    super.subtitle,
    super.onInfoPressed,
    this.topics,
    this.topicGroups,
  }) : assert(
          (topics != null) ^ (topicGroups != null),
          'Either `topics` or `topicGroups` must be given, not both.',
        );

  /// All of the selectable [Topic]s, not divided into groups.
  final List<Topic>? topics;

  /// All of the selectable [Topic]s, possibly divided into groups.
  final List<List<Topic>>? topicGroups;

  @override
  Widget buildBody(BuildContext context) {
    return TopicSelector(
      topics: topics,
      topicGroups: topicGroups,
    );
  }
}
