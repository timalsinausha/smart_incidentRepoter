import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_incident_repoter/core/network_status.dart';
import 'package:smart_incident_repoter/custom/textformfield_custom.dart';
import 'package:smart_incident_repoter/model/credentials.dart';
import 'package:smart_incident_repoter/providers/login_provider.dart';
import 'package:smart_incident_repoter/providers/register_provider.dart';

import '../../custom/elevatedButton_custom.dart';
import '../../helper/strings_utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
 final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _formKey = GlobalKey<FormState>();
bool _navigated = false;
  @override
  Widget build(BuildContext context) {
final isObscure = ref.watch(loginPasswordVisibilityProvider);
    ref.listen(loginControllerProvider, (_, state) {
  state.whenOrNull(
    data: (response) {
      if (response.status == NetworkStatus.success && !_navigated) {
        _navigated = true;
         if (response.data != null) {
          ref.read(currentUserProvider.notifier).state = response.data;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login successful")),
        );

        Future.microtask(() {
          Beamer.of(context).beamToNamed('/home/readincidents');
        });
       
      } else if (response.status == NetworkStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.errorMessage ?? "Login failed")),
        );
      }
    },
  );
});

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child: Image.network("https://img.freepik.com/free-vector/user-verification-unauthorized-access-prevention-private-account-authentication-cyber-security-people-entering-login-password-safety-measures_335657-3530.jpg?semt=ais_hybrid&w=740&q=80",height: 250,),
                  ),
                  
        
                const  SizedBox(
                    height: 15,
                  ),
                 
                 Textfield_Custom(
                  controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                      labelText: emailStr,
                      prefixIcon: Icon(Icons.email),
                    // onChanged: (value) {
                    // // signinProvider.email = value;
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return emailValidatorStr;
                      } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                          .hasMatch(value)) {
                        return "Invalid email";
                      } else {
                        return null;
                      }
                    },
                  ),
        
                  SizedBox(
                    height: 15,
                  ),
                  Textfield_Custom(
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText:isObscure,
                    labelText: passwordStr,
                    prefixIcon: Icon(Icons.lock_open),
                 suffixIcon: IconButton(
                    icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      ref.read(loginPasswordVisibilityProvider.notifier).state = !isObscure;
                    },),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return passwordValidatorStr;
                      } else if (!RegExp(
                              r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                          .hasMatch(value)) {
                        return "Password must contain 1 uppercase,1 symbol,and\n have at least 8 characters";
                      } else {
                        return null;
                      }
                    },
                  ),
                const  SizedBox(
                    height: 15,
                  ),
                  
               ElevetedButton_custom(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final credential = Credential(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );
                  await ref.read(loginControllerProvider.notifier).login(credential);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 20),
                ),
              ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: Row(
                      children: [
                       const Text(
                           "Don't Have an Account?",
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                        TextButton(
                            onPressed: () {
                               Beamer.of(context).beamToNamed('/register');
                            },
                            child:const Text(
                              "Register",
                              style: TextStyle(color:Color(0xff007958), fontSize: 20),
                            )),
                      ],
                    ),
                  ),
                 const SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}