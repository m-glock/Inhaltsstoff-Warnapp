import 'package:flutter/material.dart';

class SettingsAgbPage extends StatelessWidget {
  const SettingsAgbPage({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AGB'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: ListView(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              children: <Widget>[
                Text(
                  'Geschäftsbedingungen',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0, 
                    horizontal: 32.0
                  ),
                  child: Text('Wenn Sie diese App herunterladen oder verwenden, gelten diese Bedingungen automatisch für Sie.\n\nSie sollten daher sicherstellen, dass Sie die AGBs sorgfältig lesen, bevor Sie die App verwenden. \n\nEs ist Ihnen nicht gestattet, die App, einen Teil der App oder unsere Marken in irgendeiner Weise zu kopieren oder zu ändern. Sie dürfen den Quellcode der App nicht extrahieren. \n\nSie dürfen diese App nicht in andere Sprachen übersetzen oder abgeleitete Versionen erstellen. \n\nDie App selbst und alle damit verbundenen Marken, Urheberrechte, Datenbankrechte und sonstigen Rechte an geistigem Eigentum gehören weiterhin MAPH Software. MAPH Software setzt sich dafür ein, dass die App so nützlich und effizient wie möglich ist. Aus diesem Grund behalten wir uns das Recht vor, jederzeit und aus beliebigen Gründen Änderungen an der App vorzunehmen. \n\nWir werden Ihnen niemals die App oder ihre Dienste in Rechnung stellen, ohne Ihnen genau klar zu machen, wofür Sie bezahlen. \n\nDie EssBar-App speichert und verarbeitet personenbezogene Daten, die Sie uns zur Verfügung gestellt haben, um unseren Service bereitzustellen. \n\nEs liegt in Ihrer Verantwortung, Ihr Telefon und den Zugriff auf die App sicher zu halten. Wir empfehlen daher, dass Sie Ihr Telefon nicht jailbreaken oder rooten. Hierbei handelt es sich um das Entfernen von Softwareeinschränkungen und -beschränkungen, die vom offiziellen Betriebssystem Ihres Geräts auferlegt werden. Dies könnte Ihr Telefon für Malware anfällig machen.',
                    style: Theme
                .of(context)
                .textTheme
                .bodyText1,
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            ),
    );
  }
}