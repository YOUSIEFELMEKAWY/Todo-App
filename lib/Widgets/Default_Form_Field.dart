import 'package:flutter/material.dart';

// ignore: camel_case_types, must_be_immutable
class defaultFormField extends StatelessWidget {
  defaultFormField({
    super.key,
    required this.controller,
    required this.textInputType,
    required this.title,
    required this.icon,
    this.validator,
    this.ontap,
  });

  final TextEditingController controller;
  final TextInputType textInputType;
  final String title;
  final IconData icon;
  final String? Function(String?)? validator;
  void Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      decoration: InputDecoration(label: Text(title), prefixIcon: Icon(icon)),
      validator: validator,
      controller: controller,
      onTap: ontap,
    );
  }
}
