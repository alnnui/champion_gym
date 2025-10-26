import 'package:myapp/modules/models/activity.dart';
import 'package:myapp/modules/models/trainer.dart';
import 'package:myapp/modules/models/schedule_models.dart';

/// Модель для детальной информации о занятии из расписания
/// GET /schedule/{itemId}/item.json
class ScheduleItem {
  final int id;
  final DateTime? localClubTime;
  final DateTime? datetime;
  final List<Trainer>? trainers;
  final bool? courseActivity;
  final Activity? activity;
  final Group? group;
  final Room? room;
  final String? resourcesTitle;
  final List<Resource>? resources;
  final int? length;
  final bool? isNew;
  final bool? commercial;
  final bool? preEntry;
  final DateTime? beginDate;
  final DateTime? endDate;
  final bool? bookingOpened;
  final bool? firstFree;
  final String? type;
  final bool? popular;
  final ScheduleChange? change;
  final int? availableSlots;
  final int? totalSlots;
  final bool? reserved;
  final bool? temporarilyReserved;
  final String? comment;
  final double? cost;
  final AgeLevel? age;
  final AgeLevel? level;
  final int? subscriptionId;
  final Hook? hook;
  final int? clubId;
  final String? bookingStatus;
  final WaitingList? waitingList;
  final List<Relation>? relations;

  ScheduleItem({
    required this.id,
    this.localClubTime,
    this.datetime,
    this.trainers,
    this.courseActivity,
    this.activity,
    this.group,
    this.room,
    this.resourcesTitle,
    this.resources,
    this.length,
    this.isNew,
    this.commercial,
    this.preEntry,
    this.beginDate,
    this.endDate,
    this.bookingOpened,
    this.firstFree,
    this.type,
    this.popular,
    this.change,
    this.availableSlots,
    this.totalSlots,
    this.reserved,
    this.temporarilyReserved,
    this.comment,
    this.cost,
    this.age,
    this.level,
    this.subscriptionId,
    this.hook,
    this.clubId,
    this.bookingStatus,
    this.waitingList,
    this.relations,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return null;
      }
    }

    return ScheduleItem(
      id: json['id'] as int? ?? 0,
      localClubTime: parseDate(json['localClubTime']),
      datetime: parseDate(json['datetime']),
      trainers: (json['trainers'] as List<dynamic>?)
          ?.map((e) => Trainer.fromJson(e as Map<String, dynamic>))
          .toList(),
      courseActivity: json['courseActivity'] as bool?,
      activity: json['activity'] != null
          ? Activity.fromJson(json['activity'] as Map<String, dynamic>)
          : null,
      group: json['group'] != null
          ? Group.fromJson(json['group'] as Map<String, dynamic>)
          : null,
      room: json['room'] != null
          ? Room.fromJson(json['room'] as Map<String, dynamic>)
          : null,
      resourcesTitle: json['resourcesTitle'] as String?,
      resources: (json['resources'] as List<dynamic>?)
          ?.map((e) => Resource.fromJson(e as Map<String, dynamic>))
          .toList(),
      length: json['length'] as int?,
      isNew: json['new'] as bool?,
      commercial: json['commercial'] as bool?,
      preEntry: json['preEntry'] as bool?,
      beginDate: parseDate(json['beginDate']),
      endDate: parseDate(json['endDate']),
      bookingOpened: json['bookingOpened'] as bool?,
      firstFree: json['firstFree'] as bool?,
      type: json['type'] as String?,
      popular: json['popular'] as bool?,
      change: json['change'] != null
          ? ScheduleChange.fromJson(json['change'] as Map<String, dynamic>)
          : null,
      availableSlots: json['availableSlots'] as int?,
      totalSlots: json['totalSlots'] as int?,
      reserved: json['reserved'] as bool?,
      temporarilyReserved: json['temporarilyReserved'] as bool?,
      comment: json['comment'] as String?,
      cost: (json['cost'] as num?)?.toDouble(),
      age: json['age'] != null
          ? AgeLevel.fromJson(json['age'] as Map<String, dynamic>)
          : null,
      level: json['level'] != null
          ? AgeLevel.fromJson(json['level'] as Map<String, dynamic>)
          : null,
      subscriptionId: json['subscriptionId'] as int?,
      hook: json['hook'] != null
          ? Hook.fromJson(json['hook'] as Map<String, dynamic>)
          : null,
      clubId: json['clubId'] as int?,
      bookingStatus: json['bookingStatus'] as String?,
      waitingList: json['waitingList'] != null
          ? WaitingList.fromJson(json['waitingList'] as Map<String, dynamic>)
          : null,
      relations: (json['relations'] as List<dynamic>?)
          ?.map((e) => Relation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'localClubTime': localClubTime?.toIso8601String(),
        'datetime': datetime?.toIso8601String(),
        'trainers': trainers?.map((e) => e.toJson()).toList(),
        'courseActivity': courseActivity,
        'activity': activity?.toJson(),
        'group': group?.toJson(),
        'room': room?.toJson(),
        'resourcesTitle': resourcesTitle,
        'resources': resources?.map((e) => e.toJson()).toList(),
        'length': length,
        'new': isNew,
        'commercial': commercial,
        'preEntry': preEntry,
        'beginDate': beginDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'bookingOpened': bookingOpened,
        'firstFree': firstFree,
        'type': type,
        'popular': popular,
        'change': change?.toJson(),
        'availableSlots': availableSlots,
        'totalSlots': totalSlots,
        'reserved': reserved,
        'temporarilyReserved': temporarilyReserved,
        'comment': comment,
        'cost': cost,
        'age': age?.toJson(),
        'level': level?.toJson(),
        'subscriptionId': subscriptionId,
        'hook': hook?.toJson(),
        'clubId': clubId,
        'bookingStatus': bookingStatus,
        'waitingList': waitingList?.toJson(),
        'relations': relations?.map((e) => e.toJson()).toList(),
      };
}

class Resource {
  final String id;
  final String title;

  Resource({
    required this.id,
    required this.title,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };
}

class Hook {
  final String? status;
  final String? message;

  Hook({
    this.status,
    this.message,
  });

  factory Hook.fromJson(Map<String, dynamic> json) {
    return Hook(
      status: json['status'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
      };
}

class WaitingList {
  final bool? enabled;
  final WaitingListRecord? record;

  WaitingList({
    this.enabled,
    this.record,
  });

  factory WaitingList.fromJson(Map<String, dynamic> json) {
    return WaitingList(
      enabled: json['enabled'] as bool?,
      record: json['record'] != null
          ? WaitingListRecord.fromJson(json['record'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'record': record?.toJson(),
      };
}

class WaitingListRecord {
  final int id;
  final String? comment;

  WaitingListRecord({
    required this.id,
    this.comment,
  });

  factory WaitingListRecord.fromJson(Map<String, dynamic> json) {
    return WaitingListRecord(
      id: json['id'] as int? ?? 0,
      comment: json['comment'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'comment': comment,
      };
}

class Relation {
  final int? customerId;
  final String? comment;
  final bool? temporarilyReserved;
  final bool? reserved;
  final Hook? hook;
  final String? bookingStatus;
  final WaitingListRecord? waitingListRecord;

  Relation({
    this.customerId,
    this.comment,
    this.temporarilyReserved,
    this.reserved,
    this.hook,
    this.bookingStatus,
    this.waitingListRecord,
  });

  factory Relation.fromJson(Map<String, dynamic> json) {
    return Relation(
      customerId: json['customerId'] as int?,
      comment: json['comment'] as String?,
      temporarilyReserved: json['temporarilyReserved'] as bool?,
      reserved: json['reserved'] as bool?,
      hook: json['hook'] != null
          ? Hook.fromJson(json['hook'] as Map<String, dynamic>)
          : null,
      bookingStatus: json['bookingStatus'] as String?,
      waitingListRecord: json['waitingListRecord'] != null
          ? WaitingListRecord.fromJson(
              json['waitingListRecord'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'customerId': customerId,
        'comment': comment,
        'temporarilyReserved': temporarilyReserved,
        'reserved': reserved,
        'hook': hook?.toJson(),
        'bookingStatus': bookingStatus,
        'waitingListRecord': waitingListRecord?.toJson(),
      };
}
