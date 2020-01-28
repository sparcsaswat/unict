import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../models/localpropertydata.dart';
import '../controllers/auth.dart';
import '../localization/app_translations.dart';
import '../utils/db_helper.dart';
import '../widgets/appformcards.dart';
import './infophotonint.dart';

class FirstPartnerPage extends StatefulWidget {
  FirstPartnerPage({this.localdata});
  final LocalPropertySurvey localdata;
  @override
  _FirstPartnerPageState createState() => _FirstPartnerPageState();
}

class _FirstPartnerPageState extends State<FirstPartnerPage> {
  LocalPropertySurvey localdata;
  var _formkey = GlobalKey<FormState>();
  Future<String> appimagepicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    var apppath = await getApplicationDocumentsDirectory();
    var filename = image.path.split("/").last;
    var localfile = await image.copy('${apppath.path}/$filename');
    return localfile.path;
  }

  String setapptext({String key}) {
    return AppTranslations.of(context).text(key);
  }

  Widget formheader({String headerlablekey}) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(177, 201, 224, 1),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            setapptext(key: headerlablekey),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget nextbutton() {
    return GestureDetector(
      onTap: () async {
        if (!(_formkey.currentState.validate())) {
          return;
        } else {
          _formkey.currentState.save();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => InfoPhotoHintPage(
                localdata: localdata,
              ),
            ),
          );
        }
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Text(
              "Next",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget backbutton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Row(
          children: <Widget>[
            Icon(Icons.arrow_back_ios),
            Text(
              "Back",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    localdata = new LocalPropertySurvey();
    localdata = widget.localdata;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Property Survey",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<DBHelper>(
        builder: (context, dbdata, child) {
          return dbdata.state == AppState.Busy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //header
                        formheader(headerlablekey: 'key_first_partner'),
                        //body
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              formcardtextfield(
                                  headerlablekey: 'key_name',
                                  radiovalue: localdata
                                              .first_partner_name_property_owner
                                              ?.isEmpty ??
                                          true
                                      ? false
                                      : true,
                                  initvalue: localdata
                                              .first_partner_name_property_owner
                                              ?.isEmpty ??
                                          true
                                      ? ""
                                      : localdata
                                          .first_partner_name_property_owner,
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return "field should not be blank";
                                    }
                                  },
                                  onSaved: (value) {
                                    localdata
                                            .first_partner_name_property_owner =
                                        value.trim();
                                  },
                                  onChanged: (value) {
                                    localdata
                                            .first_partner_name_property_owner =
                                        value.trim();
                                    setState(() {});
                                  }),
                              formcardtextfield(
                                  headerlablekey: 'key_surname',
                                  radiovalue: localdata
                                              .first_partner_surname?.isEmpty ??
                                          true
                                      ? false
                                      : true,
                                  initvalue: localdata
                                              .first_partner_surname?.isEmpty ??
                                          true
                                      ? ""
                                      : localdata.first_partner_surname,
                                  onSaved: (value) {
                                    localdata.first_partner_surname =
                                        value.trim();
                                  },
                                  onChanged: (value) {
                                    localdata.first_partner_surname =
                                        value.trim();
                                    setState(() {});
                                  }),
                              formcardtextfield(
                                  headerlablekey: 'key_wold',
                                  radiovalue:
                                      localdata.first_partner_boy?.isEmpty ??
                                              true
                                          ? false
                                          : true,
                                  initvalue:
                                      localdata.first_partner_boy?.isEmpty ??
                                              true
                                          ? ""
                                          : localdata.first_partner_boy,
                                  onSaved: (value) {
                                    localdata.first_partner_boy = value.trim();
                                  },
                                  onChanged: (value) {
                                    localdata.first_partner_boy = value.trim();
                                    setState(() {});
                                  }),
                              formcardtextfield(
                                  headerlablekey: 'key_birth',
                                  radiovalue: localdata
                                              .first_partner__father?.isEmpty ??
                                          true
                                      ? false
                                      : true,
                                  initvalue: localdata
                                              .first_partner__father?.isEmpty ??
                                          true
                                      ? ""
                                      : localdata.first_partner__father,
                                  onSaved: (value) {
                                    localdata.first_partner__father =
                                        value.trim();
                                  },
                                  onChanged: (value) {
                                    localdata.first_partner__father =
                                        value.trim();
                                    setState(() {});
                                  }),
                              formCardDropdown(
                                  value: localdata.first_partner_name_gender
                                              ?.isEmpty ??
                                          true
                                      ? "0"
                                      : localdata.first_partner_name_gender,
                                  iscompleted: ((localdata
                                                  .first_partner_name_gender
                                                  ?.isEmpty ??
                                              true) ||
                                          (localdata
                                                  .first_partner_name_gender ==
                                              "0"))
                                      ? false
                                      : true,
                                  headerlablekey: 'key_gender',
                                  dropdownitems: [
                                    Dpvalue(
                                        name: setapptext(
                                            key: 'key_none_selected'),
                                        value: "0"),
                                    Dpvalue(
                                        name: setapptext(key: 'key_male'),
                                        value: "1"),
                                    Dpvalue(
                                        name: setapptext(key: 'key_female'),
                                        value: "2"),
                                  ],
                                  onSaved: (String value) {
                                    localdata.first_partner_name_gender = value;
                                  },
                                  onChanged: (value) {
                                    localdata.first_partner_name_gender = value;
                                    setState(() {});
                                  },
                                  validate: (value) {
                                    if ((value.isEmpty) || value == "0") {
                                      return "required";
                                    }
                                  }),
                              formcardtextfield(
                                  keyboardtype: TextInputType.number,
                                  headerlablekey: 'key_phone',
                                  radiovalue: localdata.first_partner_name_phone
                                              ?.isEmpty ??
                                          true
                                      ? false
                                      : true,
                                  initvalue: localdata.first_partner_name_phone
                                              ?.isEmpty ??
                                          true
                                      ? ""
                                      : localdata.first_partner_name_phone,
                                  onSaved: (value) {
                                    localdata.first_partner_name_phone =
                                        value.trim();
                                  },
                                  onChanged: (value) {
                                    localdata.first_partner_name_phone =
                                        value.trim();
                                    setState(() {});
                                  },
                                  validator: (value) {
                                    if (value.length != 10) {
                                      return "Please enter the correct mobile number";
                                    }
                                  }),
                              formcardtextfield(
                                  keyboardtype: TextInputType.emailAddress,
                                  headerlablekey: 'key_email',
                                  radiovalue: localdata.first_partner_name_email
                                              ?.isEmpty ??
                                          true
                                      ? false
                                      : true,
                                  initvalue: localdata.first_partner_name_email
                                              ?.isEmpty ??
                                          true
                                      ? ""
                                      : localdata.first_partner_name_email,
                                  validator: (value) {
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = new RegExp(pattern);
                                    if (!regex.hasMatch(value))
                                      return 'Enter Valid Email';
                                    else
                                      return null;
                                  },
                                  onSaved: (value) {
                                    localdata.first_partner_name_email =
                                        value.trim();
                                  },
                                  onChanged: (value) {
                                    localdata.first_partner_name_email =
                                        value.trim();
                                    setState(() {});
                                  }),
                              Container(
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
                                      border: Border.all(
                                          color:
                                              Color.fromRGBO(176, 174, 171, 1),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            completedcheckbox(
                                                isCompleted: localdata
                                                            .first_partner_name_property_owner
                                                            ?.isEmpty ??
                                                        true
                                                    ? false
                                                    : true),
                                            Flexible(
                                              child: Text(
                                                setapptext(
                                                    key: 'key_photo_owner'),
                                                style: TextStyle(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8, bottom: 10),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            child: Column(
                                              children: <Widget>[
                                                RaisedButton(
                                                  child: Text(
                                                      "Click here to capture image. (< 10MB)"),
                                                  onPressed: () async {
                                                    localdata
                                                            .first_partner_name_property_owner =
                                                        await appimagepicker();
                                                    setState(() {});
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: localdata
                                                        .first_partner_name_property_owner
                                                        ?.isEmpty ??
                                                    true
                                                ? Center(
                                                    child: Text("No image"),
                                                  )
                                                : Image.file(File(localdata
                                                    .first_partner_name_property_owner)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              formcardtextfield(
                                  headerlablekey: 'key_enter_any_mere',
                                  radiovalue: localdata
                                              .first_partner_name_mere_individuals
                                              ?.isEmpty ??
                                          true
                                      ? false
                                      : true,
                                  initvalue: localdata
                                              .first_partner_name_mere_individuals
                                              ?.isEmpty ??
                                          true
                                      ? ""
                                      : localdata
                                          .first_partner_name_mere_individuals,
                                  onSaved: (value) {
                                    localdata
                                            .first_partner_name_mere_individuals =
                                        value.trim();
                                  },
                                  onChanged: (value) {
                                    localdata
                                            .first_partner_name_mere_individuals =
                                        value.trim();
                                    setState(() {});
                                  }),
                              SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                        ),
                        //footer
                        Container(
                          child: Column(
                            children: <Widget>[
                              Divider(
                                color: Colors.blueAccent,
                              ),
                              Container(
                                color: Colors.white,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      backbutton(),
                                      nextbutton()
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}