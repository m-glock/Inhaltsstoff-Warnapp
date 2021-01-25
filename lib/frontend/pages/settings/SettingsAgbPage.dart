import 'package:flutter/material.dart';

class SettingsAgbPage extends StatelessWidget {
  const SettingsAgbPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AGB'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Geschäftsbedingungen',
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Allgemeines',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              '\nWenn Sie diese App herunterladen oder verwenden, gelten diese Bedingungen automatisch für Sie.\n\nSie sollten daher sicherstellen, dass Sie die AGBs sorgfältig lesen, bevor Sie die App verwenden. \n\nEs ist Ihnen nicht gestattet, die App, einen Teil der App oder unsere Marken in irgendeiner Weise zu kopieren oder zu ändern. Sie dürfen den Quellcode der App nicht extrahieren. \n\nSie dürfen diese App nicht in andere Sprachen übersetzen oder abgeleitete Versionen erstellen. \n\nDie App selbst und alle damit verbundenen Marken, Urheberrechte, Datenbankrechte und sonstigen Rechte an geistigem Eigentum gehören weiterhin MAPH Software. MAPH Software setzt sich dafür ein, dass die App so nützlich und effizient wie möglich ist. Aus diesem Grund behalten wir uns das Recht vor, jederzeit und aus beliebigen Gründen Änderungen an der App vorzunehmen. \n\nWir werden Ihnen niemals die App oder ihre Dienste in Rechnung stellen, ohne Ihnen genau klar zu machen, wofür Sie bezahlen. \n\nDie EssBar-App speichert und verarbeitet personenbezogene Daten, die Sie uns zur Verfügung gestellt haben, um unseren Service bereitzustellen. \n\nEs liegt in Ihrer Verantwortung, Ihr Telefon und den Zugriff auf die App sicher zu halten. Wir empfehlen daher, dass Sie Ihr Telefon nicht jailbreaken oder rooten. Hierbei handelt es sich um das Entfernen von Softwareeinschränkungen und -beschränkungen, die vom offiziellen Betriebssystem Ihres Geräts auferlegt werden. Dies könnte Ihr Telefon für Malware anfällig machen.',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Text(
              '§ 1 Warnhinweis zu Inhalten',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Die kostenlosen und frei zugänglichen Inhalte dieser Anwendung wurden mit größtmöglicher Sorgfalt erstellt. Der Anbieter dieser Anwendung übernimmt jedoch keine Gewähr für die Richtigkeit und Aktualität der bereitgestellten kostenlosen und frei zugänglichen journalistischen Ratgeber und Nachrichten. \n\nNamentlich gekennzeichnete Beiträge geben die Meinung des jeweiligen Autors und nicht immer die Meinung des Anbieters wieder. Allein durch den Aufruf der kostenlosen und frei zugänglichen Inhalte kommt keinerlei Vertragsverhältnis zwischen dem Nutzer und dem Anbieter zustande, insoweit fehlt es am Rechtsbindungswillen des Anbieters.',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Text(
              '§ 2 Externe Links',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Diese Anwendung enthält Verknüpfungen zu Websites Dritter (“externe Links”). Diese Websites unterliegen der Haftung der jeweiligen Betreiber. Der Anbieter hat bei der erstmaligen Verknüpfung der externen Links die fremden Inhalte daraufhin überprüft, ob etwaige Rechtsverstöße bestehen. Zu dem Zeitpunkt waren keine Rechtsverstöße ersichtlich. \n\nDer Anbieter hat keinerlei Einfluss auf die aktuelle und zukünftige Gestaltung und auf die Inhalte der verknüpften Seiten. Das Setzen von externen Links bedeutet nicht, dass sich der Anbieter die hinter dem Verweis oder Link liegenden Inhalte zu Eigen macht. \n\nEine ständige Kontrolle der externen Links ist für den Anbieter ohne konkrete Hinweise auf Rechtsverstöße nicht zumutbar. Bei Kenntnis von Rechtsverstößen werden jedoch derartige externe Links unverzüglich gelöscht.',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Text(
              '§ 3 Urheber- und Leistungsschutzrechte',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Die in dieser Anwendung veröffentlichten Inhalte unterliegen dem deutschen Urheber- und Leistungsschutzrecht. Jede vom deutschen Urheber- und Leistungsschutzrecht nicht zugelassene Verwertung bedarf der vorherigen schriftlichen Zustimmung des Anbieters oder jeweiligen Rechteinhabers. \n\nDies gilt insbesondere für Vervielfältigung, Bearbeitung, Übersetzung, Einspeicherung, Verarbeitung bzw. Wiedergabe von Inhalten in Datenbanken oder anderen elektronischen Medien und Systemen. Inhalte und Rechte Dritter sind dabei als solche gekennzeichnet. \n\nDie unerlaubte Vervielfältigung oder Weitergabe einzelner Inhalte oder kompletter Seiten ist nicht gestattet und strafbar. Lediglich die Herstellung von Kopien und Downloads für den persönlichen, privaten und nicht kommerziellen Gebrauch ist erlaubt.',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Text(
              '§ 4 Besondere Nutzungsbedingungen',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Soweit besondere Bedingungen für einzelne Nutzungen dieser Anwendung von den vorgenannten Paragraphen abweichen, wird an entsprechender Stelle ausdrücklich darauf hingewiesen. In diesem Falle gelten im jeweiligen Einzelfall die besonderen Nutzungsbedingungen.',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
