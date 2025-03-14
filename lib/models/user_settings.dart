class ShellyCloudSettings {
  ShellyCloudSettings({this.accessToken, this.refreshToken, this.tokenType, this.expiresIn, this.url, this.deviceId});

  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;
  final String? url;
  final String? deviceId;

  factory ShellyCloudSettings.fromJson(Map<String, dynamic> json) {
    return ShellyCloudSettings(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      url: json['url'],
      deviceId: json['device_id'],
    );
  }
}

class PowerSettings {
  PowerSettings({this.limitValue, this.maxValue});

  final double? limitValue;
  final double? maxValue;

  factory PowerSettings.fromJson(Map<String, dynamic> json) {
    return PowerSettings(
      limitValue: (json['limit_value'] as num?)?.toDouble(),
      maxValue: (json['max_value'] as num?)?.toDouble(),
    );
  }
}

class UserSettings {
  UserSettings({this.shellyCloud, this.power});

  ShellyCloudSettings? shellyCloud;
  PowerSettings? power;

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      shellyCloud: json['shelly_cloud'] != null ? ShellyCloudSettings.fromJson(json['shelly_cloud']) : null,
      power: json['power'] != null ? PowerSettings.fromJson(json['power']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shelly_cloud': shellyCloud != null
          ? {
              'access_token': shellyCloud!.accessToken,
              'refresh_token': shellyCloud!.refreshToken,
              'token_type': shellyCloud!.tokenType,
              'expires_in': shellyCloud!.expiresIn,
              'url': shellyCloud!.url,
              'device_id': shellyCloud!.deviceId,
            }
          : null,
      'power': power != null
          ? {
              'limit_value': power!.limitValue,
              'max_value': power!.maxValue,
            }
          : null,
    };
  }
}
