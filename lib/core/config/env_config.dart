import 'package:envied/envied.dart';

part 'env_config.g.dart';

/// Environment configuration for API keys and settings.
/// Values are loaded from .env file at build time.
@Envied(path: '.env')
abstract class EnvConfig {
  // Amazon PA-API
  @EnviedField(varName: 'AMAZON_ACCESS_KEY', defaultValue: '')
  static const String amazonAccessKey = _EnvConfig.amazonAccessKey;

  @EnviedField(varName: 'AMAZON_SECRET_KEY', defaultValue: '')
  static const String amazonSecretKey = _EnvConfig.amazonSecretKey;

  @EnviedField(varName: 'AMAZON_PARTNER_TAG', defaultValue: '')
  static const String amazonAssociateTag = _EnvConfig.amazonAssociateTag;

  static const String amazonRegion = 'us-west-2';

  // Rakuten Web Service
  @EnviedField(varName: 'RAKUTEN_APP_ID', defaultValue: '')
  static const String rakutenAppId = _EnvConfig.rakutenAppId;

  @EnviedField(varName: 'RAKUTEN_AFFILIATE_ID', defaultValue: '')
  static const String rakutenAffiliateId = _EnvConfig.rakutenAffiliateId;

  // Yahoo Shopping
  @EnviedField(varName: 'YAHOO_APP_ID', defaultValue: '')
  static const String yahooAppId = _EnvConfig.yahooAppId;

  @EnviedField(varName: 'YAHOO_AFFILIATE_ID', defaultValue: '')
  static const String yahooAffiliateId = _EnvConfig.yahooAffiliateId;

  // Debug mode - use kDebugMode from Flutter instead
  static const bool isDebug = false;

  /// Validates that required API keys are configured.
  static bool get hasAmazonConfig =>
      amazonAccessKey.isNotEmpty && amazonSecretKey.isNotEmpty;

  static bool get hasRakutenConfig => rakutenAppId.isNotEmpty;

  static bool get hasYahooConfig => yahooAppId.isNotEmpty;
}
