import 'package:complete_advanced_flutter/app/app_prefs.dart';
import 'package:complete_advanced_flutter/app/di.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/presentation/onboarding/onboarding_viewmodel.dart';
import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/routes_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingView extends StatefulWidget {
  OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  PageController _pageController = PageController(initialPage: 0);
  OnBoardingViewModel _viewModel = OnBoardingViewModel();
  AppPreferences _appPreferences = instance<AppPreferences>();
  _bind() {
    _appPreferences.setOnBoardingScreenViewed();
    _viewModel.start();
  }

  @override
  void initState() {
    // TODO: implement initState
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: viewmodel.dispose()
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
      stream: _viewModel.outputSliderViewObject,
      builder: (context, snapShot) {
        return _getContentWidget(snapShot.data);
      },
    );
  }

  Widget _getContentWidget(SliderViewObject? sliderViewObject) {
    if (sliderViewObject == null) {
      return Container();
    } else {
      return Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: AppSize.s0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.white,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: PageView.builder(
            controller: _pageController,
            itemCount: sliderViewObject.numOfSlides,
            onPageChanged: (index) {
              _viewModel.OnPageChanged(index);
            },
            itemBuilder: (context, index) {
              return OnBoardingPage(sliderViewObject.sliderObject);
            }),
        bottomSheet: Container(
          color: ColorManager.white,
          height: AppSize.s100,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.loginRoute);
                  },
                  child: Text(
                    AppStrings.skip,
                    style: Theme.of(context).textTheme.subtitle2,
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              _getBottomSheetWidget(sliderViewObject)
            ],
          ),
        ),
      );
    }
  }

  Widget _getBottomSheetWidget(SliderViewObject sliderViewObject) {
    return Container(
      color: ColorManager.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: SizedBox(
                height: AppSize.s20,
                width: AppSize.s20,
                child: SvgPicture.asset(ImageAssets.leftArrow),
              ),
              onTap: () {
                _pageController.animateToPage(_viewModel.goPrevios(),
                    duration: Duration(milliseconds: DurationConstant.d300),
                    curve: Curves.bounceInOut);
              },
            ),
          ),
          Row(
            children: [
              for (var i = 0; i < sliderViewObject.numOfSlides; i++)
                Padding(
                  padding: EdgeInsets.all(AppPadding.p8),
                  child: _getProperCircle(i, sliderViewObject.currentIndex),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: SizedBox(
                height: AppSize.s20,
                width: AppSize.s20,
                child: SvgPicture.asset(ImageAssets.rightArrow),
              ),
              onTap: () {
                _pageController.animateToPage(_viewModel.goNext(),
                    duration: Duration(milliseconds: DurationConstant.d300),
                    curve: Curves.bounceInOut);
              },
            ),
          ),
        ],
      ),
    );
  }

  _getProperCircle(int index, int currentIndex) {
    if (index == currentIndex) {
      return SvgPicture.asset(ImageAssets.holloCircle);
    } else {
      return SvgPicture.asset(ImageAssets.solidCircle);
    }
  }
}

class OnBoardingPage extends StatelessWidget {
  final SliderObject _sliderObject;
  const OnBoardingPage(this._sliderObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: AppSize.s40,
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        SizedBox(
          height: AppSize.s60,
        ),
        SvgPicture.asset(_sliderObject.image)
      ],
    );
  }
}
