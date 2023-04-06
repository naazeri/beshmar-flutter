import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../utils/responsive.dart';
import '../utils/styles.dart';
import 'home_page.dart';

class IntroductionPage extends StatelessWidget {
  final String homeTitle;

  const IntroductionPage({required this.homeTitle, super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: getModelsList(context),
      showBackButton: true,
      showNextButton: true,
      showSkipButton: false,
      next: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
      back: const Icon(Icons.arrow_back_rounded, color: Colors.white),
      done: const Icon(Icons.check_rounded, color: Colors.white),
      onDone: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => HomePage(title: homeTitle),
          ),
          (_) => false,
        );
      },
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Colors.blue.shade800,
        color: Colors.white,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }

  List<PageViewModel> getModelsList(BuildContext context) {
    final pageDecoration = PageDecoration(
      pageColor: Colors.blue.shade400,
      titleTextStyle: Styles.textHeader1.copyWith(color: Colors.white),
      bodyTextStyle: Styles.textHeader3White,
    );
    final imageWidth = Responsive.getScreenSize(context).width * 0.45;
    const double borderRadius = 1000.0;

    return [
      PageViewModel(
        title: "هر چیزی رو بشمار",
        body: 'چه افزایشی چه کاهشی',
        image: Image.asset(
          'asset/image/icon.png',
          width: imageWidth + 30,
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "کتاب صوتی",
        body:
            "فرض کن بخوای ۵ بار هر فصل کتاب رو گوش کنی بعدش بری فصل بعد. میتونی تعدادشو توی اپ وارد کنی تا یادت بمونه چند بار تکرارش کردی",
        image: getImage(
          context,
          Icons.headphones_outlined,
          borderRadius,
          imageWidth,
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "درس و کنکور",
        body:
            'اگه میخوای برای کنکور درس ها رو چند بار مرور کنی میتونی تعدادشو وارد کنی تا به اندازه مدنظرت مرورشون کنی',
        image: getImage(
          context,
          Icons.menu_book_rounded,
          borderRadius,
          imageWidth,
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "رقابت",
        body: 'میتونی نتایج هر راند بازی ها یا مسابقه ها رو یادداشت کنی',
        image: getImage(
          context,
          Icons.sports_score_rounded,
          borderRadius,
          imageWidth,
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "تعدادش یادت بمونه",
        body:
            'در کل هر چیزی که نیاز هست تا تعدادش رو به یاد داشته باشی، میتونی اینجا وارد کنی',
        image: getImage(
          context,
          Icons.format_list_numbered_rounded,
          borderRadius,
          imageWidth,
        ),
        decoration: pageDecoration,
      ),
    ];
  }

  Widget getImage(
    BuildContext context,
    IconData icon,
    double borderRadius,
    double imageWidth,
  ) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        icon,
        size: imageWidth,
        color: Colors.grey.shade900,
      ),
    );
  }
}
