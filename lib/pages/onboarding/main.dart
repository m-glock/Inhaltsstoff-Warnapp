import '../HomePage.dart';
import './OnboardingTitleWidget.dart';
import './OnboardingSwitchList.dart';
import './OnboardingRadioButtonTable.dart';
import './OnboardingCheckboxList.dart';
import './OnboardingSliderList.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  List<PreferenzesListTile> allergenePreferenceList = <PreferenzesListTile>[
    PreferenzesListTile("Nüsse", false),
    PreferenzesListTile("Lactose", false),
    PreferenzesListTile("Gluten", false),
    PreferenzesListTile("Histamin", false),
    PreferenzesListTile("Soja", false),
    PreferenzesListTile("Nüsse", false),
    PreferenzesListTile("Lactose", false),
    PreferenzesListTile("Gluten", false),
    PreferenzesListTile("Histamin", false),
    PreferenzesListTile("Soja", false),
    PreferenzesListTile("Nüsse", false),
    PreferenzesListTile("Lactose", false),
    PreferenzesListTile("Gluten", false),
    PreferenzesListTile("Histamin", false),
    PreferenzesListTile("Soja", false),
  ];

  List<PreferenzesListTile> nutrientsPreferenceList = <PreferenzesListTile>[
    PreferenzesListTile("B12", false),
    PreferenzesListTile("Vitamin D", false),
    PreferenzesListTile("Eisen", false),
    PreferenzesListTile("Magensium", false),
  ];

  List<UnwantedIngredientsListTile> unwantedIngrediencePreferenceList =
      <UnwantedIngredientsListTile>[
    UnwantedIngredientsListTile("Palmöl", preferenceOptions[1]),
    UnwantedIngredientsListTile("Zucker", preferenceOptions[1]),
    UnwantedIngredientsListTile(
        "Tierische Produkte", preferenceOptions[1]),
    UnwantedIngredientsListTile(
        "Verdickungsmittel", preferenceOptions[1]),
  ];

  List<UnwantedIngredientsListTile> unwantedIngrediencePreferenceList2 =
      <UnwantedIngredientsListTile>[
    UnwantedIngredientsListTile("Palmöl", preferenceOptions[1]),
    UnwantedIngredientsListTile("Zucker", preferenceOptions[1]),
    UnwantedIngredientsListTile(
        "Tierische Produkte", preferenceOptions[1]),
    UnwantedIngredientsListTile(
        "Verdickungsmittel", preferenceOptions[1]),
  ];

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
          bodyWidget: OnboardingSwitchList(
            list: allergenePreferenceList,
            onChange: (int index, bool isSelected) {
              setState(() {
                allergenePreferenceList[index].isSelected = isSelected;
              });
            },
          ),
          decoration: MainPageDecoration,
        ),
        PageViewModel(
          titleWidget: OnboardingTitleWidget(
            title: "Preferenzen",
            subTitle: "Gibt es Nährstoffe, die du bewusst aufnehmen möchtest?",
          ),
          bodyWidget: OnboardingCheckboxList(
            list: nutrientsPreferenceList,
            onChange: (int index, bool isSelected) {
              setState(() {
                nutrientsPreferenceList[index].isSelected = isSelected;
              });
            },
          ),
          decoration: MainPageDecoration,
        ),
        PageViewModel(
          titleWidget: OnboardingTitleWidget(
            title: "Preferenzen",
            subTitle:
                "Welche Inhaltsstoffe möchtest du möglichst wenig oder gar nicht konsumieren?",
          ),
          bodyWidget: OnboardingRadioButtonTable(
            list: unwantedIngrediencePreferenceList,
            onChange: (int index, String newPreferenceValue) {
              if (preferenceOptions.contains(newPreferenceValue)) {
                setState(() {
                  unwantedIngrediencePreferenceList[index].preference =
                      newPreferenceValue;
                });
              } else {
                throw ErrorDescription('illegal State: newPreferenceValue is not included in PreferenceOptions');
              }
            },
          ),
          decoration: MainPageDecoration,
        ),
        PageViewModel(
          titleWidget: OnboardingTitleWidget(
            title: "Preferenzen",
            subTitle:
                "Welche Inhaltsstoffe möchtest du möglichst wenig oder gar nicht konsumieren?",
          ),
          bodyWidget: OnboardingSliderList(
            list: unwantedIngrediencePreferenceList2,
            onChange: (int index, String newPreferenceValue) {
              if (preferenceOptions.contains(newPreferenceValue)) {
                setState(() {
                  unwantedIngrediencePreferenceList2[index].preference =
                      newPreferenceValue;
                });
              } else {
                throw ErrorDescription('illegal State: newPreferenceValue is not included in PreferenceOptions');
              }
            },
          ),
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
