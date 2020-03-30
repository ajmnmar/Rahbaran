import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingState{
  bool isLoading = false;
}

enum LoadingEvent {show,hide}

class LoadingBloc extends Bloc<LoadingEvent,LoadingState> {
  @override
  // TODO: implement initialState
  LoadingState get initialState => new LoadingState();

  @override
  Stream<LoadingState> mapEventToState(LoadingEvent event) async* {
    // TODO: implement mapEventToState
    if(event==LoadingEvent.show){
      yield LoadingState()..isLoading=true;
    }
    else if(event == LoadingEvent.hide){
      yield LoadingState()..isLoading=false;
    }
  }

}
