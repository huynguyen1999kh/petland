import 'package:petland/modules/authentication/login.dart';
import 'package:petland/modules/authentication/register.dart';
import 'package:petland/share/import.dart';


class WelcomePage extends StatelessWidget {
  static navigate() {
    navigatorKey.currentState.pushReplacement(pageBuilder(WelcomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#21323A'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacingBox(h: 8),
              Image.asset('assets/image/logo.png'),
              SpacingBox(h: 1.5),
              Text(
                'Wellcome!',
                style: ptHeadLine().copyWith(color: Colors.white),
              ),
              SpacingBox(h: 1),
              Text(
                'Sen ơi đăng nhập vào đây nhé',
                style: ptTitle().copyWith(color: Colors.white70),
              ),
              SpacingBox(h: 35),
              ExpandBtn(text: 'Đăng ký tài khoản', onPress: () {
                RegisterPage.navigate();
              }),
              Spacer(),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'ALREADY HAVE AN ACCOUNT?  ',
                  style: TextStyle(color: Colors.white70),
                ),
                GestureDetector(
                  onTap: () => LoginPage.navigate(),
                  child: Text(
                    'LOG IN',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]),
              SpacingBox(h: 5),
            ],
          ),
        ),
      ),
    );
  }
}
