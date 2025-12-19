import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_incident_repoter/custom/elevatedButton_custom.dart';
import 'package:smart_incident_repoter/custom/textformfield_custom.dart';
import 'package:smart_incident_repoter/providers/register_provider.dart';

import '../../core/network_status.dart';
import '../../helper/strings_utils.dart';
import '../../model/credentials.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
   final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final isObscure = ref.watch(passwordVisibilityProvider);
    // Watch the controller state
    final state = ref.watch(registerControllerProvider);

    // Listen for changes (optional: show snackbar / navigate)
    ref.listen(registerControllerProvider, (_, state) {
      state.whenOrNull(
        data: (response) {
          if (response.status == NetworkStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registered successfully!")),
            );
            // Navigate to login or home
             Future.microtask(() {
          Beamer.of(context).beamToNamed('/login');
        });
          } else if (response.status == NetworkStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response.errorMessage ?? "Error")),
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
                    child: Image.network("https://img.freepik.com/free-vector/sign-page-abstract-concept-illustration-enter-application-mobile-screen-user-login-form-website-page-interface-ui-new-profile-registration-email-account_335657-936.jpg?semt=ais_hybrid&w=740&q=80",height: 250,),
                  ),
        
                  Text(
                    "Create an Account",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
               
              Textfield_Custom(
                controller: _nameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
               inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
                labelText: nameStr,
                // onChanged: (value) {
                //  // signinProvider.name = value;
                // },
                validator: (value) {
                  if (value!.isEmpty) {
                    return nameValidatorStr;
                  } else {
                    return null;
                  }
                },
                prefixIcon: Icon(Icons.person_2),
              ),
              SizedBox(
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
                    obscureText: isObscure,
                    labelText: passwordStr,
                    prefixIcon: Icon(Icons.lock_open),
                   suffixIcon: IconButton(
                    icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      ref.read(passwordVisibilityProvider.notifier).state = !isObscure;
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
                    name: _nameController.text.trim(),
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );
                  await ref.read(registerControllerProvider.notifier).register(credential);
                  Navigator.of(context).pop(); 
                },
                child: const Text("Register"),
              ),


                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: Row(
                      children: [
                        Text(
                          "Already Have an Account?",
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                        TextButton(
                            onPressed: () {
                              Beamer.of(context).beamToNamed('/login');
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(color:Color(0xff007958), fontSize: 20),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}