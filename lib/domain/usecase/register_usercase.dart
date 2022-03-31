import 'package:complete_advanced_flutter/app/functions.dart';
import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/domain/repository/repository.dart';
import 'package:complete_advanced_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class RegisterUseCase
    implements BaseUseCase<RegisterUseCaseInput, Authentication> {
  Repository _repository;
  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      RegisterUseCaseInput input) async {
    DeviceInfo deviceInfo = await getDeviceDetails();
    return await _repository.register(RegisterRequest(
        input.name,
        input.countryMobileCode,
        input.email,
        input.password,
        input.mobileNumber,
        input.profilePicture));
  }
}

class RegisterUseCaseInput {
  String name;
  String countryMobileCode;
  String mobileNumber;
  String email;
  String password;
  String profilePicture;

  RegisterUseCaseInput(this.name, this.countryMobileCode, this.email,
      this.password, this.profilePicture, this.mobileNumber);
}
