import 'package:flutter/material.dart';

/// Jenis waktu makan yang dipakai di seluruh aplikasi.
const List<String> mealTypes = ['Sarapan', 'Siang', 'Malam', 'Camilan'];

String mealLabel(String meal) {
  switch (meal) {
    case 'Siang':
      return 'Makan Siang';
    case 'Malam':
      return 'Makan Malam';
    default:
      return meal;
  }
}

IconData mealIcon(String meal) {
  switch (meal) {
    case 'Sarapan':
      return Icons.wb_twilight;
    case 'Siang':
      return Icons.wb_sunny_outlined;
    case 'Malam':
      return Icons.nights_stay_outlined;
    default:
      return Icons.cookie_outlined;
  }
}

Color mealColor(String meal) {
  switch (meal) {
    case 'Sarapan':
      return const Color(0xFFFFB84D);
    case 'Siang':
      return const Color(0xFF43D9AE);
    default:
      return const Color(0xFFC9A7FF);
  }
}

class FoodEntry {
  final String id;
  final String name;
  final String meal;
  final String portion;
  final double grams;
  final double protein;
  final double carbs;
  final double fat;
  final TimeOfDay time;

  const FoodEntry({
    required this.id,
    required this.name,
    required this.meal,
    required this.portion,
    required this.grams,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.time,
  });

  int get calories => (protein * 4 + carbs * 4 + fat * 9).round();

  String get timeText =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} WIB';

  int get sortKey => time.hour * 60 + time.minute;
}

class FoodStore extends ChangeNotifier {
  FoodStore._();
  static final FoodStore instance = FoodStore._();

  static const int calorieTarget = 2100;
  static const int proteinTarget = 130;
  static const int carbsTarget = 240;
  static const int fatTarget = 65;

  final List<FoodEntry> _entries = [
    const FoodEntry(
      id: 'seed1',
      name: 'Oatmeal Berry & Chia Seed',
      meal: 'Sarapan',
      portion: '1 mangkuk sedang',
      grams: 280,
      protein: 12,
      carbs: 54,
      fat: 7,
      time: TimeOfDay(hour: 7, minute: 45),
    ),
    const FoodEntry(
      id: 'seed2',
      name: 'Ayam Panggang Quinoa & Brokoli',
      meal: 'Siang',
      portion: 'Porsi besar',
      grams: 350,
      protein: 48,
      carbs: 62,
      fat: 14,
      time: TimeOfDay(hour: 12, minute: 30),
    ),
    const FoodEntry(
      id: 'seed3',
      name: 'Greek Yogurt Almond',
      meal: 'Camilan',
      portion: '1 gelas saji',
      grams: 150,
      protein: 15,
      carbs: 18,
      fat: 8,
      time: TimeOfDay(hour: 16, minute: 15),
    ),
    const FoodEntry(
      id: 'seed4',
      name: 'Salmon Bakar & Asparagus',
      meal: 'Malam',
      portion: 'Porsi sedang',
      grams: 200,
      protein: 20,
      carbs: 46,
      fat: 13,
      time: TimeOfDay(hour: 19, minute: 20),
    ),
  ];

  List<FoodEntry> get entries {
    final list = List<FoodEntry>.from(_entries);
    list.sort((a, b) => a.sortKey.compareTo(b.sortKey));
    return list;
  }

  int get totalCalories => _entries.fold(0, (s, e) => s + e.calories);
  double get totalProtein => _entries.fold(0.0, (s, e) => s + e.protein);
  double get totalCarbs => _entries.fold(0.0, (s, e) => s + e.carbs);
  double get totalFat => _entries.fold(0.0, (s, e) => s + e.fat);

  FoodEntry? byId(String id) {
    for (final e in _entries) {
      if (e.id == id) return e;
    }
    return null;
  }

  String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  void add(FoodEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void update(FoodEntry entry) {
    final i = _entries.indexWhere((e) => e.id == entry.id);
    if (i == -1) return;
    _entries[i] = entry;
    notifyListeners();
  }

  void remove(String id) {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}

/// Dialog konfirmasi hapus. Mengembalikan true jika makanan benar-benar dihapus.
Future<bool> confirmDeleteFood(BuildContext context, FoodEntry entry) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color(0xFF211F2A),
      title: const Text(
        'Hapus makanan?',
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        '"${entry.name}" akan dihapus dari log harian.',
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text(
            'Hapus',
            style: TextStyle(color: Color(0xFFFF9D9D)),
          ),
        ),
      ],
    ),
  );

  if (ok == true) {
    FoodStore.instance.remove(entry.id);
    return true;
  }
  return false;
}