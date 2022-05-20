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
    _userInfoBloc.udateUserPresence(
      timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
      presence: true,
    );
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        await _userInfoBloc.udateUserPresence(
          timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
          presence: true,
        );
        break;
      case AppLifecycleState.paused:
        await _userInfoBloc.udateUserPresence(
          timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
          presence: false,
        );
        break;
      case AppLifecycleState.detached:
        await _userInfoBloc.udateUserPresence(
          timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
          presence: false,
        );
        break;
      case AppLifecycleState.inactive:
        await _userInfoBloc.udateUserPresence(
          timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
          presence: false,
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}
