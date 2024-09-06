import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/establishment_category.dart';
import 'package:service_app/models/user_profile.dart';
import 'package:service_app/services/user_info_services.dart';
import 'package:service_app/services/user_profile_services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:service_app/utils/token_provider.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/services/auth_services.dart';
import 'package:service_app/views/appointment_history_pages/review_list_page.dart';
import 'package:service_app/views/edit_address_page.dart';
import 'package:service_app/utils/token_provider.dart';
import 'package:service_app/views/establishment_pages/edit_establishment_profile_page.dart';
import 'package:service_app/views/establishment_pages/employees_list.dart';
import 'package:service_app/views/establishment_pages/register_employees.dart';
import 'package:service_app/views/establishment_pages/register_schedule_page.dart';
import 'package:service_app/views/establishment_pages/service_category_page.dart';
import 'package:service_app/views/establishment_pages/special_schedule_page.dart';

class MyEstablishmentPage extends StatefulWidget {
  const MyEstablishmentPage({super.key});

  @override
  State<MyEstablishmentPage> createState() => _MyEstablishmentPageState();
}

class _MyEstablishmentPageState extends State<MyEstablishmentPage> {
  late UserInfo _userInfo;
  Map<String, dynamic> initialData = {};
  TextEditingController commercialNameController = TextEditingController();
  TextEditingController cnpjController = TextEditingController();
  TextEditingController establishmntNameController = TextEditingController();
  TextEditingController commercialContactController = TextEditingController();
  TextEditingController commercialEmailController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<EstablishmentCategory> establishmentCategories = [];
  int? selectedCategoryId;
  final AuthServices _authService = AuthServices();
  dynamic _image;
  String? imagePath;
  late String? bytes;
  bool isEdited = false;
  Map<String, dynamic> payload = {};
  bool _isLoading = true;
  bool _isImageLoading = false;

  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData().then((_) {
      setState(() {
        _isLoading =
            false; // Atualiza o estado para refletir que o loading está completo
      });
    });
  }

  Future<void> fetchData() async {
    var tokenProvider = Provider.of<TokenProvider>(context, listen: true);
    payload = Jwt.parseJwt(tokenProvider.token!);
    print(payload);
    print(tokenProvider.token!);
    if (payload['UserId'] != null) {
      int userId = int.tryParse(payload['UserId'].toString()) ?? 0;
      await UserInfoServices()
          .getUserInfoByUserId(userId)
          .then((UserInfo userInfo) {
        _userInfo = userInfo;
        commercialNameController.text = userInfo.user.name;
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

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _isImageLoading = true;
        isEdited = true;
        imagePath = pickedImage.path;
        _image = File(pickedImage.path);
      });

      List<int> imageBytes = await pickedImage.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      setState(() {
        bytes = base64Image;
      });

      imageCache.clear();
      imageCache.clearLiveImages();

      if (!_isLoading) {
        await fatchDataImage();
      } else {
        // Adicionar um mecanismo para tentar salvar o perfil quando _userInfo estiver pronto
        print('Erro: _userInfo não está pronto para salvar.');
      }

      setState(() {
        _isImageLoading = false; // Termina o carregamento da imagem
      });
    }
  }

  Future<void> fatchDataImage() async {
    await UserProfileServices()
        .UpdateProfileImage(_userInfo.userProfile!.userProfileId, imagePath)
        .then((String Path) {
      setState(() {
        _userInfo.userProfile!.profileImage = Path;
        print(_userInfo.userProfile!.profileImage);
      });
      imageCache.clear();
      imageCache.clearLiveImages();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Imagem de perfil alterada com sucesso',
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
    }).catchError((e) {
      print('Erro ao salvar perfil: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erro ao salvar perfil',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    });
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
    final tokenProvider = Provider.of<TokenProvider>(context);
    if (tokenProvider.token == null) {
      return CircularProgressIndicator(); // ou qualquer outro widget de carregamento
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Meu estabelecimento",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 115,
                  width: 115,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        backgroundImage: _isImageLoading
                            ? AssetImage(
                                'assets/fundo cinza claro.png') // Imagem padrão durante o carregamento
                            : _userInfo.userProfile?.profileImage != null
                                ? NetworkImage(
                                    _userInfo.userProfile!.profileImage!)
                                : AssetImage('assets/foto_perfil.png')
                                    as ImageProvider,
                        radius: 57.5,
                      ),
                      if (_isImageLoading) // Exibe o indicador de carregamento
                        Positioned.fill(
                          child: Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF2864ff)),
                          ),
                        ),
                      Positioned(
                        right: -12,
                        bottom: 0,
                        child: SizedBox(
                          height: 46,
                          width: 46,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFF5F6F9),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _getImage(ImageSource.gallery);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF2864ff),
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
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _getImage(ImageSource.camera);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF2864ff),
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
                            child: const Icon(Icons.camera_alt_outlined,
                                color: Color(0xFF27a4f2)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _userInfo.userProfile!.commercialName!,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'DADOS DA LOJA',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.push<UserInfo>(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RegisterSchedulePage(userInfo: _userInfo),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/horarios.png',
                        width: 27,
                        height: 27,
                      ),
                      const SizedBox(width: 17),
                      const Expanded(
                        child: Text(
                          "Horário de Funcionamento",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SpecialSchedulePage(userInfo: _userInfo)),
                    );
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/horarios.png',
                        width: 27,
                        height: 27,
                      ),
                      const SizedBox(width: 17),
                      const Expanded(
                        child: Text(
                          "Horários em Dia Especial",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () async {
                    // Mudança aqui para capturar o resultado
                    final updatedUserInfo = await Navigator.push<UserInfo>(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ServiceCategoryPage(userInfo: _userInfo),
                      ),
                    );
                    if (updatedUserInfo != null) {
                      setState(() {
                        _userInfo.address = updatedUserInfo.address;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/categoria.png',
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(width: 18),
                      const Expanded(
                        child: Text(
                          "Categorias de Serviços",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () async {
                    // Mudança aqui para capturar o resultado
                    final updatedUserInfo = await Navigator.push<UserInfo>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditAddressPage(),
                      ),
                    );
                    if (updatedUserInfo != null) {
                      setState(() {
                        _userInfo.address = updatedUserInfo.address;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/localizacao.png',
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(width: 18),
                      const Expanded(
                        child: Text(
                          "Endereço",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () async {
                    // Mudança aqui para capturar o resultado
                    final updatedUserInfo = await Navigator.push<UserInfo>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeesListPage(),
                      ),
                    );
                    if (updatedUserInfo != null) {
                      setState(() {
                        _userInfo.userProfile = updatedUserInfo.userProfile;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/usuario.png',
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(width: 18),
                      const Expanded(
                        child: Text(
                          "Funcionários",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'DESEMPENHO',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push<UserInfo>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewListPage(
                          userId: _userInfo.userProfile!.userId,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/notificacao.png',
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(width: 18),
                      const Expanded(
                        child: Text(
                          "Feedbacks",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'CONFIGURAÇÕES',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () async {
                    // Mudança aqui para capturar o resultado
                    final updatedUserInfo = await Navigator.push<UserInfo>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEstablishmentProfilePage(),
                      ),
                    );
                    if (updatedUserInfo != null) {
                      setState(() {
                        _userInfo.userProfile = updatedUserInfo.userProfile;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/usuario.png',
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(width: 18),
                      const Expanded(
                        child: Text(
                          "Perfil",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () async {
                    _authService.logout(context);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/sair.png',
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(width: 18),
                      const Expanded(
                        child: Text(
                          "Sair",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
