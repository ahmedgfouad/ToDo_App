import 'package:flutter/material.dart';

class DefaultFormField extends StatelessWidget {
  late final double width;
  late double height;
  late final TextEditingController controller;
   TextInputType? type;
  final String? Function(String?)? validate;
  final String? hintText;
  bool? obSecure;
  IconData? prefix;
  IconData? suffix;
  void Function()? suffixButtonPressed;
  bool isPassword;
   void Function()? onTap;

  DefaultFormField({super.key,
    required this.width,
    required this.height,
    required this.controller,
     this.type,
    required this.validate,
    this.hintText,
    this.isPassword = false,
    this.suffixButtonPressed,
    this.obSecure,
    this.prefix,
    this.suffix,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        keyboardType: type,
        controller: controller,
        obscureText: obSecure ?? false,
        validator: validate,
        onTap: onTap,
        decoration: InputDecoration(
          suffix: Icon(suffix),
          prefixIcon: Icon(prefix),
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          suffixIcon: isPassword == true
              ? InkWell(
                  onTap: suffixButtonPressed,
                  child: Icon(
                    suffix,
                    size: 20),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(),
          ),
        ),
      ),
    );
  }
}
