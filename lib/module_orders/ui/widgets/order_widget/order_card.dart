import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String time;
  final bool active;
  final GestureTapCallback onTap;
  final String image;
  OrderCard(
      {this.time, this.title, this.subTitle = '', this.active, this.onTap,this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      color: active == true
          ? Theme.of(context).primaryColor
          : Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(10),
          height: 115,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              image.contains('.svg')?SvgPicture.asset('assets/images/$image',width: 75,):Image.asset('assets/images/$image',width: 75,),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: active == true
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '$subTitle $time',
                    style: TextStyle(
                        color: active == true
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Center(
                child: CircleAvatar(
                  backgroundColor: active == true
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.arrow_forward,
                    color: active == true
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
