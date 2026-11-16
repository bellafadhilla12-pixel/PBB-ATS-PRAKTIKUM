import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';
class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});
    @override
    State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>
     with SingleTickerProviderStateMixin {
    late AnimationController _controller;
    late Animation<double> _progress;
    late Animation<double> _fade;
    @override
    void initState() {
     super.initState();
     _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
     );
     _progress = Tween<double>(
      begin: 0,
      end: 0.94,
     ).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
      ),
     );
     _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
     );
     _controller.forward();
     Timer(const Duration(milliseconds: 3500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
           context,
           PageRouteBuilder(
            pageBuilder: (_, animation, secondaryAnimation) =>
                 const LoginPage(),
            transitionsBuilder: (_, animation, secondaryAnimation, child) {
                return FadeTransition(
                 opacity: animation,
                 child: child,
                );
            },
            transitionDuration: const Duration(milliseconds: 600),
           ),
      );
     });
 }
 @override
 void dispose() {
     _controller.dispose();
     super.dispose();
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   backgroundColor: const Color(0xFF121019),
   body: Container(
    width: double.infinity,
    decoration: const BoxDecoration(
     gradient: RadialGradient(
         center: Alignment(0, -0.1),
         radius: 1.15,
         colors: [
          Color(0xFF382B50),
          Color(0xFF211B30),
          Color(0xFF121019),
         ],
         stops: [0, 0.48, 1],
     ),
    ),
    child: SafeArea(
     child: LayoutBuilder(
         builder: (context, constraints) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
               children: [
                const SizedBox(height: 65),
                // STATUS BAGIAN ATAS
                Row(
                 children: [
                  Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
              ),
              decoration: BoxDecoration(
                  color: const Color(0xFF292431),
                  borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                  children: [
                   Icon(
                       Icons.circle,
                       color: Color(0xFF43D9AE),
                       size: 13,
                   ),
                   SizedBox(width: 9),
                   Text(
                       'METABOLIC SYNC',
                       style: TextStyle(
                        color: Color(0xFFCCC4D9),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5,
                       ),
                   ),
                  ],
              ),
             ),
             const Spacer(),
             const Icon(
              Icons.bolt,
                 color: Color(0xFFD0B5FF),
                 size: 21,
                ),
                const SizedBox(width: 6),
                const Text(
                 'HALO',
                 style: TextStyle(
                     color: Color(0xFFD0B5FF),
                     fontSize: 14,
                     fontWeight: FontWeight.bold,
                     letterSpacing: .5,
                 ),
                ),
            ],
           ),
           const Spacer(flex: 3),
           // LOGO DAN ANIMASI
           AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
                return SizedBox(
                 width: 270,
                 height: 270,
                 child: Stack(
                     alignment: Alignment.center,
                     children: [
                      Container(
                       width: 235,
                       height: 235,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                       BoxShadow(
                           color: const Color(0xFFAC7BFF)
                             .withOpacity(.16),
                           blurRadius: 60,
                           spreadRadius: 15,
                       ),
                      ],
                  ),
                 ),
                 SizedBox(
                  width: 215,
                  height: 215,
                  child: CircularProgressIndicator(
                      value: _progress.value,
                      strokeWidth: 4,
                      backgroundColor:
                           const Color(0xFF39304D),
                      valueColor:
                           const AlwaysStoppedAnimation(
                       Color(0xFFD4B5FF),
                      ),
                      strokeCap: StrokeCap.round,
                  ),
                 ),
                 Container(
                  width: 232,
                  height: 232,
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                   color: const Color(0xFF211F2A),
                   borderRadius: BorderRadius.circular(47),
                   boxShadow: [
                       BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                       ),
                   ],
                  ),
                  child: Container(
                   decoration: BoxDecoration(
                       color: const Color(0xFF191D27),
                       borderRadius: BorderRadius.circular(30),
                   ),
                   child: Column(
                       mainAxisAlignment:
                            MainAxisAlignment.center,
                       children: [
                        Container(
                            width: 112,
                            height: 112,
                            decoration: const BoxDecoration(
                             color: Color(0xFF121019),
                             shape: BoxShape.circle,
                            ),
                            child: const Icon(
                             Icons.local_fire_department,
                                color: Color(0xFFAC7BFF),
                                size: 76,
                            ),
                           ),
                           const SizedBox(height: 3),
                           RichText(
                            text: const TextSpan(
                                children: [
                                 TextSpan(
                                     text: 'Calo',
                                     style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                     ),
                                 ),
                                 TextSpan(
                                     text: 'Pulse',
                                     style: TextStyle(
                                      color: Color(0xFFD0B5FF),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                     ),
                                 ),
                                ],
                            ),
                           ),
                       ],
                      ),
                  ),
                 ),
                     ],
                 ),
                );
            },
           ),
           const SizedBox(height: 35),
           // NAMA APLIKASI
           RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
                children: [
                 TextSpan(
                     text: 'Calo',
                     style: TextStyle(
                      color: Color(0xFFE9E2F3),
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                     ),
                 ),
                 TextSpan(
                     text: 'Pulse',
                     style: TextStyle(
                      color: Color(0xFFBDA0FF),
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                     ),
                 ),
                ],
            ),
           ),
           const SizedBox(height: 15),
           const Text(
            'Capai Target Kalori & Nutrisi Harianmu',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFFC9C0D4),
                fontSize: 16,
                fontWeight: FontWeight.w500,
            ),
           ),
           const SizedBox(height: 48),
           // FITUR UTAMA
           Wrap(
            alignment: WrapAlignment.center,
            spacing: 9,
            runSpacing: 10,
            children: [
                _feature(
                 Icons.local_fire_department_outlined,
                 'Kalori',
                 const Color(0xFFD0B5FF),
                 const Color(0xFF30283C),
                ),
                _feature(
                 Icons.fitness_center,
                 'Protein',
                 const Color(0xFF43D9AE),
                 const Color(0xFF1B302D),
                ),
                _feature(
                 Icons.grain,
                 'Karbo & Lemak',
                 const Color(0xFFFFB84D),
                 const Color(0xFF382D29),
                ),
            ],
           ),
           const Spacer(flex: 3),
           // LOADING
           AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
                return Opacity(
                 opacity: _fade.value.clamp(0.0, 1.0),
                 child: Column(
                     children: [
                      Row(
                       children: [
                        const Icon(
                         Icons.circle,
                         color: Color(0xFFD0B5FF),
                         size: 11,
                        ),
                      const SizedBox(width: 10),
                      const Expanded(
                       child: Text(
                           'Menyiapkan data metabolisme...',
                           style: TextStyle(
                            color: Color(0xFFD0C9DC),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                           ),
                       ),
                      ),
                      Text(
                       '${(_progress.value * 100).round()}%',
                       style: const TextStyle(
                           color: Color(0xFFD0B5FF),
                           fontSize: 14,
                           fontWeight: FontWeight.bold,
                       ),
                      ),
                  ],
                 ),
                 const SizedBox(height: 13),
                 ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      height: 10,
                      color: const Color(0xFF393340),
                      child: FractionallySizedBox(
                       alignment: Alignment.centerLeft,
                               widthFactor: _progress.value,
                               child: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                     colors: [
                                         Color(0xFFD0B5FF),
                                         Color(0xFF9870F7),
                                         Color(0xFF43D9AE),
                                     ],
                                    ),
                                    borderRadius: BorderRadius.all(
                                     Radius.circular(20),
                                    ),
                                ),
                               ),
                           ),
                          ),
                      ),
                     ],
                 ),
                );
            },
           ),
           const SizedBox(height: 30),
           const Text.rich(
            TextSpan(
                children: [
                 TextSpan(
                     text: 'v2.4.0 • ',
                                   style: TextStyle(
                                    color: Color(0xFF9D94AA),
                                   ),
                               ),
                               TextSpan(
                                   text: '✧ Powered by Smart Calorie AI',
                                   style: TextStyle(
                                    color: Color(0xFFC9C0D4),
                                    fontWeight: FontWeight.w600,
                                   ),
                               ),
                              ],
                          ),
                          style: TextStyle(fontSize: 13),
                         ),
                         const SizedBox(height: 70),
                     ],
                    ),
                );
               },
           ),
          ),
      ),
     );
 }
 Widget _feature(
     IconData icon,
     String label,
     Color color,
        Color background,
    ){
        return Container(
         padding: const EdgeInsets.symmetric(
             horizontal: 13,
             vertical: 10,
         ),
         decoration: BoxDecoration(
             color: background,
             borderRadius: BorderRadius.circular(25),
         ),
         child: Row(
             mainAxisSize: MainAxisSize.min,
             children: [
              Icon(icon, color: color, size: 17),
              const SizedBox(width: 7),
              Text(
                  label,
                  style: TextStyle(
                   color: color,
                   fontSize: 13,
                   fontWeight: FontWeight.bold,
                  ),
              ),
             ],
         ),
        );
    }
}
