import 'package:flutter/material.dart';
import 'package:rahbaran/theme/style_helper.dart';

class ShowDialog{
  static showOkDialog(context,String title,String content) async{
    return await showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: title == null?null: Text(title,textAlign: TextAlign.center,style: Theme.of(context).textTheme.caption,),
            content: Container(
                child: Text(content,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.body1,)
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child:Text('باشه',style: TextStyle(color: StyleHelper.mainColor),)
              )
            ],
          );
        }
    );
  }
}