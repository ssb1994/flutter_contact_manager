import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../places_provider.dart';
import './text_form_widget.dart';

class PlaceSearchWidget extends StatefulWidget {
  final String location;
  final Function validatorFunction;
  final Function saveFunction;

  PlaceSearchWidget({
    this.location,
    this.validatorFunction,
    this.saveFunction,
  });

  @override
  _PlaceSearchWidgetState createState() => _PlaceSearchWidgetState();
}

class _PlaceSearchWidgetState extends State<PlaceSearchWidget> {
  String placeKeyValue;
  List<String> placeList = [];
  bool _isListVisible = false;
  final TextEditingController locationController = TextEditingController();
  bool _isFirstTime = true;
  bool _isValueChanged = false;

  void _onTextChangesListner(value) async {
    if (value.length > 3) {
      final result = await PlacesProvider().placesApiCall(value);
      if (result != null) {
        _isListVisible = true;
        placeList = result;
      }
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isFirstTime) {
      if (widget.location != null && widget.location.isNotEmpty) {
        locationController.text = widget.location;
        _isValueChanged = true;
      }
    }
    _isFirstTime = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: widget.validatorFunction,
            onSaved: _isValueChanged ? widget.saveFunction : null,
            keyboardType: TextInputType.text,
            maxLines: 1,
            controller: locationController,
            onChanged: _onTextChangesListner,
            decoration: InputDecoration(
                hintText: 'Enter your Location',
                labelText: 'Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
          Visibility(
            visible: _isListVisible,
            child: Card(
              child: Container(
                height: 200,
                child: ListView(
                  children: placeList.map((place) {
                    return GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Text(place),
                            Divider(
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          locationController.text = place;
                          _isListVisible = false;
                          _isValueChanged = true;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
