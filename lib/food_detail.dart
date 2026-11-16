import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'add_food.dart';
import 'food_store.dart';

const Color _bg = Color(0xFF121019);
const Color _panel = Color(0xFF211F2A);
const Color _panel2 = Color(0xFF2B2834);
const Color _purple = Color(0xFFAC7BFF);
const Color _mint = Color(0xFF43D9AE);
const Color _orange = Color(0xFFFFB84D);
const Color _lilac = Color(0xFFD0B5FF);
const Color _muted = Color(0xFFAAA5B8);

class FoodDetailPage extends StatelessWidget {
  final String entryId;

  const FoodDetailPage({super.key, required this.entryId});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FoodStore.instance,
      builder: (context, _) {
        final entry = FoodStore.instance.byId(entryId);

        // Sudah dihapus: tampilkan layar kosong selama transisi pop.
        if (entry == null) {
          return const Scaffold(backgroundColor: _bg);
        }

        return Scaffold(
          backgroundColor: _bg,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 25),
              children: [
                _topBar(context),
                const SizedBox(height: 20),
                _hero(entry),
                const SizedBox(height: 27),
                Row(
                  children: [
                    const Icon(Icons.pie_chart_outline,
                        color: Color(0xFFDCCBFF)),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Komposisi Makronutrisi',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      'Total: ${(entry.protein + entry.carbs + entry.fat).round()}g',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _macroPanel(entry),
                const SizedBox(height: 27),
                SizedBox(
                  height: 51,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddFoodPage(editing: entry),
                        ),
                      );
                    },
                    icon: const Icon(Icons.tune, size: 18),
                    label: const Text('Edit Porsi & Gramasi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _purple,
                      foregroundColor: const Color(0xFF32165E),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                SizedBox(
                  height: 51,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final deleted = await confirmDeleteFood(context, entry);
                      if (deleted && context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('${entry.name} dihapus dari log harian'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Hapus dari Log Harian'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _panel2,
                      foregroundColor: const Color(0xFFFF9D9D),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        Container(
          width: 29,
          height: 29,
          decoration: BoxDecoration(
            color: _panel2,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.bubble_chart, color: _purple, size: 19),
        ),
        const SizedBox(width: 9),
        const Text(
          'Food Detail',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const Spacer(),
        const CircleAvatar(
          radius: 16,
          backgroundColor: _panel2,
          child: Icon(Icons.person, color: Color(0xFFDCCBFF), size: 18),
        ),
      ],
    );
  }

  Widget _hero(FoodEntry e) {
    final color = mealColor(e.meal);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(mealIcon(e.meal), color: color, size: 13),
                const SizedBox(width: 5),
                Text(
                  '${mealLabel(e.meal)} • ${e.timeText}',
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  e.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B2D54),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      '${e.calories}',
                      style: const TextStyle(
                        color: Color(0xFFDCCBFF),
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'KKAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.hourglass_bottom, color: _muted, size: 15),
              const SizedBox(width: 5),
              Text(
                '${e.portion} (${e.grams.round()}g)',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _macroPanel(FoodEntry e) {
    final cal = e.calories == 0 ? 1 : e.calories;
    final pPct = (e.protein * 4 / cal * 100).round();
    final cPct = (e.carbs * 4 / cal * 100).round();
    final fPct = (e.fat * 9 / cal * 100).round();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(27),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 130,
            height: 130,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(130, 130),
                  painter: _DonutPainter(
                    values: [
                      e.protein * 4,
                      e.carbs * 4,
                      e.fat * 9,
                    ],
                    colors: const [_mint, _orange, _lilac],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${e.calories}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'KKAL',
                      style: TextStyle(color: _muted, fontSize: 9),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _macroRow(_mint, 'Protein', '$pPct% kalori', e.protein),
          const SizedBox(height: 7),
          _macroRow(_orange, 'Karbohidrat', '$cPct% kalori', e.carbs),
          const SizedBox(height: 7),
          _macroRow(_lilac, 'Lemak', '$fPct% kalori', e.fat),
        ],
      ),
    );
  }

  Widget _macroRow(Color color, String title, String sub, double grams) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: _panel2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  sub,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            '${grams.round()}',
            style: TextStyle(
              color: color,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'g',
            style: TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  _DonutPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 13.0;
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(stroke / 2);

    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = const Color(0xFF302C39);
    canvas.drawArc(arcRect, 0, math.pi * 2, false, bg);

    final total = values.fold<double>(0, (a, b) => a + b);
    if (total <= 0) return;

    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = values[i] / total * math.pi * 2;
      if (sweep <= 0) continue;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = colors[i];
      // Celah kecil antar segmen agar terlihat terpisah.
      final gap = sweep > 0.08 ? 0.03 : 0.0;
      canvas.drawArc(arcRect, start + gap, sweep - gap * 2, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.values != values || old.colors != colors;
}