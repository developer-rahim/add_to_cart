class Employee {
  int? productId;
  String? productName,
      productPrice,
      productTotalPrice,
      productImage,
      productQuntity,
      productTag;

  Employee(
      {this.productId,
      this.productName,
      this.productPrice,
      this.productTotalPrice,
      this.productImage,
      this.productQuntity,
      this.productTag});

  //to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = new Map<String, dynamic>();
    map["productName"] = productName;
    map["productPrice"] = productPrice;
    map["productTotalPrice"] = productTotalPrice;
    map["productImage"] = productImage;
    map["productQuntity"] = productQuntity;
    map["productTag"] = productTag;
    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = new Map<String, dynamic>();
    map["productId"] = productId;
    map["productName"] = productName;
    map["productPrice"] = productPrice;
    map["productTotalPrice"] = productTotalPrice;
    map["productImage"] = productImage;
    map["productQuntity"] = productQuntity;
    map["productTag"] = productTag;
    return map;
  }

  //to be used when converting the row into object
  factory Employee.fromMap(Map<String, dynamic> data) => new Employee(
      productId: data['productId'],
      productName: data['productName'],
      productPrice: data['productPrice'],
      productTotalPrice: data['productTotalPrice'],
      productImage: data['productImage'],
      productQuntity: data['productQuntity'],
      productTag: data['productTag']);
}
