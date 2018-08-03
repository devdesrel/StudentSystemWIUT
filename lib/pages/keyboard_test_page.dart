import 'package:flutter/material.dart';

class UserLoader extends StatefulWidget {
  @override
  _UserLoaderState createState() => new _UserLoaderState();
}

class _UserLoaderState extends State<UserLoader> {
  Widget _form;

  @override
  Widget build(BuildContext context) {
    if (_form == null) {
      _form = _createForm(context);
    }
    return _form;
  }

  Widget _createForm(BuildContext context) {
    final _formKey = new GlobalKey<FormState>();
    final _emailController = new TextEditingController();

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Informations"),
          actions: <Widget>[
            new IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  // unrelated stuff happens here
                })
          ],
        ),
        body: new Center(
          child: new SingleChildScrollView(
              child: new Form(
                  key: _formKey,
                  child: new Column(children: <Widget>[
                    new ListTile(
                      leading: const Icon(Icons.email),
                      title: new TextFormField(
                        decoration: new InputDecoration(
                          hintText: "Email",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        // validator: _validateEmail,
                      ),
                    ),
                  ]))),
        ));
  }
}
