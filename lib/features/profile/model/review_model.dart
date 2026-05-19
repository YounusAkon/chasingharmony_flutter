class ReviewModel {
  final String? productId;
  final int? rating;
  final String? text;

  ReviewModel({this.productId, this.rating, this.text});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      productId: json['productId'],
      rating: json['rating'] as int?,
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"productId": productId, "rating": rating, "text": text};
  }
}
