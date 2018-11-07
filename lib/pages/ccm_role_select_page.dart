import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/ccm_role_select/ccm_role_select_bloc.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/ccm_roles_model.dart';
import 'package:student_system_flutter/pages/ccm_feedback_page.dart';

class CCMRoleSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CCMRoleSelectBloc _bloc = CCMRoleSelectBloc(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Select role'),
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder<CCMRolesModel>(
                stream: _bloc.ccmRoles,
                // initialData: false,
                builder: (context, snapshot) => snapshot.hasData
                    ? snapshot.data.deansOffice
                        ? CustomCard(ListTile(
                            title: Center(child: Text('Dean\'s office')),
                            onTap: () {},
                          ))
                        : Container(
                            height: 0.0,
                          )
                    : Container(
                        height: 0.0,
                      ),
              ),
              StreamBuilder<CCMRolesModel>(
                stream: _bloc.ccmRoles,
                builder: (context, snapshot) => snapshot.hasData
                    ? snapshot.data.headOfCourse
                        ? CustomCard(
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Center(child: Text('Head of Course')),
                            ),
                          )
                        : Container(
                            height: 0.0,
                          )
                    : Container(
                        height: 0.0,
                      ),
              ),
              StreamBuilder<CCMRolesModel>(
                stream: _bloc.ccmRoles,
                builder: (context, snapshot) => snapshot.hasData
                    ? snapshot.data.rectorsOffice
                        ? CustomCard(
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Center(child: Text('Rector\'s office')),
                            ),
                          )
                        : Container(
                            height: 0.0,
                          )
                    : Container(
                        height: 0.0,
                      ),
              ),
              StreamBuilder<CCMRolesModel>(
                  stream: _bloc.ccmRoles,
                  builder: (context, snapshot) => snapshot.hasData
                      ? snapshot.data.courseLeader
                          ? CustomCard(
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Center(child: Text('Course Leader')),
                              ),
                            )
                          : Container(
                              height: 0.0,
                            )
                      : Container(
                          height: 0.0,
                        )),
              StreamBuilder<CCMRolesModel>(
                stream: _bloc.ccmRoles,
                builder: (context, snapshot) => snapshot.hasData
                    ? snapshot.data.moduleLeader
                        ? CustomCard(
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Center(child: Text('Module Leader')),
                            ),
                          )
                        : Container(
                            height: 0.0,
                          )
                    : Container(
                        height: 0.0,
                      ),
              ),
              CustomCard(
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CCMFeedbackPage(addressedToMe: true)));
                  },
                  child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text("Addressed to me",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline
                                .copyWith(color: accentColor)),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
