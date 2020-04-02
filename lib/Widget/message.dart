import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahbaran/bloc/error_bloc.dart';
import 'package:rahbaran/theme/style_helper.dart';

class Message extends StatelessWidget {
  final ErrorBloc errorBloc;

  Message(this.errorBloc);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: errorBloc,
        builder: (context, ErrorState state) {
          return Visibility(
              visible: state.messageVisibility,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                      width: double.infinity,
                      child: AnimatedOpacity(
                        opacity: state.messageOpacity,
                        duration: Duration(milliseconds: 1500),
                        onEnd: () {
                          if (state.messageOpacity == 0) {
                            errorBloc.add(HideErrorEvent());
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top),
                          height: 55,
                          color: Colors.red,
                          alignment: Alignment.center,
                          child: Text(state.message,
                              style: StyleHelper.messageTextStyle),
                        ),
                      ))));
        });
  }
}