import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:toolkit_app_company/blocs/orders_bloc.dart';
import 'package:toolkit_app_company/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _ordersBloc = BlocProvider.of<OrdersBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
        stream: _ordersBloc.outOrders,
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.redAccent),
            ),);
          else if(snapshot.data.length == 0)
            return Center(
              child: Text(
                "Nenhum pedido encontrado!",
                style: TextStyle(color: Colors.redAccent),
              ),
            );
          else
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return OrderTile(snapshot.data[index]);
              }
            );
        }
      ),
    );
  }
}
