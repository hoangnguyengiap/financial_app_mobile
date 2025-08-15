import 'package:final_project/QuynhAnh_screens/dashboard.dart';
import 'package:final_project/screens_Giap/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final login_service loginService = login_service();
  late TabController _tabController;
  bool _showPassword = false;

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _signupUsernameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupConfirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _clearPrefs();
  }

  void _clearPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();

    _signupUsernameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 20,),

                    Text("FinGuard",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 40),)
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Sign in to your account",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: "Login"),
                          Tab(text: "Sign Up"),
                        ],
                        labelColor: Colors.indigo,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.indigo,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          controller: _tabController,
                          children: [buildLoginTab(), buildSignUpTab()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginTab() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          const SizedBox(height: 10,),
          buildEmailInput(controller: _loginEmailController),
          const SizedBox(height: 16),
          buildPasswordInput(controller: _loginPasswordController),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              if (_loginFormKey.currentState!.validate()) {
                final result = await loginService.login(_loginEmailController.text, _loginPasswordController.text);
                if(result == null){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Wrong email or password'),),
                  );
                  return;
                }
                //Save to share_preference
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt('userID', result.id);
                await prefs.setString('email', result.email);
                await prefs.setString('username', result.username);
                
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text(
              "Sign In",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSignUpTab() {
    return Form(
      key: _signupFormKey,
      child: Column(
        children: [
          const SizedBox(height: 6),
          buildUsernameInput(controller: _signupUsernameController), // 👈 THÊM
          const SizedBox(height: 8),
          buildEmailInput(controller: _signupEmailController),
          const SizedBox(height: 8),
          buildPasswordInput(
            controller: _signupPasswordController,
            label: "Password",
          ),
          const SizedBox(height: 8),
          buildPasswordInput(
            controller: _signupConfirmPasswordController,
            label: "Confirm Password",
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please confirm your password';
              if (value != _signupPasswordController.text)
                return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_signupFormKey.currentState!.validate()) {
                try {
                  final user = await loginService.register(_signupEmailController.text,
                     _signupUsernameController.text, _signupConfirmPasswordController.text);
                  if (user != null) {
                    // Navigate or show success
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Register successfully! Please log in again")),
                    );

                    Future.delayed(const Duration(seconds: 1), () {
                      if (context.mounted) {
                        _tabController.animateTo(0);
                      }
                    });
                  }
                } catch (e) {
                  // Show snackbar, dialog, etc.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text(
              "Create Account",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmailInput({required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email is required';
        if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value))
          return 'Enter a valid email';
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        prefixIcon: const Icon(Icons.mail),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget buildPasswordInput({
    required TextEditingController controller,
    String label = "Password",
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !_showPassword,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) return 'Password is required';
            if (value.length < 6)
              return 'Password must be at least 6 characters';
            return null;
          },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _showPassword = !_showPassword),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget buildUsernameInput({required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'User name is required';
        }
        if (value.trim().length < 3) {
          return 'User name must be at least 3 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "User Name",
        prefixIcon: const Icon(Icons.person),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
