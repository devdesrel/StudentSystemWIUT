import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/file_download/learning_materials_bloc.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class LearningMaterialsExpansionTile extends StatelessWidget {
  final GlobalKey<AppExpansionTileState> expansionTile;
  final LearningMaterialsBloc bloc;
  final List<String> expansionChildrenList;

  LearningMaterialsExpansionTile(
      {Key key,
      @required this.expansionTile,
      @required this.bloc,
      @required this.expansionChildrenList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var bloc = CourseworkUploadProvider.of(context);
    return AppExpansionTile(
      key: expansionTile,
      title: Text(bloc.materialType.toUpperCase()),
      backgroundColor: whiteColor,
      // onExpansionChanged: (b) => print(b),
      children: expansionChildrenList
          .map((name) => InkWell(
                onTap: () {
                  if (name == 'Lectures') {
                    bloc.setLearningMaterialType.add(1);
                  } else if (name == 'Seminars') {
                    bloc.setLearningMaterialType.add(2);
                  } else if (name == 'Other') {
                    bloc.setLearningMaterialType.add(3);
                  }
                  expansionTile.currentState.collapse();
                },
                child: ItemSelection(
                  name: name,
                ),
              ))
          .toList(),
    );
  }
}

class ItemSelection extends StatelessWidget {
  final name;

  ItemSelection({
    @required this.name,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        children: <Widget>[
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0, letterSpacing: 0.3),
          ),
          SizedBox(height: 12.0),
          Divider(
            height: 0.0,
            color: greyColor,
          )
        ],
      ),
    );
  }
}

// class ModulesList {
//   ModulesList(this.children);

//   //final String title;

//   final List<String> children;
// }

const Duration _kExpand = const Duration(milliseconds: 200);

class AppExpansionTile extends StatefulWidget {
  const AppExpansionTile({
    Key key,
    this.leading,
    @required this.title,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children,
    this.trailing,
    this.initiallyExpanded: false,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  final Widget leading;
  final Widget title;
  final ValueChanged<bool> onExpansionChanged;
  final List<Widget> children;
  final Color backgroundColor;
  final Widget trailing;
  final bool initiallyExpanded;

  @override
  AppExpansionTileState createState() => new AppExpansionTileState();
}

class AppExpansionTileState extends State<AppExpansionTile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _easeOutAnimation;
  CurvedAnimation _easeInAnimation;
  ColorTween _borderColor;
  ColorTween _headerColor;
  ColorTween _iconColor;
  ColorTween _backgroundColor;
  Animation<double> _iconTurns;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(duration: _kExpand, vsync: this);
    _easeOutAnimation =
        new CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _easeInAnimation =
        new CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _borderColor = new ColorTween();
    _headerColor = new ColorTween();
    _iconColor = new ColorTween();
    _iconTurns =
        new Tween<double>(begin: 0.0, end: 0.5).animate(_easeInAnimation);
    _backgroundColor = new ColorTween();

    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void expand() {
    _setExpanded(true);
  }

  void collapse() {
    _setExpanded(false);
  }

  void toggle() {
    _setExpanded(!_isExpanded);
  }

  void _setExpanded(bool isExpanded) {
    if (_isExpanded != isExpanded) {
      setState(() {
        _isExpanded = isExpanded;
        if (_isExpanded)
          _controller.forward();
        else
          _controller.reverse().then<void>((void value) {
            setState(() {
              // Rebuild without widget.children.
            });
          });
        PageStorage.of(context)?.writeState(context, _isExpanded);
      });
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged(_isExpanded);
      }
    }
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    return Container(
      decoration: new BoxDecoration(
          color: _backgroundColor.evaluate(_easeOutAnimation) ??
              Colors.transparent,
          borderRadius: BorderRadius.circular(22.0),
          border: Border.all(width: 1.0, color: greyColor)
          // border: new Border(
          //   top: new BorderSide(color: borderSideColor),
          //   bottom: new BorderSide(color: borderSideColor),
          // )
          ),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
              data: new IconThemeData(
                  color: _iconColor.evaluate(_easeInAnimation)),
              child: InkWell(
                onTap: toggle,
                child: Container(
                  decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(100.0),
                      border: Border.all(width: 0.0, color: greyColor)),
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.subhead.copyWith(
                              fontSize: 15.0,
                              letterSpacing: 0.2,
                              color: Colors.white,
                            ),
                        child: widget.title,
                      ),
                      SizedBox(width: 1.0),
                      widget.trailing ??
                          new RotationTransition(
                            turns: _iconTurns,
                            child: const Icon(Icons.expand_more),
                          ),
                    ],
                  ),
                ),
              )

              // new ListTile(
              //   onTap: toggle,
              //   leading: widget.leading,
              //   title: new DefaultTextStyle(
              //     style: Theme
              //         .of(context)
              //         .textTheme
              //         .subhead
              //         .copyWith(color: titleColor),
              //     child: widget.title,
              //   ),
              //   trailing: widget.trailing ??
              //       new RotationTransition(
              //         turns: _iconTurns,
              //         child: const Icon(Icons.expand_more),
              //       ),
              // ),
              ),
          new ClipRect(
            child: new Align(
              heightFactor: _easeInAnimation.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    _borderColor.end = theme.dividerColor;
    _headerColor
      ..begin = theme.textTheme.subhead.color
      ..end = theme.accentColor;
    _iconColor
      ..begin = Colors.white
      ..end = Colors.white;
    _backgroundColor.end = widget.backgroundColor;

    final bool closed = !_isExpanded && _controller.isDismissed;
    return new AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : new Column(children: widget.children),
    );
  }
}
