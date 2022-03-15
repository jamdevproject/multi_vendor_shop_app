import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = GetStorage();
    String address = store.read('address');
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(address),
        ),
      ),
    );
  }
}
