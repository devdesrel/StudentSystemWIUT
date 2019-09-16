import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/pages/learning_materials_page.dart';
import 'package:student_system_flutter/pages/module_turnitin_page.dart';

import '../helpers/app_constants.dart';
import '../helpers/ui_helpers.dart';
import '../pages/marks_page.dart';
import '../enums/ApplicationEnums.dart';

class ItemModules extends StatelessWidget {
  final dynamic module;
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
                if (module.moduleMark != 'TBA' && module.moduleMark != '0') {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MarksPage(module: module)));
                }

                break;
              case RequestType.GetTeachingMaterials:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        LearningMaterialsPage(module: module)));
                break;
              case RequestType.GetTurnitin:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ModuleTurnitinPage(module: module)));
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
                  module.moduleName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
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
                    Text(module.moduleCode,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: textColor)),
                  ],
                ),
                requestType == RequestType.GetMarks
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Year Name',
                                style: Theme.of(context).textTheme.body1),
                            Text(module.session,
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(color: textColor)),
                          ],
                        ),
                      )
                    : Container(),
                requestType == RequestType.GetMarks
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Credit',
                                style: Theme.of(context).textTheme.body1),
                            Text(module.credit,
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(color: textColor)),
                          ],
                        ),
                      )
                    : Container(),
                requestType == RequestType.GetMarks
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Total Mark',
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(
                                        color:
                                            getMarkColor(module.moduleMark))),
                            Text(module.moduleMark,
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(
                                        color:
                                            getMarkColor(module.moduleMark))),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
