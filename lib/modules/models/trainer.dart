class TrainerDemand {
  final int id;
  final String title;

  TrainerDemand({required this.id, required this.title});

  factory TrainerDemand.fromJson(Map<String, dynamic> json) {
    return TrainerDemand(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
    );
  }
}

class ActivityType {
  final int id;
  final String title;
  final int? groupId;
  final String? groupTitle;

  ActivityType({
    required this.id,
    required this.title,
    this.groupId,
    this.groupTitle,
  });

  factory ActivityType.fromJson(Map<String, dynamic> json) {
    return ActivityType(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      groupId: json['groupId'],
      groupTitle: json['groupTitle'],
    );
  }
}

class TrainerRating {
  final TrainerRatingParameter parameter;
  final double rating;
  final int votes;

  TrainerRating({
    required this.parameter,
    required this.rating,
    required this.votes,
  });

  factory TrainerRating.fromJson(Map<String, dynamic> json) {
    return TrainerRating(
      parameter: TrainerRatingParameter.fromJson(json['parameter'] ?? {}),
      rating: (json['rating'] ?? 0).toDouble(),
      votes: json['votes'] ?? 0,
    );
  }
}

class TrainerRatingParameter {
  final String id;
  final String title;

  TrainerRatingParameter({required this.id, required this.title});

  factory TrainerRatingParameter.fromJson(Map<String, dynamic> json) {
    return TrainerRatingParameter(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
    );
  }
}

class Trainer {
  final int id;
  final String title;
  final String? city;
  final String? description;
  final List<int>? clubs;
  final int? sortOrder;
  final String? facePhoto;
  final String? url;
  final String? facebookLink;
  final String? vkLink;
  final String? instagramLink;
  final String? telegramLink;
  final String? okLink;
  final String? whatsAppLink;
  final String? position;
  final String? photo;
  final bool? canTrainPersonally;
  final bool? canTrainGroups;
  final List<TrainerDemand> demands;
  final List<ActivityType> activityTypes;
  final String? phone;
  final String? biography;
  final String? awards;
  final double? rating;
  final List<TrainerRating> ratings;
  final int? commentsCount;

  Trainer({
    required this.id,
    required this.title,
    this.city,
    this.description,
    this.clubs,
    this.sortOrder,
    this.facePhoto,
    this.url,
    this.facebookLink,
    this.vkLink,
    this.instagramLink,
    this.telegramLink,
    this.okLink,
    this.whatsAppLink,
    this.position,
    this.photo,
    this.canTrainPersonally,
    this.canTrainGroups,
    this.demands = const [],
    this.activityTypes = const [],
    this.phone,
    this.biography,
    this.awards,
    this.rating,
    this.ratings = const [],
    this.commentsCount,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) {
    final dynamic idRaw = json['id'];
    final int idParsed = idRaw is int
        ? idRaw
        : int.tryParse(idRaw?.toString() ?? '') ?? 0;

    // clubs may come as a list of ints (club IDs)
    List<int> clubsParsed = [];
    final dynamic clubsRaw = json['clubs'];
    if (clubsRaw is List) {
      clubsParsed = clubsRaw
          .map((e) => e is int ? e : int.tryParse(e?.toString() ?? '') ?? 0)
          .where((e) => e != 0)
          .toList();
    }

    // Parse demands
    List<TrainerDemand> demandsList = [];
    final dynamic demandsRaw = json['demands'];
    if (demandsRaw is List) {
      demandsList = demandsRaw
          .map((e) => TrainerDemand.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // Parse activity types
    List<ActivityType> activityTypesList = [];
    final dynamic activityTypesRaw = json['activityTypes'];
    if (activityTypesRaw is List) {
      activityTypesList = activityTypesRaw
          .map((e) => ActivityType.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // Parse ratings
    List<TrainerRating> ratingsList = [];
    final dynamic ratingsRaw = json['ratings'];
    if (ratingsRaw is List) {
      ratingsList = ratingsRaw
          .map((e) => TrainerRating.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    bool parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is String) {
        final s = v.toLowerCase();
        return s == 'true' || s == '1' || s == 'yes';
      }
      if (v is num) return v != 0;
      return false;
    }

    return Trainer(
      id: idParsed,
      title: (json['title'] as String?) ?? '',
      city: json['city'] as String?,
      description: json['description'] as String?,
      clubs: clubsParsed,
      sortOrder: json['sortOrder'] as int?,
      facePhoto: json['facePhoto'] as String?,
      url: json['url'] as String?,
      facebookLink: json['facebookLink'] as String?,
      vkLink: json['vkLink'] as String?,
      instagramLink: json['instagramLink'] as String?,
      telegramLink: json['telegramLink'] as String?,
      okLink: json['okLink'] as String?,
      whatsAppLink: json['whatsAppLink'] as String?,
      position: json['position'] as String?,
      photo: json['photo'] as String?,
      canTrainPersonally: parseBool(json['canTrainPersonally']),
      canTrainGroups: parseBool(json['canTrainGroups']),
      demands: demandsList,
      activityTypes: activityTypesList,
      phone: json['phone'] as String?,
      biography: json['biography'] as String?,
      awards: json['awards'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      ratings: ratingsList,
      commentsCount: json['commentsCount'] as int?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'city': city,
      'description': description,
      'clubs': clubs,
      'sortOrder': sortOrder,
      'facePhoto': facePhoto,
      'url': url,
      'facebookLink': facebookLink,
      'vkLink': vkLink,
      'instagramLink': instagramLink,
      'telegramLink': telegramLink,
      'okLink': okLink,
      'whatsAppLink': whatsAppLink,
      'position': position,
      'photo': photo,
      'canTrainPersonally': canTrainPersonally,
      'canTrainGroups': canTrainGroups,
      'phone': phone,
      'biography': biography,
      'awards': awards,
      'rating': rating,
      'commentsCount': commentsCount,
    };
  }
}