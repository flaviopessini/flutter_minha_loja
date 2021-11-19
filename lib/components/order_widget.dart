import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/models/order.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatefulWidget {
  final Order order;

  const OrderWidget(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  // bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        ExpansionTile(
          backgroundColor: Colors.white,
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          title: Text(
            NumberFormat.simpleCurrency(locale: 'PT-BR')
                .format(widget.order.total),
          ),
          subtitle: Text(
            DateFormat('dd/MM/yyyy HH:mm').format(widget.order.date),
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.order.products.length,
              itemBuilder: (ctx, index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.order.products[index].quantity.toString()}x',
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      widget.order.products[index].name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    NumberFormat.simpleCurrency(locale: 'PT-BR').format(
                        widget.order.products[index].quantity *
                            widget.order.products[index].price),
                  ),
                ],
              ),
            ),
          ],
        ),
        // ListTile(
        //   title: Text(
        //     NumberFormat.simpleCurrency(locale: 'PT-BR')
        //         .format(widget.order.total),
        //   ),
        //   subtitle: Text(
        //     DateFormat('dd/MM/yyyy HH:mm').format(widget.order.date),
        //   ),
        //   trailing: IconButton(
        //     onPressed: () {
        //       setState(() {
        //         _expanded = !_expanded;
        //       });
        //     },
        //     icon: const Icon(
        //       Icons.expand_more,
        //     ),
        //   ),
        // ),
        // if (_expanded)
        //   Container(
        //     padding:
        //         const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        //     child: ListView.builder(
        //       shrinkWrap: true,
        //       itemCount: widget.order.products.length,
        //       itemBuilder: (ctx, index) => Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Text(
        //             '${widget.order.products[index].quantity.toString()}x',
        //           ),
        //           const SizedBox(width: 8.0),
        //           Expanded(
        //             child: Text(
        //               widget.order.products[index].name,
        //               overflow: TextOverflow.ellipsis,
        //               maxLines: 1,
        //             ),
        //           ),
        //           Text(
        //             NumberFormat.simpleCurrency(locale: 'PT-BR').format(
        //                 widget.order.products[index].quantity *
        //                     widget.order.products[index].price),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
