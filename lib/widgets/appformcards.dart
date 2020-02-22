import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/locator.dart';
import '../utils/language_service.dart';

enum CheckColor { Black, Green, Red }

class Dpvalue {
  String name;
  String value;
  Dpvalue({this.name, this.value});
}

Future<String> appimagepicker() async {
  var image =
      await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 30);
  var apppath = await getApplicationDocumentsDirectory();
  var filename = image.path.split("/").last;
  var localfile = await image.copy('${apppath.path}/$filename');
  return localfile.path;
}

Widget completedcheckbox({CheckColor isCompleted}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        //color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border.all(color: getCheckColor(isCompleted), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            color: getCheckColor(isCompleted),
          ),
        ),
      ),
    ),
  );
}

Color getCheckColor(CheckColor cc) {
  Color choosenColor = Colors.black;
  try {
    switch (cc) {
      case CheckColor.Black:
        choosenColor = Colors.black;
        break;
      case CheckColor.Green:
        choosenColor = Colors.lightGreen;
        break;
      case CheckColor.Red:
        choosenColor = Colors.red;
        break;
      default:
    }
  } catch (e) {
    print(e);
  }
  return choosenColor;
}

Widget formcardtextfield(
    {TextInputType keyboardtype,
    String initvalue,
    String headerlablekey,
    CheckColor radiovalue,
    String hinttextkey,
    Function(String) onSaved,
    Function(String) validator,
    Function(String) onChanged,
    FocusNode fieldfocus,
    TextInputAction textInputAction,
    void Function(String) onFieldSubmitted,
    Widget suffix,
    bool enable}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.all(10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(176, 174, 171, 1), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: locator<LanguageService>().currentlanguage == 0
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: <Widget>[
                if (locator<LanguageService>().currentlanguage == 0) ...{
                  completedcheckbox(isCompleted: radiovalue),
                  Flexible(
                    child: Text(
                      headerlablekey,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      maxLines: 2,
                      style: TextStyle(),
                    ),
                  ),
                } else ...{
                  Flexible(
                    child: Text(
                      headerlablekey,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      maxLines: 2,
                      style: TextStyle(),
                    ),
                  ),
                  completedcheckbox(isCompleted: radiovalue),
                }
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: TextFormField(
                textDirection: locator<LanguageService>().currentlanguage == 0
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                enabled: enable,
                keyboardType: keyboardtype,
                initialValue: initvalue?.isEmpty ?? true ? "" : initvalue,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.redAccent),
                  suffixIcon: suffix,
                  hintText: hinttextkey?.isEmpty ?? true ? "" : hinttextkey,
                ),
                onSaved: onSaved,
                validator: validator,
                onChanged: onChanged,
                focusNode: fieldfocus,
                textInputAction: textInputAction,
                onFieldSubmitted: onFieldSubmitted,
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget formCardDropdown(
    {CheckColor iscompleted,
    String headerlablekey,
    List<Dpvalue> dropdownitems,
    Function(String) onSaved,
    String value,
    Function(String) validate,
    FocusNode fieldfocus,
    Function(String) onChanged}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.all(10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(176, 174, 171, 1), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: locator<LanguageService>().currentlanguage == 0
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: <Widget>[
                if (locator<LanguageService>().currentlanguage == 0) ...[
                  completedcheckbox(isCompleted: iscompleted),
                  Flexible(
                    child: Text(
                      headerlablekey,
                      style: TextStyle(),
                      //overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ] else ...[
                  Flexible(
                    child: Text(
                      headerlablekey,
                      style: TextStyle(),
                      //overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  completedcheckbox(isCompleted: iscompleted),
                ]
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: Directionality(
                textDirection: locator<LanguageService>().currentlanguage == 0
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButtonFormField<String>(
                    items: dropdownitems.map((Dpvalue data) {
                      return DropdownMenuItem<String>(
                        value: data.value,
                        child: Container(
                          alignment:
                              locator<LanguageService>().currentlanguage == 0
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: Text(
                            data.name,
                          ),
                        ),
                      );
                    }).toList(),
                    validator: validate,
                    onChanged: onChanged,
                    onSaved: onSaved,
                    value: value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
