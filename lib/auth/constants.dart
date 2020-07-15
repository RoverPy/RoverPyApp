import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

dynamic textInputDecoration = InputDecoration(
  hintStyle: TextStyle(
    fontFamily: 'Lexend_Deca',
  ),
  filled: true,
  fillColor: Colors.grey[100],
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(
      const Radius.circular(50.0),
    ),
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
      borderRadius: BorderRadius.all(
        const Radius.circular(50.0),
      ),
  ),

);