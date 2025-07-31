import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_courses/screens/main_screen.dart';
import '../theme/colors.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  // Giả lập danh sách người dùng
  final Map<String, String> _users = {
    'user1': 'pass1',
    'user2': 'pass2',
  };

  void _login() {
    setState(() => _errorMessage = null);

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng điền đầy đủ thông tin.');
      return;
    }

    if (!_users.containsKey(username)) {
      setState(() => _errorMessage = 'Người dùng không tồn tại.');
      return;
    }

    if (_users[username] != password) {
      setState(() => _errorMessage = 'Mật khẩu không đúng.');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đăng nhập thành công!')),

    );

    //wait 1-2 s chuyen trang
    Future.delayed(const Duration(seconds: 2),(){
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context)=> MainScreen()));
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.purple,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
            vertical: size.height * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App logo / illustration
              Image.asset(
                'assets/amico.png',
                height: size.height * 0.35,
              ),
              const SizedBox(height: 20),
              // Login form container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xin chào!',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vui lòng đăng nhập',
                      style: GoogleFonts.montserrat(
                       
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.purple,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Tên đăng nhập',
                        labelStyle: TextStyle(
                          color: Colors.grey[700]

                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF0F4FF),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                      labelStyle: TextStyle(
                        color: Colors.grey[700],

                      ),
                           // Viền khi không được focus
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade500, // viền xám
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(10),
    ),

    // Viền khi được focus
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.deepPurple, // viền tím
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
                        filled: true,
                        fillColor: const Color(0xFFF0F4FF),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tính năng quên mật khẩu chưa khả dụng.'),
                            ),
                          );
                        },
                        child: const Text('Quên mật khẩu?', style: TextStyle(color: AppColors.purple),),
                      ),
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _login,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(55),
                          backgroundColor: AppColors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Đăng nhập'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chưa có tài khoản?',
                          style: GoogleFonts.montserrat(fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text('Đăng ký ngay', style:TextStyle(
                            color: AppColors.purple
                          )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
