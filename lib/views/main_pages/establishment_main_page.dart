import 'package:flutter/material.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/views/appointment_history_pages/appointment_history_page.dart';
import 'package:service_app/views/establishment_pages/establishment_catalog_page.dart';
import 'package:service_app/views/establishment_pages/my_establishment_page.dart';
import 'package:service_app/views/home_pages/establishment_home_page.dart';

class EstablishmentMainPage extends StatefulWidget {
  final UserInfo userInfo;

  const EstablishmentMainPage({required this.userInfo, super.key});

  @override
  State<EstablishmentMainPage> createState() => _EstablishmentMainPageState();
}

class _EstablishmentMainPageState extends State<EstablishmentMainPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = <Widget>[
    EstablishmentHomePage(userInfo: widget.userInfo),
    AppointmentHistoryPage(),
    EstablishmentCatalogPage(userInfo: widget.userInfo),
    MyEstablishmentPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          backgroundColor: Colors.white,
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Agendamentos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              label: 'Catálogo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Meu Estabelecimento',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF2864ff),
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
