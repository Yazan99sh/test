import 'package:yes_order/generated/l10n.dart';
import 'package:flutter/material.dart';

class ReportDialogWidget extends StatelessWidget {
  final _reasonController = TextEditingController();

  ReportDialogWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.of(context).createNewReport,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[900]
                        : Color.fromRGBO(236, 239, 241, 1),
                  ),
                  child: TextFormField(
                    validator: (reason) {
                      if (reason.isEmpty) {
                        return S.of(context).reasonIsRequired;
                      }
                      return null;
                    },
                    controller: _reasonController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: S.of(context).reasonOfTheReport,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    maxLines: 6,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 45,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                color:Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[900]
                            : Color.fromRGBO(236, 239, 241, 1),
                  elevation: 0,
                  child: Text(
                    S.of(context).cancel,
                   
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right:16.0,left:16.0,bottom: 16),
            child: Container(
              height: 45,
              child: RaisedButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    S.of(context).save,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_reasonController.text.isNotEmpty) {
                      Navigator.of(context).pop(_reasonController.text);
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(S.of(context).pleaseCompleteTheForm)));
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
