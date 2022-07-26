class Employee {
  int? id, productId;
  String? productName,
      productPrice,
      productInitialPrice,
      productImage,
      productQuntity,
      productTag;

  Employee(
      {this.id,
      this.productId,
      this.productName,
      this.productPrice,
      this.productInitialPrice,
      this.productImage,
      this.productQuntity,
      this.productTag});

  //to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = new Map<String, dynamic>();
    map["productName"] = productName;
    map["productPrice"] = productPrice;
    map["productInitialPrice"] = productInitialPrice;
    map["productImage"] = productImage;
    map["productQuntity"] = productQuntity;
    map["productTag"] = productTag;
    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = new Map<String, dynamic>();
    map["id"] = id;
    map["productId"] = productId;
    map["productName"] = productName;
    map["productPrice"] = productPrice;
    map["productInitialPrice"] = productInitialPrice;
    map["productImage"] = productImage;
    map["productQuntity"] = productQuntity;
    map["productTag"] = productTag;
    return map;
  }

  //to be used when converting the row into object
  factory Employee.fromMap(Map<String, dynamic> data) => new Employee(
      id: data['id'],
      productId: data['productId'],
      productName: data['productName'],
      productPrice: data['productPrice'],
      productInitialPrice: data['productInitialPrice'],
      productImage: data['productImage'],
      productQuntity: data['productQuntity'],
      productTag: data['productTag']);
}
