

import '../consts/consts.dart';

Widget dashboardButton( context,{title, count,icons}){
  var size = MediaQuery.of(context).size.width;
  return Row(
    children: [
      Expanded(child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title,style: TextStyle(fontSize: 16,color: whiteColor),),
          Text(count,style: TextStyle(fontSize: 20, color: whiteColor),)

        ],
      )),
      Image.asset(icons,width: 40,color: whiteColor,)
    ],
  ).box.color(Color.fromRGBO(46, 41, 78, 1)).
  rounded.size(size*0.4, 80).
  padding(EdgeInsets.all(8)).make();
}