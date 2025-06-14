import 'dart:convert';
import 'package:http/http.dart' as http;

class MealPlanService {
  static const String baseUrl = "http://localhost:5000"; // если Android: замени на IP хоста
  
  static Future<List<Map<String, dynamic>>> fetchMealPlan(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/plan"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final plan = data['5_day_plan'];
      return List<Map<String, dynamic>>.from(plan);
    } else {
      throw Exception("Не удалось загрузить план питания");
    }
  }
}
