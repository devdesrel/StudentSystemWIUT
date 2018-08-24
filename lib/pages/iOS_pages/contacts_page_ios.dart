import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';

class IosContactsPage extends StatelessWidget {
  final double cardPadding = 10.0;
  @override
  Widget build(BuildContext context) {
    List<Widget> _getWidgetsList() {
      return <Widget>[
        CustomContactsCategory(
          text: 'Phone',
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomContactsListtile(
                  title: '(+998 71) 238 74 00',
                  subtitle: 'Enquiry office',
                  icon: CupertinoIcons.phone,
                  urlFrom: 'tel:+998 71 238 74 00',
                  isFromAssets: false,
                ),
                Divider(
                  height: 0.0,
                ),
                CustomContactsListtile(
                  title: '(+998 71) 238 74 44',
                  subtitle: 'Enquiry office',
                  icon: CupertinoIcons.phone,
                  urlFrom: 'tel:+998712387444',
                  isFromAssets: false,
                ),
                Divider(
                  height: 0.0,
                ),
                CustomContactsListtile(
                  title: '(+998 71) 238 74 45',
                  subtitle: 'For Masters\' programmes',
                  icon: CupertinoIcons.phone,
                  urlFrom: 'tel:+998712387445',
                  isFromAssets: false,
                ),
              ],
            ),
          ),
        ),
        CustomContactsCategory(
          text: 'Email',
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomContactsListtile(
                  title: 'info@wiut.uz',
                  subtitle: 'Enquiry office',
                  // icon: 'assets/email_ios.png',
                  imageurl: 'assets/email_ios.png',
                  // icon: ImageIcon(AssetImage('assets/email_ios.png')),
                  // icon: Icons.email,
                  isFromAssets: true,
                  urlFrom: 'mailto:info@wiut.uz?',
                ),
                Divider(
                  height: 0.0,
                ),
                CustomContactsListtile(
                  title: 'admission@wiut.uz',
                  subtitle: "Academic Registrar's office",
                  imageurl: 'assets/email_ios.png',
                  urlFrom: 'mailto:admission@wiut.uz?',
                  isFromAssets: true,
                ),
              ],
            ),
          ),
        ),
        CustomContactsCategory(
          text: 'Social',
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomContactsListtile(
                  title: 'wiut.uz',
                  subtitle: 'Web page',
                  // icon: FontAwesomeIcons.internetExplorer,
                  imageurl: 'assets/internet.png',
                  urlFrom: 'http://wiut.uz/',
                  isWebView: false,
                  isFromAssets: true,
                ),
                Divider(
                  height: 0.0,
                ),
                CustomContactsListtile(
                  title: 'facebook.com/wiut.uz',
                  subtitle: 'Facebook page',
                  // icon: FontAwesomeIcons.facebook,
                  imageurl: 'assets/facebook.png',
                  isWebView: false,
                  urlFrom: 'https://www.facebook.com/wiut.uz',
                  isFromAssets: true,
                ),
                Divider(
                  height: 0.0,
                ),
                CustomContactsListtile(
                  title: 'instagram.com/westminster.uz',
                  subtitle: 'Instagram page',
                  // icon: FontAwesomeIcons.instagram,
                  imageurl: 'assets/instagram.png',
                  isWebView: false,
                  urlFrom: 'https://www.instagram.com/westminster.uz/',
                  isFromAssets: true,
                ),
                Divider(
                  height: 0.0,
                ),
                CustomContactsListtile(
                  title: 'WIUT bot',
                  subtitle: 'Telegram bot',
                  // icon: FontAwesomeIcons.instagram,
                  imageurl: 'assets/telegram.png',
                  isWebView: false,
                  urlFrom: 'https://t.me/WestTimesBot',
                  isFromAssets: true,
                ),
              ],
            ),
          ),
        ),
        CustomContactsCategory(
          text: 'Address',
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomContactsListtile(
                  title: '12 Istiqbol Street, 100047',
                  subtitle: 'Tashkent Uzbekistan',
                  // icon: Icons.home,
                  imageurl: 'assets/home.png',
                  trailing: FontAwesomeIcons.locationArrow,
                  isMap: true,
                  isFromAssets: true,
                ),
                Divider(
                  height: 0.0,
                ),
                CustomContactsListtile(
                  title: '(+998 71) 236-35-99',
                  subtitle: 'Fax',
                  // icon: FontAwesomeIcons.fax,
                  imageurl: 'assets/fax.png',
                  isFromAssets: true,
                ),
                // SizedBox(
                //   height: 10.0,
                // )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        )
      ];
    }

    return Material(
      child: CupertinoPageScaffold(
          backgroundColor: backgroundColor,
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                automaticallyImplyLeading: false,
                trailing: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close',
                    style: TextStyle(color: accentColor),
                  ),
                ),
                largeTitle: Text("Contacts"),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getWidgetsList(),
                ),
              )
            ],
          )),
    );
  }
}

class CustomContactsCategory extends StatelessWidget {
  final String text;
  const CustomContactsCategory({Key key, @required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 12.0),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
            // fontWeight: FontWeight.bold,
            color: lightGreyTextColor,
            fontSize: 14.0),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class CustomContactsListtile extends StatelessWidget {
  final String title;
  final String subtitle;
  final icon;
  final urlFrom;
  final isWebView;
  final isMap;
  final trailing;
  final isFromAssets;
  final imageurl;
  const CustomContactsListtile(
      {Key key,
      @required this.title,
      @required this.subtitle,
      this.icon,
      this.urlFrom,
      this.isWebView,
      this.isMap,
      this.trailing,
      this.isFromAssets,
      this.imageurl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (urlFrom != null) {
            launchURL(urlFrom, isWebView);
          } else if (isMap) {
            Navigator.pushNamed(context, mapPage);
          }
        },
        child: isFromAssets
            ? ListTile(
                title: Text(title),
                leading: Image.asset(
                  imageurl,
                  height: 20.0,
                  color: Colors.grey,
                ),
                subtitle: Text(subtitle),
                trailing: Icon(
                  trailing,
                  color: Colors.red[600],
                ),
              )
            : ListTile(
                title: Text(title),
                leading: Icon(icon),
                subtitle: Text(subtitle),
                trailing: Icon(
                  trailing,
                  color: Colors.red[600],
                ),
              ));
  }
}
