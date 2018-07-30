import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatelessWidget {
  final double cardPadding = 10.0;
  @override
  Widget build(BuildContext context) {
    List<Widget> _getWidgetsList() {
      return <Widget>[
        CustomContactsCategory(
          text: 'Phone',
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
          child: Card(
            elevation: 2.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomContactsListtile(
                  title: '(+998 71) 238 74 00',
                  subtitle: 'Enquiry office',
                  icon: Icons.phone,
                  urlFrom: 'tel:+998712387400',
                ),
                Divider(
                  height: 0.0,
                ),
                CustomContactsListtile(
                  title: '(+998 71) 238 74 44',
                  subtitle: 'Enquiry office',
                  icon: Icons.phone,
                  urlFrom: 'tel:+998712387444',
                ),
                Divider(
                  height: 0.0,
                ),
                CustomContactsListtile(
                  title: '(+998 71) 238 74 45',
                  subtitle: 'Enquiries on Masters programmes',
                  icon: Icons.phone,
                  urlFrom: 'tel:+998712387445',
                ),
              ],
            ),
          ),
        ),
        CustomContactsCategory(
          text: 'Email',
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
          child: Card(
            elevation: 2.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomContactsListtile(
                  title: 'info@wiut.uz',
                  subtitle: 'Enquiry office',
                  icon: Icons.email,
                  urlFrom: 'mailto:info@wiut.uz?',
                ),
                Divider(
                  height: 0.0,
                ),
                CustomContactsListtile(
                  title: 'admission@wiut.uz',
                  subtitle: "Academic Registrar's office",
                  icon: Icons.email,
                  urlFrom: 'mailto:admission@wiut.uz?',
                ),
              ],
            ),
          ),
        ),
        CustomContactsCategory(
          text: 'Social',
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
          child: Card(
            elevation: 2.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomContactsListtile(
                  title: 'wiut.uz',
                  subtitle: 'Web page',
                  icon: FontAwesomeIcons.internetExplorer,
                  urlFrom: 'http://wiut.uz/',
                  isWebView: true,
                ),
                Divider(
                  height: 0.0,
                ),
                CustomContactsListtile(
                  title: 'facebook.com/wiut.uz',
                  subtitle: 'Facebook page',
                  icon: FontAwesomeIcons.facebook,
                  isWebView: true,
                  urlFrom: 'https://www.facebook.com/wiut.uz',
                ),
                Divider(
                  height: 0.0,
                ),
                CustomContactsListtile(
                  title: 'instagram.com/westminster.uz',
                  subtitle: 'Instagram page',
                  icon: FontAwesomeIcons.instagram,
                  isWebView: true,
                  urlFrom: 'https://www.instagram.com/westminster.uz/',
                ),
              ],
            ),
          ),
        ),
        CustomContactsCategory(
          text: 'Address',
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
          child: Card(
            elevation: 2.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomContactsListtile(
                  title: '12 Istiqbol Street, 100047',
                  subtitle: 'Tashkent	Uzbekistan',
                  icon: Icons.home,
                  trailing: FontAwesomeIcons.mapMarkerAlt,
                  isMap: true,
                ),
                Divider(
                  height: 0.0,
                ),
                CustomContactsListtile(
                  title: '(+998 71) 236-35-99',
                  subtitle: 'Fax',
                  icon: FontAwesomeIcons.fax,
                ),
              ],
            ),
          ),
        ),
      ];
    }

    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Contacts',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            background: Image.asset(
              'assets/wiut_cover2.jpg',
            ),
          ),
          expandedHeight: 243.5,
          floating: false,
          pinned: false),
      SliverList(
          //delegate: SliverChildListDelegate(children: <Widget>[]
          delegate: SliverChildListDelegate(_getWidgetsList()))
    ]));
  }
}

class CustomContactsCategory extends StatelessWidget {
  final String text;
  const CustomContactsCategory({Key key, @required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, top: 12.0),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: accentColor, fontSize: 16.0),
        textAlign: TextAlign.start,
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
  const CustomContactsListtile(
      {Key key,
      @required this.title,
      @required this.subtitle,
      @required this.icon,
      this.urlFrom,
      this.isWebView,
      this.isMap,
      this.trailing})
      : super(key: key);

  _launchURL(String urlFrom) async {
    final url = urlFrom;

    if (await canLaunch(url)) {
      if (isWebView != null && isWebView) {
        await launch(url, forceWebView: true);
      } else {
        await launch(url);
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (urlFrom != null) {
          _launchURL(urlFrom);
        } else if (isMap) {
          Navigator.pushNamed(context, mapPage);
        }
      },
      child: ListTile(
        title: Text(title),
        leading: Icon(icon),
        subtitle: Text(subtitle),
        trailing: Icon(
          trailing,
          color: Colors.red[600],
        ),
      ),
    );
  }
}
