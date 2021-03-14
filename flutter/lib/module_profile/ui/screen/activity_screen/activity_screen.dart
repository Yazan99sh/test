import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_profile/state_manager/activity/activity_state_manager.dart';
import 'package:yes_order/module_profile/ui/states/activity_state/activity_state.dart';
import 'package:yes_order/module_profile/ui/states/activity_state_loading/activity_state_loading.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';

@provide
class ActivityScreen extends StatefulWidget {
  final ActivityStateManager _profileStateManager;

  ActivityScreen(this._profileStateManager);

  @override
  State<StatefulWidget> createState() => ActivityScreenState();
}

class ActivityScreenState extends State<ActivityScreen> {
  ActivityState _currentState;

  @override
  void initState() {
    _currentState = ActivityStateLoading(this);
    widget._profileStateManager.getMyProfile(this);
    widget._profileStateManager.stateStream.listen((event) {
      _currentState = event;
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_currentState);
    if (_currentState is ActivityStateLoading) {
      return _currentState.getUI(context);
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            children: [
              SafeArea(
                top: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left:
                                  Localizations.localeOf(context).toString() ==
                                          'en'
                                      ? 6.0
                                      : 0.0,
                              right:
                                  Localizations.localeOf(context).toString() ==
                                          'en'
                                      ? 0.0
                                      : 6.0,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      S.of(context).activityLog,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                    
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              _currentState.getUI(context),
            ],
          ),
        ),
      );
    
    }
  }
}
