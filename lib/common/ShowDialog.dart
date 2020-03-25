import 'package:flutter/material.dart';

class ShowDialog{
  static showOkDialog(context,String title,String content) async{
    return await showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: title == null?null: Text(title,textAlign: TextAlign.center,),
            content: Text(content,textAlign: TextAlign.center,),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child:Text('باشه')
              )
            ],
          );
        }
    );
  }
}