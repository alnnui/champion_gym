import 'package:myapp/modules/models/activity.dart';
import 'package:myapp/modules/models/trainer.dart';

/// Models for parsing schedule JSON payloads.
/// Use `ScheduleResponse.fromJson(map)` to parse.
class ScheduleResponse {
  final DateTime? dateSince;
  final DateTime? dateTo;
  final String? next;
  final String? prev;
  final List<ScheduleActivity> schedule;
  final ScheduleChange? change;

  ScheduleResponse({
    this.dateSince,
    this.dateTo,
    this.next,
    this.prev,
    required this.schedule,
    this.change,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    DateTime? parseDt(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return ScheduleResponse(
      dateSince: parseDt(json['dateSince']),
      dateTo: parseDt(json['dateTo']),
      next: json['next'] as String?,
      prev: json['prev'] as String?,
      schedule: (json['schedule'] as List<dynamic>?)
              ?.map((e) => ScheduleActivity.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      change: json['change'] != null
          ? ScheduleChange.fromJson(json['change'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'dateSince': dateSince?.toIso8601String(),
        'dateTo': dateTo?.toIso8601String(),
        'next': next,
        'prev': prev,
        'schedule': schedule.map((s) => s.toJson()).toList(),
        'change': change?.toJson(),
      };
}

class ScheduleActivity {
  final int id;
  final DateTime? dateTime;
  final List<Trainer>? trainers;
  final bool? courseActivity;
  final Activity? activity;
  final Group? group;
  final Room? room;
  final int? length;
  final bool? isNew;
  final bool? commercial;
  final bool? preEntry;
  final DateTime? beginDate;
  final DateTime? endDate;
  final bool? firstFree;
  final bool? popular;
  final ScheduleChange? change;
  final AgeLevel? age;
  final AgeLevel? level;
  final int? clubId;

  ScheduleActivity({
    required this.id,
    this.dateTime,
    this.trainers,
    this.courseActivity,
    this.activity,
    this.group,
    this.room,
    this.length,
    this.isNew,
    this.commercial,
    this.preEntry,
    this.beginDate,
    this.endDate,
    this.firstFree,
    this.popular,
    this.change,
    this.age,
    this.level,
    this.clubId,
  });

  factory ScheduleActivity.fromJson(Map<String, dynamic> json) {
    DateTime? parseDt(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return ScheduleActivity(
      id: json['id'] ?? 0,
      dateTime: parseDt(json['datetime'] ?? json['dateTime']),
      trainers: (json['trainers'] as List<dynamic>?)
          ?.map((t) => Trainer.fromJson(t as Map<String, dynamic>))
          .toList(),
      courseActivity: json['courseActivity'] as bool?,
      activity: json['activity'] != null
          ? Activity.fromJson(json['activity'] as Map<String, dynamic>)
          : null,
      group: json['group'] != null ? Group.fromJson(json['group'] as Map<String, dynamic>) : null,
      room: json['room'] != null ? Room.fromJson(json['room'] as Map<String, dynamic>) : null,
      length: json['length'] as int?,
      isNew: json['new'] as bool?,
      commercial: json['commercial'] as bool?,
      preEntry: json['preEntry'] as bool?,
      beginDate: parseDt(json['beginDate']),
      endDate: parseDt(json['endDate']),
      firstFree: json['firstFree'] as bool?,
      popular: json['popular'] as bool?,
      change: json['change'] != null ? ScheduleChange.fromJson(json['change'] as Map<String, dynamic>) : null,
      age: json['age'] != null ? AgeLevel.fromJson(json['age'] as Map<String, dynamic>) : null,
      level: json['level'] != null ? AgeLevel.fromJson(json['level'] as Map<String, dynamic>) : null,
      clubId: json['clubId'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'datetime': dateTime?.toIso8601String(),
        'trainers': trainers?.map((t) => t.toJson()).toList(),
        'courseActivity': courseActivity,
        'activity': activity?.toJson(),
        'group': group?.toJson(),
        'room': room?.toJson(),
        'length': length,
        'new': isNew,
        'commercial': commercial,
        'preEntry': preEntry,
        'beginDate': beginDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'firstFree': firstFree,
        'popular': popular,
        'change': change?.toJson(),
        'age': age?.toJson(),
        'level': level?.toJson(),
        'clubId': clubId,
      };
}

class ScheduleChange {
  final int id;
  final String? type;
  final String? title;
  final DateTime? datetime;
  final String? note;
  final List<Trainer>? trainers;
  final DateTime? publishDatetime;
  final Activity? activity;
  final bool? silent;
  final AgeLevel? age;
  final AgeLevel? level;
  final int? length;
  final Group? group;

  ScheduleChange({
    required this.id,
    this.type,
    this.title,
    this.datetime,
    this.note,
    this.trainers,
    this.publishDatetime,
    this.activity,
    this.silent,
    this.age,
    this.level,
    this.length,
    this.group,
  });

  factory ScheduleChange.fromJson(Map<String, dynamic> json) {
    DateTime? parseDt(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return ScheduleChange(
      id: json['id'] ?? 0,
      type: json['type'] as String?,
      title: json['title'] as String?,
      datetime: parseDt(json['datetime']),
      note: json['note'] as String?,
      trainers: (json['trainers'] as List<dynamic>?)
          ?.map((t) => Trainer.fromJson(t as Map<String, dynamic>))
          .toList(),
      publishDatetime: parseDt(json['publishDatetime']),
      activity: json['activity'] != null ? Activity.fromJson(json['activity'] as Map<String, dynamic>) : null,
      silent: json['silent'] as bool?,
      age: json['age'] != null ? AgeLevel.fromJson(json['age'] as Map<String, dynamic>) : null,
      level: json['level'] != null ? AgeLevel.fromJson(json['level'] as Map<String, dynamic>) : null,
      length: json['length'] as int?,
      group: json['group'] != null ? Group.fromJson(json['group'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'datetime': datetime?.toIso8601String(),
        'note': note,
        'trainers': trainers?.map((t) => t.toJson()).toList(),
        'publishDatetime': publishDatetime?.toIso8601String(),
        'activity': activity?.toJson(),
        'silent': silent,
        'age': age?.toJson(),
        'level': level?.toJson(),
        'length': length,
        'group': group?.toJson(),
      };
}

class Room {
  final int id;
  final int? sortOrder;
  final String? title;
  final int? area;
  final int? capacity;
  final String? description;
  final List<String>? pictures;

  Room({
    required this.id,
    this.sortOrder,
    this.title,
    this.area,
    this.capacity,
    this.description,
    this.pictures,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? 0,
      sortOrder: json['sortOrder'] as int?,
      title: json['title'] as String?,
      area: json['area'] as int?,
      capacity: json['capacity'] as int?,
      description: json['description'] as String?,
      pictures: (json['pictures'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sortOrder': sortOrder,
        'title': title,
        'area': area,
        'capacity': capacity,
        'description': description,
        'pictures': pictures,
      };
}

class AgeLevel {
  final int id;
  final int? sortOrder;
  final String? title;

  AgeLevel({required this.id, this.sortOrder, this.title});

  factory AgeLevel.fromJson(Map<String, dynamic> json) {
    return AgeLevel(
      id: json['id'] ?? 0,
      sortOrder: json['sortOrder'] as int?,
      title: json['title'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'sortOrder': sortOrder, 'title': title};
}
