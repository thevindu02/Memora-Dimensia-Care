import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Authenticate user with database
      final authResult = await AuthService.authenticateUser(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (authResult.success) {
        // Login successful - navigate to appropriate dashboard
        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authResult.message),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to dashboard based on user role
          Navigator.of(context).pushReplacementNamed(
            authResult.dashboardRoute!,
          );
        }
      } else {
        // Login failed - show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authResult.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Handle unexpected errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handlePatientLogin() {
    // Navigate directly to patient email verification
    Navigator.of(context).pushNamed(
      AppRoutes.patientEmailVerification,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight - 32, // Account for AppBar and padding
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Minimal spacing at the top
                    //const SizedBox(height: 2),

                    // Logo - make it responsive
                    Image.asset(
                      'assets/images/light_logo.png', // Replace with your actual logo path
                      width: MediaQuery.of(context).size.width * 0.6, // Larger logo
                      height: MediaQuery.of(context).size.width * 0.6, // Larger logo
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 4),

                    // Welcome text
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 28, // Slightly smaller font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        
                        String trimmedValue = value.trim();
                        
                        // Check for basic email format
                        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(trimmedValue)) {
                          return 'Please enter a valid email address';
                        }
                        
                        // Check email length
                        if (trimmedValue.length > 254) {
                          return 'Email address is too long';
                        }
                        
                        // Check for consecutive dots
                        if (trimmedValue.contains('..')) {
                          return 'Email cannot contain consecutive dots';
                        }
                        
                        // Check if it starts or ends with a dot
                        if (trimmedValue.startsWith('.') || trimmedValue.endsWith('.')) {
                          return 'Email cannot start or end with a dot';
                        }
                        
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        
                        if (value.length > 128) {
                          return 'Password is too long (max 128 characters)';
                        }
                        
                        // Check for at least one uppercase letter
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Password must contain at least one uppercase letter';
                        }
                        
                        // Check for at least one lowercase letter
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Password must contain at least one lowercase letter';
                        }
                        
                        // Check for at least one digit
                        if (!RegExp(r'\d').hasMatch(value)) {
                          return 'Password must contain at least one number';
                        }
                        
                        // Check for at least one special character
                        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                          return 'Password must contain at least one special character';
                        }
                        
                        // Check for common weak passwords
                        List<String> commonPasswords = [
                          'password', 'password123', '123456', '123456789', 
                          'qwerty', 'abc123', 'password1', 'admin', 'letmein'
                        ];
                        
                        if (commonPasswords.contains(value.toLowerCase())) {
                          return 'Password is too common, please choose a stronger password';
                        }
                        
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFA0C4FD),
                          foregroundColor: Color(0xFF2B3F99),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Login as Patient button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handlePatientLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFA0C4FD),
                          foregroundColor: Color(0xFF2B3F99),
                        ),
                        child: const Text('Login as a Patient'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Forgot password link
                    TextButton(
                      onPressed: () {
                        // Navigate to forgot password screen
                        Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
                      },
                      child: const Text('Forgot Password?'),
                    ),

                    // Register link
                    TextButton(
                      onPressed: () {
                        // Navigate to registration screen
                        Navigator.of(context).pushNamed(AppRoutes.signup);
                      },
                      child: const Text('Don\'t have an account? Register'),
                    ),

                    // Bottom spacing
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}