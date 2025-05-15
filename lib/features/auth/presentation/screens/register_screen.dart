import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/constants.dart';
import '../../../../config/routes.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/utils/validators.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String _selectedRole = UserRole.student.toString();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authControllerProvider.notifier).register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        role: UserRoleExtension.fromString(_selectedRole),
      );
      
      // Registration successful, navigation will be handled by app_home.dart
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.createAccount),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App logo
                    SvgPicture.asset(
                      AppAssets.logo,
                      height: 100,
                      width: 100,
                      placeholderBuilder: (context) => const CircularProgressIndicator(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Registration form
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_errorMessage != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red.shade300),
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: Colors.red.shade800),
                                ),
                              ),

                            CustomTextField(
                              controller: _fullNameController,
                              labelText: AppStrings.fullName,
                              hintText: 'John Doe',
                              prefixIcon: const Icon(Icons.person_outline),
                              validator: Validators.validateName,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: _emailController,
                              labelText: AppStrings.email,
                              hintText: 'example@school.com',
                              prefixIcon: const Icon(Icons.email_outlined),
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.validateEmail,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: _passwordController,
                              labelText: AppStrings.password,
                              hintText: '••••••',
                              prefixIcon: const Icon(Icons.lock_outline),
                              obscureText: _obscurePassword,
                              validator: Validators.validatePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: _confirmPasswordController,
                              labelText: AppStrings.confirmPassword,
                              hintText: '••••••',
                              prefixIcon: const Icon(Icons.lock_outline),
                              obscureText: _obscureConfirmPassword,
                              validator: (value) => Validators.validateConfirmPassword(
                                _passwordController.text,
                                value,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),

                            // Role selection dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedRole,
                              decoration: InputDecoration(
                                labelText: AppStrings.role,
                                prefixIcon: const Icon(Icons.badge_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: UserRole.student.toString(),
                                  child: const Text('Student'),
                                ),
                                DropdownMenuItem(
                                  value: UserRole.parent.toString(),
                                  child: const Text('Parent'),
                                ),
                                DropdownMenuItem(
                                  value: UserRole.teacher.toString(),
                                  child: const Text('Teacher'),
                                ),
                                DropdownMenuItem(
                                  value: UserRole.clerk.toString(),
                                  child: const Text('Clerk'),
                                ),
                                DropdownMenuItem(
                                  value: UserRole.admin.toString(),
                                  child: const Text('Admin'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 24),

                            CustomButton(
                              onPressed: _register,
                              text: AppStrings.register,
                              isLoading: _isLoading,
                              isFullWidth: true,
                            ),
                            const SizedBox(height: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppStrings.hasAccount),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(AppRoutes.login);
                                  },
                                  child: Text(AppStrings.login),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
