import 'package:yes_order/consts/order_status.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_chat/chat_routes.dart';
import 'package:yes_order/module_orders/model/order/order_model.dart';
import 'package:yes_order/module_orders/orders_routes.dart';
import 'package:yes_order/module_orders/ui/screens/order_status/order_status_screen.dart';
import 'package:yes_order/module_orders/ui/state/order_status/order_status.state.dart';
import 'package:yes_order/module_orders/ui/widgets/communication_card/communication_card.dart';
import 'package:yes_order/module_orders/util/whatsapp_link_helper.dart';
import 'package:yes_order/module_orders/utils/icon_helper/order_progression_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:timeago/timeago.dart' as timeago;

class OrderDetailsStateCaptainOrderLoaded extends OrderDetailsState {
  OrderModel currentOrder;
  final _distanceCalculator = TextEditingController();

  OrderDetailsStateCaptainOrderLoaded(
    this.currentOrder,
    OrderStatusScreenState screenState,
  ) : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            OrdersRoutes.CAPTAIN_ORDERS_SCREEN, (route) => false);
        return;
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: OrderProgressionHelper.getStatusIcon(
                  currentOrder.status, context),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stepper(
                  type: StepperType.horizontal,
                  steps: [
                    Step(
                        title: Container(),
                        content: Container(),
                        isActive:
                            currentOrder.status.index == 0 ? true : false),
                    Step(
                        title: Container(),
                        content: Container(),
                        isActive:
                            currentOrder.status.index == 1 ? true : false),
                    Step(
                        title: Container(),
                        content: Container(),
                        isActive:
                            currentOrder.status.index == 2 ? true : false),
                    Step(
                        title: Container(),
                        content: Container(),
                        isActive:
                            currentOrder.status.index == 3 ? true : false),
                    Step(
                        title: Container(),
                        content: Container(),
                        isActive:
                            currentOrder.status.index == 4 ? true : false),
                    Step(
                        title: Container(),
                        content: Container(),
                        isActive:
                            currentOrder.status.index == 5 ? true : false),
                  ],
                  currentStep: currentOrder.status.index,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 200,
                child: CommunicationCard(
                  text: timeago.format(currentOrder.creationTime,
                      locale: Localizations.localeOf(context).languageCode),
                  color:Colors.orange,
                  image: Icon(Icons.timer),
                ),
              ),
            ),
            
            SizedBox(
              height: 56,
            ),
            // To Progress the Order
            _getNextStageCard(context),
            // To Chat with Store owner in app
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ChatRoutes.chatRoute,
                    arguments: currentOrder.chatRoomId,
                  );
                },
                child: CommunicationCard(
                  text: S.of(context).chatWithStoreOwner,
                  color: Theme.of(context).primaryColor,
                  image: Icon(
                    Icons.chat_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // To WhatsApp with store owner
            currentOrder.ownerPhone != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Divider(),
                  )
                : Container(),
            currentOrder.ownerPhone != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        var url = WhatsAppLinkHelper.getWhatsAppLink(
                            currentOrder.ownerPhone);
                        launch(url);
                      },
                      child: CommunicationCard(
                        color: Colors.green,
                        text: S.of(context).whatsappWithStoreOwner,
                        image: FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Container(),
            // To WhatsApp with client
            currentOrder.clientPhone != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Divider(),
                  )
                : Container(),
            currentOrder.clientPhone != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        var url = WhatsAppLinkHelper.getWhatsAppLink(
                            currentOrder.clientPhone);
                        launch(url);
                      },
                      child: CommunicationCard(
                        color: Colors.green,
                        text: S.of(context).whatsappWithClient,
                        image: FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Container(),
            // To Open Maps
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  var url = WhatsAppLinkHelper.getMapsLink(
                      currentOrder.to.lat, currentOrder.to.lat);
                  launch(url);
                },
                child: CommunicationCard(
                  text: S.of(context).getDirection,
                  image: FaIcon(
                    FontAwesomeIcons.mapSigns,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              height: 36,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getNextStageCard(BuildContext context) {
    if (currentOrder.status == OrderStatus.FINISHED) {
      return Container();
    }
    if (currentOrder.status == OrderStatus.GOT_CASH) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 72,
            width: MediaQuery.of(context).size.width,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[900]
                              : Color.fromRGBO(236, 239, 241, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: _distanceCalculator,
                        decoration: InputDecoration(
                          hintText:
                              '${S.of(context).pleaseProvideTheDistance} e.g 45',
                          prefixIcon: Icon(Icons.add_road),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ),
                IconButton(
                    splashRadius: 20,
                    icon: Icon(Icons.check),
                    onPressed: () {
                      if (_distanceCalculator.text.isNotEmpty) {
                        screenState.requestOrderProgress(
                            currentOrder, _distanceCalculator.text);
                      } else {
                        screenState.showSnackBar(
                            S.of(context).pleaseProvideTheDistance);
                      }
                    }),
              ],
            ),
          ),
        ),
      );
    } else if (currentOrder.status == OrderStatus.DELIVERING) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 72,
            width: MediaQuery.of(context).size.width,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[900]
                              : Color.fromRGBO(236, 239, 241, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: _distanceCalculator,
                        decoration: InputDecoration(
                          hintText:
                              '${S.of(context).finishOrderProvideDistanceInKm} e.g 45',
                          prefixIcon: Icon(Icons.add_road),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ),
                IconButton(
                    splashRadius: 20,
                    icon: Icon(Icons.check),
                    onPressed: () {
                      if (_distanceCalculator.text.isNotEmpty) {
                        screenState.requestOrderProgress(
                            currentOrder, _distanceCalculator.text);
                      } else {
                        screenState.showSnackBar(
                            S.of(context).pleaseProvideTheDistance);
                      }
                    }),
              ],
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            screenState.requestOrderProgress(currentOrder);
          },
          child: CommunicationCard(
            text: OrderProgressionHelper.getNextStageHelper(
              currentOrder.status,
              currentOrder.paymentMethod.toLowerCase().contains('ca'),
              context,
            ),
            color: Colors.green[700],
            image: Icon(Icons.navigate_next_sharp, color: Colors.white),
          ),
        ),
      );
    }
  }
}
