import 'package:flutter/material.dart';
import 'package:service_app/Services/auth_services.dart';
import 'package:service_app/models/auth/pre_register.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/utils/text_field_utils.dart';
import 'package:service_app/utils/validation_utils.dart';
import 'package:service_app/views/auth_pages/register_client_profile_page.dart';
import 'package:service_app/views/auth_pages/register_establishment_profile_page.dart';

class RegisterUserPage extends StatefulWidget {
  final int userRoleId;

  const RegisterUserPage({required this.userRoleId, super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String mensagemErro = '';
  bool filledFields = false;
  bool visiblePassword = false;
  bool visibleCPassword = false;

  @override
  void initState() {
    super.initState();

    nameController.addListener(atualizarEstadoCampos);
    emailController.addListener(atualizarEstadoCampos);
    passwordController.addListener(atualizarEstadoCampos);
    confirmPasswordController.addListener(atualizarEstadoCampos);
  }

  void atualizarEstadoCampos() {
    setState(() {
      filledFields = nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty;

      if (filledFields) {
        atualizarMensagemErro('');
      }
    });
  }

  List<ValidationResult> passwordValidations = [];

  void atualizarValidacoesSenha(String senha) {
    setState(() {
      passwordValidations = ValidationUtils.validatePassword(senha);
    });
  }

  void atualizarMensagemErro(String mensagem) {
    setState(() {
      mensagemErro = mensagem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Crie sua conta",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Utils.buildTextField(
                controller: nameController,
                hintText: 'Nome',
                prefixIcon: Icons.account_circle_rounded,
              ),
              const SizedBox(
                height: 20,
              ),
              Utils.buildTextField(
                controller: emailController,
                hintText: 'E-mail',
                prefixIcon: Icons.email_sharp,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: passwordController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                obscureText: !visiblePassword,
                onChanged: (senha) {
                  atualizarValidacoesSenha(senha);
                },
                decoration: InputDecoration(
                  hintText: 'Senha',
                  hintStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w100,
                  ),
                  prefixIcon: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.blue, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.lock_open_sharp,
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.5),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      visiblePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        visiblePassword = !visiblePassword;
                      });
                    },
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: passwordValidations.map((validation) {
                  return Text(
                    '${validation.message}: ${validation.isValid ? 'OK' : 'Falta'}',
                    style: TextStyle(
                      color: validation.isValid ? Colors.green : Colors.red,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: confirmPasswordController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                obscureText: !visibleCPassword,
                onChanged: (password) {
                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    atualizarMensagemErro('As senhas não são iguais.');
                  } else {
                    atualizarMensagemErro('');
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Confirme a senha',
                  hintStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w100,
                  ),
                  prefixIcon: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.blue, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.lock_outline_sharp,
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.5),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      visibleCPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        visibleCPassword = !visibleCPassword;
                      });
                    },
                  ),
                ),
              ),

              // Botão de avançar
              SizedBox(
                height: 40,
                child: Text(
                  mensagemErro,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () async {
                  if (!filledFields) {
                    atualizarMensagemErro(
                        'Por favor, preencha todos os campos.');
                  } else if (passwordController.text !=
                      confirmPasswordController.text) {
                    atualizarMensagemErro('As senhas não são iguais.');
                  } else if (!ValidationUtils.isValidEmail(
                      emailController.text)) {
                    setState(() {
                      mensagemErro = 'Por favor, insira um e-mail válido.';
                    });
                  } else {
                    try {
                      var request = PreRegister(
                          userRoleId: widget.userRoleId,
                          email: emailController.text,
                          name: nameController.text,
                          password: passwordController.text);

                      await AuthServices()
                          .preRegister(request)
                          .then((UserInfo userInfo) {
                        if (userInfo.userRole.userRoleId == 2) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterEstablishmentProfilePage(
                                          userInfo: userInfo)));
                        } else if (userInfo.userRole.userRoleId == 3) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterClientProfilePage(
                                          userInfo: userInfo)));
                        }
                      }).catchError((err) {
                        atualizarMensagemErro('${err.message}');
                      });
                    } catch (err) {
                      atualizarMensagemErro('Erro ao registrar usuário: $err');
                    }
                  }
                },
                color: filledFields ? const Color(0xFF2864ff) : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  "Avançar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 250,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
