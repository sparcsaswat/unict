import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../models/localpropertydata.dart';
import '../utils/appstate.dart';
import '../localization/app_translations.dart';
import '../utils/db_helper.dart';
import '../widgets/appformcards.dart';
import './propertydetails.dart';
import './physicalstate.dart';

class PropertyLocationPage extends StatefulWidget {
  PropertyLocationPage({this.localdata});
  final LocalPropertySurvey localdata;
  @override
  _PropertyLocationPageState createState() => _PropertyLocationPageState();
}

class _PropertyLocationPageState extends State<PropertyLocationPage> {
  LocalPropertySurvey localdata;
  var _formkey = GlobalKey<FormState>();

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
        if (!(_formkey.currentState.validate()) ||
            (localdata.property_type?.isEmpty ?? true) ||
            (localdata.property_type == "0")) {
          return;
        } else {
          _formkey.currentState.save();
          //in edit mode
          if (localdata.editmode == 1) {
            if (localdata.isdrafted != 2) {
              var newloaclkey = localdata.province +
                  localdata.city +
                  localdata.area +
                  localdata.pass +
                  localdata.block +
                  localdata.part_number +
                  localdata.unit_number;
              if (newloaclkey != localdata.local_property_key) {
                var isexistPropertyId =
                    await DBHelper().ifpropertyexist(localkey: newloaclkey);
                if (isexistPropertyId) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            setapptext(key: 'key_warning'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          content: Text(setapptext(key: 'key_prop_data_exide')),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                setapptext(key: 'key_ok'),
                              ),
                            ),
                          ],
                        );
                      });
                } else {
                  await DBHelper().updatePropertySurvey(
                      localdata, localdata.local_property_key);
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: PropertyDetailsPage(
                          localdata: localdata,
                        ),
                        type: PageTransitionType.rightToLeft),
                  );
                }
              } else {
                await DBHelper().updatePropertySurvey(
                    localdata, localdata.local_property_key);
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: PropertyDetailsPage(
                        localdata: localdata,
                      ),
                      type: PageTransitionType.rightToLeft),
                );
              }
            } else {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: PropertyDetailsPage(
                        localdata: localdata,
                      ),
                      type: PageTransitionType.rightToLeft));
            }
          } else {
            localdata.local_property_key = localdata.province +
                localdata.city +
                localdata.area +
                localdata.pass +
                localdata.block +
                localdata.part_number +
                localdata.unit_number;
            int svval = await DBHelper().addPropertySurvey(localdata);
            if (svval == 0) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        setapptext(key: 'key_warning'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      content: Text(setapptext(key: 'key_prop_data_exide')),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            setapptext(key: 'key_ok'),
                          ),
                        ),
                      ],
                    );
                  });
            } else {
              localdata.isdrafted = 0;
              localdata.editmode = 1;
              await DBHelper().updateTaskStatus(taskid: localdata.taskid);
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: PropertyDetailsPage(
                        localdata: localdata,
                      ),
                      type: PageTransitionType.rightToLeft));
            }
          }
        }
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Text(
              setapptext(key: 'key_next'),
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget backbutton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: PhysicalStatePropertyPage(
                  localdata: localdata,
                ),
                type: PageTransitionType.leftToRight));
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Icon(Icons.arrow_back_ios, color: Colors.white),
            Text(
              setapptext(key: 'key_back'),
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  String getProvincename(String id) {
    var result = "";
    switch (id) {
      case "01-01":
        result = setapptext(key: 'key_kabul');
        break;
      case "06-01":
        result = setapptext(key: 'key_nangarhar');
        break;
      case "33-01":
        result = setapptext(key: 'key_Kandahar');
        break;
      case "10-01":
        result = setapptext(key: 'key_Bamyan');
        break;
      case "22-01":
        result = setapptext(key: 'key_Daikundi');
        break;
      case "17-01":
        result = setapptext(key: 'key_Kundoz');
        break;
      case "18-01":
        result = setapptext(key: 'key_Balkh');
        break;
      case "30-01":
        result = setapptext(key: 'key_Herat');
        break;
      case "03-01":
        result = setapptext(key: 'key_Parwan');
        break;
      case "04-01":
        result = setapptext(key: 'key_Farah');
        break;
      default:
        result = id;
    }
    return result;
  }

  String getCity(String id) {
    var result = "";
    switch (id) {
      case "1":
        result = setapptext(key: 'key_kabul');
        break;
      case "2":
        result = setapptext(key: 'key_Jalalabad');
        break;
      case "3":
        result = setapptext(key: 'key_Kandahar');
        break;
      case "4":
        result = setapptext(key: 'key_Bamyan');
        break;
      case "5":
        result = setapptext(key: 'key_Nili');
        break;
      case "6":
        result = setapptext(key: 'key_Kundoz');
        break;
      case "7":
        result = setapptext(key: 'key_Sharif');
        break;
      case "8":
        result = setapptext(key: 'key_Herat');
        break;
      case "9":
        result = setapptext(key: 'key_Charikar');
        break;
      case "10":
        result = setapptext(key: 'key_Farah');
        break;
      default:
        result = id;
    }
    return result;
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
          setapptext(key: 'key_property_survey'),
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
                        formheader(headerlablekey: 'key_property_location'),
                        //body
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              //province
                              formcardtextfield(
                                fieldrequired: true,
                                enable: false,
                                initvalue: localdata.province?.isEmpty ?? true
                                    ? ""
                                    : getProvincename(localdata.province),
                                headerlablekey:
                                    setapptext(key: 'key_select_province'),
                                radiovalue: localdata.province?.isEmpty ?? true
                                    ? CheckColor.Black
                                    : CheckColor.Green,
                              ),
                              //municipality
                              formcardtextfield(
                                fieldrequired: true,
                                enable: false,
                                initvalue: localdata.city?.isEmpty ?? true
                                    ? ""
                                    : getCity(localdata.city),
                                headerlablekey:
                                    setapptext(key: 'key_select_city'),
                                radiovalue: localdata.city?.isEmpty ?? true
                                    ? CheckColor.Black
                                    : CheckColor.Green,
                              ),
                              //district/nahia
                              formcardtextfield(
                                enable: false,
                                keyboardtype: TextInputType.number,
                                headerlablekey: setapptext(key: 'key_area'),
                                radiovalue: localdata.area?.isEmpty ?? true
                                    ? CheckColor.Black
                                    : CheckColor.Green,
                                hinttextkey:
                                    setapptext(key: 'Key_number_value'),
                                initvalue: localdata.area?.isEmpty ?? true
                                    ? ""
                                    : localdata.area,
                                fieldrequired: true,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return setapptext(
                                        key: 'key_field_not_blank');
                                  } else if (value.length != 2) {
                                    return setapptext(key: 'key_two_digit');
                                  }
                                },
                                onSaved: (value) {
                                  localdata.area = value.trim();
                                },
                                onChanged: (value) {
                                  localdata.area = value.trim();
                                  setState(() {});
                                },
                              ),
                              //ctu/gozar
                              formcardtextfield(
                                  enable: false,
                                  keyboardtype: TextInputType.number,
                                  initvalue: localdata.pass?.isEmpty ?? true
                                      ? ""
                                      : localdata.pass,
                                  headerlablekey: setapptext(key: 'key_pass'),
                                  hinttextkey:
                                      setapptext(key: 'Key_number_value'),
                                  radiovalue: localdata.pass?.isEmpty ?? true
                                      ? CheckColor.Black
                                      : CheckColor.Green,
                                  fieldrequired: true,
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return setapptext(
                                          key: 'key_field_not_blank');
                                    } else if (value.length != 2) {
                                      return setapptext(key: 'key_two_digit');
                                    }
                                  },
                                  onSaved: (value) {
                                    localdata.pass = value.trim();
                                  },
                                  onChanged: (value) {
                                    localdata.pass = value.trim();
                                    setState(() {});
                                  }),
                              //block
                              formcardtextfield(
                                  enable: false,
                                  keyboardtype: TextInputType.number,
                                  initvalue: localdata.block?.isEmpty ?? true
                                      ? ""
                                      : localdata.block,
                                  headerlablekey: setapptext(key: 'key_block'),
                                  radiovalue: localdata.block?.isEmpty ?? true
                                      ? CheckColor.Black
                                      : CheckColor.Green,
                                  hinttextkey:
                                      setapptext(key: 'Key_number_value'),
                                  fieldrequired: true,
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return setapptext(
                                          key: 'key_field_not_blank');
                                    } else if (value.length != 3) {
                                      return setapptext(key: 'key_three_digit');
                                    }
                                  },
                                  onSaved: (value) {
                                    localdata.block = value.trim();
                                  },
                                  onChanged: (value) {
                                    localdata.block = value.trim();
                                    setState(() {});
                                  }),
                              //parcel
                              formcardtextfield(
                                enable:
                                    (localdata.isdrafted == 2) ? false : true,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                keyboardtype: TextInputType.number,
                                initvalue:
                                    localdata.part_number?.isEmpty ?? true
                                        ? ""
                                        : localdata.part_number,
                                headerlablekey:
                                    setapptext(key: 'key_part_number'),
                                radiovalue:
                                    localdata.part_number?.isEmpty ?? true
                                        ? CheckColor.Black
                                        : CheckColor.Green,
                                fieldrequired: true,
                                hinttextkey:
                                    setapptext(key: 'Key_number_value'),
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return setapptext(
                                        key: 'key_field_not_blank');
                                  } else if (value.length != 3) {
                                    return setapptext(key: 'key_three_digit');
                                  }
                                },
                                maxLength: 3,
                                onSaved: (value) {
                                  localdata.part_number = value.trim();
                                },
                                onChanged: (value) {
                                  localdata.part_number = value.trim();
                                  setState(() {});
                                },
                              ),
                              //unit no
                              formcardtextfield(
                                  enable:
                                      (localdata.isdrafted == 2) ? false : true,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  keyboardtype: TextInputType.number,
                                  initvalue:
                                      localdata.unit_number?.isEmpty ?? true
                                          ? ""
                                          : localdata.unit_number,
                                  headerlablekey:
                                      setapptext(key: 'key_unit_number'),
                                  radiovalue:
                                      localdata.unit_number?.isEmpty ?? true
                                          ? CheckColor.Black
                                          : CheckColor.Green,
                                  fieldrequired: true,
                                  hinttextkey:
                                      setapptext(key: 'Key_number_value'),
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return setapptext(
                                          key: 'key_field_not_blank');
                                    } else if (value.length != 4) {
                                      return setapptext(key: 'key_limit_four');
                                    }
                                  },
                                  maxLength: 4,
                                  onSaved: (value) {
                                    localdata.unit_number = value.trim();
                                  },
                                  onChanged: (value) {
                                    localdata.unit_number = value.trim();
                                    setState(() {});
                                  }),
                              formcardtextfield(
                                  keyboardtype: TextInputType.number,
                                  enable:
                                      localdata.isdrafted == 2 ? false : true,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  maxLength: 3,
                                  initvalue:
                                      localdata.unit_in_parcel?.isEmpty ?? true
                                          ? ""
                                          : localdata.unit_in_parcel,
                                  headerlablekey:
                                      setapptext(key: 'key_number_of_unit'),
                                  radiovalue:
                                      localdata.unit_in_parcel?.isEmpty ?? true
                                          ? CheckColor.Black
                                          : CheckColor.Green,
                                  hinttextkey:
                                      setapptext(key: 'Key_number_value'),
                                  onSaved: (value) {
                                    localdata.unit_in_parcel = value.trim();
                                  },
                                  onChanged: (value) {
                                    localdata.unit_in_parcel = value.trim();
                                    setState(() {});
                                  }),
                              formcardtextfield(
                                  maxLength: 120,
                                  inputFormatters: [],
                                  enable:
                                      localdata.isdrafted == 2 ? false : true,
                                  initvalue:
                                      localdata.street_name?.isEmpty ?? true
                                          ? ""
                                          : localdata.street_name,
                                  headerlablekey:
                                      setapptext(key: 'key_state_name'),
                                  radiovalue:
                                      localdata.street_name?.isEmpty ?? true
                                          ? CheckColor.Black
                                          : CheckColor.Green,
                                  hinttextkey:
                                      setapptext(key: 'key_enter_1st_surveyor'),
                                  onSaved: (value) {
                                    localdata.street_name = value.trim();
                                  },
                                  onChanged: (value) {
                                    localdata.street_name = value.trim();
                                    setState(() {});
                                  }),
                              formcardtextfield(
                                  keyboardtype: TextInputType.number,
                                  maxLength: 4,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  enable:
                                      localdata.isdrafted == 2 ? false : true,
                                  initvalue:
                                      localdata.historic_site_area?.isEmpty ??
                                              true
                                          ? ""
                                          : localdata.historic_site_area,
                                  headerlablekey:
                                      setapptext(key: 'key_historycal_site'),
                                  radiovalue:
                                      localdata.historic_site_area?.isEmpty ??
                                              true
                                          ? CheckColor.Black
                                          : CheckColor.Green,
                                  onSaved: (value) {
                                    localdata.historic_site_area = value.trim();
                                  },
                                  onChanged: (value) {
                                    localdata.historic_site_area = value.trim();
                                    setState(() {});
                                  }),
                              formcardtextfield(
                                  maxLength: 9,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter(
                                        RegExp(r'^[0-9.]*$'))
                                  ],
                                  enable:
                                      localdata.isdrafted == 2 ? false : true,
                                  initvalue:
                                      localdata.land_area?.isEmpty ?? true
                                          ? ""
                                          : localdata.land_area,
                                  keyboardtype: TextInputType.number,
                                  headerlablekey:
                                      setapptext(key: 'key_land_area'),
                                  radiovalue:
                                      localdata.land_area?.isEmpty ?? true
                                          ? CheckColor.Black
                                          : CheckColor.Green,
                                  hinttextkey:
                                      setapptext(key: 'Key_number_value'),
                                  onSaved: (value) {
                                    localdata.land_area = value.trim();

                                    setState(() {});
                                  },
                                  onChanged: (value) {
                                    localdata.land_area = value.trim();
                                    setState(() {});
                                  }),
                              formCardDropdown(
                                  fieldrequired: true,
                                  enable:
                                      localdata.isdrafted == 2 ? true : false,
                                  value:
                                      localdata.property_type?.isEmpty ?? true
                                          ? "0"
                                          : localdata.property_type,
                                  iscompleted:
                                      ((localdata.property_type?.isEmpty ??
                                                  true) ||
                                              (localdata.property_type == "0"))
                                          ? CheckColor.Black
                                          : CheckColor.Green,
                                  headerlablekey:
                                      setapptext(key: 'key_type_ownership'),
                                  dropdownitems: [
                                    Dpvalue(
                                        name: setapptext(
                                            key: 'key_none_selected'),
                                        value: "0"),
                                    Dpvalue(
                                        name: setapptext(key: 'key_solo'),
                                        value: "1"),
                                    Dpvalue(
                                        name: setapptext(key: 'key_collective'),
                                        value: "2"),
                                  ],
                                  onSaved: (String value) {
                                    localdata.property_type = value;
                                  },
                                  onChanged: (value) {
                                    localdata.property_type = value;

                                    setState(() {});
                                  },
                                  validate: (value) {
                                    if ((value.isEmpty) || value == "0") {
                                      return setapptext(key: 'key_required');
                                    }
                                  }),
                              SizedBox(
                                height: 50,
                              ),
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
                                color: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
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
