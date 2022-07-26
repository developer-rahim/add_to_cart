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
        bottomNavigationBar: BottomAppBar(
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
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 113, 174, 225),
          title: Text('Cart Page'
              //  listEmployees.length.toString()
              ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AddEditEmployee(false)));
              },
            )
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
                      int productPrice = int.parse(product_list.productPrice!);
                      var productTag = product_list.productTag;
                      int productquantity =
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
                                              int product_price = productPrice;
                                              int product_quntity =
                                                  productquantity;
                                              if (productquantity == 1) {
                                                productquantity--;
                                              }

                                              var newprice = product_quntity *
                                                  product_price;
                                              //  var newPrice=product_quntity * product_price;
                                              // print('product_price $product_price');
                                              print(
                                                  'product_quantity $product_quntity');
                                              print(
                                                  'product_newprice $newprice');
                                              Employee addEmployee = Employee(
                                                  productId: productId,
                                                  productImage: productImage,
                                                  productName:
                                                      product_list.productName,
                                                  productPrice:
                                                      newprice.toString(),
                                                  productQuntity:
                                                      product_quntity
                                                          .toString(),
                                                  productTag: productTag);
                                              DatabaseHelper.instance
                                                  .update(addEmployee.toMap())
                                                  .then((value) {
                                                newprice = 0;
                                                product_quntity = 0;

                                                cartCounter.removeTotalPrice(
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
                                                  productquantity.toString())),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              int product_price = productPrice;
                                              int product_quntity =
                                                  productquantity;

                                              productquantity++;

                                              var newprice = product_quntity *
                                                  product_price;
                                              //  var newPrice=product_quntity * product_price;
                                              // print('product_price $product_price');
                                              print(
                                                  'product_quantity $product_quntity');
                                              print(
                                                  'product_newprice $newprice');
                                              Employee addEmployee = Employee(
                                                  productId: productId,
                                                  productImage: productImage,
                                                  productName:
                                                      product_list.productName,
                                                  productPrice:
                                                      newprice.toString(),
                                                  productQuntity:
                                                      product_quntity
                                                          .toString(),
                                                  productTag: productTag);
                                              DatabaseHelper.instance
                                                  .update(addEmployee.toMap())
                                                  .then((value) {
                                                newprice = 0;
                                                product_quntity = 0;

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
