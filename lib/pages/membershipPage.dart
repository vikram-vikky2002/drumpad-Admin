import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drum_pad_admin/widgets/membershipCard.dart';
import 'package:drum_pad_admin/widgets/priceEdit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  var gold, diamond, platinum;
  TextEditingController _goldPriceController = TextEditingController();
  TextEditingController _diamondPriceController = TextEditingController();
  TextEditingController _platinumPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void goldUpdate() {
    try {
      FirebaseFirestore.instance.collection('membership').doc('Gold').update({
        'amount': _goldPriceController.text,
        'updatedOn': DateTime.now().toString(),
      });
      Fluttertoast.showToast(
        msg: 'Gold Membership Price Updated',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      _goldPriceController.clear();
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error : ${error.toString()}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 239, 111, 111),
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  void diamondUpdate() {
    try {
      FirebaseFirestore.instance
          .collection('membership')
          .doc('Diamond')
          .update({
        'amount': _diamondPriceController.text,
        'updatedOn': DateTime.now().toString(),
      });
      Fluttertoast.showToast(
        msg: 'Diamond Membership Price Updated',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      _diamondPriceController.clear();
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error : ${error.toString()}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 239, 111, 111),
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  void platinumUpdate() {
    try {
      FirebaseFirestore.instance
          .collection('membership')
          .doc('Platinum')
          .update({
        'amount': _platinumPriceController.text,
        'updatedOn': DateTime.now().toString(),
      });
      Fluttertoast.showToast(
        msg: 'Platinum Membership Price Updated',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      _platinumPriceController.clear();
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error : ${error.toString()}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 239, 111, 111),
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  void clear(controller) {
    controller.clear();
  }

  String? numberValidator(String value) {
    if (value == null) {
      return null;
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.cyan,
                Colors.cyanAccent,
                Colors.yellow,
              ],
            ),
          ),
        ),
        title: const Text(
          'Premium Membership',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 3,
          ),
        ),
      ),
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<Object>(
                  stream: FirebaseFirestore.instance
                      .collection('membership')
                      .doc('Gold')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.data != null) {
                      gold = snapshot.data;
                      return MembershipCard(
                        title: "GOLD",
                        image: 'Assets/goldPlan.png',
                        price: gold['amount'],
                        color: const Color.fromARGB(255, 255, 243, 139),
                      );
                    } else {
                      const Text('Something went wrong ==== 2');
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                StreamBuilder<Object>(
                  stream: FirebaseFirestore.instance
                      .collection('membership')
                      .doc('Diamond')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.data != null) {
                      diamond = snapshot.data;
                      return MembershipCard(
                        title: "DIAMOND",
                        image: 'Assets/diamondPlan.png',
                        price: diamond['amount'],
                        color: const Color.fromARGB(255, 173, 245, 255),
                      );
                    } else {
                      const Text('Something went wrong ==== 2');
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                StreamBuilder<Object>(
                  stream: FirebaseFirestore.instance
                      .collection('membership')
                      .doc('Platinum')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.data != null) {
                      platinum = snapshot.data;
                      return MembershipCard(
                        title: "PLATINUM",
                        image: 'Assets/platinumPlan.png',
                        price: platinum['amount'],
                        color: const Color.fromARGB(255, 210, 210, 210),
                      );
                    } else {
                      const Text('Something went wrong ==== 2');
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Column(
                    children: [
                      Flexible(
                        child: TextFormField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          controller: _goldPriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0123456789.]')),
                          ],
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 38, 37, 49),
                            border: OutlineInputBorder(),
                            labelText: 'Gold Premium New Price',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: Row(
                          children: [
                            Flexible(
                              child: InkWell(
                                onTap: () => clear(_goldPriceController),
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
                            ),
                            const SizedBox(width: 15),
                            Flexible(
                              child: InkWell(
                                onTap: () => goldUpdate(),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Column(
                    children: [
                      Flexible(
                        child: TextFormField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          controller: _diamondPriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0123456789.]')),
                          ],
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 38, 37, 49),
                            border: OutlineInputBorder(),
                            labelText: 'Diamond Premium New Price',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: Row(
                          children: [
                            Flexible(
                              child: InkWell(
                                onTap: () => clear(_diamondPriceController),
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
                            ),
                            const SizedBox(width: 15),
                            Flexible(
                              child: InkWell(
                                onTap: () => diamondUpdate(),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Column(
                    children: [
                      Flexible(
                        child: TextFormField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          controller: _platinumPriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0123456789.]')),
                          ],
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 38, 37, 49),
                            border: OutlineInputBorder(),
                            labelText: 'Platinum Premium New Price',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: Row(
                          children: [
                            Flexible(
                              child: InkWell(
                                onTap: () => clear(_platinumPriceController),
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
                            ),
                            const SizedBox(width: 15),
                            Flexible(
                              child: InkWell(
                                onTap: () => platinumUpdate(),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
