class Parameter {
  final String id;
  final String title;

  Parameter({
    required this.id,
    required this.title,
  });

  factory Parameter.fromJson(Map<String, dynamic> json) {
    return Parameter(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
class Rating {
  final Parameter parameter;
  final int rating;
  final int votes;

  Rating({
    required this.parameter,
    required this.rating,
    required this.votes,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      parameter: Parameter.fromJson(json['parameter']),
      rating: json['rating'] ?? 0,
      votes: json['votes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parameter': parameter.toJson(),
      'rating': rating,
      'votes': votes,
    };
  }
}
class Activity {
  final int id;
  final String title;
  final String? description;
  final int? length;
  final String? clubs;
  final String? type;
  final int? typeId;
  final String? color;
  final String? youtubePreviewUrl;
  final String? youtubeUrl;
  final List<Rating>? ratings;
  final int? rating;
  final int? commentsCount;

  bool isBooked = false;

  Activity({
    required this.id,
    required this.title,
    this.description,
    this.length,
    this.clubs,
    this.type,
    this.typeId,
    this.color,
    this.youtubePreviewUrl,
    this.youtubeUrl,
    this.ratings,
    this.rating,
    this.commentsCount,
    this.isBooked = false
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      length: json['length'],
      clubs: json['clubs'],
      type: json['type'],
      typeId: json['typeId'],
      color: json['color'],
      youtubePreviewUrl: json['youtubePreviewUrl'],
      youtubeUrl: json['youtubeUrl'],
      ratings: (json['ratings'] as List<dynamic>?)
          ?.map((rating) => Rating.fromJson(rating))
          .toList(),
      rating: json['rating'],
      commentsCount: json['commentsCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'length': length,
      'clubs': clubs,
      'type': type,
      'typeId': typeId,
      'color': color,
      'youtubePreviewUrl': youtubePreviewUrl,
      'youtubeUrl': youtubeUrl,
      'ratings': ratings?.map((rating) => rating.toJson()).toList(),
      'rating': rating,
      'commentsCount': commentsCount,
    };
  }
}
class ActivityType {
  final int id;
  final String title;
  final String? color;
  final List<Activity>? activities;

  ActivityType({
    required this.id,
    required this.title,
    this.color,
    this.activities,
  });

  factory ActivityType.fromJson(Map<String, dynamic> json) {
    return ActivityType(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      color: json['color'] ?? 'default',
      activities: (json['activities'] as List<dynamic>?)
          ?.map((activity) => Activity.fromJson(activity))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'color': color,
      'activities': activities?.map((activity) => activity.toJson()).toList(),
    };
  }
}
class Group {
  final int id;
  final String title;
  final int? sortOrder;
  final List<ActivityType>? activityTypes;

  Group({
    required this.id,
    required this.title,
    this.sortOrder,
    this.activityTypes,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      sortOrder: json['sortOrder'],
      activityTypes: (json['activityTypes'] as List<dynamic>?)
          ?.map((activityType) => ActivityType.fromJson(activityType))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sortOrder': sortOrder,
      'activityTypes': activityTypes?.map((activityType) => activityType.toJson()).toList(),
    };
  }
}

class Groups {
  final List<Group> groups;

  Groups({
    required this.groups,
  });

  factory Groups.fromJson(Map<String, dynamic> json) {
    return Groups(
      groups: (json['groups'] as List<dynamic>?)
          ?.map((group) => Group.fromJson(group))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groups': groups.map((group) => group.toJson()).toList(),
    };
  }
}