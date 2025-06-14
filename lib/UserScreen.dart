import 'package:flutter/material.dart';
import 'package:flutter_application_1/start_screen.dart';
import 'ChangeUserScreen.dart';
import 'InputScreen.dart';
import 'RegistrationScreen.dart';
import 'data_classes/user_data_class.dart';

class UserScreen extends StatefulWidget {
  final User user;
  const UserScreen({super.key, required this.user});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFDFF5E3),
      appBar: AppBar(
        title: const Text('Профиль', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              child: Text(
                'Возраст: ${widget.user.age}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: width,
              child: Text(
                'Рост: ${widget.user.height}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: width,
              child: Text(
                'Вес: ${widget.user.weight}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: width,
              child: Text(
                'Пол: ${widget.user.gender}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: width,
              child: Text(
                'Уровень активности: ${widget.user.activityLevel}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: width,
              child: Text(
                'Цель: ${widget.user.goal}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: width,
              child: Text(
                'Диета: ${widget.user.diet}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: width,
              child: Text(
                'Аллергии: ${widget.user.allergies}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: width,
              child: Text(
                'Калории: ${widget.user.calories}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: width,
              child: Text(
                'Протеины: ${widget.user.proteins}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: width,
              child: Text(
                'Жиры: ${widget.user.fats}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: width,
              child: Text(
                'Углеводы: ${widget.user.carbs}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeUserScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Изменить данные',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StartScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Выйти из аккаунта',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
