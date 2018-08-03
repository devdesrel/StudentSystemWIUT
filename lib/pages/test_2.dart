import 'package:flutter/material.dart';
import 'package:student_system_flutter/pages/test_page.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => new _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FocusNode _focusNodeFirstName = new FocusNode();
  FocusNode _focusNodeLastName = new FocusNode();
  FocusNode _focusNodeDescription = new FocusNode();
  static final TextEditingController _firstNameController =
      new TextEditingController();
  static final TextEditingController _lastNameController =
      new TextEditingController();
  static final TextEditingController _descriptionController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('My Test Page'),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
          key: _formKey,
          child: new SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                /* -- Something large -- */
                Container(
                  width: double.infinity,
                  height: 150.0,
                  color: Colors.red,
                ),

                /* -- First Name -- */
                EnsureVisibleWhenFocused(
                  focusNode: _focusNodeFirstName,
                  child: new TextFormField(
                    decoration: const InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,
                      icon: const Icon(Icons.person),
                      hintText: 'Enter your first name',
                      labelText: 'First name *',
                    ),
                    onSaved: (String value) {
                      //TODO
                    },
                    controller: _firstNameController,
                    focusNode: _focusNodeFirstName,
                  ),
                ),
                const SizedBox(height: 24.0),

                /* -- Last Name -- */
                EnsureVisibleWhenFocused(
                  focusNode: _focusNodeLastName,
                  child: new TextFormField(
                    decoration: const InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,
                      icon: const Icon(Icons.person),
                      hintText: 'Enter your last name',
                      labelText: 'Last name *',
                    ),
                    onSaved: (String value) {
                      //TODO
                    },
                    controller: _lastNameController,
                    focusNode: _focusNodeLastName,
                  ),
                ),
                const SizedBox(height: 24.0),

                /* -- Some other fields -- */
                new Container(
                  width: double.infinity,
                  height: 250.0,
                  color: Colors.blue,
                ),

                /* -- Description -- */
                new EnsureVisibleWhenFocused(
                  focusNode: _focusNodeDescription,
                  child: new TextFormField(
                    decoration: const InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Tell us about yourself',
                      labelText: 'Describe yourself',
                    ),
                    onSaved: (String value) {
                      //TODO
                    },
                    maxLines: 5,
                    controller: _descriptionController,
                    focusNode: _focusNodeDescription,
                  ),
                ),
                const SizedBox(height: 24.0),

                /* -- Save Button -- */
                new Center(
                  child: new RaisedButton(
                    child: const Text('Save'),
                    onPressed: () {
                      //TODO
                    },
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
