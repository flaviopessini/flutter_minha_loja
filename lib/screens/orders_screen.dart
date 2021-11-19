import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/components/app_drawer_widget.dart';
import 'package:flutter_minha_loja/components/order_widget.dart';
import 'package:flutter_minha_loja/models/order_list.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  Future<void> _refresh(BuildContext context) {
    return Provider.of<OrderList>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        centerTitle: true,
      ),
      drawer: const AppDrawerWidget(),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).loadOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.error_outlined,
                    color: Colors.redAccent,
                    size: 48.0,
                  ),
                  Text('Ocorreu um erro ao carregar os dados.'),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: Consumer<OrderList>(
                builder: (ctx, orders, child) => ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: orders.itemCount,
                  itemBuilder: (ctx, index) => OrderWidget(orders.items[index]),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
