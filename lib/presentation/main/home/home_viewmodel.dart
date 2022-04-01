import 'dart:async';
import 'dart:ffi';

import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/domain/usecase/home_usecase.dart';
import 'package:complete_advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInputs, HomeViewModelOutputs {
  HomeUseCase _homeUseCase;

  StreamController _bannerStreamController = BehaviorSubject<List<BannerAd>>();
  StreamController _serviceStreamController = BehaviorSubject<List<Service>>();
  StreamController _storeStreamController = BehaviorSubject<List<Store>>();

  HomeViewModel(this._homeUseCase);

  @override
  void start() {
    // TODO: implement start
    _getHome();
  }

  _getHome() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));
    (await _homeUseCase.execute(Void)).fold((failure) {
      inputState.add(ErrorState(
          StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
    }, (homeObjet) {
      inputState.add(ContentState());
      inputBanners.add(homeObjet.data.banners);
      inputServices.add(homeObjet.data.services);
      inputStores.add(homeObjet.data.stores);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bannerStreamController.close();
    _serviceStreamController.close();
    _storeStreamController.close();
    super.dispose();
  }

  //inputs
  @override
  // TODO: implement inputBanners
  Sink get inputBanners => _bannerStreamController.sink;

  @override
  // TODO: implement inputServices
  Sink get inputServices => _serviceStreamController.sink;

  @override
  // TODO: implement inputStores
  Sink get inputStores => _storeStreamController.sink;

// outputs

  @override
  // TODO: implement outputBanners
  Stream<List<BannerAd>> get outputBanners =>
      _bannerStreamController.stream.map((banners) => banners);

  @override
  // TODO: implement outputServices
  Stream<List<Service>> get outputServices =>
      _serviceStreamController.stream.map((services) => services);

  @override
  // TODO: implement outputStores
  Stream<List<Store>> get outputStores =>
      _storeStreamController.stream.map((stores) => stores);
}

abstract class HomeViewModelInputs {
  Sink get inputStores;
  Sink get inputServices;
  Sink get inputBanners;
}

abstract class HomeViewModelOutputs {
  Stream<List<Store>> get outputStores;
  Stream<List<Service>> get outputServices;
  Stream<List<BannerAd>> get outputBanners;
}
