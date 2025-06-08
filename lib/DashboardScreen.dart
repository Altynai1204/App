import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user.dart';


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

  double _eatenCalories = 0;
  double _eatenProteins = 0;
  double _eatenFats = 0;
  double _eatenCarbs = 0;

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

  void _showAddIntakeDialog() {
    final _caloriesController = TextEditingController();
    final _proteinController = TextEditingController();
    final _fatController = TextEditingController();
    final _carbController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Добавить съеденное"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _caloriesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Калории"),
                ),
                TextField(
                  controller: _proteinController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Белки"),
                ),
                TextField(
                  controller: _fatController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Жиры"),
                ),
                TextField(
                  controller: _carbController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Углеводы"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _eatenCalories += double.tryParse(_caloriesController.text) ?? 0;
                  _eatenProteins += double.tryParse(_proteinController.text) ?? 0;
                  _eatenFats += double.tryParse(_fatController.text) ?? 0;
                  _eatenCarbs += double.tryParse(_carbController.text) ?? 0;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Добавить"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Профиль и план питания"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchMealPlan,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.food_bank),
              label: 'План питания',
            ),
          ],
          currentIndex: 1,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _hasError
                  ? const Center(child: Text("Ошибка загрузки данных"))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Возраст: ${widget.user.age}"),
                                Text("Рост: ${widget.user.height} см  Вес: ${widget.user.weight} кг"),
                                Text(
                                  "Ккал: ${widget.user.calories.toStringAsFixed(0)}  Б: ${widget.user.proteins.toStringAsFixed(1)}  Ж: ${widget.user.fats.toStringAsFixed(1)}  У: ${widget.user.carbs.toStringAsFixed(1)}",
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _showAddIntakeDialog,
                          icon: const Icon(Icons.add),
                          label: const Text("Добавить съеденное"),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: (_eatenCalories / widget.user.calories).clamp(0.0, 1.0),
                          backgroundColor: Colors.grey[300],
                          color: Colors.green,
                        ),
                        Text("Съедено: ${_eatenCalories.toStringAsFixed(0)} из ${widget.user.calories} Ккал"),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(5, (index) {
                            return ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentDayIndex = index;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _currentDayIndex == index ? Colors.green : Colors.grey[300],
                                foregroundColor:
                                    _currentDayIndex == index ? Colors.white : Colors.black,
                              ),
                              child: Text("День ${index + 1}"),
                            );
                          }),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView(
                            children: _mealPlan[_currentDayIndex].entries.map<Widget>((entry) {
                              final meal = entry.key;
                              final recipes = entry.value;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.restaurant_menu, color: Colors.green),
                                      const SizedBox(width: 8),
                                      Text(
                                        meal.toUpperCase(),
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  ...recipes.map<Widget>((recipe) => Card(
                                        color: Colors.grey[100],
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
      ),
    );
  }
}
