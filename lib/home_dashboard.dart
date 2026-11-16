import 'package:flutter/material.dart';
import 'add_food.dart';
import 'food_detail.dart';
import 'food_store.dart';
const Color _bg = Color(0xFF121019);
const Color _panel = Color(0xFF211F2A);
const Color _panel2 = Color(0xFF292632);
const Color _purple = Color(0xFFAC7BFF);
const Color _mint = Color(0xFF43D9AE);
const Color _orange = Color(0xFFFFB84D);
const Color _muted = Color(0xFFAAA5B8);
class HomeDashboardPage extends StatelessWidget {
 const HomeDashboardPage({super.key});
 String _dateText() {
  const days = [
   'Senin',
   'Selasa',
   'Rabu',
   'Kamis',
   'Jumat',
   'Sabtu',
   'Minggu',
  ];
  const months = [
   'Jan',
   'Feb',
   'Mar',
   'Apr',
   'Mei',
   'Jun',
   'Jul',
   'Agu',
   'Sep',
   'Okt',
   'Nov',
   'Des',
  ];
  final now = DateTime.now();
  return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
 }
 void _openAdd(BuildContext context) {
     Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddFoodPage()),
     );
 }
 @override
 Widget build(BuildContext context) {
     return ListenableBuilder(
      listenable: FoodStore.instance,
      builder: (context, _) {
          final store = FoodStore.instance;
          final entries = store.entries;
          return Scaffold(
           backgroundColor: _bg,
           body: SafeArea(
            child: ListView(
             padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
             children: [
              _topBar(),
              const SizedBox(height: 22),
              Row(
                children: [
                 Expanded(
                  child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
              const Text(
                'Halo, Alex! 👋',
                style: TextStyle(
                   color: Colors.white,
                   fontSize: 23,
                   fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                   const Icon(
                     Icons.calendar_month,
                     size: 15,
                     color: Color(0xFFD8C8FF),
                   ),
                   const SizedBox(width: 5),
                   Text(
                     '${_dateText()} • ',
                     style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                     ),
                   ),
                   const Text(
                     'Fase Optimal',
                     style: TextStyle(
                        color: _mint,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                     ),
                      ),
                     ],
                 ),
                ],
            ),
           ),
           Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
            ),
            decoration: BoxDecoration(
                color: _panel2,
                borderRadius: BorderRadius.circular(24),
            ),
            child: const Row(
                children: [
                 Icon(
                     Icons.local_fire_department,
                     color: _orange,
                     size: 18,
                 ),
                 SizedBox(width: 5),
                 Text(
                     '12 Hari',
                     style: TextStyle(
                      color: _orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                     ),
                 ),
                   ],
               ),
              ),
          ],
         ),
         const SizedBox(height: 22),
         _calorieCard(store),
         const SizedBox(height: 24),
         _addFoodButton(context),
         const SizedBox(height: 25),
         Row(
          children: [
              const Icon(
               Icons.restaurant,
               color: Color(0xFFDCCBFF),
               size: 20,
              ),
              const SizedBox(width: 9),
              const Text(
               'Makanan Hari Ini',
               style: TextStyle(
                   color: Colors.white,
                   fontWeight: FontWeight.w800,
                   fontSize: 19,
               ),
              ),
              const Spacer(),
              Text(
               '${entries.length} item',
               style: const TextStyle(
                   color: Color(0xFFDCCBFF),
                   fontSize: 12,
               ),
              ),
          ],
         ),
         const SizedBox(height: 12),
         if (entries.isEmpty)
          _emptyState()
         else
          ...entries.map((e) => _mealCard(context, e)),
         const SizedBox(height: 14),
         Row(
          children: [
              Expanded(
               child: _smallStat(
                   'Hidrasi',
                   Icons.water_drop_outlined,
                   '1.750',
                   '/ 2.500 ml',
                   '70% Target',
                   _mint,
               ),
              ),
              const SizedBox(width: 12),
              Expanded(
               child: _smallStat(
                   'Aktivitas',
                   Icons.directions_run,
                   '420',
                   'kkal terbakar',
                   '45 mnt latihan',
                              _orange,
                          ),
                         ),
                     ],
                    ),
                ],
               ),
           ),
           bottomNavigationBar: _bottomBar(context),
          );
      },
     );
 }
 Widget _topBar() {
     return Row(
      children: [
          Container(
           width: 34,
           height: 34,
           decoration: BoxDecoration(
               color: _panel2,
               borderRadius: BorderRadius.circular(9),
           ),
           child: const Icon(Icons.bubble_chart, color: _purple),
          ),
          const SizedBox(width: 9),
          const Text(
           'CaloPulse',
           style: TextStyle(
               color: Color(0xFFDCCBFF),
               fontWeight: FontWeight.w800,
               fontSize: 20,
           ),
          ),
          const SizedBox(width: 10),
          Container(width: 1, height: 20, color: Colors.white24),
          const SizedBox(width: 10),
          const Expanded(
           child: Text(
               'Home Dashboard',
               style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
               ),
           ),
          ),
          const Icon(Icons.notifications_none, color: Colors.white, size: 23),
          const SizedBox(width: 14),
          const CircleAvatar(
           radius: 16,
           backgroundColor: _panel2,
           child: Icon(Icons.person, color: Color(0xFFDCCBFF), size: 18),
          ),
      ],
     );
 }
 Widget _calorieCard(FoodStore store) {
     const target = FoodStore.calorieTarget;
     final consumed = store.totalCalories;
  final remaining = (target - consumed).clamp(0, target);
  final ratio = (consumed / target).clamp(0.0, 1.0);
  final percent = (consumed / target * 100).round();
  return Container(
   padding: const EdgeInsets.fromLTRB(16, 17, 16, 20),
   decoration: BoxDecoration(
    gradient: const LinearGradient(
        colors: [Color(0xFF25222F), Color(0xFF1B2025)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(30),
   ),
   child: Column(
    children: [
        Container(
         padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
         decoration: BoxDecoration(
          color: const Color(0xFF17151E),
          borderRadius: BorderRadius.circular(20),
         ),
         child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
              Icon(Icons.circle, size: 9, color: _mint),
              SizedBox(width: 7),
              Text(
               'Target Harian: ',
               style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
           Text(
               '2.100 kkal',
               style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
               ),
           ),
          ],
      ),
     ),
     const SizedBox(height: 15),
     SizedBox(
      width: 220,
      height: 220,
      child: Stack(
          alignment: Alignment.center,
          children: [
           SizedBox.expand(
               child: CircularProgressIndicator(
                value: ratio,
                strokeWidth: 13,
                backgroundColor: const Color(0xFF302C39),
                valueColor: const AlwaysStoppedAnimation(_purple),
                strokeCap: StrokeCap.round,
               ),
           ),
           Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                const Text(
            'SISA KALORI',
            style: TextStyle(
                color: Color(0xFFDCCBFF),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
            ),
           ),
           const SizedBox(height: 2),
           Text(
            '$remaining',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 39,
                height: 1,
                fontWeight: FontWeight.w900,
            ),
           ),
           const Text(
            'kkal',
            style: TextStyle(color: Colors.white70, fontSize: 12),
           ),
           const SizedBox(height: 5),
           Text(
            '$percent% Tercapai',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                backgroundColor: Color(0xFF383342),
            ),
           ),
               ],
           ),
          ],
      ),
     ),
     const SizedBox(height: 13),
     Text(
      'Konsumsi: $consumed / $target kkal',
      style: const TextStyle(color: Colors.white70, fontSize: 12),
     ),
     const SizedBox(height: 18),
     Row(
      children: [
          _macro(
           'PROTEIN',
           store.totalProtein,
           FoodStore.proteinTarget,
           _mint,
          ),
          const SizedBox(width: 8),
          _macro(
           'KARBO',
           store.totalCarbs,
           FoodStore.carbsTarget,
           _orange,
          ),
          const SizedBox(width: 8),
          _macro(
           'LEMAK',
           store.totalFat,
           FoodStore.fatTarget,
                    _purple,
                ),
               ],
           ),
          ],
      ),
     );
 }
 Widget _macro(String title, double current, int target, Color color) {
     final value = (current / target).clamp(0.0, 1.0);
     final percent = (current / target * 100).round();
     return Expanded(
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
           color: const Color(0xFF17151F),
           borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
               Row(
                children: [
                    Expanded(
                     child: Text(
                      title,
                      style: TextStyle(
                       color: color,
                       fontWeight: FontWeight.bold,
                    fontSize: 10,
                   ),
               ),
              ),
              Text(
               '$percent%',
               style: TextStyle(
                   color: color,
                   fontSize: 10,
                   fontWeight: FontWeight.bold,
               ),
              ),
          ],
         ),
         const SizedBox(height: 7),
         Text(
          '${current.round()}/${target}g',
          style: const TextStyle(color: Colors.white, fontSize: 12),
         ),
         const SizedBox(height: 7),
         ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: const Color(0xFF393541),
              valueColor: AlwaysStoppedAnimation(color),
          ),
         ),
     ],
    ),
      ),
     );
 }
 Widget _addFoodButton(BuildContext context) {
     return InkWell(
      onTap: () => _openAdd(context),
      borderRadius: BorderRadius.circular(35),
      child: Container(
          height: 58,
          decoration: BoxDecoration(
           gradient: const LinearGradient(
               colors: [_purple, Color(0xFFD0B5FF)],
           ),
           borderRadius: BorderRadius.circular(35),
           boxShadow: [
               BoxShadow(
                color: _purple.withOpacity(.25),
                blurRadius: 18,
               ),
           ],
          ),
          child: const Row(
           children: [
               SizedBox(width: 18),
               Icon(Icons.add_circle_outline, color: Color(0xFF32165E)),
               SizedBox(width: 10),
               Text(
                'Catat Makanan',
                style: TextStyle(
                    color: Color(0xFF32165E),
                    fontWeight: FontWeight.w700,
                ),
               ),
               Spacer(),
               Icon(Icons.bolt, color: Color(0xFF32165E)),
               SizedBox(width: 20),
           ],
          ),
      ),
     );
 }
 Widget _emptyState() {
     return Container(
      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: _panel,
          borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
          children: [
           Icon(Icons.restaurant_menu, color: _muted, size: 34),
           SizedBox(height: 10),
           Text(
               'Belum ada makanan hari ini',
               style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
               ),
           ),
           SizedBox(height: 4),
           Text(
               'Tekan "Catat Makanan" untuk mulai mencatat.',
               style: TextStyle(color: Colors.white70, fontSize: 12),
           ),
          ],
      ),
     );
 }
 Widget _mealCard(BuildContext context, FoodEntry e) {
     final color = mealColor(e.meal);
     return InkWell(
      onTap: () {
          Navigator.push(
           context,
           MaterialPageRoute(
               builder: (_) => FoodDetailPage(entryId: e.id),
           ),
          );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.fromLTRB(14, 14, 6, 14),
          decoration: BoxDecoration(
           color: _panel,
           borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Row(
        children: [
         CircleAvatar(
          radius: 15,
          backgroundColor: color.withOpacity(.16),
          child: Icon(mealIcon(e.meal), color: color, size: 17),
         ),
         const SizedBox(width: 9),
         Text(
          mealLabel(e.meal),
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
          ),
         ),
         const SizedBox(width: 7),
         Expanded(
          child: Text(
              '• ${e.timeText}',
              style: const TextStyle(color: _muted, fontSize: 11),
          ),
         ),
         Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
          ),
          decoration: BoxDecoration(
                color: _panel2,
                borderRadius: BorderRadius.circular(18),
             ),
             child: Text(
                '${e.calories} kkal',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
             ),
           ),
           _menuButton(context, e),
        ],
      ),
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
                e.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
             ),
          const SizedBox(height: 2),
          Text(
           '${e.portion} (${e.grams.round()}g)',
           style: const TextStyle(
               color: Colors.white70,
               fontSize: 11,
           ),
          ),
          const SizedBox(height: 8),
          Row(
           children: [
               Text(
                'P: ${e.protein.round()}g',
                style: const TextStyle(
                    color: _mint,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                ),
               ),
               const SizedBox(width: 14),
               Text(
                'K: ${e.carbs.round()}g',
                style: const TextStyle(
                    color: _orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                ),
               ),
               const SizedBox(width: 14),
               Text(
                'L: ${e.fat.round()}g',
                              style: const TextStyle(
                               color: Color(0xFFD0B5FF),
                               fontSize: 10,
                               fontWeight: FontWeight.bold,
                              ),
                          ),
                         ],
                     ),
                    ],
                ),
               ),
           ],
          ),
      ),
     );
 }
 Widget _menuButton(BuildContext context, FoodEntry e) {
     return PopupMenuButton<String>(
      color: _panel2,
      icon: const Icon(Icons.more_vert, color: _muted),
      onSelected: (value) async {
          if (value == 'edit') {
           Navigator.push(
               context,
               MaterialPageRoute(
                builder: (_) => AddFoodPage(editing: e),
               ),
           );
          } else if (value == 'delete') {
           final deleted = await confirmDeleteFood(context, e);
              if (deleted && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('${e.name} dihapus dari log harian')),
                  );
              }
          }
      },
      itemBuilder: (_) => const [
          PopupMenuItem(
              value: 'edit',
              child: Row(
                  children: [
                   Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                   SizedBox(width: 10),
                   Text('Edit', style: TextStyle(color: Colors.white)),
                  ],
              ),
          ),
          PopupMenuItem(
              value: 'delete',
              child: Row(
                  children: [
                   Icon(Icons.delete_outline, color: Color(0xFFFF9D9D), size: 18),
                   SizedBox(width: 10),
                   Text('Hapus', style: TextStyle(color: Color(0xFFFF9D9D))),
                  ],
              ),
          ),
      ],
     );
 }
 Widget _smallStat(
  String title,
  IconData icon,
  String value,
  String suffix,
  String note,
  Color color,
 ){
  return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
       color: _panel,
       borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
           Row(
            children: [
                Expanded(
                 child: Text(
                     title,
                     style: const TextStyle(color: Colors.white70, fontSize: 12),
                 ),
                ),
                Icon(icon, color: color),
            ],
           ),
           const SizedBox(height: 12),
           Row(
         crossAxisAlignment: CrossAxisAlignment.baseline,
         textBaseline: TextBaseline.alphabetic,
         children: [
             Text(
              value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
              ),
             ),
             const SizedBox(width: 4),
             Flexible(
              child: Text(
                  suffix,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
             ),
         ],
        ),
        const SizedBox(height: 12),
        Text(
         note,
         style: TextStyle(
             color: color,
             fontSize: 10,
             fontWeight: FontWeight.w600,
         ),
        ),
    ],
   ),
     );
 }
 Widget _bottomBar(BuildContext context) {
     return BottomNavigationBar(
      backgroundColor: const Color(0xFF1C1924),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFDCCBFF),
      unselectedItemColor: _muted,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      currentIndex: 0,
      onTap: (index) {
          if (index == 1) _openAdd(context);
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
