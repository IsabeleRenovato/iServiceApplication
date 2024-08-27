import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/models/user_profile.dart';
import 'package:service_app/services/auth_services.dart';
import 'package:service_app/utils/validation_utils.dart';
import 'package:service_app/views/home_pages/home_page.dart';

class RegisterClientProfilePage extends StatefulWidget {
  final UserInfo userInfo;

  const RegisterClientProfilePage({required this.userInfo, super.key});

  @override
  State<RegisterClientProfilePage> createState() =>
      _RegisterClientProfilePageState();
}

class _RegisterClientProfilePageState extends State<RegisterClientProfilePage> {
  TextEditingController cpfController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController celController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  String mensagemErro = '';
  bool filledFields = false;

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (dataEscolhida != null) {
      setState(() {
        birthController.text = DateFormat('dd/MM/yyyy').format(dataEscolhida);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    cpfController.addListener(atualizarEstadoCampos);
    birthController.addListener(atualizarEstadoCampos);
    celController.addListener(atualizarEstadoCampos);
  }

  void atualizarMensagemErro(String mensagem) {
    setState(() {
      mensagemErro = mensagem;
    });
  }

  void atualizarEstadoCampos() {
    setState(() {
      filledFields = cpfController.text.isNotEmpty &&
          birthController.text.isNotEmpty &&
          celController.text.isNotEmpty;
      if (filledFields) {
        atualizarMensagemErro('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Informações Pessoais",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: cpfController,
                  inputFormatters: [LengthLimitingTextInputFormatter(11)],
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'CPF',
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
                        Icons.badge_outlined,
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: birthController,
                  onTap: () => _selecionarData(context),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Selecione a data de nascimento',
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
                        Icons.calendar_today,
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.5),
                    ),
                  ),
                  validator: (birthController) {
                    // Usando a validação de idade da classe ValidationUtils
                    return ValidationUtils.validateAge(birthController);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  inputFormatters: [LengthLimitingTextInputFormatter(11)],
                  controller: celController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Telefone (com DDD)',
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
                        Icons.local_phone,
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.5),
                    ),
                  ),
                ),
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
                    if (filledFields) {
                      widget.userInfo.userProfile = UserProfile(
                          userProfileId: 0,
                          userId: widget.userInfo.user.userId,
                          document: cpfController.text,
                          phone: celController.text,
                          dateOfBirth: DateFormat("dd/MM/yyyy")
                              .parse(birthController.text),
                          creationDate: DateTime.now(),
                          lastUpdateDate: DateTime.now());

                      await AuthServices()
                          .registerUserProfile(widget.userInfo)
                          .then((UserInfo userInfo) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }).catchError((err) {
                        atualizarMensagemErro('${err.message}');
                      });
                    } else {
                      atualizarMensagemErro(
                          'Por favor, preencha todos os campos.');
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
                  height: 260,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
