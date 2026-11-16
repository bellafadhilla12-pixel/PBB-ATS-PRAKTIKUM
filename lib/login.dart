import 'package:flutter/material.dart';
import 'home_dashboard.dart';
const Color loginBg = Color(0xFF121019);
const Color loginPanel = Color(0xFF211F2A);
const Color loginPurple = Color(0xFFAC7BFF);
const Color loginMint = Color(0xFF43D9AE);
class LoginPage extends StatefulWidget {
    const LoginPage({super.key});
    @override
    State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool obscurePassword = true;
    bool rememberMe = true;
    @override
 void dispose() {
     emailController.dispose();
     passwordController.dispose();
     super.dispose();
 }
 void login() {
     if (emailController.text.trim().isEmpty ||
          passwordController.text.isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Masukkan email dan kata sandi terlebih dahulu.'),
          ),
         );
         return;
     }
     if (passwordController.text.length < 8) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Kata sandi minimal 8 karakter.'),
          ),
         );
         return;
     }
     Navigator.pushReplacement(
         context,
         MaterialPageRoute(
          builder: (_) => const HomeDashboardPage(),
         ),
     );
 }
 @override
 Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: loginBg,
      body: SafeArea(
          child: Center(
           child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(29, 25, 29, 30),
            child: Column(
             children: [
              _logo(),
              const SizedBox(height: 28),
              _welcomeText(),
              const SizedBox(height: 58),
              _emailField(),
              const SizedBox(height: 28),
              _passwordField(),
              const SizedBox(height: 30),
              _rememberSection(),
              const SizedBox(height: 43),
              _loginButton(),
              const SizedBox(height: 35),
              _divider(),
              const SizedBox(height: 32),
              _socialButtons(),
              const SizedBox(height: 58),
              _registerText(),
             ],
               ),
           ),
          ),
      ),
     );
 }
 Widget _logo() {
     return Container(
      width: 174,
      height: 174,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF211F2D),
          border: Border.all(
           color: const Color(0xFF302941),
           width: 14,
          ),
          boxShadow: [
           BoxShadow(
               color: loginPurple.withOpacity(.15),
               blurRadius: 35,
               spreadRadius: 8,
           ),
          ],
      ),
      child: Container(
          margin: const EdgeInsets.all(9),
          decoration: const BoxDecoration(
           color: Color(0xFF17151F),
           shape: BoxShape.circle,
          ),
          child: const Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
               Icon(
                Icons.local_fire_department,
                color: loginPurple,
                size: 65,
               ),
               SizedBox(height: 2),
               Text(
                'CaloPulse',
                style: TextStyle(
                    color: Color(0xFFDCCBFF),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                ),
               ),
           ],
          ),
      ),
     );
 }
 Widget _welcomeText() {
     return Column(
      children: [
          Container(
           padding: const EdgeInsets.symmetric(
               horizontal: 21,
               vertical: 10,
     ),
     decoration: BoxDecoration(
         color: const Color(0xFF292531),
         borderRadius: BorderRadius.circular(30),
     ),
     child: const Row(
         mainAxisSize: MainAxisSize.min,
         children: [
          Icon(
              Icons.local_fire_department_outlined,
              color: Color(0xFFDCCBFF),
              size: 19,
          ),
          SizedBox(width: 9),
          Text(
              'CALOPULSE SYNC',
              style: TextStyle(
               color: Color(0xFFDCCBFF),
               fontWeight: FontWeight.bold,
               fontSize: 17,
               letterSpacing: .5,
              ),
          ),
         ],
     ),
    ),
    const SizedBox(height: 22),
    const Text(
     'Selamat Datang\nKembali',
     textAlign: TextAlign.center,
     style: TextStyle(
               color: Color(0xFFE9E3F1),
               fontSize: 39,
               height: 1.15,
               fontWeight: FontWeight.w900,
               letterSpacing: -.8,
           ),
          ),
          const SizedBox(height: 12),
          const Text(
           'Masuk untuk pantau asupan kalori & nutrisi\nharian',
           textAlign: TextAlign.center,
           style: TextStyle(
               color: Color(0xFFC3BDCE),
               fontSize: 17,
               height: 1.5,
           ),
          ),
      ],
     );
 }
 Widget _emailField() {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          const Padding(
           padding: EdgeInsets.only(left: 7, bottom: 10),
           child: Text(
               'Email atau Nama Pengguna',
               style: TextStyle(
                color: Color(0xFFD8D1E2),
          fontSize: 16,
          fontWeight: FontWeight.w600,
         ),
     ),
    ),
    Container(
     height: 76,
     decoration: BoxDecoration(
         color: loginPanel,
         borderRadius: BorderRadius.circular(27),
     ),
     child: TextField(
         controller: emailController,
         keyboardType: TextInputType.emailAddress,
         style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
         ),
         decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Padding(
              padding: EdgeInsets.only(left: 15, right: 12),
              child: Icon(
               Icons.alternate_email,
               color: Color(0xFF9E97AC),
               size: 30,
              ),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 65),
          hintText: 'contoh@domain.com',
          hintStyle: TextStyle(
                    color: Color(0xFF777180),
                    fontSize: 18,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 24),
               ),
           ),
          ),
      ],
     );
 }
 Widget _passwordField() {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Row(
           children: [
               const Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: Text(
                     'Kata Sandi',
                     style: TextStyle(
                         color: Color(0xFFD8D1E2),
                         fontSize: 16,
                         fontWeight: FontWeight.w600,
                     ),
                    ),
                ),
               ),
               TextButton(
          onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(
                   content: Text(
                    'Fitur lupa kata sandi belum diaktifkan.',
                   ),
               ),
              );
          },
          child: const Text(
              'Lupa Kata Sandi?',
              style: TextStyle(
               color: Color(0xFFDCCBFF),
               fontSize: 15,
               fontWeight: FontWeight.w600,
              ),
          ),
         ),
     ],
    ),
    const SizedBox(height: 5),
    Container(
     height: 76,
     decoration: BoxDecoration(
         color: loginPanel,
         borderRadius: BorderRadius.circular(27),
     ),
     child: TextField(
         controller: passwordController,
         obscureText: obscurePassword,
         style: const TextStyle(
        color: Colors.white,
        fontSize: 17,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: const Padding(
           padding: EdgeInsets.only(left: 15, right: 12),
           child: Icon(
             Icons.lock_outline,
             color: Color(0xFF9E97AC),
             size: 29,
           ),
        ),
        prefixIconConstraints:
             const BoxConstraints(minWidth: 65),
        hintText: 'Masukkan minimal 8 karakter',
        hintStyle: const TextStyle(
           color: Color(0xFF777180),
           fontSize: 17,
        ),
        contentPadding:
             const EdgeInsets.symmetric(vertical: 24),
        suffixIcon: IconButton(
           onPressed: () {
             setState(() {
                obscurePassword = !obscurePassword;
             });
           },
           icon: Icon(
             obscurePassword
                   ? Icons.visibility_outlined
                         : Icons.visibility_off_outlined,
                     color: const Color(0xFF9E97AC),
                    ),
                ),
               ),
           ),
          ),
      ],
     );
 }
 Widget _rememberSection() {
     return Row(
      children: [
          GestureDetector(
           onTap: () {
               setState(() => rememberMe = !rememberMe);
           },
           child: Container(
               width: 34,
               height: 34,
               decoration: BoxDecoration(
                color: rememberMe
                     ? const Color(0xFFDCCBFF)
                     : Colors.transparent,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                    color: const Color(0xFFDCCBFF),
                    width: 1.5,
                ),
               ),
         child: rememberMe
              ? const Icon(
                   Icons.check,
                   color: Color(0xFF32165E),
                   size: 23,
               )
              : null,
     ),
    ),
    const SizedBox(width: 12),
    const Expanded(
     child: Text(
         'Ingat saya di perangkat ini',
         style: TextStyle(
          color: Color(0xFFD8D1E2),
          fontSize: 14,
         ),
     ),
    ),
    Container(
     padding: const EdgeInsets.symmetric(
         horizontal: 13,
         vertical: 7,
     ),
     decoration: BoxDecoration(
         color: const Color(0xFF10372F),
         borderRadius: BorderRadius.circular(20),
     ),
     child: const Row(
         children: [
          Icon(Icons.circle, color: loginMint, size: 10),
                SizedBox(width: 7),
                Text(
                    'Metabolisme Aktif',
                    style: TextStyle(
                     color: loginMint,
                     fontSize: 12,
                     fontWeight: FontWeight.bold,
                    ),
                ),
               ],
           ),
          ),
      ],
     );
 }
 Widget _loginButton() {
     return SizedBox(
      width: double.infinity,
      height: 77,
      child: ElevatedButton(
          onPressed: login,
          style: ElevatedButton.styleFrom(
           backgroundColor: loginPurple,
           foregroundColor: const Color(0xFF32165E),
           elevation: 0,
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(45),
           ),
          ),
          child: const Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
               Text(
                'Masuk Sekarang',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                ),
               ),
               SizedBox(width: 12),
               Icon(Icons.arrow_forward, size: 24),
           ],
          ),
      ),
     );
 }
 Widget _divider() {
     return Row(
      children: [
          const Expanded(
           child: Divider(color: Color(0xFF393441)),
          ),
          const Padding(
           padding: EdgeInsets.symmetric(horizontal: 16),
           child: Text(
               'ATAU LANJUTKAN DENGAN',
               style: TextStyle(
                color: Color(0xFFA49DAF),
                fontSize: 13,
                fontWeight: FontWeight.bold,
               ),
           ),
          ),
          const Expanded(
           child: Divider(color: Color(0xFF393441)),
          ),
      ],
     );
 }
 Widget _socialButtons() {
     return Row(
      children: [
          Expanded(
           child: _socialButton(
               icon: const Text(
                'G',
                style: TextStyle(
                    color: Color(0xFF4285F4),
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                ),
               ),
               label: 'Google',
           ),
          ),
          const SizedBox(width: 17),
          Expanded(
           child: _socialButton(
               icon: const Icon(
                Icons.apple,
                color: Colors.white,
                size: 30,
               ),
               label: 'Apple',
           ),
          ),
      ],
     );
 }
 Widget _socialButton({
     required Widget icon,
     required String label,
 }) {
     return SizedBox(
      height: 75,
      child: ElevatedButton(
          onPressed: () {
           ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                content: Text('Login dengan $label belum diaktifkan.'),
               ),
           );
          },
          style: ElevatedButton.styleFrom(
           backgroundColor: loginPanel,
           foregroundColor: Colors.white,
           elevation: 0,
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(25),
           ),
          ),
          child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
               icon,
               const SizedBox(width: 12),
               Text(
                label,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                ),
               ),
           ],
          ),
      ),
     );
 }
 Widget _registerText() {
     return Wrap(
      alignment: WrapAlignment.center,
      children: [
          const Text(
           'Belum punya akun? ',
           style: TextStyle(
               color: Color(0xFFD0C9D9),
               fontSize: 17,
           ),
          ),
          GestureDetector(
              onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(
                       content: Text('Halaman pendaftaran belum dibuat.'),
                   ),
                  );
              },
              child: const Text(
                  'Daftar gratis',
                  style: TextStyle(
                   color: Color(0xFFDCCBFF),
                   fontSize: 17,
                   fontWeight: FontWeight.bold,
                  ),
              ),
             ),
         ],
        );
    }
}
