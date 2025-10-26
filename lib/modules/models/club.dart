class Club {
  final int id;
  final String title;
  final String address;
  final String phone;
  final String email;
  final String city;
  final List<ClubPhoto> photos;
  final String description;
  final String workingHours;
  final String? barCodeType;

  Club({
    required this.id,
    required this.title,
    required this.address,
    required this.phone,
    required this.photos,
    required this.email,
    required this.city,
    required this.description,
    required this.workingHours,
    this.barCodeType,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      photos: (json['photos'] as List<dynamic>?)
          ?.map((photo) => ClubPhoto.fromJson(photo))
          .toList() ?? [],
      city: json['city'] ?? '',
      description: json['description'] ?? '',
      workingHours: json['workingHours'] ?? 'Не указано',
      barCodeType: json['barCodeType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'address': address,
      'phone': phone,
      'email': email,
      'city': city,
      'photos': photos.map((photo) => photo.toJson()).toList(),
      'description': description,
      'barCodeType': barCodeType,
    };
  }
}

class ClubPhoto {
  final String normal;
  final String high;
  final bool isDefault;

  ClubPhoto({
    required this.normal,
    required this.high,
    required this.isDefault,
  });

  factory ClubPhoto.fromJson(Map<String, dynamic> json) {
    return ClubPhoto(
      normal: json['normal'] ?? '',
      high: json['high'] ?? '',
      isDefault: json['default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'normal': normal,
      'high': high,
      'default': isDefault,
    };
  }
}