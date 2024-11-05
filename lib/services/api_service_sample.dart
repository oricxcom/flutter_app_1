import '../config/app_config.dart';

class ApiService {
  final String baseUrl = AppConfig.instance.baseUrl;
  final String apiKey = AppConfig.instance.apiKey;

  Future<void> makeApiCall() async {
    // 使用配置参数
    // final response = await http.get(
    //   Uri.parse('$baseUrl/endpoint'),
    //   headers: {'Authorization': 'Bearer $apiKey'},
    // );
    // ... 处理响应

    
  }
}
