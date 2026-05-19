// class OrderModel {
//   final AddressModel? address;
//   final String? id;
//   final String? orderId;
//   final List<OrderItemModel>? items;
//   final double? totalAmount;
//   final double? shippingFee;
//   final double? discount;
//   final String? status;
//   final String? trackingNumber;
//   final DateTime? expectedDeliveryDate;
//   final CustomerModel? customer;
//   final VendorModel? vendor;
//   final String? addressString;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   OrderModel({
//     this.address,
//     this.id,
//     this.orderId,
//     this.items,
//     this.totalAmount,
//     this.shippingFee,
//     this.discount,
//     this.status,
//     this.trackingNumber,
//     this.expectedDeliveryDate,
//     this.customer,
//     this.vendor,
//     this.addressString,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory OrderModel.fromJson(Map<String, dynamic> json) {
//     return OrderModel(
//       address:
//           json['address'] != null && json['address'] is Map<String, dynamic>
//           ? AddressModel.fromJson(json['address'])
//           : null,
//       addressString: json['address'] is String ? json['address'] : null,
//       id: json['_id'],
//       orderId: json['orderId'],
//       items: json['items'] != null
//           ? List<OrderItemModel>.from(
//               json['items'].map((x) => OrderItemModel.fromJson(x)),
//             )
//           : [],
//       totalAmount: (json['totalAmount'] as num?)?.toDouble(),
//       shippingFee: (json['shippingFee'] as num?)?.toDouble(),
//       discount: (json['discount'] as num?)?.toDouble(),
//       status: json['status'],
//       trackingNumber: json['trackingNumber'],
//       expectedDeliveryDate: json['expectedDeliveryDate'] != null
//           ? DateTime.tryParse(json['expectedDeliveryDate'])
//           : null,
//       customer:
//           json['customer'] != null && json['customer'] is Map<String, dynamic>
//           ? CustomerModel.fromJson(json['customer'])
//           : null,
//       vendor: json['vendor'] != null && json['vendor'] is Map<String, dynamic>
//           ? VendorModel.fromJson(json['vendor'])
//           : null,
//       createdAt: json['createdAt'] != null
//           ? DateTime.tryParse(json['createdAt'])
//           : null,
//       updatedAt: json['updatedAt'] != null
//           ? DateTime.tryParse(json['updatedAt'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'address': address?.toJson() ?? addressString,
//     '_id': id,
//     'orderId': orderId,
//     'items': items?.map((e) => e.toJson()).toList(),
//     'totalAmount': totalAmount,
//     'shippingFee': shippingFee,
//     'discount': discount,
//     'status': status,
//     'trackingNumber': trackingNumber,
//     'expectedDeliveryDate': expectedDeliveryDate?.toIso8601String(),
//     'customer': customer?.toJson(),
//     'vendor': vendor?.toJson(),
//     'createdAt': createdAt?.toIso8601String(),
//     'updatedAt': updatedAt?.toIso8601String(),
//   };
// }

// class AddressModel {
//   final String? street;
//   final String? city;
//   final String? postalCode;
//   final String? country;

//   AddressModel({this.street, this.city, this.postalCode, this.country});

//   factory AddressModel.fromJson(Map<String, dynamic> json) {
//     return AddressModel(
//       street: json['street'],
//       city: json['city'],
//       postalCode: json['postalCode'],
//       country: json['country'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'street': street,
//     'city': city,
//     'postalCode': postalCode,
//     'country': country,
//   };
// }

// class OrderItemModel {
//   final ProductModel? product;
//   final int? quantity;
//   final double? price;
//   final String? id;

//   OrderItemModel({this.product, this.quantity, this.price, this.id});

//   factory OrderItemModel.fromJson(Map<String, dynamic> json) {
//     return OrderItemModel(
//       product: json['product'] != null
//           ? (json['product'] is Map<String, dynamic>
//                 ? ProductModel.fromJson(json['product'])
//                 : null) // If it's a String, we just have the ID, wait, we might want to store the ID
//           : null,
//       quantity: json['quantity'],
//       price: (json['price'] as num?)?.toDouble(),
//       id: json['_id'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'product': product,
//     'quantity': quantity,
//     'price': price,
//     '_id': id,
//   };
// }

// // class ProductModel {
// //   final String? id;
// //   final String? title;
// //   final double? price;
// //   final List<PhotoModel>? photos;

// //   ProductModel({
// //     this.id,
// //     this.title,
// //     this.price,
// //     this.photos,
// //   });

// //   factory ProductModel.fromJson(Map<String, dynamic> json) {
// //   return ProductModel(
// //     id: json['_id'] as String?,
// //     title: json['title'] as String?,
// //     price: (json['price'] as num?)?.toDouble(),
// //     photos: json['photos'] != null
// //         ? List<PhotoModel>.from(
// //             (json['photos'] as List).map((x) => PhotoModel.fromJson(x as Map<String, dynamic>)))
// //         : [],   // ← safe guard
// //   );
// // }

// //   Map<String, dynamic> toJson() => {
// //         '_id': id,
// //         'title': title,
// //         'price': price,
// //         'photos': photos?.map((e) => e.toJson()).toList(),
// //       };
// // }

// class PhotoModel {
//   final String? publicId;
//   final String? url;
//   final String? id;

//   PhotoModel({this.publicId, this.url, this.id});

//   factory PhotoModel.fromJson(Map<String, dynamic> json) {
//     return PhotoModel(
//       publicId: json['public_id'],
//       url: json['url'],
//       id: json['_id'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'public_id': publicId,
//     'url': url,
//     '_id': id,
//   };
// }

// class CustomerModel {
//   final String? id;
//   final String? name;
//   final String? email;

//   CustomerModel({this.id, this.name, this.email});

//   factory CustomerModel.fromJson(Map<String, dynamic> json) {
//     return CustomerModel(
//       id: json['_id'],
//       name: json['name'],
//       email: json['email'],
//     );
//   }

//   Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'email': email};
// }

// class VendorModel {
//   final String? id;
//   final String? name;

//   VendorModel({this.id, this.name});

//   factory VendorModel.fromJson(Map<String, dynamic> json) {
//     return VendorModel(id: json['_id'], name: json['name']);
//   }

//   Map<String, dynamic> toJson() => {'_id': id, 'name': name};
// }
