import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class ErrorState{
  String message = '';
  double messageOpacity = 0;
  bool messageVisibility = false;

  ErrorState copy(){
    ErrorState newState=ErrorState();
    newState.message=this.message;
    newState.messageOpacity=this.messageOpacity;
    newState.messageVisibility=this.messageVisibility;

    return newState;
  }

  void showMessage(String message) {
    this.message = message;
    this.messageOpacity = 1;
    this.messageVisibility = true;
  }

  void hideMessage(){
    this.messageOpacity = 0;
    this.messageVisibility = true;
  }
}

abstract class ErrorEvent {}

class ShowErrorEvent extends ErrorEvent{
  final String message;
  ShowErrorEvent(this.message);
}

class HideErrorEvent extends ErrorEvent{}

class ErrorBloc extends Bloc<ErrorEvent,ErrorState> {
  Timer messageTimer;

  @override
  // TODO: implement initialState
  ErrorState get initialState => new ErrorState();


  @override
  Stream<ErrorState> mapEventToState(ErrorEvent event) async* {
    // TODO: implement mapEventToState
    if(event is ShowErrorEvent){
      if (messageTimer != null) {
        messageTimer.cancel();
      }

      var tempState=state.copy();
      tempState.showMessage(event.message);
      yield tempState;

      messageTimer = new Timer(Duration(seconds: 3), () {
        this.add(HideErrorEvent());
      });
    }else{
      var tempState=state.copy();
      tempState.hideMessage();
      yield tempState;
    }
  }

}
