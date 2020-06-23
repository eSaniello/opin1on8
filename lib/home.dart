import 'package:flutter/material.dart';
import 'package:opin1on8/add_service.dart';
import 'Timeline.dart';
import 'settings.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 0;
  List<Widget> screens = [];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen;

  @override
  void initState() {
    super.initState();

    screens = [
      TimelineScreen(),
      SettingsScreen(),
    ];

    currentScreen = TimelineScreen();
  }

  @override
  Widget build(BuildContext context) {
    // final userData = Provider.of<User>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('OPIN1ON8'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddServiceScreen.id,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        elevation: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    currentScreen = TimelineScreen();
                    currentTab = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.dashboard,
                      color: currentTab == 0
                          ? Colors.deepOrangeAccent
                          : Colors.grey,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        color: currentTab == 0
                            ? Colors.deepOrangeAccent
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    currentScreen = SettingsScreen();
                    currentTab = 3;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: currentTab == 3 ? Colors.orange : Colors.grey,
                    ),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: currentTab == 3 ? Colors.orange : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
