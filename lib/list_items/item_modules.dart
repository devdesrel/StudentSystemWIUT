import 'package:flutter/material.dart';
import 'package:student_system_flutter/pages/lectures_page.dart';

import '../helpers/app_constants.dart';
import '../helpers/ui_helpers.dart';
import '../models/modules_list_model.dart';
import '../pages/marks_page.dart';
import '../enums/ApplicationEnums.dart';

class ItemModules extends StatelessWidget {
  final Module module;
  final RequestType requestType;

  ItemModules({Key key, @required this.module, @required this.requestType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: CustomCard(
        InkWell(
          onTap: () {
            switch (requestType) {
              case RequestType.GetMarks:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MarksPage(module: module)));
                break;
              case RequestType.GetTeachingMaterials:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LecturesPage(module: module)));
                break;
              default:
            }
            // Navigator.of(context).pushNamed(marksPage);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  module.moduleNameField,
                  textAlign: TextAlign.center,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline
                      .copyWith(color: accentColor),
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Module Code',
                        style: Theme.of(context).textTheme.body1),
                    Text(module.moduleCodeField,
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1
                            .copyWith(color: textColor)),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Level Name',
                        style: Theme.of(context).textTheme.body1),
                    Text(module.levelField,
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1
                            .copyWith(color: textColor)),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Year Name', style: Theme.of(context).textTheme.body1),
                    Text(module.sessionField,
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1
                            .copyWith(color: textColor)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
