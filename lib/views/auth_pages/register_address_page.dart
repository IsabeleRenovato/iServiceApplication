import 'package:flutter/material.dart';
import 'package:service_app/Services/auth_services.dart';
import 'package:service_app/models/address.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/models/via_cep.dart';
import 'package:service_app/services/via_cep_services.dart';
import 'package:service_app/utils/text_field_utils.dart';
import 'package:service_app/views/home_pages/home_page.dart';

class RegisterAddressPage extends StatefulWidget {
  final UserInfo userInfo;

  const RegisterAddressPage({required this.userInfo, super.key});

  @override
  State<RegisterAddressPage> createState() => _RegisterAddressPageState();
}

class _RegisterAddressPageState extends State<RegisterAddressPage> {
  TextEditingController cepController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController hoodController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController compController = TextEditingController();
  String mensagemErro = '';
  bool filledFields = false;

  @override
  void initState() {
    super.initState();
    cepController.addListener(atualizarEstadoCampos);
    stateController.addListener(atualizarEstadoCampos);
    cityController.addListener(atualizarEstadoCampos);
    hoodController.addListener(atualizarEstadoCampos);
    streetController.addListener(atualizarEstadoCampos);
    numController.addListener(atualizarEstadoCampos);
    compController.addListener(atualizarEstadoCampos);
  }

  void atualizarEstadoCampos() {
    setState(() {
      filledFields = cepController.text.isNotEmpty &&
          stateController.text.isNotEmpty &&
          cityController.text.isNotEmpty &&
          hoodController.text.isNotEmpty &&
          streetController.text.isNotEmpty &&
          numController.text.isNotEmpty;
      fetchData();

      if (filledFields) {
        atualizarMensagemErro('');
      }
    });
  }

  void atualizarMensagemErro(String mensagem) {
    setState(() {
      mensagemErro = mensagem;
    });
  }

  Future<void> fetchData() async {
    ViaCepServices().getAddress(cepController.text).then((ViaCep viaCep) {
      stateController.text = viaCep.uf ?? '';
      cityController.text = viaCep.localidade ?? '';
      hoodController.text = viaCep.bairro ?? '';
      streetController.text = viaCep.logradouro ?? '';
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        children: <Widget>[
          const SizedBox(height: 20),
          const Text(
            "Endereço",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: cepController,
            style: const TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Cep',
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
                  Icons.share_location_sharp,
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
            onEditingComplete: () {
              fetchData();
            },
          ),
          Utils.buildTextField(
            controller: stateController,
            hintText: 'Estado',
            prefixIcon: Icons.location_city,
          ),
          Utils.buildTextField(
            controller: cityController,
            hintText: 'Cidade',
            prefixIcon: Icons.location_city_outlined,
          ),
          Utils.buildTextField(
            controller: hoodController,
            hintText: 'Bairro',
            prefixIcon: Icons.location_on,
          ),
          Utils.buildTextField(
            controller: streetController,
            hintText: 'Rua',
            prefixIcon: Icons.streetview,
          ),
          Utils.buildTextField(
            controller: numController,
            hintText: 'Número',
            prefixIcon: Icons.confirmation_number,
          ),
          Utils.buildTextField(
            controller: compController,
            hintText: 'Complemento',
            prefixIcon: Icons.article,
          ),
          const SizedBox(height: 40),
          Text(
            mensagemErro,
            style: const TextStyle(color: Colors.red),
          ),
          SizedBox(
            height: 60,
            child: MaterialButton(
              onPressed: () async {
                widget.userInfo.address = Address(
                    addressId: 0,
                    street: streetController.text,
                    number: numController.text,
                    neighborhood: hoodController.text,
                    additionalInfo: compController.text,
                    city: cityController.text,
                    state: stateController.text,
                    country: "BR",
                    postalCode: cepController.text,
                    active: true,
                    deleted: false,
                    creationDate: DateTime.now(),
                    lastUpdateDate: DateTime.now());

                await AuthServices()
                    .registerAddress(widget.userInfo)
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
          ),
          const SizedBox(height: 260),
        ],
      ),
    );
  }
}
