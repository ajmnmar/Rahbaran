import 'package:flutter_bloc/flutter_bloc.dart';

class ValidationState{
  bool validationVisibility = false;
  String validationMessage = '';

  ValidationState copy(){
    ValidationState newState=ValidationState();
    newState.validationVisibility=this.validationVisibility;
    newState.validationMessage=this.validationMessage;

    return newState;
  }

  void showValidation(String message) {
    validationMessage = message;
    validationVisibility = true;
  }

  void hideValidation() {
    validationMessage = '';
    validationVisibility = false;
  }
}

abstract class ValidationEvent {}

class ShowValidationEvent extends ValidationEvent{
  final String message;
  ShowValidationEvent(this.message);
}

class HideValidationEvent extends ValidationEvent{
}

class ValidationBloc extends Bloc<ValidationEvent,ValidationState> {
  @override
  // TODO: implement initialState
  ValidationState get initialState => new ValidationState();


  @override
  Stream<ValidationState> mapEventToState(ValidationEvent event) async* {
    // TODO: implement mapEventToState
    if(event is ShowValidationEvent){
      var tempState=state.copy();
      tempState.showValidation(event.message);
      yield tempState;
    }
    else if(event is HideValidationEvent){
      yield ValidationState()..hideValidation();
    }
  }

}
