import 'package:flutter/material.dart';
import 'package:phraso/core/colors/colors.dart';

void alertDialogBoxForLanguage(
    {required BuildContext context,
    required String languageName,
    required void Function()? ifYes,
    required void Function()? ifNo}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
        backgroundColor: backgroundColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(4, 4))
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Unfollow $languageName phrase?",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: ifYes,
                      child: const Text(
                        "Yes",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      )),
                  TextButton(
                      onPressed: ifNo,
                      child: const Text(
                        "No",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                      )),
                ],
              )
            ],
          ),
        )),
  );
}

void alertDialogBoxForPhrase(
    {required BuildContext context,
    required String phraseName,
    required void Function()? ifYes,
    required void Function()? ifNo}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
        backgroundColor: backgroundColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(4, 4))
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "remove $phraseName from favourite?",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: ifYes,
                      child: const Text(
                        "Yes",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      )),
                  TextButton(
                      onPressed: ifNo,
                      child: const Text(
                        "No",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                      )),
                ],
              )
            ],
          ),
        )),
  );
}
