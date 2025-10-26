class Currency {
  final String? alfa3;
  final int? precision;
  final String? title;
  final String? symbol;
  final String? locale;

  Currency({
    this.alfa3,
    this.precision,
    this.title,
    this.symbol,
    this.locale,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      alfa3: json['alfa3'] as String?,
      precision: json['precision'] as int?,
      title: json['title'] as String?,
      symbol: json['symbol'] as String?,
      locale: json['locale'] as String?,
    );
  }
}

class Price {
  final num? amount;
  final Currency? currency;

  Price({
    this.amount,
    this.currency,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      amount: json['amount'] as num?,
      currency: json['currency'] != null
          ? Currency.fromJson(json['currency'] as Map<String, dynamic>)
          : null,
    );
  }
}

class RecurrentSettings {
  final String? status;
  final DateTime? nextDate;
  final bool? canBeCanceled;
  final Price? price;
  final int? sortOrder;

  RecurrentSettings({
    this.status,
    this.nextDate,
    this.canBeCanceled,
    this.price,
    this.sortOrder,
  });

  factory RecurrentSettings.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v is DateTime) return v;
      if (v is String && v.isNotEmpty) {
        return DateTime.tryParse(v);
      }
      return null;
    }

    return RecurrentSettings(
      status: json['status'] as String?,
      nextDate: parseDate(json['nextDate']),
      canBeCanceled: json['canBeCanceled'] as bool?,
      price: json['price'] != null
          ? Price.fromJson(json['price'] as Map<String, dynamic>)
          : null,
      sortOrder: json['sortOrder'] as int?,
    );
  }
}

class AccountService {
  final String id;
  final String? title;
  final String? priceType;
  final String? type;
  final String? typeService;
  final num? initialBalance;
  final String? status;
  final DateTime? endDate;
  final DateTime? statusDate;
  final num? balance;
  final bool? recurrent;
  final RecurrentSettings? recurrentSettings;
  final int? countReserves;
  final String? trainerName;

  AccountService({
    required this.id,
    this.title,
    this.priceType,
    this.type,
    this.typeService,
    this.initialBalance,
    this.status,
    this.endDate,
    this.statusDate,
    this.balance,
    this.recurrent,
    this.recurrentSettings,
    this.countReserves,
    this.trainerName,
  });

  factory AccountService.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v is DateTime) return v;
      if (v is String && v.isNotEmpty) {
        return DateTime.tryParse(v);
      }
      return null;
    }

    return AccountService(
      id: json['id']?.toString() ?? '0',
      title: json['title'] as String?,
      priceType: json['priceType'] as String?,
      type: json['type'] as String?,
      typeService: json['typeService'] as String?,
      initialBalance: json['initialBalance'] as num?,
      status: json['status'] as String?,
      endDate: parseDate(json['endDate']),
      statusDate: parseDate(json['statusDate']),
      balance: json['balance'] as num?,
      recurrent: json['recurrent'] as bool?,
      recurrentSettings: json['recurrentSettings'] != null
          ? RecurrentSettings.fromJson(json['recurrentSettings'] as Map<String, dynamic>)
          : null,
      countReserves: json['countReserves'] as int?,
      trainerName: json['trainerName'] as String?,
    );
  }

  static List<AccountService> listFromJson(List<dynamic> list) {
    return list
        .map((e) => e is Map<String, dynamic>
            ? AccountService.fromJson(e)
            : AccountService.fromJson({}))
        .toList();
  }

  /// Проверяет, является ли сервис абонементом (Membership)
  bool get isMembership => type == 'Membership';

  /// Проверяет, активен ли абонемент
  bool get isActive => status == 'Active';

  /// Получить количество оставшихся дней до окончания
  int? get daysLeft {
    if (endDate == null) return null;
    final now = DateTime.now();
    if (endDate!.isBefore(now)) return 0;
    return endDate!.difference(now).inDays;
  }
}
