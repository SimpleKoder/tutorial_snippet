import 'package:flutter/material.dart';

class AnimatedBottomNavBar extends StatefulWidget {
  const AnimatedBottomNavBar({super.key});

  @override
  State<AnimatedBottomNavBar> createState() => _AnimatedBottomNavBarState();
}

class _AnimatedBottomNavBarState extends State<AnimatedBottomNavBar> {
  final tabs = ["Home", "Search", "Orders", "Profile"];
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final tabSize = (MediaQuery.of(context).size.width / tabs.length);
    return SafeArea(
      top: false,
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: tabSize * currentTab,
                top: 0,
                bottom: 0,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6c5ce7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: tabSize - 10 * 2,
                ),
              ),
              Center(
                child: Row(
                  children: List.generate(
                    tabs.length,
                    (index) => Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentTab = index;
                          });
                        },
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            color: index == currentTab
                                ? Colors.white
                                : Colors.grey,
                          ),
                          child: Text(
                            tabs[index],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
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
