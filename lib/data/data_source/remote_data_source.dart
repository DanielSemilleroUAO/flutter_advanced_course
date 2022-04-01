import 'package:complete_advanced_flutter/data/mapper/mapper.dart';
import 'package:complete_advanced_flutter/data/network/app_api.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/data/responses/responses.dart';

abstract class RemoteDataSource {
  Future<AuthenticationResponse> login(LoginRequest loginRequest);
  Future<ForgotPasswordResponse> forgotPassword(String email);
  Future<AuthenticationResponse> register(RegisterRequest registerRequest);
  Future<HomeResponse> getHome();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  AppServiceClient _appServiceClient;
  RemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<AuthenticationResponse> login(LoginRequest loginRequest) async {
    // TODO: implement login
    // return await _appServiceClient.login(loginRequest.email,
    //     loginRequest.password, loginRequest.imei, loginRequest.deviceType);
    return await _appServiceClient.login(
        loginRequest.email, loginRequest.password, EMPTY, EMPTY);
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(String email) async {
    // TODO: implement forgotPassword
    return await _appServiceClient.forgotPassword(email);
  }

  @override
  Future<AuthenticationResponse> register(
      RegisterRequest registerRequest) async {
    // TODO: implement register
    return await _appServiceClient.register(
        registerRequest.countryMobileCode,
        registerRequest.name,
        registerRequest.email,
        registerRequest.password,
        registerRequest.mobileNumber,
        registerRequest.profilePicture);
  }

  @override
  Future<HomeResponse> getHome() async {
    // TODO: implement getHome
    return await _appServiceClient.getHome();
  }
}
