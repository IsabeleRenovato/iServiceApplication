import 'package:flutter/material.dart';
import 'package:service_app/models/service_category.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/service_category_services.dart';
import 'package:service_app/utils/text_field_utils.dart';
import 'package:service_app/views/establishment_pages/service_category_page.dart';

class RegisterServiceCategoryPage extends StatefulWidget {
  final UserInfo userInfo;

  const RegisterServiceCategoryPage({required this.userInfo, super.key});

  @override
  State<RegisterServiceCategoryPage> createState() =>
      _RegisterServiceCategoryPageState();
}

class _RegisterServiceCategoryPageState
    extends State<RegisterServiceCategoryPage> {
  TextEditingController categoryController = TextEditingController();

  String mensagemErro = '';
  bool filledFields = false;

  @override
  void initState() {
    super.initState();

    categoryController.addListener(atualizarEstadoCampos);
  }

  void atualizarMensagemErro(String mensagem) {
    setState(() {
      mensagemErro = mensagem;
    });
  }

  void atualizarEstadoCampos() {
    setState(() {
      filledFields = categoryController.text.isNotEmpty;
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
        backgroundColor: Colors.white,
        title: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 55.0),
            child: Text(
              "Categoria de Serviços",
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                Utils.buildTextField(
                  controller: categoryController,
                  hintText: 'Adicione uma categoria de serviço',
                  prefixIcon: Icons.category,
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
                    var request = ServiceCategory(
                        serviceCategoryId: 0,
                        establishmentUserProfileId:
                            widget.userInfo.userProfile!.userProfileId,
                        name: categoryController.text,
                        active: true,
                        deleted: false,
                        creationDate: DateTime.now(),
                        lastUpdateDate: DateTime.now());

                    await ServiceCategoryServices()
                        .addServiceCategory(request)
                        .then((ServiceCategory serviceCategory) {
                      Navigator.pop(context, true);
                    });
                  },
                  color: filledFields ? const Color(0xFF2864ff) : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Cadastrar",
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
