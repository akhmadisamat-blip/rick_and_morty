import 'package:flutter/material.dart';
import 'package:ygroup/ui/screen/character_list/charapter_list.screen.dart';
import 'package:ygroup/ui/screen/episode_list/episode_list.screen.dart';
import 'package:ygroup/ui/screen/location_list/location_list.screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  static const Color _backgroundColor = Color(0xFF24282F);
  static const Color _accentColor = Color(0xFF97CE4C);
  static const Color _cardColor = Color(0xFF3C3E44);

  final List<Widget> _screens = [
    const CharacterListScreen(),
    const LocationListScreen(),
    const EpisodeListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: _accentColor, width: 1)),
        ),
        child: BottomNavigationBar(
          backgroundColor: _cardColor,
          selectedItemColor: _accentColor,
          unselectedItemColor: Colors.white54,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Characters',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.public),
              label: 'Locations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tv),
              label: 'Episodes',
            ),
          ],
        ),
      ),
    );
  }
}
