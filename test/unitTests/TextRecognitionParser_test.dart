import 'package:collection/collection.dart';
import 'package:Essbar/backend/TextRecognitionParser.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){

  TestWidgetsFlutterBinding.ensureInitialized();

  test('text1', () async {
    String text = 'Zutaten: 79% Sahne, Zucker, Molkerzeugnis, modifizierte Stärke, '
        '2.1% fettarmer Kakao, Speisegelatine (Rind), Verdickungsmittel: Carrageen; '
        'Emulgator: Mono- und Diglyceride von Speisefettsäuren; Milcheiweiß, Stickstoff.';
    List<String> expectedNames = ['Sahne', 'Zucker', 'Molkerzeugnis',
      'modifizierte Stärke', 'fettarmer Kakao', 'Speisegelatine (Rind)',
      'Carrageen', 'Mono- und Diglyceride von Speisefettsäuren', 'Milcheiweiß',
      'Stickstoff'];

    List<String> parsedIngredientNames = await TextRecognitionParser.parseIngredientNames(text);
    bool listsAreEqual = ListEquality().equals(parsedIngredientNames, expectedNames);
    expect(listsAreEqual, isTrue);
  });

  test('text2', () async {
    String text = 'Koffeinhaltiges Erfrischungsgetränk mit Pflanzenextrakten. '
        'Zutaten: Wasser, Zucker, Kohlensäure, Farbstoff E150d, Säuerungsmittel '
        'Phosphorsäure, natürliches Aroma, Aroma Koffein';
    List<String> expectedNames = ['Wasser', 'Zucker', 'Kohlensäure', 'E150d',
      'Phosphorsäure', 'natürliches Aroma', 'Aroma Koffein'];

    List<String> parsedIngredientNames = await TextRecognitionParser.parseIngredientNames(text);
    bool listsAreEqual = ListEquality().equals(parsedIngredientNames, expectedNames);
    expect(listsAreEqual, isTrue);
  });

  test('text3', () async {
    String text = 'Zutaten: 76% Butter, 7% Zwiebeln, 6% Petersilie, Wasser, '
        '3% Knoblauch, 1,8% Speisesalz, 1% Schnittlauch, 1% Kräuter (Dill, Zwiebellauch, Basilikum), '
        'Gewürze, natürliches Aroma, Säuerungsmittel: Citronensäure';
    List<String> expectedNames = ['Butter', 'Zwiebeln', 'Petersilie', 'Wasser',
      'Knoblauch', 'Speisesalz', 'Schnittlauch', 'Gewürze', 'natürliches Aroma',
      'Citronensäure', 'Dill', 'Zwiebellauch', 'Basilikum'];

    List<String> parsedIngredientNames = await TextRecognitionParser.parseIngredientNames(text);
    bool listsAreEqual = ListEquality().equals(parsedIngredientNames, expectedNames);
    expect(listsAreEqual, isTrue);
  });

  test('text4', () async {
    String text = 'Zutaten: 28% Schweinefleisch, HARTWEIZENGRIESS, Trinkwasser, '
        'Weißbrot (WEIZENMEHL, Trink-wasser, Speisesalz, Hefe), Spinat, Speck, VOLLEI**, '
        'Zwiebeln, Speisesalz, Petersilie, Dextrose, Stabilisator: Natriumcitrate, '
        'Gewürze, Gewürzextrakte (enthält SELLERIE), Rapsöl. Kann Spuren von '
        'MILCH, SOJA enthalten. **Eier aus Bodenhaltung';
    List<String> expectedNames = ['Schweinefleisch', 'HARTWEIZENGRIESS',
      'Trinkwasser', 'Spinat', 'Speck', 'VOLLEI', 'Zwiebeln', 'Speisesalz',
      'Petersilie', 'Dextrose', 'Natriumcitrate', 'Gewürze',
      'Gewürzextrakte (enthält SELLERIE)', 'Rapsöl', 'WEIZENMEHL', 'Trinkwasser',
      'Speisesalz', 'Hefe'];

    List<String> parsedIngredientNames = await TextRecognitionParser.parseIngredientNames(text);
    bool listsAreEqual = ListEquality().equals(parsedIngredientNames, expectedNames);
    expect(listsAreEqual, isTrue);
  });

  test('text5', () async {
    String text = 'Chili 70%, Zucker, Wasser, Salz, Säuerungsmittel: E260, E330; '
        'Stabilisator: E415; Geschmacksverstärker: E621; Konservierungsstoff: E202.';
    List<String> expectedNames = ['Chili', 'Zucker', 'Wasser', 'Salz', 'E260',
      'E330', 'E415', 'E621', 'E202'];

    List<String> parsedIngredientNames = await TextRecognitionParser.parseIngredientNames(text);
    bool listsAreEqual = ListEquality().equals(parsedIngredientNames, expectedNames);
    expect(listsAreEqual, isTrue);
  });
}