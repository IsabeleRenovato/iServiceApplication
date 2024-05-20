import 'package:flutter/material.dart';
import 'package:service_app/models/address.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/models/via_cep.dart';
import 'package:service_app/services/address_services.dart';
import 'package:service_app/services/via_cep_services.dart';
import 'package:service_app/utils/text_field_utils.dart';

class EditAddressPage extends StatefulWidget {
  final UserInfo userInfo;

  EditAddressPage({required this.userInfo, super.key});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late UserInfo _userInfo;
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
    setState(() {
      _userInfo = widget.userInfo;
    });
    fetchData();
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
    if (widget.userInfo.address != null) {
      await AddressServices()
          .getById(widget.userInfo.address!.addressId)
          .then((Address? address) {
        cepController.text = address?.postalCode ?? '';
        stateController.text = address?.state ?? '';
        cityController.text = address?.city ?? '';
        hoodController.text = address?.neighborhood ?? '';
        streetController.text = address?.street ?? '';
        numController.text = address?.number ?? '';
        compController.text = address?.additionalInfo ?? '';
      }).catchError((e) {});
    }
  }

  Future<void> fetchDataCep() async {
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
        title: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 55.0),
            child: Text(
              "Endereço",
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        children: <Widget>[
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
              fetchDataCep();
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
                setState(() {
                  _userInfo.address = Address(
                      addressId: widget.userInfo.address != null
                          ? widget.userInfo.address!.addressId
                          : 0,
                      street: streetController.text,
                      number: numController.text,
                      neighborhood: hoodController.text,
                      city: cityController.text,
                      state: stateController.text,
                      country: "BR",
                      additionalInfo: compController.text,
                      postalCode: cepController.text,
                      active: true,
                      deleted: false,
                      creationDate: DateTime.now(),
                      lastUpdateDate: DateTime.now());
                });

                AddressServices().save(_userInfo).then((UserInfo userInfo) {
                  if (filledFields) {
                    setState(() {
                      _userInfo = userInfo;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Dados cadastrados com sucesso',
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
