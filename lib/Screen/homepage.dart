import 'dart:math';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/db_helper.dart';
import 'package:flutter_application_1/Model/data_base_model.dart';
import 'package:flutter_application_1/Provider/cart_counter.dart';
import 'package:flutter_application_1/Screen/cart_page.dart';
import 'package:flutter_application_1/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddEditEmployee extends StatefulWidget {
  bool isEdit;
  Employee? selectedEmployee;

  AddEditEmployee(this.isEdit, [this.selectedEmployee]);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddEditEmployeeState();
  }
}

class AddEditEmployeeState extends State<AddEditEmployee> {
  List<String> productName = [
    'Mango',
    'Banana',
    'Tomoto',
    'Juckfruit',
    'watermilon',
    'Liche',
    'Pototo'
  ];
  List<String> productUnit = [
    'KG',
    'DORZEN',
    'KG',
    'LITER',
    'GRAM',
    'PUYA',
    'MON'
  ];
  List<int> productPRICE = [10, 20, 30, 40, 50, 60, 70];
  List<String> productQuantity = ['1', '1', '1', '1', '1', '1', '1'];
  List<String> productmageUrl = [
    'https://media.istockphoto.com/photos/mango-picture-id467328250?k=20&m=467328250&s=612x612&w=0&h=b21g4jLnkNRkcOX84X_Vn-z1gHnLW1n3RXK8bKV692s=',
    'https://images.unsplash.com/photo-1570913149827-d2ac84ab3f9a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&w=1000&q=80g',
    'https://image.shutterstock.com/image-photo/bunch-bananas-isolated-on-white-260nw-1297537468.jpg',
    'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg',
    'https://media.istockphoto.com/photos/tomatoes-isolate-on-white-background-tomato-half-isolated-tomatoes-picture-id1258142863?k=20&m=1258142863&s=612x612&w=0&h=lVLMaX3tiP407SwLUElEifKqHpNRYw4ZR6B0GOycGc4=',
    'https://thumbs.dreamstime.com/b/big-watermelon-slice-white-background-as-package-design-element-44517200.jpg',
    'https://static.addtoany.com/images/dracaena-cinnabari.jpg',
  ];

  List<Employee> listEmployees = [];

  Future<List<Map<String, dynamic>>> getEmployees() async {
    List<Map<String, dynamic>> listMap =
        await DatabaseHelper.instance.queryAllRows();
    setState(() {
      listMap.forEach((map) => listEmployees.add(Employee.fromMap(map)));
    });
    return listMap;
  }

  // int _counter = 0;

  // void _incrementCounter() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _counter = ((prefs.getInt('counter') ?? 0) + 1);
  //     prefs.setInt('counter', _counter);
  //   });
  // }

  // void loadCounter() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _counter = (prefs.getInt('counter') ?? 0);
  //   });
  // }

  @override
  void initState() {
    // loadCounter();
    CartCounter cartCounter = Provider.of<CartCounter>(context, listen: false);
    cartCounter.loadCounter();
    // cartCounter.  quantityloadCounter();
    // getEmployees();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CartCounter cartCounter = Provider.of<CartCounter>(
      context,
    );
    return SafeArea(
        child: Scaffold(
            // backgroundColor: Colors.grey[800],
            appBar: AppBar(
              backgroundColor: Colors.grey[900],
              title: Text('Product List'),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Center(
                      child: Badge(
                    badgeContent: Consumer<CartCounter>(
                        builder: ((context, value, child) {
                      return Text(
                        cartCounter.counter.toString(),
                        // value.getCounter().toString(),
                        style: TextStyle(color: Colors.white),
                      );
                    })),

                    // animationDuration: Duration(milliseconds: 300),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => EmployeesList())));
                        },
                        child: Icon(Icons.shopping_bag_outlined)),
                  )),
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: ListView.builder(
                      itemCount: productName.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var nameindex = productName[index];
                        var unitindex = productUnit[index];
                        var priceindex = productPRICE[index];
                        var imageurl = productmageUrl[index];
                        var productquantity=productQuantity[index];

                        return Card(
                          child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              leading: Container(
                                height: 80,
                                width: 80,
                                child: Image.network(
                                  imageurl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              title: Text(
                                nameindex,
                                style: TextStyle(fontSize: 15),
                              ),
                              subtitle: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      priceindex.toString(),
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      unitindex.toString(),
                                      style: TextStyle(fontSize: 13),
                                    )
                                  ],
                                ),
                              ),
                              trailing: Wrap(children: [
                                RaisedButton(
                                    //color: Colors.grey,
                                    color: Colors.black.withOpacity(.2),
                                    child: Text("Add Cart",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                    onPressed: () {
                                      // cartCounter.addCounter();

                                      //  cartCounter.productTotalPrice(productPRICE[index]);
                                      Employee addEmployee =  Employee(
                                          productId: index,
                                          productImage: imageurl,
                                          productName: productName[index],
                                          productPrice:
                                              productPRICE[index].toString(),
                                          productQuntity:productquantity
                                             ,
                                         // productTag: unitindex
                                         );
                                      DatabaseHelper.instance
                                          .insert(addEmployee.toMap())
                                          .then((value) => {
                                                cartCounter.incrementCounter(),
                                                cartCounter.addTotalPrice(
                                                    double.parse(
                                                        productPRICE[index]
                                                            .toString())),
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content:  Text(
                                                      'Added Successfully'),
                                                  duration:  Duration(
                                                      seconds: 1),
                                                ))
                                              })
                                          .onError((error, stackTrace) => {
                                                // ignore: avoid_print
                                                //  return e.toString();
                                              });
                                    }),
                              ])),
                        );
                      }),
                ),
                // IconButton(
                //     onPressed: () async {
                //       SharedPreferences prefs =
                //           await SharedPreferences.getInstance();
                //       prefs.remove('counter');
                //     },
                //     icon: Icon(Icons.delete))
              ],
            )));
  }
}
