import 'package:emart/consts/consts.dart';
import 'package:emart/views/orders_screen/components/order_place_details.dart';
import 'package:emart/views/orders_screen/components/order_status.dart';
import 'package:intl/intl.dart' as intl;

class OrderStatus extends StatelessWidget {
  final dynamic data;
  const OrderStatus({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: "Order Details".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              orderStatus(title: "Placed", icon: Icons.done, color: redColor, showDone: data['order_placed']),
              orderStatus(title: "Confirmed", icon: Icons.thumb_up, color: Colors.blue, showDone: data['order_confirmed']),
              orderStatus(title: "On Delivery", icon: Icons.car_crash, color: Colors.yellow, showDone: data['order_on_delivery']),
              orderStatus(title: "Delivered", icon: Icons.done_all_rounded, color: Colors.purple, showDone: data['order_delivery']),
              // const Divider(thickness: 2,),

              10.heightBox,
              "Ordered Product".text.size(16).fontFamily(semibold).color(darkFontGrey).makeCentered(),
              10.heightBox,
              ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(data['orders'].length, (index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderPlaceDetails(
                        title1: data['orders'][index]['title'],
                        title2: data['orders'][index]['tPrice'],
                        d1: "${data['orders'][index]['qty']}x",
                        d2: "Refundable",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: 30,
                          height: 20,
                          color: Color(data['orders'][index]['color']),
                        )
                      ),
                      // const Divider(thickness: 2,),
                    ],
                  );
                }).toList(),
              ).box.shadowLg.p8.white.roundedSM.make(),
              10.heightBox,
              Column(
                children: [
                  10.heightBox,
                  orderPlaceDetails(
                    title1: "Order Code",
                    title2: "Shipping Method",
                    d1: data['order_code'],
                    d2: data['shipping_method'],
                  ),
                  orderPlaceDetails(
                    title1: "Order Date",
                    title2: "Payment Method",
                    d1: intl.DateFormat().add_yMd().format((data['order_date'].toDate())),
                    d2: data['payment_method'],
                  ),
                  orderPlaceDetails(
                    title1: "Payment Status",
                    title2: "Delivery Status",
                    d1: "Unpaid",
                    d2: "Order Placed",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address".text.fontFamily(semibold).make(),
                            "${data['order_by_name']}".text.make(),
                            "${data['order_by_email']}".text.make(),
                            "${data['order_by_address']}".text.fontFamily(bold).make().box.width(175).make(),
                            "${data['order_by_city']}".text.make(),
                            "${data['order_by_state']}".text.make(),
                            "${data['order_by_phone']}".text.make(),
                            "${data['order_by_postal_code']}".text.make(),
                          ],
                        ),
                        SizedBox(
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Total Amount".text.fontFamily(semibold).make(),
                              "${data['total_amount']}".numCurrency.text.color(redColor).fontFamily(bold).make(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ).box.roundedSM.shadowSm.white.make(),
            ],
          ),
        ),
      ),
    );
  }
}
