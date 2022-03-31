import 'dart:async';
import 'dart:io';

import 'package:complete_advanced_flutter/app/functions.dart';
import 'package:complete_advanced_flutter/data/mapper/mapper.dart';
import 'package:complete_advanced_flutter/domain/usecase/register_usercase.dart';
import 'package:complete_advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:complete_advanced_flutter/presentation/common/freezed_data_classes.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render_impl.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInput, RegisterViewModelOutput {
  StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  StreamController _mobileNumberStreamController =
      StreamController<String>.broadcast();
  StreamController _emailStreamController =
      StreamController<String>.broadcast();
  StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  StreamController _profilePictureStreamController =
      StreamController<File>.broadcast();
  StreamController _isAllInputsValidStreamController =
      StreamController<void>.broadcast();
  StreamController isUserLoggedInSuccessfullyStreamController =
      StreamController<bool>();

  RegisterUseCase _registerUseCase;
  var registerViewObject =
      RegisterObject(EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY);
  RegisterViewModel(this._registerUseCase);

  @override
  register() async {
    // TODO: implement register
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (await _registerUseCase.execute(RegisterUseCaseInput(
            registerViewObject.username,
            registerViewObject.countryMobileCode,
            registerViewObject.email,
            registerViewObject.password,
            registerViewObject.profilePicture,
            registerViewObject.mobileNumber)))
        .fold(
            (failure) => {
                  // left -> failure
                  inputState.add(ErrorState(
                      StateRendererType.POPUP_ERROR_STATE, failure.message))
                }, (data) {
      // right -> success
      inputState.add(ContentState());
      isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }

  @override
  void start() {
    // TODO: implement start
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _isAllInputsValidStreamController.close();
    _userNameStreamController.close();
    _mobileNumberStreamController.close();
    _emailStreamController.close();
    _passwordStreamController.close();
    _profilePictureStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
    super.dispose();
  }

  @override
  // TODO: implement inputEmail
  Sink get inputEmail => _emailStreamController.sink;

  @override
  // TODO: implement inputMobileNumber
  Sink get inputMobileNumber => _mobileNumberStreamController.sink;

  @override
  // TODO: implement inputPassword
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  // TODO: implement inputProfilePicture
  Sink get inputProfilePicture => _profilePictureStreamController.sink;

  @override
  // TODO: implement inputUserName
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  // TODO: implement outputErrorEmailValid
  Stream<String?> get outputErrorEmailValid => outputIsEmailValid
      .map((isEmailValid) => isEmailValid ? null : "Invalid email");

  @override
  // TODO: implement outputErrorMobileNumberValid
  Stream<String?> get outputErrorMobileNumberValid =>
      outputIsMobileNumberValid.map((isMobileNumberValid) =>
          isMobileNumberValid ? null : "Invalid mobile number");

  @override
  // TODO: implement outputErrorPasswordValid
  Stream<String?> get outputErrorPasswordValid => outputIsPasswordValid
      .map((isPasswordValid) => isPasswordValid ? null : "Invalid password");

  @override
  // TODO: implement outputErrorUserNameValid
  Stream<String?> get outputErrorUserNameValid => outputIsUserNameValid
      .map((isUserNameValid) => isUserNameValid ? null : "Invalid username");

  @override
  // TODO: implement outputIsEmailValid
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  // TODO: implement outputIsMobileNumberValid
  Stream<bool> get outputIsMobileNumberValid =>
      _mobileNumberStreamController.stream
          .map((mobileNumber) => _isMobileNumberValid(mobileNumber));

  @override
  // TODO: implement outputIsPasswordValid
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  // TODO: implement outputIsProfilePictureValid
  Stream<File?> get outputIsProfilePictureValid =>
      _profilePictureStreamController.stream.map((file) => file);

  @override
  // TODO: implement outputIsUserNameValid
  Stream<bool> get outputIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  bool _isUserNameValid(String userName) {
    return userName.length >= 5;
  }

  bool _isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length >= 9;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 5;
  }

  @override
  setCountryCode(String countryCode) {
    // TODO: implement setCountryCode
    if (countryCode.isNotEmpty) {
      registerViewObject =
          registerViewObject.copyWith(countryMobileCode: countryCode);
    } else {
      registerViewObject =
          registerViewObject.copyWith(countryMobileCode: countryCode);
    }
    _validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    inputMobileNumber.add(mobileNumber);
    // TODO: implement setMobileNumber
    if (_isMobileNumberValid(mobileNumber)) {
      registerViewObject =
          registerViewObject.copyWith(mobileNumber: mobileNumber);
    } else {
      registerViewObject = registerViewObject.copyWith(mobileNumber: EMPTY);
    }
    _validate();
  }

  @override
  setPassword(String password) {
    // TODO: implement setPassword
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      registerViewObject = registerViewObject.copyWith(password: password);
    } else {
      registerViewObject = registerViewObject.copyWith(password: EMPTY);
    }
    _validate();
  }

  @override
  setProfilePicture(File file) {
    // TODO: implement setProfilePicture
    inputProfilePicture.add(file);
    if (file.path.isNotEmpty) {
      registerViewObject =
          registerViewObject.copyWith(profilePicture: file.path);
    } else {
      registerViewObject = registerViewObject.copyWith(profilePicture: EMPTY);
    }
    _validate();
  }

  @override
  setUserName(String userName) {
    // TODO: implement setUserName
    inputUserName.add(userName);
    if (_isUserNameValid(userName)) {
      registerViewObject = registerViewObject.copyWith(username: userName);
    } else {
      registerViewObject = registerViewObject.copyWith(username: EMPTY);
    }
    _validate();
  }

  @override
  setEmail(String email) {
    // TODO: implement setEmail
    inputEmail.add(email);
    if (isEmailValid(email)) {
      registerViewObject = registerViewObject.copyWith(email: email);
    } else {
      registerViewObject = registerViewObject.copyWith(email: EMPTY);
    }
    _validate();
  }

  @override
  // TODO: implement inputAllInputsValid
  Sink get inputAllInputsValid => _isAllInputsValidStreamController.sink;

  @override
  // TODO: implement outputIsAllInputsValid
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputsValidStreamController.stream.map((_) => _validateAllInputs());

  bool _validateAllInputs() {
    return registerViewObject.profilePicture.isNotEmpty &&
        registerViewObject.email.isNotEmpty &&
        registerViewObject.password.isNotEmpty &&
        registerViewObject.username.isNotEmpty &&
        registerViewObject.countryMobileCode.isNotEmpty &&
        registerViewObject.mobileNumber.isNotEmpty;
  }

  _validate() {
    inputAllInputsValid.add(null);
  }
}

abstract class RegisterViewModelInput {
  register();

  setUserName(String userName);
  setMobileNumber(String mobileNumber);
  setCountryCode(String countryCode);
  setEmail(String email);
  setPassword(String password);
  setProfilePicture(File file);

  Sink get inputUserName;
  Sink get inputMobileNumber;
  Sink get inputEmail;
  Sink get inputPassword;
  Sink get inputProfilePicture;
  Sink get inputAllInputsValid;
}

abstract class RegisterViewModelOutput {
  Stream<bool> get outputIsUserNameValid;
  Stream<String?> get outputErrorUserNameValid;

  Stream<bool> get outputIsMobileNumberValid;
  Stream<String?> get outputErrorMobileNumberValid;

  Stream<bool> get outputIsEmailValid;
  Stream<String?> get outputErrorEmailValid;

  Stream<bool> get outputIsPasswordValid;
  Stream<String?> get outputErrorPasswordValid;

  Stream<File?> get outputIsProfilePictureValid;

  Stream<bool> get outputIsAllInputsValid;
}
