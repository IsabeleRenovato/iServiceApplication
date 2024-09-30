import 'package:flutter/material.dart';
import 'package:service_app/services/user_info_services.dart';
import 'package:service_app/utils/token_provider.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/address.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/models/via_cep.dart';
import 'package:service_app/services/address_services.dart';
import 'package:service_app/services/via_cep_services.dart';
import 'package:service_app/utils/text_field_utils.dart';

class EditAddressPage extends StatefulWidget {
  EditAddressPage({Key? key}) : super(key: key);

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late UserInfo? _userInfo;
  late Address? _address;
  bool _isLoading = true;
  TextEditingController cepController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController hoodController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController compController = TextEditingController();
  String mensagemErro = '';
  bool filledFields = false;
  Map<String, dynamic> payload = {};

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData().then((_) {
      setState(() {
        _isLoading =
            false; // Atualiza o estado para refletir que o loading está completo
      });
    });
    fetchUserInfo();
  }

  void atualizarEstadoCampos() {
    setState(() {
      filledFields = cepController.text.isNotEmpty &&
          stateController.text.isNotEmpty &&
          cityController.text.isNotEmpty &&
          hoodController.text.isNotEmpty &&
          streetController.text.isNotEmpty &&
          numController.text.isNotEmpty;
      fetchDataCep();

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

  Future<UserInfo?> fetchUserInfo() async {
    var tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    var payload = Jwt.parseJwt(tokenProvider.token!);
    print(payload);
    print(tokenProvider.token!);

    if (payload['UserId'] != null) {
      int userId = int.tryParse(payload['UserId'].toString()) ?? 0;
      try {
        UserInfo userInfo =
            await UserInfoServices().getUserInfoByUserId(userId);
        _userInfo = userInfo;
      } catch (e) {
        print("Error fetching user info: $e");
        return null;
      }
    }
    return null;
  }

  Future<void> fetchData() async {
    var tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    payload = Jwt.parseJwt(tokenProvider.token!);
    print(payload['AddressId']);
    if (payload['AddressId'] != null) {
      int AddressId = int.tryParse(payload['AddressId'].toString()) ?? 0;
      await AddressServices().getById(AddressId).then((Address? address) {
        _address = address;
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
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cepController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white, // Define o fundo da tela como branco
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2864ff)),
        ),
      );
    }
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
                  _userInfo!.address = Address(
                      addressId: int.tryParse(payload['AddressId']) != null
                          ? int.tryParse(payload['AddressId'])!
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

                AddressServices().save(_userInfo!).then((UserInfo userInfo) {
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
