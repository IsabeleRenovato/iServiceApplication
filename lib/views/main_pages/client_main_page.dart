import 'package:flutter/material.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/views/appointment_history_pages/appointment_history_page.dart';
import 'package:service_app/views/appointment_pages/search_page.dart';
import 'package:service_app/views/client_pages/my_profile_page.dart';
import 'package:service_app/views/home_pages/client_home_page.dart';

class ClientMainPage extends StatefulWidget {
  final UserInfo userInfo;

  const ClientMainPage({required this.userInfo, super.key});

  @override
  State<ClientMainPage> createState() => _ClientMainPage();
}

class _ClientMainPage extends State<ClientMainPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = <Widget>[
    ClientHomePage(),
    SearchPage(userInfo: widget.userInfo),
    AppointmentHistoryPage(),
    MyProfilePage(userInfo: widget.userInfo)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black26,
              width: 0.3,
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Busca',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Agendamentos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Perfil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF2864ff),
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
