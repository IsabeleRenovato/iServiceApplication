import 'package:flutter/material.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/views/client_pages/edit_client_profile_page.dart';
import 'package:service_app/views/edit_address_page.dart';
import 'package:service_app/views/home_pages/home_page.dart';

class MyProfilePage extends StatefulWidget {
  final UserInfo userInfo;
  const MyProfilePage({required this.userInfo, super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
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
                widget.userInfo.user.name,
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
                    'MEUS DADOS',
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
                        builder: (context) =>
                            EditClientProfilePage(userInfo: widget.userInfo),
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
                          "Informações pessoais",
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
                    'CONFIGURAÇÕES',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/politica-de-privacidade.png',
                        width: 29,
                        height: 29,
                      ),
                      const SizedBox(width: 17),
                      const Expanded(
                        child: Text(
                          "Política de privacidade",
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
                  onPressed: () {
                    Navigator.push<UserInfo>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
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
