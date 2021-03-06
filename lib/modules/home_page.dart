import 'package:petland/modules/dashboard/dashboard_page.dart';
import 'package:petland/modules/bottom_navigator.dart';
import 'package:petland/modules/notification/notification_page.dart';
import 'package:petland/modules/profile/profile_page.dart';
import 'package:petland/modules/story/story_page.dart';
import 'package:petland/share/import.dart';

class HomePage extends StatefulWidget {
  static navigate() {
    navigatorKey.currentState.pushReplacement(pageBuilder(HomePage()));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 1;
  List<Widget> _pages = <Widget>[];

  @override
  void initState() {
    _pages.addAll([
      StoryPage(),
      DashboardPage(),
      NotificationPage(),
      ProfilePage(),
    ]);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool flag = await showConfirmDialog(context, 'Close the app?',
            confirmTap: () {}, navigatorKey: navigatorKey);
        return flag;
      },
      child: Stack(
        children: [
          Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
          Positioned(
            bottom: 0,
            child: BottomNavigator(
              selectedIndex: _selectedIndex,
              listIcons: [
                MdiIcons.heart,
                MdiIcons.home,
                MdiIcons.bell,
                Icons.pets
              ],
              onSelect: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
