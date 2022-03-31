import 'package:complete_advanced_flutter/data/data_source/remote_data_source.dart';
import 'package:complete_advanced_flutter/data/mapper/mapper.dart';
import 'package:complete_advanced_flutter/data/network/error_handler.dart';
import 'package:complete_advanced_flutter/data/network/network_info.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

class RepositoryImpl extends Repository {
  RemoteDataSource _remoteDataSource;
  NetworkInfo _networkInfo;
  RepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    // TODO: implement login
    if (await _networkInfo.isConnected) {
      try {
        // its safge to call the api
        final response = await _remoteDataSource.login(loginRequest);
        if (response.status == ApiInternalStatus.SUCESS) {
          //return data (success)
          return Right(response.toDomain());
        } else {
          return Left(Failure(response.status ?? ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.UNKNOW));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return connection error
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    // TODO: implement forgotPassword
     if (await _networkInfo.isConnected) {
      try {
        // its safe to call API
        final response = await _remoteDataSource.forgotPassword(email);

        if (response.status == ApiInternalStatus.SUCESS) {
          // success
          // return right
          return Right(response.toDomain());
        } else {
          // failure
          // return left
          return Left(Failure(response.status ?? ResponseCode.UNKNOW,
              response.message ?? ResponseMessage.UNKNOW));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return network connection error
      // return left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(RegisterRequest registerRequest) async {
    // TODO: implement register
    if (await _networkInfo.isConnected) {
      try {
        // its safge to call the api
        final response = await _remoteDataSource.register(registerRequest);
        if (response.status == ApiInternalStatus.SUCESS) {
          //return data (success)
          return Right(response.toDomain());
        } else {
          return Left(Failure(response.status ?? ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.UNKNOW));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return connection error
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
