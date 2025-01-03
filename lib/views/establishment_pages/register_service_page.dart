import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:service_app/models/establishment_employee.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/service_category.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/establishment_employee_services.dart';
import 'package:service_app/services/service_category_services.dart';
import 'package:service_app/services/service_services.dart';
import 'package:service_app/utils/duration_selector_utils.dart';
import 'package:service_app/utils/text_field_utils.dart';
import 'package:service_app/views/establishment_pages/establishment_catalog_page.dart';

class RegisterServicePage extends StatefulWidget {
  final UserInfo userInfo;
  final int serviceId;

  const RegisterServicePage(
      {required this.userInfo, required this.serviceId, super.key});

  @override
  State<RegisterServicePage> createState() => _RegisterServicePageState();
}

class _RegisterServicePageState extends State<RegisterServicePage> {
  TextEditingController durationController = TextEditingController();
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
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
  List<EstablishmentEmployee?> employees = [];

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

  @override
  void initState() {
    super.initState();
    fetchData();
    durationController.addListener(atualizarEstadoCampos);
    serviceNameController.addListener(atualizarEstadoCampos);
    priceController.addListener(atualizarEstadoCampos);
    descriptionController.addListener(atualizarEstadoCampos);

    fetchServiceCategories();
    fetchServiceEmployees();
  }

  Future<void> fetchData() async {
    if (widget.serviceId > 0) {
      try {
        var service = await ServiceServices().getById(widget.serviceId);
        if (service!.serviceId > 0) {
          if (mounted) {
            setState(() {
              _image = service.serviceImage;
              imagePath = service.serviceImage;
              durationController.text = service.estimatedDuration.toString();
              serviceNameController.text = service.name;
              priceController.text = service.price.toString();
              descriptionController.text = service.description;
              doubleValue = service.price;
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

  Future fetchServiceCategories() async {
    try {
      var fetchedCategories = await ServiceCategoryServices()
          .getByUserProfileId(widget.userInfo.userProfile!.userProfileId);
      setState(() {
        serviceCategories = fetchedCategories;
      });
    } catch (e) {
      print('Erro ao buscar as categorias de serviço: $e');
    }
  }

  Future fetchServiceEmployees() async {
    try {
      var fetchedEstablishmentEmployees = await EstablishmentEmployeeServices()
          .getByServiceId(widget.serviceId);
      setState(() {
        employees = fetchedEstablishmentEmployees;
      });
    } catch (e) {
      print('Erro ao buscar as categorias de serviço: $e');
    }
  }

  void atualizarMensagemErro(String mensagem) {
    setState(() {
      mensagemErro = mensagem;
    });
  }

  void atualizarEstadoCampos() {
    setState(() {
      filledFields = serviceNameController.text.isNotEmpty &&
          priceController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty;
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
        backgroundColor: Colors.white,
        title: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 55.0),
            child: Text(
              "Adicionar um serviço",
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
                    DurationSelector(
                      onDurationSelected: (duration) {
                        setState(() {
                          selectedDuration = duration;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Utils.buildTextField(
                      controller: serviceNameController,
                      hintText: 'Nome do serviço',
                      prefixIcon: Icons.business,
                    ),
                    const SizedBox(height: 10),
                    Utils.buildTextField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        hintText: 'Preço',
                        prefixIcon: Icons.price_change_outlined,
                        onChanged: (value) {
                          setState(() {
                            String formattedValue =
                                priceController.text.replaceAll(',', '.');
                            doubleValue =
                                double.tryParse(formattedValue) ?? 999999;
                          });
                        }),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: descriptionController,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      maxLines: null,
                      maxLength: 105,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Descrição sobre o serviço',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w100,
                        ),
                        prefixIcon: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF2864ff), Color(0xFF2864ff)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: const Icon(
                            Icons.article_outlined,
                            color: Color(0xFF2864ff),
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF2864ff), width: 2.5),
                        ),
                      ),
                      onChanged: (value) {
                        if (descriptionController.text.length >= 105) {
                          descriptionController.text =
                              descriptionController.text.substring(0, 105);
                        }
                        atualizarEstadoCampos();
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<int>(
                        value: selectedCategory,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF2864ff), width: 2.5),
                          ),
                          prefixIcon: selectedCategory == null
                              ? const Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.category,
                                        color: Color(0xFF2864ff),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Selecione uma categoria',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w100,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : null,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                        items: [
                          const DropdownMenuItem<int>(
                            value: 0,
                            child: Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.category,
                                      color: Color(0xFF2864ff)),
                                  SizedBox(width: 8),
                                  Text(
                                    'Categoria do serviço',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w100,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ...serviceCategories.map<DropdownMenuItem<int>>(
                            (ServiceCategory category) {
                              return DropdownMenuItem<int>(
                                value: category.serviceCategoryId,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_outlined,
                                        color: Color(0xFF2864ff),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        category.name,
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
                            },
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value == 0) {
                            return 'Por favor, selecione uma categoria';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Selecione os',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' funcionários responsáveis: ',
                            style: TextStyle(
                              color: Color(0xFF2864ff),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...employees
                        .map((employee) => CheckboxListTile(
                              title: Text(employee!.name),
                              value: employee.isAvailable,
                              onChanged: (bool? value) {
                                setState(() {
                                  employee.isAvailable = value ?? false;
                                });
                              },
                              activeColor: Color(0xFF2864ff),
                              checkColor: Colors.white,
                            ))
                        .toList(),
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
                            var selectedEmployeesIds = employees
                                .where((employee) =>
                                    employee?.isAvailable != false)
                                .map((employee) =>
                                    employee!.establishmentEmployeeId)
                                .toList();

                            if (widget.serviceId > 0) {
                              var request = Service(
                                  serviceId: widget.serviceId,
                                  establishmentUserProfileId: widget
                                      .userInfo.userProfile!.userProfileId,
                                  serviceCategoryId: selectedCategory!,
                                  name: serviceNameController.text,
                                  description: descriptionController.text,
                                  price: doubleValue,
                                  priceNet: doubleValue.toStringAsFixed(2),
                                  estimatedDuration: selectedDuration!,
                                  serviceImage: imagePath,
                                  establishmentEmployeeIds:
                                      selectedEmployeesIds,
                                  active: true,
                                  deleted: false,
                                  creationDate: DateTime.now(),
                                  lastUpdateDate: DateTime.now());

                              await ServiceServices()
                                  .updateService(request, isEdited)
                                  .then((Service service) {
                                Navigator.pop(context, true);
                              }).catchError((e) {
                                print('Erro ao registrar servidor: $e');
                                atualizarMensagemErro(
                                    'Erro ao registrar servidor: $e');
                              });
                            } else {
                              var request = Service(
                                  serviceId: 0,
                                  establishmentUserProfileId: widget
                                      .userInfo.userProfile!.userProfileId,
                                  serviceCategoryId: selectedCategory!,
                                  name: serviceNameController.text,
                                  description: descriptionController.text,
                                  price: doubleValue,
                                  priceNet: doubleValue.toStringAsFixed(2),
                                  estimatedDuration: selectedDuration!,
                                  serviceImage: imagePath,
                                  establishmentEmployeeIds:
                                      selectedEmployeesIds,
                                  active: true,
                                  deleted: false,
                                  creationDate: DateTime.now(),
                                  lastUpdateDate: DateTime.now());
                              print(request.price);
                              await ServiceServices()
                                  .addService(request)
                                  .then((Service service) {
                                Navigator.pop(context, true);
                              }).catchError((e) {
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
