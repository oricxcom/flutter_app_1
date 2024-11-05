import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class AppConfig {
  static late final AppConfig instance;
  late final String baseUrl;
  late final int timeout;
  late final String googleClientId;
  late final String apiKey;

  static Future<void> load(String env) async {
    final configString = await rootBundle.loadString('config/$env.yaml');
    final YamlMap yamlMap = loadYaml(configString);
    
    instance = AppConfig._();
    instance.baseUrl = yamlMap['api']['base_url'];
    instance.timeout = yamlMap['api']['timeout'];
    instance.googleClientId = yamlMap['auth']['google_client_id'];
    instance.apiKey = yamlMap['auth']['api_key'];
  }

  AppConfig._();
} 