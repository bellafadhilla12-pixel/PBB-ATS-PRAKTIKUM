import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// MODEL
// ---------------------------------------------------------------------------

/// Satu catatan makanan di log harian.
class FoodEntry {
  final String id;
  final String name;
  final String meal; // Sarapan | Siang | Camilan | Malam
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

  /// Kalori dihitung dari makronutrien (4 / 4 / 9 kkal per gram).
  int get calories => (protein * 4 + carbs * 4 + fat * 9).round();

  /// Contoh: "07:45 WIB".
  String get timeText {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m WIB';
  }
}

// ---------------------------------------------------------------------------
// STORE (singleton + ChangeNotifier) dengan DATA DUMMY
// ---------------------------------------------------------------------------

class FoodStore extends ChangeNotifier {
  FoodStore._() {
    _seedDummyData();
  }

  static final FoodStore instance = FoodStore._();

  // Target harian.
  static const int calorieTarget = 2100;
  static const int proteinTarget = 130;
  static const int carbsTarget = 240;
  static const int fatTarget = 65;

  final List<FoodEntry> _entries = [];
  int _idCounter = 0;

  /// Daftar makanan, terurut berdasarkan jam.
  List<FoodEntry> get entries => List.unmodifiable(_entries);

  int get totalCalories => _entries.fold(0, (s, e) => s + e.calories);
  double get totalProtein => _entries.fold(0.0, (s, e) => s + e.protein);
  double get totalCarbs => _entries.fold(0.0, (s, e) => s + e.carbs);
  double get totalFat => _entries.fold(0.0, (s, e) => s + e.fat);

  String newId() => 'food_${++_idCounter}';

  FoodEntry? byId(String id) {
    for (final e in _entries) {
      if (e.id == id) return e;
    }
    return null;
  }

  void add(FoodEntry entry) {
    _entries.add(entry);
    _sort();
    notifyListeners();
  }

  void update(FoodEntry entry) {
    final i = _entries.indexWhere((e) => e.id == entry.id);
    if (i == -1) return;
    _entries[i] = entry;
    _sort();
    notifyListeners();
  }

  void remove(String id) {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void _sort() {
    _entries.sort((a, b) {
      final ta = a.time.hour * 60 + a.time.minute;
      final tb = b.time.hour * 60 + b.time.minute;
      return ta.compareTo(tb);
    });
  }

  /// DATA DUMMY: total 1478 kkal, P 95 g, K 180 g, L 42 g
  /// (sesuai tampilan Beranda: 1478 / 2100 kkal, sisa 622 kkal).
  void _seedDummyData() {
    _entries.addAll([
      FoodEntry(
        id: newId(),
        name: 'Oatmeal Berry & Chia Seed',
        meal: 'Sarapan',
        portion: '1 Mangkok',
        grams: 250,
        protein: 13.5,
        carbs: 48,
        fat: 9,
        time: const TimeOfDay(hour: 7, minute: 45),
      ),
      FoodEntry(
        id: newId(),
        name: 'Dada Ayam Panggang & Nasi Merah',
        meal: 'Siang',
        portion: '1 Porsi Sedang',
        grams: 350,
        protein: 40,
        carbs: 55,
        fat: 8,
        time: const TimeOfDay(hour: 12, minute: 30),
      ),
      FoodEntry(
        id: newId(),
        name: 'Pisang & Selai Kacang',
        meal: 'Camilan',
        portion: '1 Porsi Kecil',
        grams: 130,
        protein: 8,
        carbs: 29,
        fat: 7,
        time: const TimeOfDay(hour: 15, minute: 45),
      ),
      FoodEntry(
        id: newId(),
        name: 'Salmon Panggang & Sayur Kukus',
        meal: 'Malam',
        portion: '1 Porsi Sedang',
        grams: 300,
        protein: 33.5,
        carbs: 48,
        fat: 18,
        time: const TimeOfDay(hour: 19, minute: 10),
      ),
    ]);
  }
}

// ---------------------------------------------------------------------------
// HELPER WAKTU MAKAN
// ---------------------------------------------------------------------------

/// Urutan pilihan waktu makan (dipakai selector di halaman tambah makanan).
const List<String> mealTypes = ['Sarapan', 'Siang', 'Camilan', 'Malam'];

Color mealColor(String meal) {
  switch (meal) {
    case 'Sarapan':
      return const Color(0xFFFFB84D);
    case 'Siang':
      return const Color(0xFF43D9AE);
    case 'Camilan':
      return const Color(0xFFFFAAA9);
    case 'Malam':
    default:
      return const Color(0xFFAC7BFF);
  }
}

IconData mealIcon(String meal) {
  switch (meal) {
    case 'Sarapan':
      return Icons.free_breakfast_outlined;
    case 'Siang':
      return Icons.lunch_dining_outlined;
    case 'Camilan':
      return Icons.cookie_outlined;
    case 'Malam':
    default:
      return Icons.dinner_dining_outlined;
  }
}

String mealLabel(String meal) => meal;

// ---------------------------------------------------------------------------
// DIALOG KONFIRMASI HAPUS
// ---------------------------------------------------------------------------

/// Menampilkan dialog konfirmasi; mengembalikan true jika makanan dihapus.
Future<bool> confirmDeleteFood(BuildContext context, FoodEntry entry) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF211F2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: const Text(
        'Hapus makanan?',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      content: Text(
        '${entry.name} akan dihapus dari log harian.',
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Batal', style: TextStyle(color: Colors.white70)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text(
            'Hapus',
            style: TextStyle(color: Color(0xFFFF9D9D)),
          ),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    FoodStore.instance.remove(entry.id);
    return true;
  }
  return false;
}
