import 'package:flutter/material.dart';

class MembershipCard extends StatelessWidget {
  const MembershipCard({
    super.key,
    required this.title,
    required this.image,
    required this.price,
    required this.color,
  });

  final String title;
  final String image;
  final String price;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Container(
        height: 300,
        color: color,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: Center(
                    child: Image(
                      image: AssetImage(image),
                    ),
                  ),
                ),
              ),
              Text(
                '₹ ${price.toString()}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
