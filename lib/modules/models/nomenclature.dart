class NomenclatureType {
  final int id;
  final String title;
  final int priority;
  final List<Nomenclature> nomenclatures;

  NomenclatureType({
    required this.id,
    required this.title,
    required this.priority,
    required this.nomenclatures,
  });

  factory NomenclatureType.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;
    return NomenclatureType(
      id: parseInt(json['id']),
      title: (json['title'] ?? '').toString(),
      priority: parseInt(json['priority']),
      nomenclatures: (json['nomenclatures'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => Nomenclature.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'priority': priority,
        'nomenclatures': nomenclatures.map((e) => e.toJson()).toList(),
      };
}

class Nomenclature {
  final int id;
  final String title;
  final int priority;
  final List<Sku> skus;
  final List<int> clubs;

  Nomenclature({
    required this.id,
    required this.title,
    required this.priority,
    required this.skus,
    required this.clubs,
  });

  factory Nomenclature.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;
    return Nomenclature(
      id: parseInt(json['id']),
      title: (json['title'] ?? '').toString(),
      priority: parseInt(json['priority']),
      skus: (json['skus'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => Sku.fromJson(e))
          .toList(),
      clubs: (json['clubs'] as List<dynamic>? ?? [])
          .map((e) => e is int ? e : int.tryParse(e?.toString() ?? '') ?? 0)
          .where((e) => e != 0)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'priority': priority,
        'skus': skus.map((e) => e.toJson()).toList(),
        'clubs': clubs,
      };
}

class Sku {
  final String id;
  final String title;
  final String? description;
  final String? type;
  final String? restriction;
  final Restrictions? restrictions;
  final int? amount;
  final String? entityId;
  final num? price;
  final int? priority;
  final bool? usedToCount;
  final bool? recurrent;
  final List<DependentSku> dependentSku;
  final bool? hasPriceTypes;
  final bool? hasCyclePeriods;
  final DepositAccount? depositAccount;
  final List<DepositAccount> depositAccounts;
  final String? externalId;
  final String? courseId;
  final String? cycleId;
  final Cycle? cycle;
  final List<String> pictures;

  Sku({
    required this.id,
    required this.title,
    this.description,
    this.type,
    this.restriction,
    this.restrictions,
    this.amount,
    this.entityId,
    this.price,
    this.priority,
    this.usedToCount,
    this.recurrent,
    this.dependentSku = const [],
    this.hasPriceTypes,
    this.hasCyclePeriods,
    this.depositAccount,
    this.depositAccounts = const [],
    this.externalId,
    this.courseId,
    this.cycleId,
    this.cycle,
    this.pictures = const [],
  });

  factory Sku.fromJson(Map<String, dynamic> json) {
    int? parseIntN(dynamic v) => v == null
        ? null
        : (v is int ? v : int.tryParse(v.toString()));
    num? parseNum(dynamic v) => v == null
        ? null
        : (v is num ? v : num.tryParse(v.toString()));
    bool? parseBool(dynamic v) {
      if (v == null) return null;
      if (v is bool) return v;
      final s = v.toString().toLowerCase();
      if (s == 'true' || s == '1' || s == 'yes') return true;
      if (s == 'false' || s == '0' || s == 'no') return false;
      return null;
    }

    return Sku(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] as String?),
      type: (json['type'] as String?),
      restriction: (json['restriction'] as String?),
      restrictions: json['restrictions'] is Map<String, dynamic>
          ? Restrictions.fromJson(json['restrictions'])
          : null,
      amount: parseIntN(json['amount']),
      entityId: (json['entityId'] as String?),
      price: parseNum(json['price']),
      priority: parseIntN(json['priority']),
      usedToCount: parseBool(json['usedToCount']),
      recurrent: parseBool(json['recurrent']),
      dependentSku: (json['dependentSku'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => DependentSku.fromJson(e))
          .toList(),
      hasPriceTypes: parseBool(json['hasPriceTypes']),
      hasCyclePeriods: parseBool(json['hasCyclePeriods']),
      depositAccount: json['depositAccount'] is Map<String, dynamic>
          ? DepositAccount.fromJson(json['depositAccount'])
          : null,
      depositAccounts: (json['depositAccounts'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => DepositAccount.fromJson(e))
          .toList(),
      externalId: (json['externalId'] as String?),
      courseId: (json['courseId'] as String?),
      cycleId: (json['cycleId'] as String?),
      cycle: json['cycle'] is Map<String, dynamic>
          ? Cycle.fromJson(json['cycle'])
          : null,
      pictures: (json['pictures'] as List<dynamic>? ?? [])
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type,
        'restriction': restriction,
        'restrictions': restrictions?.toJson(),
        'amount': amount,
        'entityId': entityId,
        'price': price,
        'priority': priority,
        'usedToCount': usedToCount,
        'recurrent': recurrent,
        'dependentSku': dependentSku.map((e) => e.toJson()).toList(),
        'hasPriceTypes': hasPriceTypes,
        'hasCyclePeriods': hasCyclePeriods,
        'depositAccount': depositAccount?.toJson(),
        'depositAccounts': depositAccounts.map((e) => e.toJson()).toList(),
        'externalId': externalId,
        'courseId': courseId,
        'cycleId': cycleId,
        'cycle': cycle?.toJson(),
        'pictures': pictures,
      };
}

class Restrictions {
  final Locations? locations;
  final WorkTime? workTime;

  Restrictions({this.locations, this.workTime});

  factory Restrictions.fromJson(Map<String, dynamic> json) => Restrictions(
        locations: json['locations'] is Map<String, dynamic>
            ? Locations.fromJson(json['locations'])
            : null,
        workTime: json['workTime'] is Map<String, dynamic>
            ? WorkTime.fromJson(json['workTime'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'locations': locations?.toJson(),
        'workTime': workTime?.toJson(),
      };
}

class Locations {
  final String? caption;
  final List<String> items;

  Locations({this.caption, this.items = const []});

  factory Locations.fromJson(Map<String, dynamic> json) => Locations(
        caption: json['caption'] as String?,
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => e?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'caption': caption,
        'items': items,
      };
}

class WorkTime {
  final String? caption;
  final String? plainText;
  final List<WorkDay> items;

  WorkTime({this.caption, this.plainText, this.items = const []});

  factory WorkTime.fromJson(Map<String, dynamic> json) => WorkTime(
        caption: json['caption'] as String?,
        plainText: json['plainText'] as String?,
        items: (json['items'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map((e) => WorkDay.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'caption': caption,
        'plainText': plainText,
        'items': items.map((e) => e.toJson()).toList(),
      };
}

class WorkDay {
  final String? day;
  final List<TimeRange> times;
  final String? hint;

  WorkDay({this.day, this.times = const [], this.hint});

  factory WorkDay.fromJson(Map<String, dynamic> json) => WorkDay(
        day: json['day'] as String?,
        times: (json['times'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map((e) => TimeRange.fromJson(e))
            .toList(),
        hint: json['hint'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        'times': times.map((e) => e.toJson()).toList(),
        'hint': hint,
      };
}

class TimeRange {
  final String? begin;
  final String? end;

  TimeRange({this.begin, this.end});

  factory TimeRange.fromJson(Map<String, dynamic> json) => TimeRange(
        begin: json['begin'] as String?,
        end: json['end'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'begin': begin,
        'end': end,
      };
}

class DependentSku {
  final String id;
  final String title;
  final String? type;
  final num? price;

  DependentSku({required this.id, required this.title, this.type, this.price});

  factory DependentSku.fromJson(Map<String, dynamic> json) => DependentSku(
        id: (json['id'] ?? '').toString(),
        title: (json['title'] ?? '').toString(),
        type: json['type'] as String?,
        price: json['price'] is num ? json['price'] as num : num.tryParse(json['price']?.toString() ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'price': price,
      };
}

class DepositAccount {
  final String id;
  final String name;
  final String type;
  final String? entityId;
  final num? balance;

  DepositAccount({
    required this.id,
    required this.name,
    required this.type,
    this.entityId,
    this.balance,
  });

  factory DepositAccount.fromJson(Map<String, dynamic> json) => DepositAccount(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        type: (json['type'] ?? '').toString(),
        entityId: json['entityId']?.toString(),
        balance: json['balance'] is num ? json['balance'] as num : num.tryParse(json['balance']?.toString() ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'entityId': entityId,
        'balance': balance,
      };
}

class Cycle {
  final String id;
  final String title;
  final String? periodicity;
  final int? iteration;

  Cycle({
    required this.id,
    required this.title,
    this.periodicity,
    this.iteration,
  });

  factory Cycle.fromJson(Map<String, dynamic> json) => Cycle(
        id: (json['id'] ?? '').toString(),
        title: (json['title'] ?? '').toString(),
        periodicity: json['periodicity'] as String?,
        iteration: json['iteration'] is int ? json['iteration'] as int : int.tryParse(json['iteration']?.toString() ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'periodicity': periodicity,
        'iteration': iteration,
      };
}
