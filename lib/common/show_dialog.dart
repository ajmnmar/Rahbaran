import 'package:flutter/material.dart';
import 'package:rahbaran/theme/style_helper.dart';

class ShowDialog{
  static showAlertDialog(context,String title,String content) async{
    return await showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: title == null?null: Text(title,textAlign: TextAlign.center,style: Theme.of(context).textTheme.caption,),
            content: Container(
                child: Text(content,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.body2,)
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

  static showUploadImageDialog(context,GestureTapCallback onCameraTap,GestureTapCallback onGalleryTap) async{
    return await showDialog(context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            content: new SingleChildScrollView(
              child:Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: onCameraTap,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                              width:58,
                              height: 58,
                              child: Image.asset('assets/images/camera.png')),
                          Text('دوربین',style: Theme.of(context).textTheme.body2,),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onGalleryTap,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                              width:58,
                              height: 58,
                              child: Image.asset('assets/images/gallery.png')),
                          Text('گالری',style:Theme.of(context).textTheme.body2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}