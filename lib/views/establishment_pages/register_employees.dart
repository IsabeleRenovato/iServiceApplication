import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:service_app/utils/token_provider.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/establishment_employee.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/service_category.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/establishment_employee_services.dart';
import 'package:service_app/services/service_category_services.dart';
import 'package:service_app/services/service_services.dart';
import 'package:service_app/utils/text_field_utils.dart';
import 'package:service_app/utils/validation_utils.dart';
import 'package:service_app/views/establishment_pages/establishment_catalog_page.dart';

class RegisterEmployeesPage extends StatefulWidget {
  final int establishmentEmployeeId;

  const RegisterEmployeesPage(
      {required this.establishmentEmployeeId, super.key});

  @override
  State<RegisterEmployeesPage> createState() => _RegisterEmployeesPageState();
}

class _RegisterEmployeesPageState extends State<RegisterEmployeesPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  late double doubleValue;
  int? selectedCategory;
  String mensagemErro = '';
  bool filledFields = false;
  dynamic _image;
  String? imagePath;
  late String? bytes;
  int? selectedDuration;
  List<int> durationsInMinutes = List.generate(20, (index) => (index + 1) * 15);
  ServiceServices serviceServices = ServiceServices();
  List<ServiceCategory> serviceCategories = [];
  bool isEdited = false;
  DateTime? selectedDate = DateTime.now();
  Map<String, dynamic> payload = {};
  int userProfileId = 0;

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

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        isEdited = true;
        imagePath = pickedImage.path;
        _image = File(pickedImage.path);
      });

      List<int> imageBytes = await pickedImage.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      setState(() {
        bytes = base64Image;
      });
    }
  }

  Future<void> fetchData() async {
    if (widget.establishmentEmployeeId > 0) {
      try {
        var employee = await EstablishmentEmployeeServices()
            .getById(widget.establishmentEmployeeId);
        if (employee!.establishmentEmployeeId > 0) {
          if (mounted) {
            setState(() {
              _image = employee.employeeImage;
              imagePath = employee.employeeImage;
              nameController.text = employee.name.toString();
              cpfController.text = employee.document;
              birthController.text =
                  DateFormat('dd/MM/yyyy').format(employee.dateOfBirth!);
            });
          }
        }
      } catch (e) {
        debugPrint('Erro ao buscar Special Schedules: $e');
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  Future<void> fetchDataToken() async {
    var tokenProvider = Provider.of<TokenProvider>(context, listen: true);
    payload = Jwt.parseJwt(tokenProvider.token!);
    print(payload);
    print(tokenProvider.token!);
    if (payload['UserId'] != null) {
      userProfileId = int.tryParse(payload['UserProfileId']) ?? 0;
    }
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    // Mova a lógica para o didChangeDependencies.
    fetchDataToken();
  }

  @override
  void initState() {
    super.initState();

    fetchData();

    nameController.addListener(atualizarEstadoCampos);
    cpfController.addListener(atualizarEstadoCampos);
    birthController.addListener(atualizarEstadoCampos);
  }

  void atualizarMensagemErro(String mensagem) {
    setState(() {
      mensagemErro = mensagem;
    });
  }

  void atualizarEstadoCampos() {
    setState(() {
      filledFields = nameController.text.isNotEmpty &&
          cpfController.text.isNotEmpty &&
          birthController.text.isNotEmpty;
      if (filledFields) {
        atualizarMensagemErro('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F6F9),
        title: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 55.0),
            child: Text(
              "Funcionários",
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.center,
                    ),
                    const SizedBox(height: 10),
                    _image != null
                        ? _image is File
                            ? Image.file(
                                _image,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                _image,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  // Retornar um widget para exibir em caso de erro
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[200],
                                    ),
                                    width: 200,
                                    height: 200,
                                    child: const Icon(Icons.image),
                                  );
                                },
                              )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[200],
                            ),
                            width: 200,
                            height: 200,
                            child: const Icon(Icons.image),
                          ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2864ff),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () =>
                                        _getImage(ImageSource.gallery),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2864ff),
                                    ),
                                    child: const Text(
                                      'Escolher imagem da galeria',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () =>
                                        _getImage(ImageSource.camera),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2864ff),
                                    ),
                                    child: const Text(
                                      'Tirar Foto',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Editar',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    Utils.buildTextField(
                      controller: nameController,
                      hintText: 'Nome do funcionário',
                      prefixIcon: Icons.business,
                    ),
                    const SizedBox(height: 10),
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
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.5),
                        ),
                      ),
                      validator: (birthController) {
                        // Usando a validação de idade da classe ValidationUtils
                        return ValidationUtils.validateAge(birthController);
                      },
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
                        if (!filledFields) {
                          atualizarMensagemErro(
                              'Por favor, preencha todos os campos.');
                        } else {
                          try {
                            if (widget.establishmentEmployeeId > 0) {
                              var request = EstablishmentEmployee(
                                establishmentEmployeeId: 0,
                                name: nameController.text,
                                document: cpfController.text,
                                dateOfBirth: DateFormat("dd/MM/yyyy")
                                    .parse(birthController.text),
                                employeeImage: imagePath,
                                active: true,
                                deleted: false,
                                establishmentUserProfileId: userProfileId,
                              );

                              await EstablishmentEmployeeServices()
                                  .updateEstablishmentEmployee(
                                      request, isEdited)
                                  .then((EstablishmentEmployee
                                      establishmentEmployee) {})
                                  .catchError((e) {
                                print('Erro ao registrar servidor: $e');
                                atualizarMensagemErro(
                                    'Erro ao registrar servidor: $e');
                              });
                            } else {
                              var request = EstablishmentEmployee(
                                establishmentEmployeeId: 0,
                                name: nameController.text,
                                document: cpfController.text,
                                dateOfBirth: DateFormat("dd/MM/yyyy")
                                    .parse(birthController.text),
                                employeeImage: imagePath,
                                active: true,
                                deleted: false,
                                establishmentUserProfileId: userProfileId,
                              );

                              await EstablishmentEmployeeServices()
                                  .addEstablishmentEmployee(request)
                                  .then((EstablishmentEmployee
                                      establishmentEmployee) {})
                                  .catchError((e) {
                                print('Erro ao registrar servidor: $e');
                                atualizarMensagemErro(
                                    'Erro ao registrar servidor: $e');
                              });
                            }
                          } catch (error) {
                            atualizarMensagemErro(
                                'Erro ao registrar servidor: $error');
                          }
                        }
                      },
                      color:
                          filledFields ? const Color(0xFF2864ff) : Colors.grey,
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
          ],
        ),
      ),
    );
  }
}
