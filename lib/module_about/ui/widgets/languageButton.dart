import 'package:yes_order/module_about/state_manager/about_screen_state_manager.dart';
import 'package:flutter/material.dart';

class LanguageButton extends StatefulWidget {
  final String textLang;
  final String flag;
  final String currentLanguage;
  @override
  _LanguageButtonState createState() => _LanguageButtonState();
  LanguageButton({Key key, this.textLang, this.flag, this.currentLanguage});
}

class _LanguageButtonState extends State<LanguageButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            'assets/images/${widget.flag}',
            width: 25,
          ),
          Text(
            '${widget.textLang}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black
                    ),
          ),
          Container(
              width: 25,
              height: 25,
              child: widget.currentLanguage==widget.textLang
                  ? Center(
                      child: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 25,
                    ))
                  : Container()),
        ],
      ),
    );
  }
}
