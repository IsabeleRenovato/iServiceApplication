import 'package:flutter/material.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/models/user_profile.dart';
import 'package:service_app/services/user_profile_services.dart';
import 'package:service_app/utils/text_field_utils.dart';

class EditEstablishmentProfilePage extends StatefulWidget {
  final UserInfo userInfo;

  const EditEstablishmentProfilePage({required this.userInfo, super.key});

  @override
  State<EditEstablishmentProfilePage> createState() =>
      _EditEstablishmentProfilePageState();
}

class _EditEstablishmentProfilePageState
    extends State<EditEstablishmentProfilePage> {
  late UserInfo _userInfo;
  bool _isLoading = true;
  TextEditingController commercialNameController = TextEditingController();
  TextEditingController cnpjController = TextEditingController();
  TextEditingController establishmntNameController = TextEditingController();
  TextEditingController commercialContactController = TextEditingController();
  TextEditingController commercialEmailController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<String> opcoes = [
    'Escolha uma opção',
    'Opção 1',
    'Opção 2',
    'Opção 3',
    'Opção 4'
  ];
  String? selectedValue;
  String mensagemErro = '';
  bool filledFields = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _userInfo = widget.userInfo;
    });
    fetchData().then((_) {
      setState(() {
        _isLoading =
            false; // Atualiza o estado para refletir que o loading está completo
      });
    });
    commercialNameController.addListener(atualizarEstadoCampos);
    cnpjController.addListener(atualizarEstadoCampos);
    establishmntNameController.addListener(atualizarEstadoCampos);
    commercialContactController.addListener(atualizarEstadoCampos);
    commercialEmailController.addListener(atualizarEstadoCampos);
    categoryController.addListener(atualizarEstadoCampos);
    descriptionController.addListener(atualizarEstadoCampos);
    selectedValue = opcoes[0];
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
        commercialNameController.text = userInfo!.user.name;
        cnpjController.text = userInfo.userProfile!.document;
        establishmntNameController.text = userInfo.userProfile!.commercialName!;
        commercialContactController.text =
            userInfo.userProfile!.commercialPhone!;
        commercialEmailController.text = userInfo.userProfile!.commercialEmail!;
        /*categoryController.text = userInfo.establishmentProfile!. ?? '';*/
        descriptionController.text = userInfo.userProfile!.description!;
      }).catchError((e) {});
    }
  }

  void atualizarEstadoCampos() {
    setState(() {
      filledFields = commercialNameController.text.isNotEmpty &&
          cnpjController.text.isNotEmpty &&
          establishmntNameController.text.isNotEmpty &&
          commercialContactController.text.isNotEmpty &&
          commercialEmailController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty;
      if (filledFields) {
        atualizarMensagemErro('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 55.0),
            child: Text(
              "Perfil",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
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
          height: 500,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Column(
              children: <Widget>[
                const Expanded(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Utils.buildTextField(
                  controller: commercialNameController,
                  hintText: 'Nome',
                  prefixIcon: Icons.account_circle_rounded,
                ),
                const SizedBox(
                  height: 10,
                ),
                Utils.buildTextField(
                  controller: cnpjController,
                  hintText: 'CNPJ',
                  prefixIcon: Icons.document_scanner_outlined,
                ),
                const SizedBox(
                  height: 10,
                ),
                Utils.buildTextField(
                  controller: establishmntNameController,
                  hintText: 'Nome do seu estabelecimento',
                  prefixIcon: Icons.business,
                ),
                const SizedBox(
                  height: 10,
                ),
                Utils.buildTextField(
                  controller: commercialContactController,
                  hintText: 'Contato comercial',
                  prefixIcon: Icons.local_phone,
                ),
                const SizedBox(
                  height: 10,
                ),
                Utils.buildTextField(
                  controller: commercialEmailController,
                  hintText: 'E-mail comercial',
                  prefixIcon: Icons.email_sharp,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: descriptionController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  maxLines: null,
                  maxLength: 500,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Apresente seu negocio',
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
                        Icons.article_outlined,
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
                  onChanged: (value) {
                    if (descriptionController.text.length > 105) {
                      descriptionController.text =
                          descriptionController.text.substring(0, 105);
                    }
                    atualizarEstadoCampos();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    value: selectedValue,
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue;
                        mensagemErro = '';
                      });
                    },
                    items:
                        opcoes.map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.category,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                value ?? '',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    underline: Container(
                      height: 1.5,
                      decoration: const UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  mensagemErro,
                  style: const TextStyle(color: Colors.red),
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () async {
                    if (filledFields) {
                      _userInfo.user.name = commercialNameController.text;
                      _userInfo.userProfile = UserProfile(
                          userProfileId:
                              widget.userInfo.userProfile!.userProfileId,
                          userId: widget.userInfo.userProfile!.userId,
                          document: cnpjController.text,
                          establishmentCategoryId: 1,
                          addressId: widget.userInfo.address!.addressId,
                          commercialName: establishmntNameController.text,
                          commercialEmail: commercialEmailController.text,
                          commercialPhone: commercialContactController.text,
                          description: descriptionController.text,
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
                    "Atualizar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
