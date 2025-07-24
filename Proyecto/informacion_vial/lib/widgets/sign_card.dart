import 'package:flutter/material.dart';
import '../models/traffic_sign.dart';

class SignCard extends StatelessWidget {
  final TrafficSign sign;
  final VoidCallback? onTap;

  const SignCard({
    Key? key,
    required this.sign,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        leading: Image.asset(sign.imageUrl, width: 48, height: 48),
        title: Text(sign.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sign.type),
        onTap: onTap,
      ),
    );
  }
}
