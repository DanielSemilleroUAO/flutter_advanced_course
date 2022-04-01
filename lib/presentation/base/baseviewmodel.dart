import 'dart:async';

import 'package:complete_advanced_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOutputs {
  StreamController _inputStatestreamController =
      BehaviorSubject<FlowState>();

  @override
  // TODO: implement inputState
  Sink get inputState => _inputStatestreamController.sink;

  @override
  // TODO: implement outputState
  Stream<FlowState> get outputState =>
      _inputStatestreamController.stream.map((flowState) => flowState);

  @override
  void dispose() {
    // TODO: implement dispose
    _inputStatestreamController.close();
  }
  // shared variables and functions that will be used
}

abstract class BaseViewModelInputs {
  void start(); // will be called while init, of view model
  void dispose(); // will be called when viewmodel dies

  Sink get inputState;
}

abstract class BaseViewModelOutputs {
  Stream<FlowState> get outputState;
}
