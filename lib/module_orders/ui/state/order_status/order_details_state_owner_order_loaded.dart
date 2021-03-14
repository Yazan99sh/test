import 'package:yes_order/consts/order_status.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_chat/chat_routes.dart';
import 'package:yes_order/module_orders/model/order/order_model.dart';
import 'package:yes_order/module_orders/ui/screens/order_status/order_status_screen.dart';
import 'package:yes_order/module_orders/ui/state/order_status/order_status.state.dart';
import 'package:yes_order/module_orders/ui/widgets/communication_card/communication_card.dart';
import 'package:yes_order/module_orders/util/whatsapp_link_helper.dart';
import 'package:yes_order/module_orders/utils/icon_helper/order_progression_helper.dart';
import 'package:yes_order/utils/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../../../orders_routes.dart';

class OrderDetailsStateOwnerOrderLoaded extends OrderDetailsState {
  OrderModel currentOrder;

  OrderDetailsStateOwnerOrderLoaded(
    this.currentOrder,
    OrderStatusScreenState screenState,
  ) : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            OrdersRoutes.OWNER_ORDERS_SCREEN, (route) => false);
        return;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flex(
            direction: Axis.vertical,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: OrderProgressionHelper.getStatusIcon(
                    currentOrder.status, context),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  OrderProgressionHelper.getCurrentStageHelper(
                      currentOrder.status, context),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 75,
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
                    color: Colors.orange,
                    image: Icon(Icons.timer),
                  ),
                ),
              ),
            ],
          ),
          currentOrder.status == OrderStatus.INIT
              ? Container()
              : Flex(
                  direction: Axis.vertical,
                  children: [
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
                          text: S.of(context).openChatRoom,
                          color: Theme.of(context).primaryColor,
                          image: Icon(
                            Icons.chat_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          var url = WhatsAppLinkHelper.getWhatsAppLink(
                              currentOrder.captainPhone);
                          launch(url);
                        },
                        child: CommunicationCard(
                          color: Colors.green,
                          text: S.of(context).whatsappWithCaptain,
                          image: FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    currentOrder.clientPhone == null
                        ? Container()
                        : GestureDetector(
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
                    Container(
                      height: 48,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
