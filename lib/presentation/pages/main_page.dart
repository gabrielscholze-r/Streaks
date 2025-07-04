import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:get_it/get_it.dart';
import 'package:streaks/presentation/viewmodels/home_page_viewmodel.dart';
import 'package:streaks/presentation/pages/home_page.dart';
import 'package:streaks/presentation/pages/score_page.dart';

final sl = GetIt.instance;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  
  

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(), 
    ScorePage(), 
  ];

  static const List<String> _appBarTitles = <String>[
    'Streaks',
    'Score',
  ];

  @override
  void initState() {
    super.initState();
    
    
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    
    return ChangeNotifierProvider<HomePageViewModel>(
      create: (context) {
        final viewModel = sl<HomePageViewModel>();
        
        viewModel.fetchHabits();
        return viewModel;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_appBarTitles[_selectedIndex]),
          centerTitle: true,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Streaks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.score),
              label: 'Score',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary, 
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}