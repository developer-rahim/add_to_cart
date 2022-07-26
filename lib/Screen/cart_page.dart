import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/db_helper.dart';
import 'package:flutter_application_1/Provider/cart_counter.dart';
import 'package:provider/provider.dart';

import '../Model/data_base_model.dart';
import '../SCREEN/homepage.dart';

class EmployeesList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EmployeesListState();
  }
}

class EmployeesListState extends State<EmployeesList> {
  //var productQuntity = 1;
  List<Employee> listEmployees = [];

  Future<List<Map<String, dynamic>>> product_lists() async {
    List<Map<String, dynamic>> listMap =
        await DatabaseHelper.instance.queryAllRows();
    setState(() {
      listMap.forEach((map) => listEmployees.insert(0, Employee.fromMap(map)));
    });
    return listMap;
  }

  @override
  void initState() {
    CartCounter cartCounter = Provider.of<CartCounter>(context, listen: false);
    cartCounter.getTotalPrice();
    print(cartCounter.totalPrice);
    // TODO: implement initState

    product_lists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CartCounter cartCounter = Provider.of<CartCounter>(
      context,
    );

    // TODO: implement build

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Visibility(
          visible: cartCounter.totalPrice == 0.0 ? false : true,
          child: BottomAppBar(
            child: Container(
              color: Colors.black.withOpacity(.2),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Total amount Tk ${cartCounter.totalPrice}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 113, 174, 225),
          title: Text('Cart Page'
              //  listEmployees.length.toString()
              ),
          centerTitle: true,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Center(
                  child: Badge(
                badgeContent:
                    Consumer<CartCounter>(builder: ((context, value, child) {
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
        body: listEmployees.length == 0
            ? Center(child: Text('No Data add in Cart'))
            : Container(
                // padding: EdgeInsets.all(15),
                child: ListView.builder(
                    itemCount: listEmployees.length,
                    // reverse: true,
                    itemBuilder: (context, position) {
                      Employee product_list = listEmployees[position];
                      var id = product_list.id;
                      var productName = product_list.productName;
                      int productPrice = int.parse(product_list.productPrice!);
                      int productInitialPrice = int.parse(
                          product_list.productInitialPrice.toString());
                      var productTag = product_list.productTag;
                      int productQuntity =
                          int.parse(product_list.productQuntity!);
                      var productImage = product_list.productImage;
                      var productId = product_list.productId;

                      return Card(
                        elevation: 8,
                        child: Container(
                          // height: 97,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                child: Image(
                                  image: NetworkImage(
                                    productImage.toString(),
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                width: 160,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product_list.productName!,
                                        style: TextStyle(fontSize: 18)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Price: $productPrice Tk ",
                                        style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  //  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          ),
                                          onPressed: () {
                                            cartCounter.removeTotalPrice(
                                                productPrice.toDouble());

                                            // cartCounter.removeProductTotalPrice(productPrice);
                                            cartCounter.decrementCounter();
                                            DatabaseHelper.instance.delete(
                                                product_list.productId!);
                                            setState(() => {
                                                  listEmployees.removeWhere(
                                                      (item) =>
                                                          item.productId ==
                                                          product_list
                                                              .productId)
                                                });
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              int productQuntitys =
                                                  productQuntity;
                                              int productInitialPrices =
                                                  productInitialPrice;
                                              productQuntitys++;
                                              int newPrice =
                                                  productInitialPrices *
                                                      productInitialPrices;

                                              int product_price = productPrice;

                                              Employee addEmployee = Employee(
                                                id: id,
                                                productId: productId,
                                                productImage: productImage,
                                                productName:
                                                    product_list.productName,
                                                productTag: productTag,
                                                productQuntity:
                                                    productQuntitys.toString(),
                                                productPrice:
                                                    newPrice.toString(),
                                                productInitialPrice:
                                                    productInitialPrice
                                                        .toString(),
                                              );
                                              DatabaseHelper.instance
                                                  .update(addEmployee.toMap())
                                                  .then((value) {
                                                newPrice = 0;
                                                productQuntitys = 0;
                                                cartCounter.addTotalPrice(
                                                    double.parse(product_price
                                                        .toString()));
                                              }).onError((error, stackTrace) {
                                                print(error.toString());
                                              });
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 19,
                                                )),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  // color: Colors.blueAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: Text(
                                                  productQuntity.toString()
                                                  //  productquantity.toString()

                                                  )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              int product_price = productPrice;

                                              //  var newPrice=product_quntity * product_price;
                                              // print('product_price $product_price');

                                              Employee addEmployee = Employee(
                                                  productId: productId,
                                                  productImage: productImage,
                                                  productName:
                                                      product_list.productName,
                                                  productTag: productTag);
                                              DatabaseHelper.instance
                                                  .update(addEmployee.toMap())
                                                  .then((value) {
                                                cartCounter.addTotalPrice(
                                                    double.parse(product_price
                                                        .toString()));
                                              }).onError((error, stackTrace) {
                                                print(error.toString());
                                              });
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 19,
                                                )),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })),
      ),
    );
  }
}
