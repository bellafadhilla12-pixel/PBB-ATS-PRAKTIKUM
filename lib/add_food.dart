import 'package:flutter/material.dart';
import 'food_store.dart';

const Color addBg = Color(0xFF121019);
const Color addPanel = Color(0xFF211F2A);
const Color addPanel2 = Color(0xFF2B2835);
const Color addPurple = Color(0xFFAC7BFF);
const Color addMint = Color(0xFF43D9AE);
const Color addOrange = Color(0xFFFFB84D);
const Color addPink = Color(0xFFFFAAA9);

class _Suggestion {
  final String name;
  final Color color;
  final double grams;
  final double protein;
  final double carbs;
  final double fat;

  const _Suggestion(
    this.name,
    this.color,
    this.grams,
    this.protein,
    this.carbs,
    this.fat,
  );
}

// Nilai perkiraan per porsi umum.
const List<_Suggestion> _foodDb = [
  _Suggestion('Nasi Merah', addOrange, 150, 4, 34, 1),
  _Suggestion('Dada Ayam', addMint, 100, 31, 0, 4),
  _Suggestion('Telur Rebus', addMint, 50, 6, 1, 5),
  _Suggestion('Alpukat', addPink, 100, 2, 9, 15),
  _Suggestion('Pisang', addOrange, 100, 1, 23, 0),
  _Suggestion('Tempe Goreng', addMint, 50, 10, 5, 9),
  _Suggestion('Tahu Kukus', addMint, 100, 8, 2, 5),
  _Suggestion('Oatmeal', addOrange, 80, 8, 54, 6),
];

class AddFoodPage extends StatefulWidget {
  /// Jika diisi, halaman berjalan dalam mode edit.
  final FoodEntry? editing;

  const AddFoodPage({super.key, this.editing});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final TextEditingController searchController = TextEditingController();
  late final TextEditingController foodController;
  late final TextEditingController gramController;

  late String selectedMeal;
  late String selectedPortion;

  late double protein;
  late double carbs;
  late double fat;

  bool get isEditing => widget.editing != null;

  static const List<String> _portions = [
    '1 Porsi Sedang',
    '1 Porsi Kecil',
    '1 Porsi Besar',
    '1 Mangkok',
    '1 Buah',
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.editing;

    if (e != null) {
      foodController = TextEditingController(text: e.name);
      gramController = TextEditingController(text: e.grams.round().toString());
      selectedMeal = e.meal;
      selectedPortion = e.portion;
      protein = e.protein;
      carbs = e.carbs;
      fat = e.fat;
    } else {
      foodController = TextEditingController();
      gramController = TextEditingController(text: '100');
      selectedMeal = _mealByHour();
      selectedPortion = _portions.first;
      protein = 0;
      carbs = 0;
      fat = 0;
    }
  }

  String _mealByHour() {
    final h = TimeOfDay.now().hour;
    if (h < 10) return 'Sarapan';
    if (h < 15) return 'Siang';
    if (h < 18) return 'Camilan';
    return 'Malam';
  }

  int get totalCalories => (protein * 4 + carbs * 4 + fat * 9).round();

  List<_Suggestion> get _filteredSuggestions {
    final q = searchController.text.trim().toLowerCase();
    if (q.isEmpty) return _foodDb;
    return _foodDb.where((s) => s.name.toLowerCase().contains(q)).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    foodController.dispose();
    gramController.dispose();
    super.dispose();
  }

  void _save() {
    final name = foodController.text.trim();
    final grams = double.tryParse(gramController.text.trim().replaceAll(',', '.'));

    if (name.isEmpty || grams == null || grams <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi nama makanan dan takaran!'),
        ),
      );
      return;
    }

    if (totalCalories == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Atur nilai nutrisi (protein, karbo, lemak) dulu.'),
        ),
      );
      return;
    }

    final store = FoodStore.instance;
    final old = widget.editing;

    final entry = FoodEntry(
      id: old?.id ?? store.newId(),
      name: name,
      meal: selectedMeal,
      portion: selectedPortion,
      grams: grams,
      protein: protein,
      carbs: carbs,
      fat: fat,
      time: old?.time ?? TimeOfDay.now(),
    );

    if (isEditing) {
      store.update(entry);
    } else {
      store.add(entry);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing
              ? '$name berhasil diperbarui ($totalCalories kkal)'
              : '$name berhasil dicatat (+$totalCalories kkal)',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: addBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 25),
          children: [
            _header(),
            const SizedBox(height: 27),
            if (!isEditing) ...[
              _searchBar(),
              const SizedBox(height: 34),
            ],
            const Text(
              'WAKTU MAKAN',
              style: TextStyle(
                color: Color(0xFFD8CDE5),
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: .7,
              ),
            ),
            const SizedBox(height: 9),
            _mealSelector(),
            if (!isEditing) ...[
              const SizedBox(height: 34),
              _suggestions(),
            ],
            const SizedBox(height: 39),
            _foodForm(),
            const SizedBox(height: 35),
            _qualityCard(),
            const SizedBox(height: 38),
            _saveButton(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _header() {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: addPanel,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back, color: addPurple),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'CaloPulse',
          style: TextStyle(
            color: Color(0xFFDCCBFF),
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 12),
        Container(width: 1, height: 25, color: Colors.white24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            isEditing ? 'Edit Food' : 'Add Food',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Icon(Icons.notifications_none, color: Colors.white, size: 26),
        const SizedBox(width: 15),
        const CircleAvatar(
          radius: 21,
          backgroundColor: addPanel2,
          child: Icon(Icons.person, color: Color(0xFFDCCBFF)),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: addPanel,
              borderRadius: BorderRadius.circular(22),
            ),
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFFD8CDE5),
                  size: 27,
                ),
                hintText: 'Cari makanan...',
                hintStyle: TextStyle(
                  color: Color(0xFF9C96A8),
                  fontSize: 17,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 23),
              ),
            ),
          ),
        ),
        const SizedBox(width: 11),
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur scan barcode belum diaktifkan'),
              ),
            );
          },
          child: Container(
            width: 72,
            height: 70,
            decoration: BoxDecoration(
              color: addPanel2,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.document_scanner_outlined,
              color: Color(0xFFDCCBFF),
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  Widget _mealSelector() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFF191621),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Row(
        children: mealTypes.map((meal) {
          final selected = selectedMeal == meal;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedMeal = meal),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF342B49)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: addPurple.withOpacity(.20),
                            blurRadius: 18,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    Icon(
                      mealIcon(meal),
                      color: selected
                          ? const Color(0xFFDCCBFF)
                          : const Color(0xFFBEB7CC),
                      size: 22,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      meal,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.white70,
                        fontSize: 13,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _suggestions() {
    final items = _filteredSuggestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Saran Cepat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        if (items.isEmpty)
          const Text(
            'Tidak ada hasil. Isi nama makanan secara manual di bawah.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items.map((item) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      foodController.text = item.name;
                      gramController.text = item.grams.round().toString();
                      protein = item.protein;
                      carbs = item.carbs;
                      fat = item.fat;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: addPanel,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 9, color: item.color),
                        const SizedBox(width: 7),
                        Text(
                          item.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _foodForm() {
    final portionItems = {..._portions, selectedPortion}.toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(26, 48, 26, 35),
      decoration: BoxDecoration(
        color: const Color(0xFF201D29),
        borderRadius: BorderRadius.circular(42),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Nama Makanan',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                'Total Kalori',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: foodController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Contoh: Nasi Goreng',
                    hintStyle: const TextStyle(
                      color: Color(0xFF777180),
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: addPanel,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 17,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3C2D56),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    Text(
                      '$totalCalories',
                      style: const TextStyle(
                        color: Color(0xFFDCCBFF),
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'kkal',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Takaran (Gram/Ml)',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 9),
                    TextField(
                      controller: gramController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        suffixText: 'gr',
                        suffixStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: addPanel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Satuan Saji',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Container(
                      height: 57,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: addPanel,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedPortion,
                          isExpanded: true,
                          dropdownColor: addPanel2,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white70,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          items: portionItems.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => selectedPortion = value);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 23),
          _nutritionPanel(),
        ],
      ),
    );
  }

  Widget _nutritionPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
      decoration: BoxDecoration(
        color: addPanel,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.pie_chart_outline,
                  color: Color(0xFFDCCBFF), size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Rincian Nutrisi Makro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Otomatis Terkalkulasi',
                style: TextStyle(color: Color(0xFF9F98AB), fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Row(
              children: [
                Expanded(
                  flex: protein.round().clamp(1, 150),
                  child: Container(height: 11, color: addMint),
                ),
                Expanded(
                  flex: carbs.round().clamp(1, 150),
                  child: Container(height: 11, color: addOrange),
                ),
                Expanded(
                  flex: fat.round().clamp(1, 150),
                  child: Container(height: 11, color: addPink),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          _macroSlider(
            'Protein',
            protein,
            addMint,
            (value) => setState(() => protein = value),
          ),
          _macroSlider(
            'Karbohidrat',
            carbs,
            addOrange,
            (value) => setState(() => carbs = value),
          ),
          _macroSlider(
            'Lemak',
            fat,
            addPink,
            (value) => setState(() => fat = value),
          ),
        ],
      ),
    );
  }

  Widget _macroSlider(
    String title,
    double value,
    Color color,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 14, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                width: 78,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: addPanel2,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  value.round().toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'g',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: const Color(0xFF55515D),
              thumbColor: color,
              overlayColor: color.withOpacity(.15),
              trackHeight: 5,
            ),
            child: Slider(
              value: value.clamp(0, 150).toDouble(),
              min: 0,
              max: 150,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _qualityCard() {
    final cal = totalCalories;

    String title;
    String sub;
    Color color;
    IconData icon;

    if (cal == 0) {
      title = 'Belum Ada Data Nutrisi';
      sub = 'Atur slider makro atau pilih saran cepat.';
      color = Colors.white70;
      icon = Icons.info_outline;
    } else {
      final pShare = protein * 4 / cal;
      final fShare = fat * 9 / cal;

      if (pShare >= .25 && fShare <= .30) {
        title = 'Kualitas Nutrisi Sangat Baik';
        sub = 'Tinggi protein, lemak terkontrol.';
        color = addMint;
        icon = Icons.check_circle;
      } else if (fShare > .40) {
        title = 'Perhatikan Asupan Lemak';
        sub = 'Lemak mendominasi kalori makanan ini.';
        color = addOrange;
        icon = Icons.warning_amber_rounded;
      } else {
        title = 'Kualitas Nutrisi Cukup';
        sub = 'Komposisi makro cukup seimbang.';
        color = addPurple;
        icon = Icons.thumbs_up_down_outlined;
      }
    }

    final name = foodController.text.trim();

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: addPanel,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: addPanel2,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(Icons.restaurant, color: color, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 17),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  name.isEmpty ? 'Makanan Baru' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  sub,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      height: 78,
      child: ElevatedButton.icon(
        onPressed: _save,
        icon: Icon(isEditing ? Icons.check : Icons.add_task, size: 25),
        label: Text(
          isEditing
              ? 'Simpan Perubahan ($totalCalories kkal)'
              : 'Simpan ke Buku Harian (+$totalCalories kkal)',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: addPurple,
          foregroundColor: const Color(0xFF32165E),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF1C1924),
      type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      selectedItemColor: const Color(0xFFDCCBFF),
      unselectedItemColor: const Color(0xFFAAA5B8),
      selectedFontSize: 11,
      unselectedFontSize: 11,
      onTap: (index) {
        if (index == 0) Navigator.pop(context);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Log Food',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Meals',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Profile',
        ),
      ],
    );
  }
}