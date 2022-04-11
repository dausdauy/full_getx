import 'package:email_validator/email_validator.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:full_getx/services/controller/login_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Login extends GetView {
  Login({Key? key}) : super(key: key);
  final c = Get.put(LoginController());
  final cUser = TextEditingController();
  final cPass = TextEditingController();
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Obx(
            () => Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      image(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        child: Form(
                          key: _keyForm,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: cUser,
                                style: Theme.of(context).textTheme.bodyMedium,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                validator: _validatorUserEmail,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  label: Text('Username / Email'),
                                  isDense: true,
                                  focusColor: Colors.black,
                                  errorStyle: TextStyle(fontSize: 11),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: cPass,
                                style: Theme.of(context).textTheme.bodyMedium,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.done,
                                onEditingComplete: () => onLogin(context),
                                validator: _validatorPassword,
                                obscureText: c.showPassword.value,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  label: const Text('Password'),
                                  isDense: true,
                                  focusColor: Colors.black,
                                  errorStyle: const TextStyle(fontSize: 11),
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                  prefixIcon: const Icon(Icons.password),
                                  suffixIcon: GetBuilder<LoginController>(
                                    init: LoginController(),
                                    initState: (_) {},
                                    builder: (c) {
                                      return InkWell(
                                        onTap: () {
                                          c.showPassword.value =
                                              !c.showPassword.value;
                                          c.update();
                                        },
                                        child: c.showPassword.isFalse
                                            ? const Icon(
                                                Icons.visibility_rounded)
                                            : const Icon(
                                                Icons.visibility_off_rounded),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () => c.isLoading.isTrue
                                    ? null
                                    : onLogin(context),
                                style: ElevatedButton.styleFrom(
                                  primary: c.isLoading.isTrue
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                                child: const Text('LOGIN'),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Divider(
                                      color: Colors.black,
                                      indent: 70,
                                      endIndent: 10,
                                      thickness: 0.2,
                                    ),
                                  ),
                                  Text(
                                    'OR',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  const Expanded(
                                    child: Divider(
                                      color: Colors.black,
                                      indent: 10,
                                      endIndent: 70,
                                      thickness: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              SignInButton(
                                Buttons.Google,
                                onPressed: () => c
                                    .signInWithGoogle()
                                    .whenComplete(() => c.isLoading(false)),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Don\'t have an account? ',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      textScaleFactor: 1.25),
                                  Text('SignUp',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (c.isLoading.isTrue) const LinearProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onLogin(context) {
    if (_keyForm.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      c.isLoading(true);
      c.signIn(cUser.text, cPass.text).whenComplete(() => c.isLoading(false));
    }
  }

  String? _validatorUserEmail(String? value) {
    if (value!.contains('@')) {
      return EmailValidator.validate(value)
          ? null
          : 'Masukkan email dengan benar';
    } else {
      if (value.isEmpty) return 'Username / Email tidak boleh kosong';
      if (value.length < 4) return 'Username terlalu pendek';
    }
    return null;
  }

  String? _validatorPassword(String? value) {
    if (value!.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 4) return 'Password terlalu pendek';
    return null;
  }

  Widget image() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: SizedBox(
        height: 250,
        child: Image.asset(
          'assets/login.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
