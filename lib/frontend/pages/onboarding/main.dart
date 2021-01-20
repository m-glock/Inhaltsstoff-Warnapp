import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';

import './onboardingCustomWidgets/OnboardingTitleWidget.dart';
import '../../customWidgets/preferences/PreferencesAllergensView.dart';
import '../../customWidgets/preferences/PreferencesNutrientsView.dart';
import '../../customWidgets/preferences/PreferencesOtherIngredientsView.dart';
import '../../customWidgets/preferences/PreferencesSummary.dart';
import '../../../backend/PreferenceManager.dart';
import '../../../backend/Ingredient.dart';
import '../../../backend/Enums/Type.dart';
import '../../../backend/Enums/PreferenceType.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  Map<Ingredient, PreferenceType> _allergenePreferences;
  Map<Ingredient, PreferenceType> _nutrientPreferences;
  Map<Ingredient, PreferenceType> _otherIngredientPreferences;

  Future<Map<Ingredient, PreferenceType>> getIngredients(Type type) async {
    Map<Ingredient, PreferenceType> ingredients = new Map();
    var getAllAvailIg =
        await PreferenceManager.getAllAvailableIngredients(type);
    ingredients = Map.fromIterable(
        getAllAvailIg.where((ingredient) => ingredient.type == type),
        key: (ingredient) => ingredient,
        value: (ingredient) => ingredient.preferenceType);
    return ingredients;
  }

  void _onFinishOnboarding(context) {
    // save _preferences
    PreferenceManager.changePreference(_allergenePreferences);
    PreferenceManager.changePreference(_nutrientPreferences);
    PreferenceManager.changePreference(_otherIngredientPreferences);

    Navigator.of(context).pushReplacementNamed('/');
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/images/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  void _animateToPage(String pageName) {
    int pageIndex = pageName == "allergens"
        ? 1
        : pageName == "nutrients"
            ? 2
            : 3;
    _introKey.currentState.animateScroll(pageIndex);
  }

  @override
  void initState() {
    super.initState();
    setIngredients();
  }

  void setIngredients() async {
    Map<Ingredient, PreferenceType> allergenePreferences =
        await getIngredients(Type.Allergen);
    Map<Ingredient, PreferenceType> nutrientPreferences =
        await getIngredients(Type.Nutriment);
    Map<Ingredient, PreferenceType> otherIngredientPreferences =
        await getIngredients(Type.General);
    setState(() {
      _allergenePreferences = allergenePreferences;
      _nutrientPreferences = nutrientPreferences;
      _otherIngredientPreferences = otherIngredientPreferences;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imagePageDecoration = PageDecoration(
      pageColor: Colors.white,
      titleTextStyle: Theme.of(context).textTheme.headline1,
      titlePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      bodyTextStyle: Theme.of(context).textTheme.bodyText1,
      descriptionPadding: EdgeInsets.all(16.0),
      imagePadding: EdgeInsets.fromLTRB(4.0, 32.0, 4.0, 0.0),
      imageFlex: 1,
    );
    final mainPageDecoration = PageDecoration(
      descriptionPadding: EdgeInsets.all(16.0),
      contentPadding: EdgeInsets.zero,
      pageColor: Colors.white,
      titlePadding: EdgeInsets.only(bottom: 8.0),
    );
    final summaryPageDecoration = PageDecoration(
      descriptionPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      contentPadding: EdgeInsets.zero,
      pageColor: Colors.white,
      titlePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      key: _introKey,
      pages: [
        PageViewModel(
          title: "Willkommen",
          bodyWidget: Column(
            children: [
              Text(
                "Mit der Inhaltsstoff Warnapp kannst du beim Einkaufen schnell und unkompliziert erkennen, ob du ein Produkt aufgrund seiner Inhaltsstoffe essen kannst.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Padding(
                child: Text(
                  "Bevor es losgehen kann, erzähl uns ein bisschen über deine Lebensmittelverträglichkeiten und Ernährungspräferenzen.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ],
          ),
          image: _buildImage("healthy_options"),
          decoration: imagePageDecoration,
        ),
        PageViewModel(
          titleWidget: OnboardingTitleWidget(
            title: "Allergien",
            subTitle: "Hast du irgendwelche Allergien?",
          ),
          bodyWidget: PreferencesAllergensView(
            allergenePreferences: _allergenePreferences,
            onChange:
                (Ingredient changedIngredient, PreferenceType newPreference) {
              setState(() {
                _allergenePreferences[changedIngredient] = newPreference;
              });
            },
          ),
          decoration: mainPageDecoration,
        ),
        PageViewModel(
          titleWidget: OnboardingTitleWidget(
            title: "Erwünschte Nährstoffe",
            subTitle:
                "Gibt es Nährstoffe, die du bewusst vermehrt aufnehmen möchtest?",
          ),
          bodyWidget: PreferencesNutrientsView(
            nutrientPreferences: _nutrientPreferences,
            onChange:
                (Ingredient changedIngredient, PreferenceType newPreference) {
              setState(() {
                _nutrientPreferences[changedIngredient] = newPreference;
              });
            },
          ),
          decoration: mainPageDecoration,
        ),
        PageViewModel(
          titleWidget: OnboardingTitleWidget(
            title: "Unerwünschte Inhaltsstoffe",
            subTitle:
                "Welche Inhaltsstoffe möchtest du möglichst wenig oder gar nicht konsumieren?",
          ),
          bodyWidget: PreferencesOtherIngredientsView(
            otherIngredientPreferences: _otherIngredientPreferences,
            onChange:
                (Ingredient changedIngredient, PreferenceType newPreference) {
              setState(() {
                _otherIngredientPreferences[changedIngredient] = newPreference;
              });
            },
          ),
          decoration: mainPageDecoration,
        ),
        PageViewModel(
          titleWidget: OnboardingTitleWidget(
            title: "Zusammenfassung",
            subTitle: "Kontrolliere deine Auswahl und bearbeite sie wenn nötig",
          ),
          bodyWidget: PreferencesSummary(
            allergenePreferences: _allergenePreferences,
            nutrientPreferences: _nutrientPreferences,
            otherIngredientPreferences: _otherIngredientPreferences,
            onEditPreference: _animateToPage,
          ),
          decoration: summaryPageDecoration,
        ),
        PageViewModel(
          title: "Geschafft!",
          bodyWidget: Column(
            children: [
              Text(
                "Jetzt da du uns deine Präferenzen mitgeteilt hast, können wir deine Lebensmittel anhand deiner Präferenzen für dich in geeignet, eingeschränkt geeignet oder ungeeignet einstufen. Scanne dazu einfach das jeweilige Produkt mit dem Barcode-scanner ein und schon siehst du das Ergebnis.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Padding(
                child: Text(
                  "Lass uns einkaufen gehen!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ],
          ),
          image: _buildImage("shopping_app"),
          decoration: imagePageDecoration,
        ),
      ],
      onDone: () => _onFinishOnboarding(context),
      showSkipButton: true,
      dotsFlex: 0,
      skip: Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: Icon(Icons.arrow_forward),
      done: Text('Starten', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Theme.of(context).disabledColor,
        activeColor: Theme.of(context).primaryColor,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
