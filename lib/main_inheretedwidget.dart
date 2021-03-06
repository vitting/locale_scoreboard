import 'package:flutter/material.dart';

class MainInherited extends StatefulWidget {
  ///Child widget to this root widget
  final Widget child;
  final bool canVibrate;

  MainInherited({
    this.child,
    this.canVibrate = false,
  });

  @override
  MainInheritedState createState() => new MainInheritedState();

  static MainInheritedState of([BuildContext context, bool rebuild = true]) {
    return (rebuild
            ? context.inheritFromWidgetOfExactType(_MainInherited)
                as _MainInherited
            : context.ancestorWidgetOfExactType(_MainInherited)
                as _MainInherited)
        .data;
  }
}

class MainInheritedState extends State<MainInherited> {
  bool canVibrate;
  String systemLanguageCode = "en";

  @override
  void initState() {
    super.initState();
    canVibrate = widget.canVibrate;
  }

  @override
  Widget build(BuildContext context) {
    return _MainInherited(
      data: this,
      child: widget.child,
    );
  }
}

class _MainInherited extends InheritedWidget {
  final MainInheritedState data;

  _MainInherited({Key key, this.data, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_MainInherited old) {
    return true;
  }
}
