import 'package:myapp/modules/models/schedule_item.dart';

/// Models for parsing visit history JSON payloads.
/// Use `VisitHistory.fromJson(map)` to parse.
class VisitHistory {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final List<HistoryEvent> historyEvents;
  
  // Дополнительное поле для хранения детальной информации о занятии
  // Загружается отдельным запросом
  ScheduleItem? scheduleItem;

  VisitHistory({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.historyEvents,
    this.scheduleItem,
  });

  factory VisitHistory.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return DateTime.now();
      }
    }

    return VisitHistory(
      id: json['id'] as String? ?? '',
      startDate: parseDate(json['startDate']),
      endDate: parseDate(json['endDate']),
      historyEvents: (json['historyEvents'] as List<dynamic>?)
              ?.map((e) => HistoryEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'historyEvents': historyEvents.map((e) => e.toJson()).toList(),
      };
}

class HistoryEvent {
  final int eventId;
  final DateTime startDate;
  final DateTime endDate;
  final String? trainerTitle;
  final String? trainerPosition;
  final ServiceTitle? serviceTitle;
  final RoomTitle? roomTitle;
  final String? type;
  final int? count;
  final String? status;
  final String? arrivalStatus;

  HistoryEvent({
    required this.eventId,
    required this.startDate,
    required this.endDate,
    this.trainerTitle,
    this.trainerPosition,
    this.serviceTitle,
    this.roomTitle,
    this.type,
    this.count,
    this.status,
    this.arrivalStatus,
  });

  factory HistoryEvent.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return DateTime.now();
      }
    }

    return HistoryEvent(
      eventId: json['eventId'] as int? ?? 0,
      startDate: parseDate(json['startDate']),
      endDate: parseDate(json['endDate']),
      trainerTitle: json['trainerTitle'] as String?,
      trainerPosition: json['trainerPosition'] as String?,
      serviceTitle: json['serviceTitle'] != null
          ? ServiceTitle.fromJson(json['serviceTitle'] as Map<String, dynamic>)
          : null,
      roomTitle: json['roomTitle'] != null
          ? RoomTitle.fromJson(json['roomTitle'] as Map<String, dynamic>)
          : null,
      type: json['type'] as String?,
      count: json['count'] as int?,
      status: json['status'] as String?,
      arrivalStatus: json['arrivalStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'trainerTitle': trainerTitle,
        'trainerPosition': trainerPosition,
        'serviceTitle': serviceTitle?.toJson(),
        'roomTitle': roomTitle?.toJson(),
        'type': type,
        'count': count,
        'status': status,
        'arrivalStatus': arrivalStatus,
      };

  /// Вычисляет длительность события в минутах
  int get durationInMinutes {
    return endDate.difference(startDate).inMinutes;
  }
}

class ServiceTitle {
  final int id;
  final String title;
  final String? type;
  final int? typeId;
  final String? color;
  final String? description;
  final String? youtubePreviewUrl;
  final String? youtubeUrl;
  final int? length;

  ServiceTitle({
    required this.id,
    required this.title,
    this.type,
    this.typeId,
    this.color,
    this.description,
    this.youtubePreviewUrl,
    this.youtubeUrl,
    this.length,
  });

  factory ServiceTitle.fromJson(Map<String, dynamic> json) {
    return ServiceTitle(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      type: json['type'] as String?,
      typeId: json['typeId'] as int?,
      color: json['color'] as String?,
      description: json['description'] as String?,
      youtubePreviewUrl: json['youtubePreviewUrl'] as String?,
      youtubeUrl: json['youtubeUrl'] as String?,
      length: json['length'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'typeId': typeId,
        'color': color,
        'description': description,
        'youtubePreviewUrl': youtubePreviewUrl,
        'youtubeUrl': youtubeUrl,
        'length': length,
      };
}

class RoomTitle {
  final int id;
  final int? sortOrder;
  final String title;
  final int? area;
  final int? capacity;
  final String? description;
  final List<String>? pictures;

  RoomTitle({
    required this.id,
    required this.title,
    this.sortOrder,
    this.area,
    this.capacity,
    this.description,
    this.pictures,
  });

  factory RoomTitle.fromJson(Map<String, dynamic> json) {
    return RoomTitle(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      sortOrder: json['sortOrder'] as int?,
      area: json['area'] as int?,
      capacity: json['capacity'] as int?,
      description: json['description'] as String?,
      pictures: (json['pictures'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'sortOrder': sortOrder,
        'area': area,
        'capacity': capacity,
        'description': description,
        'pictures': pictures,
      };
}
