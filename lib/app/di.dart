import 'package:complete_advanced_flutter/app/app_prefs.dart';
import 'package:complete_advanced_flutter/data/data_source/local_data_source.dart';
import 'package:complete_advanced_flutter/data/data_source/remote_data_source.dart';
import 'package:complete_advanced_flutter/data/network/app_api.dart';
import 'package:complete_advanced_flutter/data/network/dio_factory.dart';
import 'package:complete_advanced_flutter/data/network/network_info.dart';
import 'package:complete_advanced_flutter/data/repository/repository_impl.dart';
import 'package:complete_advanced_flutter/domain/repository/repository.dart';
import 'package:complete_advanced_flutter/domain/usecase/forgot_password_usecase.dart';
import 'package:complete_advanced_flutter/domain/usecase/home_usecase.dart';
import 'package:complete_advanced_flutter/domain/usecase/login_usecase.dart';
import 'package:complete_advanced_flutter/domain/usecase/register_usercase.dart';
import 'package:complete_advanced_flutter/presentation/forgot_password/forgot_password_viewmodel.dart';
import 'package:complete_advanced_flutter/presentation/login/login_viewmodel.dart';
import 'package:complete_advanced_flutter/presentation/main/home/home_viewmodel.dart';
import 'package:complete_advanced_flutter/presentation/register/register_viewmodel.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  instance.registerLazySingleton<AppPreferences>(
      () => AppPreferences(instance<SharedPreferences>()));

  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(DataConnectionChecker()));

  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  final dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance()));
  
  instance.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImpl());

  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    instance.registerFactory<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(instance()));
    instance.registerFactory<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(instance()));
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}
