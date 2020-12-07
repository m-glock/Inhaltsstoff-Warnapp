import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';

import './OnboardingSummary.dart';
import './OnboardingTitleWidget.dart';
import '../HomePage.dart';
import '../../customWidgets/RadioButtonTable.dart';
import '../../customWidgets/CheckboxList.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Map<String, List<String>> preferences = {
    "allergens": [],
    "nutrients": [],
    "unwantedIngredientsFew": [],
    "unwantedIngredientsNothing": [],
  };
  List<String> allergenOptions = [
    "Nüsse",
    "Lactose",
    "Gluten",
    "Histamin",
    "Soja"
  ];
  List<String> nutrientOptions = ["B12", "Eisen", "Vitamin D", "Magnesium"];
  List<String> ingredientOptions = [
    "Palmöl",
    "Zucker",
    "Tierische Produkte",
    "Verdickungsmittel"
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

  void _animateToPage(String pageName) {
    int pageIndex = pageName == "allergens"
        ? 1
        : pageName == "nutrients"
            ? 2
            : 3;
    introKey.currentState.animateScroll(pageIndex);
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
      titlePadding: EdgeInsets.only(bottom: 8.0),
    );
    const SummaryPageDecoration = const PageDecoration(
      descriptionPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      contentPadding: EdgeInsets.zero,
      pageColor: Colors.white,
      titlePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Willkommen",
          bodyWidget: Column(
            children: [
              Text(
                "Mit der Inhaltstoff Warnapp kannst du beim Einkaufen schnell und unkompliziert erkennen, ob du ein Produkt aufgrund seiner Inhaltsstoffe essen kannst.",
                textAlign: TextAlign.center,
              ),
              Padding(
                child: Text(
                  "Bevor es losgehen kann, erzähl uns ein bisschen über deine Lebensmittelverträglichkeiten und Ernährungspräferenzen.",
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ],
          ),
          image: _buildImage("healthy_options"),
          decoration: ImagePageDecoration,
        ),
        PageViewModel(
          titleWidget: OnboardingTitleWidget(
            title: "Allergien",
            subTitle: "Hast du irgendwelche Allergien?",
          ),
          bodyWidget: CheckboxList(
            options: allergenOptions,
            selectedItems: preferences["allergens"],
            onChange: (int index, bool hasBeenSelected) {
              String changedItem = allergenOptions[index];
              setState(() {
                hasBeenSelected
                    ? preferences["allergens"].add(changedItem)
                    : preferences["allergens"].remove(changedItem);
              });
            },
          ),
          decoration: MainPageDecoration,
        ),
        PageViewModel(
          titleWidget: OnboardingTitleWidget(
            title: "Erwünschte Nährstoffe",
            subTitle:
                "Gibt es Nährstoffe, die du bewusst vermehrt aufnehmen möchtest?",
          ),
          bodyWidget: CheckboxList(
            options: nutrientOptions,
            selectedItems: preferences["nutrients"],
            onChange: (int index, bool hasBeenSelected) {
              String changedItem = nutrientOptions[index];
              setState(() {
                hasBeenSelected
                    ? preferences["nutrients"].add(changedItem)
                    : preferences["nutrients"].remove(changedItem);
              });
            },
          ),
          decoration: MainPageDecoration,
        ),
        PageViewModel(
          titleWidget: OnboardingTitleWidget(
            title: "Unerwünschte Inhaltsstoffe",
            subTitle:
                "Welche Inhaltsstoffe möchtest du möglichst wenig oder gar nicht konsumieren?",
          ),
          bodyWidget: RadioButtonTable(
            itemList: ingredientOptions,
            options: ["nichts", "egal", "wenig"],
            selectedItems: {
              "wenig": preferences["unwantedIngredientsFew"],
              "nichts": preferences["unwantedIngredientsNothing"],
              "egal": ingredientOptions.where((element) =>
                  !preferences["unwantedIngredientsFew"].contains(element) &&
                  !preferences["unwantedIngredientsNothing"].contains(element)).toList(),
            },
            onChange: (int index, String newPreferenceValue) {
              String changedItem = ingredientOptions[index];
              setState(() {
                switch (newPreferenceValue) {
                  case "wenig":
                    preferences["unwantedIngredientsNothing"]
                        .remove(changedItem);
                    preferences["unwantedIngredientsFew"].add(changedItem);
                    break;
                  case "nichts":
                    preferences["unwantedIngredientsFew"].remove(changedItem);
                    preferences["unwantedIngredientsNothing"].add(changedItem);
                    break;
                  case "egal":
                    preferences["unwantedIngredientsFew"].remove(changedItem);
                    preferences["unwantedIngredientsNothing"]
                        .remove(changedItem);
                    break;
                }
              });
            },
          ),
          decoration: MainPageDecoration,
        ),
        PageViewModel(
          titleWidget: OnboardingTitleWidget(
            title: "Zusammenfassung",
            subTitle: "Kontrolliere deine Auswahl und bearbeite sie wenn nötig",
          ),
          bodyWidget: OnboardingSummary(
            preferences: preferences,
            onEditPreference: _animateToPage,
          ),
          decoration: SummaryPageDecoration,
        ),
        PageViewModel(
          title: "Geschafft!",
          bodyWidget: Column(
            children: [
              Text(
                "Jetzt da du uns deine Präferenzen mitgeteilt hast, können wir deine Lebensmittel anhand deiner Präferenzen für dich in geeignet oder ungeeignet einstufen. Scanne dazu einfach das jeweilige Produkt mit dem Barcode-scanner ein und schon siehst du das Ergebnis.",
                textAlign: TextAlign.center,
              ),
              Padding(
                child: Text(
                  "Lass uns einkaufen gehen!",
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ],
          ),
          image: _buildImage("shopping_app"),
          decoration: ImagePageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      dotsFlex: 0,
      skip: Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: Icon(Icons.arrow_forward),
      done: Text('Starten', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
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
