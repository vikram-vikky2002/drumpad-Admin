// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class PriceEdit extends StatelessWidget {
  PriceEdit({
    super.key,
    required this.price,
    required this.type,
    required this.controller,
  });

  String price;
  String type;
  TextEditingController controller = TextEditingController();

  update() {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Column(
        children: [
          Flexible(
            child: TextFormField(
              style: const TextStyle(
                color: Colors.white,
              ),
              controller: controller,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter value';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 38, 37, 49),
                border: const OutlineInputBorder(),
                labelText: '$type Premium New Price',
                labelStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
