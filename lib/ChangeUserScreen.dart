import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ResultScreen.dart'; // импорт экрана результата
import 'data_classes/macro_nutriens_data_class.dart';   // импорт файла с расчетами

class ChangeUserScreen extends StatefulWidget {
  const ChangeUserScreen({super.key});

  @override
  State<ChangeUserScreen> createState() => _ChangeUserScreenState();
}

class _ChangeUserScreenState extends State<ChangeUserScreen> {
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final allergiesController = TextEditingController();

  String selectedGoal = 'Поддержание веса';
  String selectedDiet = 'Обычное питание';
  String selectedGender = 'Мужской';
  String selectedActivity = 'Средняя (x1.4)';

  final goals = ['Похудение', 'Набор массы', 'Поддержание веса', 'Рекомпозиция'];
  final diets = ['Обычное питание', 'Вегетарианская', 'Кето', 'Безглютеновая', 'Веганская'];
  final genders = ['Мужской', 'Женский'];
  final activityLevels = {
    'Малоподвижный (x1.2)': 1.2,
    'Средняя (x1.4)': 1.4,
    'Высокая (x1.6)': 1.6,
    'Очень высокая (x1.8)': 1.8,
  };

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    allergiesController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    final age = int.tryParse(ageController.text);
    final height = int.tryParse(heightController.text);
    final weight = int.tryParse(weightController.text);

    if (age == null || height == null || weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Введите корректные числовые значения")),
      );
      return false;
    }

    if (age <= 0 || height <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Значения должны быть больше нуля")),
      );
      return false;
    }

    return true;
  }

  void _goToResult() {
    if (_validateInputs()) {
      final age = int.parse(ageController.text);
      final height = int.parse(heightController.text);
      final weight = int.parse(weightController.text);

      final gender = selectedGender.toLowerCase() == 'мужской' ? 'male' : 'female';
      final activityLevel = activityLevels[selectedActivity]!;
      final goalMap = {
        'Похудение': 'weight_loss',
        'Набор массы': 'weight_gain',
        'Поддержание веса': 'maintenance',
        'Рекомпозиция': 'recomposition',
      };
      final goal = goalMap[selectedGoal]!;

      // Расчёт КБЖУ
      final result = calculateKcalAndMacros(
        age: age,
        height: height,
        weight: weight,
        gender: gender,
        activityLevel: activityLevel,
        goal: goal,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            age: age,
            height: height,
            weight: weight,
            gender: selectedGender,
            activityLevel: activityLevel,
            goal: selectedGoal,
            diet: selectedDiet,
            allergies: allergiesController.text.trim(),
            calories: result.calories,
            proteins: result.proteins,
            fats: result.fats,
            carbs: result.carbs,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Введите параметры", style: TextStyle(color: Colors.white),), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildInput("Возраст", ageController),
            _buildInput("Рост (см)", heightController),
            _buildInput("Вес (кг)", weightController),
            const SizedBox(height: 20),

            _buildDropdown("Пол", genders, selectedGender, (val) => setState(() => selectedGender = val!)),
            _buildDropdown("Уровень активности", activityLevels.keys.toList(), selectedActivity, (val) => setState(() => selectedActivity = val!)),
            _buildDropdown("Цель", goals, selectedGoal, (val) => setState(() => selectedGoal = val!)),
            _buildDropdown("Диета", diets, selectedDiet, (val) => setState(() => selectedDiet = val!)),

            const SizedBox(height: 20),
            const Text("Аллергии / непереносимости", style: TextStyle(fontSize: 18)),
            TextField(
              controller: allergiesController,
              decoration: const InputDecoration(hintText: "Например: лактоза, орехи"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _goToResult,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade400),
              child: Padding(padding: EdgeInsets.symmetric(
                  vertical: 15
              ), child: const Text("Сохранить данные", style: TextStyle(color: Colors.white),),),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(hintText: "Введите $label".toLowerCase()),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String currentValue, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        DropdownButton<String>(
          value: currentValue,
          isExpanded: true,
          onChanged: onChanged,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

