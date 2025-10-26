import 'package:myapp/modules/models/club.dart';

class Customer {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? email;
  final String? phone;
  final DateTime? birthday;
  final bool? temporaryPass;
  final String? card;
  final int? gender;
  final String? passportSeries;
  final String? passportNumber;
  final DateTime? passportDate;
  final String? passportPlace;
  final String? residencePlace;
  final String? additionalPhone;
  final String? carNumber;
  final String? photo;

  Customer({
    required this.id,
    this.firstName,
    this.lastName,
    this.middleName,
    this.email,
    this.phone,
    this.birthday,
    this.temporaryPass,
    this.card,
    this.gender,
    this.passportSeries,
    this.passportNumber,
    this.passportDate,
    this.passportPlace,
    this.residencePlace,
    this.additionalPhone,
    this.carNumber,
    this.photo,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) {
      if (v is int) return v;
      return int.tryParse(v?.toString() ?? '') ?? 0;
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

    DateTime? parseDate(dynamic v) {
      if (v is DateTime) return v;
      if (v is String && v.isNotEmpty) {
        return DateTime.tryParse(v);
      }
      return null;
    }

    return Customer(
      id: parseInt(json['id']),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      middleName: json['middleName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      birthday: parseDate(json['birthday']),
      temporaryPass: json.containsKey('temporaryPass')
          ? parseBool(json['temporaryPass'])
          : null,
      card: json['card'] as String?,
      gender: json['gender'] as int?,
      passportSeries: json['passportSeries'] as String?,
      passportNumber: json['passportNumber'] as String?,
      passportDate: parseDate(json['passportDate']),
      passportPlace: json['passportPlace'] as String?,
      residencePlace: json['residencePlace'] as String?,
      additionalPhone: json['additionalPhone'] as String?,
      carNumber: json['carNumber'] as String?,
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'email': email,
      'phone': phone,
      'birthday': birthday?.toIso8601String(),
      'temporaryPass': temporaryPass,
      'card': card,
      'gender': gender,
      'passportSeries': passportSeries,
      'passportNumber': passportNumber,
      'passportDate': passportDate?.toIso8601String(),
      'passportPlace': passportPlace,
      'residencePlace': residencePlace,
      'additionalPhone': additionalPhone,
      'carNumber': carNumber,
    };
  }

  static List<Customer> listFromJson(List<dynamic> list) {
    return list
        .map((e) => e is Map<String, dynamic>
            ? Customer.fromJson(e)
            : Customer.fromJson({}))
        .toList();
  }

  /// Helper for payloads like { "customer": [ ... ] }
  static List<Customer> listFromEnvelope(Map<String, dynamic> json, {String key = 'customer'}) {
    final raw = json[key] ?? json['Customer'];
    // API sometimes returns a single object under 'customer' (not an array)
    if (raw is List) {
      return listFromJson(raw);
    }
    if (raw is Map<String, dynamic>) {
      return [Customer.fromJson(raw)];
    }
    return [];
  }
}

class User {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final DateTime? birthday;
  final bool? temporaryPass;

  User({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.birthday,
    this.temporaryPass,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) {
      if (v is int) return v;
      return int.tryParse(v?.toString() ?? '') ?? 0;
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

    DateTime? parseDate(dynamic v) {
      if (v is DateTime) return v;
      if (v is String && v.isNotEmpty) {
        return DateTime.tryParse(v);
      }
      return null;
    }

    return User(
      id: parseInt(json['id']),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      birthday: parseDate(json['birthday']),
      temporaryPass: json.containsKey('temporaryPass')
          ? parseBool(json['temporaryPass'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'birthday': birthday?.toIso8601String(),
      'temporaryPass': temporaryPass,
    };
  }

  static List<Customer> listFromJson(List<dynamic> list) {
    return list
        .map((e) => e is Map<String, dynamic>
            ? Customer.fromJson(e)
            : Customer.fromJson({}))
        .toList();
  }

  /// Helper for payloads like { "customer": [ ... ] }
  static List<Customer> listFromEnvelope(Map<String, dynamic> json, {String key = 'customer'}) {
    final raw = json[key] ?? json['Customer'];
    if (raw is List) {
      return listFromJson(raw);
    }
    if (raw is Map<String, dynamic>) {
      return [Customer.fromJson(raw)];
    }
    return [];
  }
}

class Balance {
  final int credits;
  final int totalCredits;

  Balance({required this.credits, required this.totalCredits});

  factory Balance.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;
    return Balance(
      credits: parseInt(json['credits']),
      totalCredits: parseInt(json['totalCredits']),
    );
  }

  Map<String, dynamic> toJson() => {
        'credits': credits,
        'totalCredits': totalCredits,
      };
}

/// Full user payload model matching:
/// {
///   "card": "string",
///   "phone": "string",
///   "countryId": 0,
///   "businessStatus": "lead",
///   "locale": "string",
///   "editAllowed": true,
///   "showBonusRankInApi": true,
///   "club": Club,
///   "Customer": [ Customer ],
///   "balance": { "credits": 0, "totalCredits": 0 }
/// }
class UserProfile {
  final String? card;
  final String? phone;
  final int? countryId;
  final String? businessStatus;
  final String? locale;
  final bool? editAllowed;
  final bool? showBonusRankInApi;
  final Club? club;
  final List<Customer> customers;
  final Balance? balance;

  UserProfile({
    this.card,
    this.phone,
    this.countryId,
    this.businessStatus,
    this.locale,
    this.editAllowed,
    this.showBonusRankInApi,
    this.club,
    this.customers = const [],
    this.balance,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    String? parseString(dynamic v) => v?.toString();
    int? parseIntNullable(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }
    bool? parseBoolNullable(dynamic v) {
      if (v == null) return null;
      if (v is bool) return v;
      final s = v.toString().toLowerCase();
      if (s == 'true' || s == '1' || s == 'yes') return true;
      if (s == 'false' || s == '0' || s == 'no') return false;
      return null;
    }

    final customersList = Customer.listFromEnvelope(json, key: 'customer');

    // Resolve balance with fallbacks: 'balance' map, 'Balance' map, or credits/totalCredits at root
    Balance? resolvedBalance;
    final dynamic balanceRaw = json['balance'] ?? json['Balance'];
    if (balanceRaw is Map<String, dynamic>) {
      resolvedBalance = Balance.fromJson(balanceRaw);
    } else if (json.containsKey('credits') || json.containsKey('totalCredits')) {
      resolvedBalance = Balance.fromJson({
        'credits': json['credits'],
        'totalCredits': json['totalCredits'],
      });
    }

    return UserProfile(
      card: parseString(json['card']),
      phone: parseString(json['phone']),
      countryId: parseIntNullable(json['countryId']),
      businessStatus: parseString(json['businessStatus']),
      locale: parseString(json['locale']),
      editAllowed: parseBoolNullable(json['editAllowed']),
      showBonusRankInApi: parseBoolNullable(json['showBonusRankInApi']),
      club: json['club'] is Map<String, dynamic> ? Club.fromJson(json['club']) : null,
      customers: customersList,
      balance: resolvedBalance,
    );
  }

  Map<String, dynamic> toJson() => {
        'card': card,
        'phone': phone,
        'countryId': countryId,
        'businessStatus': businessStatus,
        'locale': locale,
        'editAllowed': editAllowed,
        'showBonusRankInApi': showBonusRankInApi,
        'club': club?.toJson(),
        // Keep API key as provided — prefer capitalized 'Customer' but include lowercase for consistency if needed
        'Customer': customers.map((e) => e.toJson()).toList(),
        'balance': balance?.toJson(),
      };
}
