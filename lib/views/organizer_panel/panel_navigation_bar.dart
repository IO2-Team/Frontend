import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webfrontend_dionizos/api/storage_controllers.dart';
import 'package:webfrontend_dionizos/utils/appColors.dart';
import 'package:webfrontend_dionizos/widgets/dionizos_logo.dart';

class PanelNavigationBar extends StatelessWidget {
  const PanelNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserNameContoller userNameContoller = UserNameContoller();
    late String userName;
    try {
      userName = userNameContoller.get();
    } catch (e) {
      userName = "";
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DionizosLogo(path: '/organizerPanel'),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                userName,
                style: TextStyle(fontSize: 20),
              ),
              PopupMenuButton(
                key: Key('menuButtonKey'),
                //color: mainColor,
                offset: Offset(0, 50),
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: mainColor,
                ),
                iconSize: 40,
                itemBuilder: (context) => [
                  PopupMenuItem(
                      key: Key('signOutButtonKey'),
                      onTap: () => context.go('/'),
                      child: Text('Sign out')),
                  PopupMenuItem(
                      key: Key('accountMenuButtonKey'),
                      onTap: () {
                        print('Session Token:' + SessionTokenContoller().get());
                        context.go('/organizerPanel/account');
                      },
                      child: Text('Account')),
                  PopupMenuItem(
                      onTap: () => SessionTokenContoller().set('asadasd'),
                      child: Text('Session ended test'))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
