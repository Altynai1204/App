import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/UserScreen.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'data_classes/user_data_class.dart';

class DashboardScreen extends StatefulWidget {
  final User user;
  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentDayIndex = 0;
  List<dynamic> _mealPlan = [];
  bool _isLoading = true;
  bool _hasError = false;

  double consumedCalories = 0;
  double consumedProteins = 0;
  double consumedFats = 0;
  double consumedCarbs = 0;

  @override
  void initState() {
    super.initState();
    _fetchMealPlan();
  }

  Future<void> _fetchMealPlan() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/plan'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "calories": widget.user.calories,
          "proteins": widget.user.proteins,
          "fats": widget.user.fats,
          "carbs": widget.user.carbs,
          "diet": widget.user.diet,
          "allergies": widget.user.allergies,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _mealPlan = data['5_day_plan'];
          _isLoading = false;
        });
      } else {
        throw Exception("Ошибка при загрузке плана");
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _openAddFoodDialog() async {
    File? imageFile;
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      imageFile = File(picked.path);
      final request = http.MultipartRequest('POST', Uri.parse('http://localhost:5000/analyze_image'));
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final Map<String, dynamic> result = json.decode(body);

        final caloriesController = TextEditingController(text: result['calories'].toString());
        final proteinController = TextEditingController(text: result['proteins'].toString());
        final fatController = TextEditingController(text: result['fats'].toString());
        final carbsController = TextEditingController(text: result['carbs'].toString());

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Добавить еду"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Image.file(imageFile!, height: 100),
                  TextField(
                    controller: caloriesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Калории'),
                  ),
                  TextField(
                    controller: proteinController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Белки'),
                  ),
                  TextField(
                    controller: fatController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Жиры'),
                  ),
                  TextField(
                    controller: carbsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Углеводы'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Отмена"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: const Text("Добавить"),
                onPressed: () {
                  setState(() {
                    consumedCalories += double.tryParse(caloriesController.text) ?? 0;
                    consumedProteins += double.tryParse(proteinController.text) ?? 0;
                    consumedFats += double.tryParse(fatController.text) ?? 0;
                    consumedCarbs += double.tryParse(carbsController.text) ?? 0;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  Widget _buildProgress(String label, double consumed, double target, Color color) {
    return Column(
      children: [
        Text(label),
        CircularPercentIndicator(
          radius: 60,
          lineWidth: 8.0,
          percent: (consumed / target).clamp(0, 1),
          center: Text("${consumed.toInt()} / ${target.toInt()}"),
          progressColor: color,
          backgroundColor: Colors.grey[200]!,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Здоровье и Питание"),
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserScreen(user: widget.user,),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddFoodDialog,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(child: Text("Ошибка загрузки плана"))
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildProgress("Калории", consumedCalories, widget.user.calories.toDouble(), Colors.red),
                          _buildProgress("Белки", consumedProteins, widget.user.proteins.toDouble(), Colors.blue),
                          _buildProgress("Жиры", consumedFats, widget.user.fats.toDouble(), Colors.orange),
                          _buildProgress("Углеводы", consumedCarbs, widget.user.carbs.toDouble(), Colors.purple),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 45,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      _currentDayIndex == index ? Colors.green : Colors.grey[300],
                                  foregroundColor:
                                      _currentDayIndex == index ? Colors.white : Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _currentDayIndex = index;
                                  });
                                },
                                child: Text("День ${index + 1}"),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          children: _mealPlan[_currentDayIndex].entries.map<Widget>((entry) {
                            final meal = entry.key;
                            final recipes = entry.value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  meal.toUpperCase(),
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                ...recipes.map<Widget>((recipe) => Card(
                                      child: ListTile(
                                        leading: recipe['image'] != null && recipe['image'] != ""
                                            ? Image.network(recipe['image'], width: 50, fit: BoxFit.cover)
                                            : const Icon(Icons.fastfood),
                                        title: Text(recipe['title'] ?? "Без названия"),
                                        subtitle: Text(
                                            "Ккал: ${recipe['calories']}  Б: ${recipe['protein']}  Ж: ${recipe['fat']}  У: ${recipe['carbs']}"),
                                      ),
                                    ))
                              ],
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
