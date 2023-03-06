import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tromega/data/account.dart';
import 'package:tromega/data/body.dart';
import 'package:tromega/data/account_http_helper.dart';
import '../../widgets/bottom_menu.dart';
import '../../widgets/shared/app_bar.dart';
import '../../widgets/account/profile_widget.dart';
import 'package:intl/intl.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Account lastAccount;
  late Body lastBody;
  late AccountHttpHelper accountHttpHelper;
  bool fetching = true;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    accountHttpHelper = AccountHttpHelper();
    fetchData();
    super.initState();
  }

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut().then((value) {
        Navigator.pushNamed(context, '/');
      });
    } catch (error) {
      print(error);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar_Icon(
        actions: [],
      ),
      body: fetching
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SizedBox(height: 24),
                ProfileWidget(
                  imagePath:
                      'https://media.istockphoto.com/photos/close-up-photo-beautiful-amazing-she-her-lady-look-side-empty-space-picture-id1146468004?k=20&m=1146468004&s=612x612&w=0&h=oCXhe0yOy-CSePrfoj9d5-5MFKJwnr44k7xpLhwqMsY=',
                  onClicked: () {
                    //Navigator.pushNamed(context, '/editProfile');
                  },
                ),
                const SizedBox(height: 24),
                buildName(),
                const SizedBox(height: 24),
                buildData(),
                const SizedBox(height: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton.icon(
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        //color: Color.fromARGB(1000, 240, 157, 2)
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                        maximumSize: const Size(200, 50),
                        primary: Color.fromARGB(1000, 0, 48, 80),
                      ),
                      onPressed: _handleSignOut,
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget buildName() => Column(
        children: [
          Text(
            lastAccount.name,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xff003050)),
          ),
        ],
      );

  Widget buildData() {
    DateFormat formatter = DateFormat.yMMMMd('de_DE');
    var formattedDate = formatter.format(lastAccount.birthdate);
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            buildDataRow(text1: 'Alter', text2: formattedDate),
            const SizedBox(height: 24),
            buildDataRow(
                text1: 'Größe', text2: "${lastBody.height.toString()} m"),
            const SizedBox(height: 24),
            buildDataRow(
                text1: 'Gewicht', text2: "${lastBody.weight.toString()} kg"),
            const SizedBox(height: 24),
            buildDataRow(
                text1: 'Geschlecht', text2: lastAccount.sex.toString()),
            const SizedBox(height: 24),
            buildDataRow(text1: 'Trainingsziel', text2: "Muskeln aufbauen")
          ],
        ));
  }

  Widget buildDataRow({required String text1, text2}) => Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Text(text1, style: const TextStyle(fontSize: 16)),
            ),
            Expanded(
              flex: 5,
              child: Text(text2, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      );

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account account =
        await accountHttpHelper.getAccount(prefs.getString('googleId') ?? '');
    Body body =
        await accountHttpHelper.getBody(prefs.getString('userId') ?? '');

    setState(() {
      lastAccount = account;
      lastBody = body;
      fetching = false;
    });
  }
}
