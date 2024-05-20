import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/models/user_profile.dart';
import 'package:service_app/services/user_profile_services.dart';
import 'package:service_app/utils/text_field_utils.dart';

class EditClientProfilePage extends StatefulWidget {
  final UserInfo userInfo;

  const EditClientProfilePage({required this.userInfo, super.key});

  @override
  State<EditClientProfilePage> createState() => _EditClientProfilePageState();
}

class _EditClientProfilePageState extends State<EditClientProfilePage> {
  late UserInfo _userInfo;
  TextEditingController nameController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController celController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  String mensagemErro = '';
  bool filledFields = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _userInfo = widget.userInfo;
    });
    fetchData();
    cpfController.addListener(atualizarEstadoCampos);
    birthController.addListener(atualizarEstadoCampos);
    celController.addListener(atualizarEstadoCampos);
  }

  void atualizarMensagemErro(String mensagem) {
    setState(() {
      mensagemErro = mensagem;
    });
  }

  Future<void> fetchData() async {
    if (widget.userInfo.userProfile != null) {
      await UserProfileServices()
          .getById(widget.userInfo.user.userId)
          .then((UserInfo? userInfo) {
        nameController.text = userInfo!.user.name;
        cpfController.text = userInfo.userProfile!.document;
        birthController.text =
            DateFormat('dd/MM/yyyy').format(userInfo.userProfile!.dateOfBirth!);
        celController.text = userInfo.userProfile!.phone!;
      }).catchError((e) {});
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, _userInfo);
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
                Utils.buildTextField(
                  controller: nameController,
                  hintText: 'Nome',
                  prefixIcon: Icons.account_circle_rounded,
                ),
                TextFormField(
                  controller: cpfController,
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
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
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
                      _userInfo.user.name = nameController.text;
                      _userInfo.userProfile = UserProfile(
                          userProfileId:
                              widget.userInfo.userProfile!.userProfileId,
                          userId: widget.userInfo.userProfile!.userId,
                          document: cpfController.text,
                          dateOfBirth: DateFormat("dd/MM/yyyy")
                              .parse(birthController.text),
                          phone: celController.text,
                          creationDate: DateTime.now(),
                          lastUpdateDate: DateTime.now());

                      UserProfileServices()
                          .save(_userInfo)
                          .then((UserInfo userInfo) {
                        if (filledFields) {
                          setState(() {
                            _userInfo = userInfo;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Dados editados com sucesso',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          print('404 not found');
                        }
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
