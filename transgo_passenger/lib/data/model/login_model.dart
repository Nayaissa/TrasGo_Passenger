class LoginModel {
  final bool? success;
  final String? message;
  final LoginData? data;
  final int? statusCode;
  final String? timestamp;

  LoginModel({
    this.success,
    this.message,
    this.data,
    this.statusCode,
    this.timestamp,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
      statusCode: json['status_code'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'status_code': statusCode,
      'timestamp': timestamp,
    };
  }
}

class LoginData {
  final UserModel? user;
  final String? token;
  final String? role;
  final List<String>? roles;
  final bool? mustChangePassword;

  LoginData({
    this.user,
    this.token,
    this.role,
    this.roles,
    this.mustChangePassword,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      token: json['token'],
      role: json['role'],
      roles: json['roles'] != null
          ? List<String>.from(json['roles'])
          : [],
      mustChangePassword: json['must_change_password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'token': token,
      'role': role,
      'roles': roles,
      'must_change_password': mustChangePassword,
    };
  }
}

class UserModel {
  final int? userId;
  final String? fullName;
  final String? phone;
  final String? email;
  final bool? mustChangePassword;
  final int? accountStatus;
  final String? rating;
  final String? ratingLastUpdated;
  final dynamic createdBy;
  final String? registrationType;
  final String? profilePhoto;
  final String? createdAt;
  final String? updatedAt;
  final List<RoleModel>? roles;

  UserModel({
    this.userId,
    this.fullName,
    this.phone,
    this.email,
    this.mustChangePassword,
    this.accountStatus,
    this.rating,
    this.ratingLastUpdated,
    this.createdBy,
    this.registrationType,
    this.profilePhoto,
    this.createdAt,
    this.updatedAt,
    this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      fullName: json['full_name'],
      phone: json['phone'],
      email: json['email'],
      mustChangePassword: json['must_change_password'],
      accountStatus: json['account_status'],
      rating: json['rating']?.toString(),
      ratingLastUpdated: json['rating_last_updated']?.toString(),
      createdBy: json['created_by'],
      registrationType: json['registration_type'],
      profilePhoto: json['profile_photo']?.toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      roles: json['roles'] != null
          ? List<RoleModel>.from(
              json['roles'].map((role) => RoleModel.fromJson(role)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'must_change_password': mustChangePassword,
      'account_status': accountStatus,
      'rating': rating,
      'rating_last_updated': ratingLastUpdated,
      'created_by': createdBy,
      'registration_type': registrationType,
      'profile_photo': profilePhoto,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'roles': roles?.map((role) => role.toJson()).toList(),
    };
  }
}

class RoleModel {
  final int? id;
  final String? name;
  final String? createdAt;
  final String? updatedAt;
  final PivotModel? pivot;

  RoleModel({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pivot: json['pivot'] != null ? PivotModel.fromJson(json['pivot']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'pivot': pivot?.toJson(),
    };
  }
}

class PivotModel {
  final int? userId;
  final int? roleId;

  PivotModel({
    this.userId,
    this.roleId,
  });

  factory PivotModel.fromJson(Map<String, dynamic> json) {
    return PivotModel(
      userId: json['user_id'],
      roleId: json['role_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'role_id': roleId,
    };
  }
}