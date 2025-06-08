import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart'; // ваш класс User

Future<Map<String, dynamic>> fetchMealPlan(User user) async {
  final url = Uri.parse('http://127.0.0.1:5000/plan'); // добавлен маршрут /plan

  final body = jsonEncode({
    'age': user.age,
    'height': user.height,
    'weight': user.weight,
    'gender': user.gender,
    'activityLevel': user.activityLevel,
    'goal': user.goal,
    'diet': user.diet,
    'allergies': user.allergies,
    'calories': user.calories,
    'proteins': user.proteins,
    'fats': user.fats,
    'carbs': user.carbs,
  });

  final headers = {'Content-Type': 'application/json'};

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Ошибка при получении рекомендаций: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Ошибка при выполнении запроса: $e');
  }
}