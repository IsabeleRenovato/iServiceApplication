import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_app/Services/auth_services.dart';
import 'package:service_app/models/establishment_category.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/models/user_profile.dart';
import 'package:service_app/services/establishment_category_services.dart';
import 'package:service_app/utils/text_field_utils.dart';
import 'package:service_app/views/auth_pages/register_address_page.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterEstablishmentProfilePage extends StatefulWidget {
  final UserInfo userInfo;

  const RegisterEstablishmentProfilePage({required this.userInfo, super.key});

  @override
  State<RegisterEstablishmentProfilePage> createState() =>
      _RegisterEstablishmentProfilePageState();
}

class _RegisterEstablishmentProfilePageState
    extends State<RegisterEstablishmentProfilePage> {
  TextEditingController cnpjController = TextEditingController();
  TextEditingController establishmntNameController = TextEditingController();
  TextEditingController commercialContactController = TextEditingController();
  TextEditingController commercialEmailController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<EstablishmentCategory> establishmentCategories = [];
  int? selectedCategoryId;
  String mensagemErro = '';
  bool filledFields = false;
  final maskFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();

    cnpjController.addListener(atualizarEstadoCampos);
    establishmntNameController.addListener(atualizarEstadoCampos);
    commercialContactController.addListener(atualizarEstadoCampos);
    commercialEmailController.addListener(atualizarEstadoCampos);
    categoryController.addListener(atualizarEstadoCampos);
    descriptionController.addListener(atualizarEstadoCampos);
    fetchEstablishmentCategories();
  }

  void atualizarMensagemErro(String mensagem) {
    setState(() {
      mensagemErro = mensagem;
    });
  }

  void atualizarEstadoCampos() {
    setState(() {
      filledFields = cnpjController.text.isNotEmpty &&
          establishmntNameController.text.isNotEmpty &&
          commercialContactController.text.isNotEmpty &&
          commercialEmailController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty;
      if (filledFields) {
        atualizarMensagemErro('');
      }
    });
  }

  Future fetchEstablishmentCategories() async {
    try {
      var fetchedCategories = await EstablishmentCategoryServices().get();
      setState(() {
        establishmentCategories = fetchedCategories;
      });
    } catch (e) {
      print('Erro ao buscar as categorias de serviço: $e');
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Informações Adicionais",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Utils.buildTextField(
                  controller: cnpjController,
                  inputFormatters: [maskFormatter],
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
                  inputFormatters: [LengthLimitingTextInputFormatter(11)],
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
                  child: DropdownButton<int>(
                    value: selectedCategoryId,
                    onChanged: (newValue) {
                      setState(() {
                        selectedCategoryId = newValue;
                      });
                    },
                    items: establishmentCategories.map<DropdownMenuItem<int>>(
                        (EstablishmentCategory category) {
                      return DropdownMenuItem<int>(
                        value: category.establishmentCategoryId,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.category, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(category.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
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
                      widget.userInfo.userProfile = UserProfile(
                          userProfileId: 0,
                          userId: widget.userInfo.user.userId,
                          establishmentCategoryId: selectedCategoryId,
                          document: cnpjController.text
                              .replaceAll(".", "")
                              .replaceAll("-", "")
                              .replaceAll("/", ""),
                          commercialName: establishmntNameController.text,
                          commercialEmail: commercialEmailController.text,
                          commercialPhone: commercialContactController.text,
                          description: descriptionController.text,
                          creationDate: DateTime.now(),
                          lastUpdateDate: DateTime.now());

                      await AuthServices()
                          .registerUserProfile(widget.userInfo)
                          .then((UserInfo userInfo) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RegisterAddressPage(userInfo: userInfo),
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
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
