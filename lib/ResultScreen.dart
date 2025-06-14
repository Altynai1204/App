import 'package:flutter/material.dart';
import 'DashboardScreen.dart';
import 'data_classes/user_data_class.dart';  // Импорт главного экрана

class ResultScreen extends StatelessWidget {
  final int age;
  final int height;
  final int weight;
  final String gender;
  final double activityLevel;
  final String goal;
  final String diet;
  final String allergies;
  final int calories;
  final double proteins;
  final double fats;
  final double carbs;

  const ResultScreen({
    super.key,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.activityLevel,
    required this.goal,
    required this.diet,
    required this.allergies,
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbs,
  });

  Future<void> _saveUserData(BuildContext context) async {
    // TODO: добавь сюда сохранение SharedPreferences или другое
  }

  void _goToDashboard(BuildContext context) {
    final user = User(
      age: age,
      height: height,
      weight: weight,
      gender: gender,
      activityLevel: activityLevel,
      goal: goal,
      diet: diet,
      allergies: allergies,
      calories: calories,
      proteins: proteins,
      fats: fats,
      carbs: carbs,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Результаты расчета", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Калории: $calories ккал", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text("Белки: ${proteins.toStringAsFixed(1)} г", style: const TextStyle(fontSize: 18)),
            Text("Жиры: ${fats.toStringAsFixed(1)} г", style: const TextStyle(fontSize: 18)),
            Text("Углеводы: ${carbs.toStringAsFixed(1)} г", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            Text("Тип диеты: $diet", style: const TextStyle(fontSize: 18)),
            Text("Цель: $goal", style: const TextStyle(fontSize: 18)),
            Text("Аллергии: ${allergies.isEmpty ? 'Нет' : allergies}", style: const TextStyle(fontSize: 18)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _saveUserData(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Сохранить данные", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _goToDashboard(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Перейти к профилю", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
