// Model for User Info table

class UserDetail {
  String userName;
  String email;
  String userImageUrl;
  String displayName;
  String providerId;
  String addressLocation;
  String countryCode;
  String buyingCountryCode;
  double latitude;
  double longitude;
  String phoneNumber;
  String alternateNumber;
  String userType;
  String licenceNumber;
  String companyName;
  String companyLogoUrl;
  String userDetailDocId;

  UserDetail({
    this.userName,
    this.email,
    this.userImageUrl,
    this.displayName,
    this.providerId,
    this.addressLocation,
    this.countryCode,
    this.buyingCountryCode,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.alternateNumber,
    this.userType,
    this.licenceNumber,
    this.companyName,
    this.companyLogoUrl,
    this.userDetailDocId,
  });
}

// Model for admin user

class AdminUser {
  String userName;
  String userId;
  String permission;
  String countryCode;
  String adminUserDocId;

  AdminUser({
    this.userName,
    this.userId,
    this.permission,
    this.countryCode,
    this.adminUserDocId,
  });
}

// Model for User's device token table

class UserDeviceToken {
  String userId;
  String deviceToken;
  String userLevel;
  String userDeviceTokenDocId;

  UserDeviceToken({
    this.userId,
    this.deviceToken,
    this.userLevel,
    this.userDeviceTokenDocId,
  });
}

// Model to store userType
class UserType {
  String userType;

  UserType({
    this.userType,
  });
}
