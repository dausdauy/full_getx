import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:full_getx/pages/signup.dart';
import 'package:full_getx/services/controller/login_controller.dart';
import 'package:full_getx/services/function.dart';
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
                      Text('Sign In',
                          style: Theme.of(context).textTheme.titleLarge),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
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
                                validator: MyFunc.validatorUserEmail,
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
                                validator: MyFunc.validatorPassword,
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
                                  InkWell(
                                    onTap: () => Get.to(() => SignUp(),
                                        transition: Transition.rightToLeft,
                                        duration:
                                            const Duration(milliseconds: 500)),
                                    child: Text(
                                      'Sign Up',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
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

  Widget image() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: SizedBox(
        height: 230,
        child: Image.asset(
          'assets/login.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
