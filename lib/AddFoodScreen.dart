import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class AddFoodScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onFoodAdded;

  const AddFoodScreen({super.key, required this.onFoodAdded});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  File? _imageFile;
  final TextEditingController _gramController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _kbju;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _kbju = null;
      });
    }
  }

  Future<void> _analyzeFood(BuildContext context) async {
    if (_imageFile == null || _gramController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse('http://localhost:5000/analyze_food'));
      request.fields['grams'] = _gramController.text;

      final mimeType = lookupMimeType(_imageFile!.path) ?? 'image/jpeg';
      final mediaType = MediaType.parse(mimeType);

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _imageFile!.path,
        contentType: mediaType,
        filename: basename(_imageFile!.path),
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = json.decode(respStr);
        setState(() {
          _kbju = data;
        });
      } else {
        throw Exception('Ошибка анализа изображения');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ошибка: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _saveFood(BuildContext context) {
    if (_kbju != null) {
      widget.onFoodAdded(_kbju!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Добавить приём пищи")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_imageFile != null)
              Image.file(_imageFile!, height: 200, fit: BoxFit.cover)
            else
              const Text("Фото не выбрано"),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text("Сделать фото"),
            ),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo),
              label: const Text("Выбрать из галереи"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _gramController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Граммы в порции"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await _analyzeFood(context);
              },
              child: _isLoading ? const CircularProgressIndicator() : const Text("Анализировать"),
            ),
            const SizedBox(height: 16),
            if (_kbju != null) ...[
              Text("Калории: ${_kbju!['calories'] ?? 0}"),
              Text("Белки: ${_kbju!['proteins'] ?? 0}"),
              Text("Жиры: ${_kbju!['fats'] ?? 0}"),
              Text("Углеводы: ${_kbju!['carbs'] ?? 0}"),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: (){
                  _saveFood(context);
                },
                icon: const Icon(Icons.save),
                label: const Text("Сохранить"),
              )
            ]
          ],
        ),
      ),
    );
  }
}
