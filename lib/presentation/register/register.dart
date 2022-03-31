import 'dart:io';

import 'package:complete_advanced_flutter/app/app_prefs.dart';
import 'package:complete_advanced_flutter/app/di.dart';
import 'package:complete_advanced_flutter/data/mapper/mapper.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:complete_advanced_flutter/presentation/register/register_viewmodel.dart';
import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/routes_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/values_manager.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class RegisterView extends StatefulWidget {
  RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  RegisterViewModel _viewModel = instance<RegisterViewModel>();
  ImagePicker picker = instance<ImagePicker>();
  AppPreferences _appPreferences = instance<AppPreferences>();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _userNameTextEditingController =
      TextEditingController();
  TextEditingController _mobileNumberTextEditingController =
      TextEditingController();
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _bind();
    super.initState();
  }

  void _bind() {
    _viewModel.start();
    _userNameTextEditingController.addListener(() {
      _viewModel.setUserName(_userNameTextEditingController.text);
    });
    _mobileNumberTextEditingController.addListener(() {
      _viewModel.setMobileNumber(_mobileNumberTextEditingController.text);
    });
    _emailTextEditingController.addListener(() {
      _viewModel.setEmail(_emailTextEditingController.text);
    });
    _passwordTextEditingController.addListener(() {
      _viewModel.setPassword(_passwordTextEditingController.text);
    });
    _viewModel.isUserLoggedInSuccessfullyStreamController.stream
        .listen((isSuccessLoggedIn) {
      // navigate to main screen
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _appPreferences.setIsUserLoggedIn();
        Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: AppSize.s0,
        iconTheme: IconThemeData(color: ColorManager.primary),
        backgroundColor: ColorManager.white,
      ),
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return Center(
            child: snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _viewModel.register();
                }) ??
                _getContentWidget(),
          );
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: EdgeInsets.only(top: AppPadding.p20),
      color: ColorManager.white,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image(
                image: AssetImage(ImageAssets.splashlogo),
              ),
              SizedBox(height: AppSize.s20),
              Padding(
                padding: EdgeInsets.only(
                  left: AppPadding.p20,
                  right: AppPadding.p20,
                ),
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorUserNameValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _userNameTextEditingController,
                      decoration: InputDecoration(
                        hintText: AppStrings.username,
                        labelText: AppStrings.username,
                        errorText: snapshot.data,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: AppSize.s20),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AppPadding.p20,
                    right: AppPadding.p20,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: CountryCodePicker(
                            onChanged: (country) {
                              // update view model
                              _viewModel
                                  .setCountryCode(country.dialCode ?? EMPTY);
                            },
                            initialSelection: "+57",
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            hideMainText: true,
                            favorite: ["+57", "+02", "+39"],
                          )),
                      Expanded(
                        flex: 3,
                        child: StreamBuilder<String?>(
                          stream: _viewModel.outputErrorMobileNumberValid,
                          builder: (context, snapshot) {
                            return TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: _mobileNumberTextEditingController,
                              decoration: InputDecoration(
                                hintText: AppStrings.mobileNumber,
                                labelText: AppStrings.mobileNumber,
                                errorText: snapshot.data,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSize.s20),
              Padding(
                padding: EdgeInsets.only(
                  left: AppPadding.p20,
                  right: AppPadding.p20,
                ),
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorEmailValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextEditingController,
                      decoration: InputDecoration(
                          hintText: AppStrings.emailHint,
                          labelText: AppStrings.emailHint,
                          errorText: snapshot.data),
                    );
                  },
                ),
              ),
              SizedBox(height: AppSize.s20),
              Padding(
                padding: EdgeInsets.only(
                  left: AppPadding.p20,
                  right: AppPadding.p20,
                ),
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorPasswordValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordTextEditingController,
                      decoration: InputDecoration(
                          hintText: AppStrings.password,
                          labelText: AppStrings.password,
                          errorText: snapshot.data),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: AppPadding.p20,
                  left: AppPadding.p20,
                  right: AppPadding.p20,
                ),
                child: Container(
                  height: AppSize.s40,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManager.lightGrey),
                  ),
                  child: GestureDetector(
                    child: _getMediaWidget(),
                    onTap: () {
                      _showPicker(context);
                    },
                  ),
                ),
              ),
              SizedBox(height: AppSize.s20),
              Padding(
                padding: EdgeInsets.only(
                  left: AppPadding.p20,
                  right: AppPadding.p20,
                ),
                child: StreamBuilder<bool?>(
                  stream: _viewModel.outputIsAllInputsValid,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: double.infinity,
                      height: AppSize.s40,
                      child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () {
                                  _viewModel.register();
                                }
                              : null,
                          child: Text(AppStrings.register)),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: AppPadding.p8,
                    left: AppPadding.p20,
                    right: AppPadding.p20),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppStrings.haveAccount,
                    style: Theme.of(context).textTheme.subtitle2,
                    textAlign: TextAlign.end,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: EdgeInsets.only(left: AppPadding.p8, right: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(AppStrings.profilePicture),
          ),
          Flexible(
            child: StreamBuilder<File?>(
              stream: _viewModel.outputIsProfilePictureValid,
              builder: (context, snapshot) {
                return _imagePickedByUser(snapshot.data);
              },
            ),
          ),
          Flexible(
            child: SvgPicture.asset(ImageAssets.photoCamera),
          ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  trailing: Icon(Icons.arrow_forward),
                  leading: Icon(Icons.camera),
                  title: Text(AppStrings.photoGallery),
                  onTap: () {
                    _imageFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  trailing: Icon(Icons.arrow_forward),
                  leading: Icon(Icons.camera),
                  title: Text(AppStrings.photoCamera),
                  onTap: () {
                    _imageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ));
        });
  }

  Widget _imagePickedByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      return Image.file(image);
    } else {
      return Container();
    }
  }

  void _imageFromGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? EMPTY));
  }

  void _imageFromCamera() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? EMPTY));
  }
}

class _appPreferences {}
