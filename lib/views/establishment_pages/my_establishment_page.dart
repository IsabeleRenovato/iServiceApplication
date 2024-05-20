import 'package:flutter/material.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/views/appointment_history_pages/review_list_page.dart';
import 'package:service_app/views/edit_address_page.dart';
import 'package:service_app/views/establishment_pages/edit_establishment_profile_page.dart';
import 'package:service_app/views/establishment_pages/register_schedule_page.dart';
import 'package:service_app/views/establishment_pages/service_category_page.dart';
import 'package:service_app/views/establishment_pages/special_schedule_page.dart';

class MyEstablishmentPage extends StatefulWidget {
  final UserInfo userInfo;

  const MyEstablishmentPage({required this.userInfo, super.key});

  @override
  State<MyEstablishmentPage> createState() => _MyEstablishmentPageState();
}

class _MyEstablishmentPageState extends State<MyEstablishmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 55.0),
            child: Text(
              "Meu Estabelecimento",
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
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/foto_perfil.png'),
                        radius: 57.5,
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
                            onPressed: () {},
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
                widget.userInfo.userProfile!.commercialName!,
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
                            RegisterSchedulePage(userInfo: widget.userInfo),
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
                          "Horários",
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
                              SpecialSchedulePage(userInfo: widget.userInfo)),
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
                            ServiceCategoryPage(userInfo: widget.userInfo),
                      ),
                    );
                    if (updatedUserInfo != null) {
                      setState(() {
                        widget.userInfo.address = updatedUserInfo.address;
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
                        builder: (context) =>
                            EditAddressPage(userInfo: widget.userInfo),
                      ),
                    );
                    if (updatedUserInfo != null) {
                      setState(() {
                        widget.userInfo.address = updatedUserInfo.address;
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
                          userId: widget.userInfo.userProfile!.userId,
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
                        builder: (context) => EditEstablishmentProfilePage(
                            userInfo: widget.userInfo),
                      ),
                    );
                    if (updatedUserInfo != null) {
                      setState(() {
                        widget.userInfo.userProfile =
                            updatedUserInfo.userProfile;
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
            ],
          ),
        ),
      ),
    );
  }
}
