import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/data_base_model.dart';
import 'package:flutter_application_1/Provider/cart_counter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Database/db_helper.dart';
import 'SCREEN/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider<CartCounter>(create: (_) => CartCounter()), 
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Sqflite Sample',
        home: AddEditEmployee(false),
      ),
    
    );
  }
}

