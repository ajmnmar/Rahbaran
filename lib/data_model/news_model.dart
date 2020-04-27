import 'package:shamsi_date/shamsi_date.dart';

class NewsModel {
  String id;
  String messageTitle;
  String messageBody;
  String messageImageAddress;
  DateTime publishDate;

  String get shamsiPublishDate{
    var tempDate=Jalali.fromDateTime(publishDate);
    return '${tempDate.year}/${tempDate.month}/${tempDate.day}';
  }

  NewsModel(this.id, this.messageTitle, this.messageBody,
      this.messageImageAddress, this.publishDate);

  factory NewsModel.fromJson(dynamic json) {
    return NewsModel(json['id'], json['messageTitle'], json['messageBody'],
        json['messageImageAddress'], DateTime.parse(json['fromDate']));
  }
}