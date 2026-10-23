import 'package:flutter/material.dart';
import 'package:workify_prototype/screens/add_screen.dart';
import 'package:workify_prototype/screens/favorite_screen.dart';
import 'package:workify_prototype/screens/home_screen.dart';
import 'package:workify_prototype/screens/profile_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int index=0;
  @override
  Widget build(BuildContext context) {
    Map<String,dynamic>barItems={
      'Home':Icons.home,
      'Add':Icons.add,
      'Favorite':Icons.favorite,
      'Profile':Icons.person
    };
    List<Widget>screens=[
      HomeScreen(),
      AddScreen(),
      FavoriteScreen(),
      ProfileScreen()
    ];
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar:BottomNavigationBar(
        items:barItems.entries.map((item)=>BottomNavigationBarItem(
        label: item.key,
        icon: item.value
        )).toList(),
        onTap: (value) =>index=value ,
         ) ,
    );
  }
}