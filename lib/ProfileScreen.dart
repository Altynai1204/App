import 'package:flutter/material.dart';
import 'user.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль пользователя"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/avatar.png'), // или любой заглушкой
            ),
            const SizedBox(height: 16),
            Text("Возраст: ${user.age}", style: const TextStyle(fontSize: 18)),
            Text("Рост: ${user.height} см", style: const TextStyle(fontSize: 18)),
            Text("Вес: ${user.weight} кг", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Divider(),
            Text("Цель: ${user.diet}", style: const TextStyle(fontSize: 16)),
            Text("Аллергии: ${user.allergies}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Text("Калории: ${user.calories} ккал", style: const TextStyle(fontSize: 16)),
            Text("Белки: ${user.proteins} г", style: const TextStyle(fontSize: 16)),
            Text("Жиры: ${user.fats} г", style: const TextStyle(fontSize: 16)),
            Text("Углеводы: ${user.carbs} г", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
