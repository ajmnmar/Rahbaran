class NewsModel {
  String id;
  String messageTitle;
  String messageBody;
  String messageImageAddress;
  DateTime publishDate;

  NewsModel(this.id, this.messageTitle, this.messageBody,
      this.messageImageAddress, this.publishDate);

  factory NewsModel.fromJson(dynamic json) {
    return NewsModel(json['id'], json['messageTitle'], json['messageBody'],
        json['messageImageAddress'], DateTime.parse(json['fromDate']));
  }
}