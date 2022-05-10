import 'package:fluttertoast/fluttertoast.dart';
import 'package:full_getx/services/controller/login_controller.dart';
import 'package:full_getx/services/function.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SignUp extends GetView {
  SignUp({Key? key}) : super(key: key);
  final c = Get.put(LoginController());
  final cUser = TextEditingController();
  final cPass = TextEditingController();
  final cConfirmPass = TextEditingController();
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
                      Text('Sign Up',
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
                                  label: Text('Email'),
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
                                onEditingComplete: () => onSignUp(context),
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
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: cConfirmPass,
                                style: Theme.of(context).textTheme.bodyMedium,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.done,
                                onEditingComplete: () => onSignUp(context),
                                validator: MyFunc.validatorPassword,
                                obscureText: c.showPassword.value,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  label: const Text('Confirm Password'),
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
                                    : onSignUp(context),
                                style: ElevatedButton.styleFrom(
                                  primary: c.isLoading.isTrue
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                                child: const Text('SUBMIT'),
                              ),

                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Already have an account? ',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      textScaleFactor: 1.25),
                                  InkWell(
                                    onTap: () => Get.back(),
                                    child: Text(
                                      'Sign In',
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

  Future<void> onSignUp(context) async {
    if (_keyForm.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      c.isLoading(true);
      if (cPass.text != cConfirmPass.text) {
        await 1.delay();
        Fluttertoast.showToast(msg: 'Kombinasi password tidak sesuai');
        c.isLoading(false);
      } else {
        c.signUp(cUser.text, cPass.text).whenComplete(() => c.isLoading(false));
      }
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
