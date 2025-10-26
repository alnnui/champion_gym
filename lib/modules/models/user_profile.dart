class UserProfile {
  final int id;
  final String phone;
  final String? username;
  final String? email;
  final String? avatarUrl;
  final Map<String, dynamic>? avatarConfig;  // Конфигурация Rive-аватара
  final String? card;  // Номер карты из CRM

  // Геймификация
  final int xpPoints;
  final int level;
  final String? referralCode;
  
  // Метаданные
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // CRM данные (опционально)
  final int? crmUserId;
  final DateTime? crmLastSync;

  UserProfile({
    required this.id,
    required this.phone,
    this.username,
    this.email,
    this.avatarUrl,
    this.avatarConfig,
    this.card,
    this.xpPoints = 0,
    this.level = 1,
    this.referralCode,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.crmUserId,
    this.crmLastSync,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      phone: json['phone'] as String,
      username: json['username'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      avatarConfig: json['avatar_config'] != null
          ? Map<String, dynamic>.from(json['avatar_config'] as Map)
          : null,
      card: json['card'] as String?,
      xpPoints: json['xp_points'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      referralCode: json['referral_code'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      crmUserId: json['crm_user_id'] as int?,
      crmLastSync: json['crm_last_sync'] != null 
          ? DateTime.parse(json['crm_last_sync'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'avatar_config': avatarConfig,
      'card': card,
      'xp_points': xpPoints,
      'level': level,
      'referral_code': referralCode,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'crm_user_id': crmUserId,
      'crm_last_sync': crmLastSync?.toIso8601String(),
    };
  }

  // Helper методы
  String get displayName => username ?? phone;
  
  int get xpToNextLevel => (level * 100) - (xpPoints % (level * 100));
  
  double get levelProgress => (xpPoints % (level * 100)) / (level * 100);

  UserProfile copyWith({
    int? id,
    String? phone,
    String? username,
    String? email,
    String? avatarUrl,
    Map<String, dynamic>? avatarConfig,
    String? card,
    int? xpPoints,
    int? level,
    String? referralCode,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? crmUserId,
    DateTime? crmLastSync,
  }) {
    return UserProfile(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarConfig: avatarConfig ?? this.avatarConfig,
      card: card ?? this.card,
      xpPoints: xpPoints ?? this.xpPoints,
      level: level ?? this.level,
      referralCode: referralCode ?? this.referralCode,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      crmUserId: crmUserId ?? this.crmUserId,
      crmLastSync: crmLastSync ?? this.crmLastSync,
    );
  }
}
