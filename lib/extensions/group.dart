/// The possible locations from where a grouping could start.
///
/// See [Group] for more information.
enum GroupingStart {
  /// Start the grouping at the start of the list.
  ///
  /// Possible leftover elements will thus be at the end of the list.
  start,

  /// Start the grouping at the end of the list.
  ///
  /// Possible leftover elements will thus be at the start of the list.
  end,
}

/// The possible types of ways to handle leftover elements in a grouping.
///
/// See [Group] for more information.
enum GroupingLeftoverHandlingType {
  /// Keep the leftovers in a last group smaller than the other groups.
  keep,

  /// Discard the leftovers completely.
  discard,

  /// Keep the leftovers in a group padded to be as big as the other groups.
  ///
  /// A padding will be inserted either at the start or the end of that group
  /// depending on the selected [GroupingStart].
  pad,
}

/// A concrete description of how to handle leftover elements in a grouping.
///
/// See [Group] for more information.
class GroupingLeftoverHandling<T> {
  /// Create a new leftover handling instance of type keep.
  ///
  /// Use the public [keep] to access this variant.
  const GroupingLeftoverHandling._keep()
      : type = GroupingLeftoverHandlingType.keep,
        padding = null;

  /// Create a new leftover handling instance of type discard.
  ///
  /// Use the public [discard] to access this variant.
  const GroupingLeftoverHandling._discard()
      : type = GroupingLeftoverHandlingType.discard,
        padding = null;

  /// Create a new leftover handling instance of type pad.
  ///
  /// A concreate value of type [T] for padding must be given.
  const GroupingLeftoverHandling.pad(T this.padding)
      : type = GroupingLeftoverHandlingType.pad;

  /// A grouping leftover handling of type keep.
  static const keep = GroupingLeftoverHandling._keep();

  /// A grouping leftover handling of type discard.
  static const discard = GroupingLeftoverHandling._discard();

  /// The type of way to handle the grouping leftovers.
  final GroupingLeftoverHandlingType type;

  /// A concrete padding value for [GroupingLeftoverHandlingType.pad].
  ///
  /// This is of type [T] (note that that could include `null`) if and only if
  /// the [type] is [GroupingLeftoverHandlingType.pad] (and `null` otherwise).
  final T? padding;
}

/// An extension to goup elements of a list into groups.
extension Group<T> on List<T> {
  /// Return the elements of this list in groups of a given [size].
  ///
  /// Staring at the given [GroupingStart] the elements of this list will be
  /// continuously added to a group (i.e. a sublist) until that group reaches
  /// the given [size], at which point a new groupt (i.e. a new sublist) is
  /// opened for the next elements.
  ///
  /// If the length of this list is not evenly divisible by the given [size],
  /// the last group will be shorter than all of the other ones. The elements of
  /// that last unfinished group are deemed the leftovers. The given
  /// [leftoverHandling] specifies how those leftovers are treated.
  List<List<T>> group(
    int size, {
    GroupingStart start = GroupingStart.start,
    GroupingLeftoverHandling leftoverHandling = GroupingLeftoverHandling.keep,
  }) {
    // The list of groups (i.e. sublists) to be filled.
    List<List<T>> groups = [];

    // The list to be grouped is this list, but reversed, if the grouping
    // should start from the end. The grouping logic will be correct in that
    // case, but the order of the groups and the order of the elements within
    // those groups will be the wrong way round. This is fixed at the bottom.
    List<T> list = start == GroupingStart.start
        ? List<T>.from(this)
        : List<T>.from(this).reversed.toList();

    while (list.isNotEmpty) {
      if (list.length >= size) {
        // While there are still enough elements in the list to form a complete
        // group, continually extract that group into the list of groups to be
        // filled.
        groups.add(list.sublist(0, size));
        list.removeRange(0, size);
      } else {
        // However if there are still elements in the list, but too few to form a
        // complete group, those are the leftover elements. Handle them according
        // to the leftoverHandling type.
        if (leftoverHandling.type == GroupingLeftoverHandlingType.keep) {
          // If they should be kept, add the list (at this point only containing
          // the leftover elements) as a last incomplete group.
          groups.add(list);
        } else if (leftoverHandling.type == GroupingLeftoverHandlingType.pad) {
          // If they should be padded, add the list (at this point only
          // containing the leftover elements), followed by as many padding
          // objects as needed to reach the size of all the other groups, as a
          // last padded but complete group.
          groups.add(
            list +
                List.filled(
                  size - list.length,
                  leftoverHandling.padding,
                ),
          );
        }

        // Exit the loop after handling the leftover elemets (or after simply
        // forgetting about them, if the leftoverHandling was of type discard).
        break;
      }
    }

    // Return the now filled list of groups (but itself and every of its
    // groups (i.e. sublists) reversed to fix their order, if the grouping
    // started at the end).
    return start == GroupingStart.start
        ? groups
        : groups.reversed
            .map(
              (group) => group.reversed.toList(),
            )
            .toList();
  }
}
