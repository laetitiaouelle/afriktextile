class Customer{
  int id,con,son,img;
  String name, phone,password,email,link,aftxlID,liv;
  Customer({this.id, this.con, this.son, this.img, this.name, this.phone, this.password, this.email, this.link, this.aftxlID, this.liv});
}

class Commande{
  var id,userId,quantity,price, prodId;
  var name, image;
  var description;
  var descriptionShort;
  Commande({this.id, this.userId, this.quantity, this.price, this.prodId, this.name,this.image, this.description, this.descriptionShort});
  Commande.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    quantity = json['quantity'];
    price = json['price'];
    prodId = json['prodId'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    descriptionShort = json['descriptionShort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['name'] = this.name;
    data['prodId'] = this.prodId;
    data['image'] = this.image;
    data['description'] = this.description;
    data['descriptionShort'] = this.descriptionShort;
    return data;
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'quantity': quantity,
      'price': price,
      'name': name,
      'prodId': prodId,
      'image': image,
      'description':description,
      'descriptionShort':descriptionShort
    };
  }
}

class Wish{
  int id,userId,quantity,price, prodId;
  String name, image;
  Wish({this.id, this.userId, this.quantity, this.price, this.prodId, this.name,this.image});
}
class Products {
  int id;
  var image;
  var quantity;
  var price;
  var active;
  var name;
  var description;
  var descriptionShort;
  var reduction;
  int index;

  Products(
      {this.id,
      this.image,
      this.quantity,
      this.price,
      this.active,
      this.name,
      this.description,
      this.descriptionShort,
      this.reduction,
      this.index });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['id_default_image'];
    quantity = json['quantity'];
    price = json['price'];
    active = json['active'];
    name = json['name'];
    description = json['description'];
    descriptionShort = json['description_short'];
    reduction = json['reduction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_default_image'] = this.image;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['name'] = this.name;
    data['description'] = this.description;
    data['description_short'] = this.descriptionShort;
    data['reduction'] = this.reduction;
    return data;
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'quantity': quantity,
      'price': price,
      'name': name,
      'description': description,
      'descriptionShort': descriptionShort,
      'reduction': reduction
    };
  }
  }
  

class Buyings {
  String userName;
  String qty;
  String price;
  String userPhone;
  String idProd;
  String idImage;
  String idCommand;
  String isValidate;
  String isTerminated;
  String nbCom;

  Buyings(
      {this.userName,
      this.qty,
      this.price,
      this.userPhone,
      this.idProd,
      this.idImage,
      this.idCommand,
      this.isValidate,
      this.isTerminated,
      this.nbCom});

  Buyings.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    qty = json['qty'];
    price = json['price'];
    userPhone = json['user_phone'];
    idProd = json['id_prod'];
    idImage = json['id_image'];
    idCommand = json['id_command'];
    isValidate = json['is_validate'];
    isTerminated = json['is_terminated'];
    nbCom = json['nbCom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['user_phone'] = this.userPhone;
    data['id_prod'] = this.idProd;
    data['id_image'] = this.idImage;
    data['id_command'] = this.idCommand;
    data['is_validate'] = this.isValidate;
    data['is_terminated'] = this.isTerminated;
    data['nbCom'] = this.nbCom;
    return data;
  }
}

class BuyingsDetails {
  String id;
  String userName;
  String productName;
  String productQty;
  String productPrice;
  String userPhone;
  String isValidate;
  String isTerminated;
  String idProd;
  String idImage;
  String idCommand;

  BuyingsDetails(
      {this.id,
      this.userName,
      this.productName,
      this.productQty,
      this.productPrice,
      this.userPhone,
      this.isValidate,
      this.isTerminated,
      this.idProd,
      this.idImage,
      this.idCommand});

  BuyingsDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    productName = json['product_name'];
    productQty = json['product_qty'];
    productPrice = json['product_price'];
    userPhone = json['user_phone'];
    isValidate = json['is_validate'];
    isTerminated = json['is_terminated'];
    idProd = json['id_prod'];
    idImage = json['id_image'];
    idCommand = json['id_command'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['product_name'] = this.productName;
    data['product_qty'] = this.productQty;
    data['product_price'] = this.productPrice;
    data['user_phone'] = this.userPhone;
    data['is_validate'] = this.isValidate;
    data['is_terminated'] = this.isTerminated;
    data['id_prod'] = this.idProd;
    data['id_image'] = this.idImage;
    data['id_command'] = this.idCommand;
    return data;
  }
}
