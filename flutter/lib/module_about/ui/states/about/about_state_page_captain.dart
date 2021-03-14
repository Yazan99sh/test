import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_about/state_manager/about_screen_state_manager.dart';
import 'package:yes_order/module_about/ui/screen/about_screen/about_screen.dart';
import 'package:yes_order/module_about/ui/states/about/about_state.dart';
import 'package:yes_order/module_auth/authorization_routes.dart';
import 'package:yes_order/module_init/model/package/packages.model.dart';
import 'package:yes_order/module_init/ui/widget/package_card/package_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutStatePageCaptain extends AboutState {
  int currentPage = 0;
  final pageController = PageController(initialPage: 0);

  AboutStatePageCaptain(AboutScreenStateManager screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: pageController,
          onPageChanged: (pos) {
            currentPage = pos;
            screenState.refresh(this);
          },
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 25.0, left: 25, bottom: 35),
                  child: Image.asset(
                    'assets/images/open_app.png',
                    width: 250,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 25.0, left: 25.0, bottom: 10),
                  child: Text(
                    '${S.of(context).launch}',
                    style: TextStyle(
                        height: 2, fontWeight: FontWeight.bold, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 35, left: 35),
                  child: Text(
                    '${S.of(context).lanchDescribtionCaptain}',
                    style: TextStyle(
                        height: 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 25.0, left: 25, bottom: 35),
                  child: Image.asset(
                    'assets/images/check_order.png',
                    width: 250,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 25.0, left: 25.0, bottom: 10),
                  child: Text(
                    '${S.of(context).checkOrders}',
                    style: TextStyle(
                        height: 2, fontWeight: FontWeight.bold, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 35, left: 35),
                  child: Text(
                    '${S.of(context).checkOrdersDescribtion}',
                    style: TextStyle(
                        height: 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 25.0, left: 25, bottom: 35),
                  child: Image.asset(
                    'assets/images/accept_order.png',
                    width: 250,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 25.0, left: 25.0, bottom: 10),
                  child: Text(
                    '${S.of(context).acceptOrder}',
                    style: TextStyle(
                        height: 2, fontWeight: FontWeight.bold, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 35, left: 35),
                  child: Text(
                    '${S.of(context).acceptOrderDescribtion}',
                    style: TextStyle(
                        height: 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 25.0, left: 25, bottom: 35),
                  child: Image.asset(
                    'assets/images/deliver.png',
                    width: 250,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 25.0, left: 25.0, bottom: 10),
                  child: Text(
                    '${S.of(context).deliver}',
                    style: TextStyle(
                        height: 2, fontWeight: FontWeight.bold, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 35, left: 35),
                  child: Text(
                    '${S.of(context).deliverDescribtion}',
                    style: TextStyle(
                        height: 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 25.0, left: 25, bottom: 35),
                  child: Image.asset(
                    'assets/images/earn_cash.png',
                    width: 250,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 25.0, left: 25.0, bottom: 10),
                  child: Text(
                    '${S.of(context).earnCash}',
                    style: TextStyle(
                        height: 2, fontWeight: FontWeight.bold, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 35, left: 35),
                  child: Text(
                    '${S.of(context).earnCashDescribtion}',
                    style: TextStyle(
                        height: 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 18,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentPage != 4
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AuthorizationRoutes.REGISTER_SCREEN)
                              .whenComplete(() => pageController.jumpToPage(0));
                          ;
                        },
                        child: Text(
                          '${S.of(context).skip}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    : Text(
                        '${S.of(context).skip}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.transparent.withOpacity(0),
                        ),
                      ),
                getIndicator(context),
                GestureDetector(
                  onTap: () {
                    if (currentPage == 4) {
                      Navigator.of(context)
                          .pushNamed(AuthorizationRoutes.REGISTER_SCREEN)
                          .whenComplete(() => pageController.jumpToPage(0));
                    } else {
                      pageController.animateToPage(currentPage + 1,
                          duration: Duration(milliseconds: 750),
                          curve: Curves.easeIn);
                    }
                  },
                  child: Text(
                    '${S.of(context).next}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget getIndicator(BuildContext context) {
    var circles = <Widget>[];
    for (int i = 0; i < 5; i++) {
      double size = i == currentPage ? 10 : 6;
      circles.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
              color: i == currentPage
                  ? Theme.of(context).primaryColor
                  : Color.fromRGBO(236, 239, 241, 1),
              shape: BoxShape.circle),
        ),
      ));
    }
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: circles,
    );
  }
}
