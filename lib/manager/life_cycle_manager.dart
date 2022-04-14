import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/user_bloc.dart';

class LifeCycleManager extends StatefulWidget {
  LifeCycleManager({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  final UserInfoBloc _userInfoBloc = UserInfoBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _userInfoBloc.udateUserPresence(
        DateTime.now().millisecondsSinceEpoch.toString(),
        false,
      );
    } else if (state == AppLifecycleState.resumed) {
      _userInfoBloc.udateUserPresence(
        DateTime.now().millisecondsSinceEpoch.toString(),
        true,
      );
    } else if (state == AppLifecycleState.detached) {
      _userInfoBloc.udateUserPresence(
        DateTime.now().millisecondsSinceEpoch.toString(),
        false,
      );
    } else if (state == AppLifecycleState.inactive) {
      _userInfoBloc.udateUserPresence(
        DateTime.now().millisecondsSinceEpoch.toString(),
        false,
      );
    }
    print('AppLifecycleState state:  $state');
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}
