import 'package:Inhaltsstoff_Warnapp/pages/HomePage.dart';
import 'package:Inhaltsstoff_Warnapp/pages/onboarding/OnboardingTitleWidget.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new HomePage()));
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const ImagePageDecoration = const PageDecoration(
      pageColor: Colors.white,
      titleTextStyle: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w600),
      titlePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      bodyTextStyle: TextStyle(fontSize: 14.0),
      descriptionPadding: EdgeInsets.all(16.0),
      imagePadding: EdgeInsets.fromLTRB(4.0, 32.0, 4.0, 0.0),
      imageFlex: 1,
    );
    const MainPageDecoration = const PageDecoration(
      descriptionPadding: EdgeInsets.all(16.0),
      contentPadding: EdgeInsets.zero,
      pageColor: Colors.white,
    );
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Inhaltsstoff Warnapp",
          body: "Short describtion of what this app offers to ist users",
          image: _buildImage("healthy_options"),
          decoration: ImagePageDecoration,
        ),
        PageViewModel(
          titleWidget: OnboardingTitleWidget(
            title: "Preferenzen",
            subTitle: "Hast du irgendwelche Allergien?",
          ),
          body: "SelectWidget",
          decoration: MainPageDecoration,
        ),
        PageViewModel(
          titleWidget: OnboardingTitleWidget(
            title: "Preferenzen",
            subTitle: "Gibt es Nährstoffe, die du bewusst aufnehmen möchtest?",
          ),
          body: "SelectWidget",
          decoration: MainPageDecoration,
        ),
        PageViewModel(
          titleWidget: OnboardingTitleWidget(
            title: "Preferenzen",
            subTitle: "Welche Inhaltsstoffe möchtest du nicht konsumieren?",
          ),
          body: "SelectWidget",
          decoration: MainPageDecoration,
        ),
        PageViewModel(
          title: "Geschafft!",
          body:
              "Du hast das Setup abgeschlossen. Lass uns jetzt einkaufen gehen!",
          image: _buildImage("shopping_app"),
          decoration: ImagePageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      dotsFlex: 0,
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Fertig', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
