import 'package:flutter/material.dart';

class CommunicationCard extends StatelessWidget {
  final String text;
  final Widget image;
  final Color textColor;
  final Color color;

  CommunicationCard({
    this.text,
    this.image,
    this.textColor,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        //tileColor:getBGColor(context),
        title: Text(text, style: TextStyle(color: getTextColor(context)),),
        leading: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getBGColor(context),
          ),
          child: Center(child: image)),
      )
    );
  }

  Color getBGColor(BuildContext context) {
    if (color != null) {
      return color;
    }
    return Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.black;
  }

  Color getTextColor(BuildContext context) {
    if (textColor != null) {
      return textColor;
    }
    return Theme.of(context).brightness != Brightness.light
        ? Colors.white
        : Colors.black;
  }
}
