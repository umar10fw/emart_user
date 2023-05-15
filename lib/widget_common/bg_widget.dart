
import 'package:emart/consts/consts.dart';

Widget bgWidget({Widget? child}){
  return Container(
    child: child,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imgBackground),
        fit: BoxFit.fill
      ),
    ),
  );
}