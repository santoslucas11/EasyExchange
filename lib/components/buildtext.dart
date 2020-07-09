import 'package:flutter/material.dart';

Widget buildTextField(String label, String prefix, TextEditingController controller, Function coinChange ) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      prefixText:prefix,
      labelStyle: TextStyle(color: Colors.blueGrey[400]),
      border: OutlineInputBorder(),
    ),
    style: TextStyle(color: Colors.blueGrey[400], fontSize: 18.0),
    onChanged: coinChange,
    keyboardType: TextInputType.number,
  );
}