import 'dart:async';

import 'package:ayadi/VideoCall/callPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:math' as math;

//specialist app

import 'package:custom_clippers/custom_clippers.dart';
import 'package:permission_handler/permission_handler.dart';

class chating extends StatefulWidget {
  const chating({super.key, required this.session});
  final session;
  @override
  State<chating> createState() => _chatingState(session);
}

class _chatingState extends State<chating> {
  final session;
  _chatingState(this.session);
  List<Message> messageWidgets = [];
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  // late User signedInUser;
  User? signedInUser;
  String? messageText;
  bool buttonEnabled = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    _getParentName();
    _getSpecialistID();
  }

  String formattedDate(timeStamp, String format) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat(format).format(dateFromTimeStamp);
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) signedInUser = user;
    } catch (err) {}
  }

  Stream<bool> buttonEnabledStream(DateTime sessionDate) {
    return Stream.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final timeElapsed = now.difference(sessionDate);
      return timeElapsed >= Duration(minutes: 0) &&
          timeElapsed <= Duration(minutes: 45);
    });
  }

  var parentFname = "";
  var parentLname = "";
  var parentFullName = "";
  String specialistID = "";
  String parentID = "";

  void _getParentName() async {
    FirebaseFirestore.instance
        .collection('parent')
        .where('phone', isEqualTo: session["parentPhone"])
        .limit(1)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.length > 0) {
          var documentSnapshot = querySnapshot.docs.first;
          if (documentSnapshot.exists) {
            setState(() {
              parentFname = documentSnapshot['Fname'];
              parentLname = documentSnapshot['Lname'];
              parentFullName = parentFname + " " + parentLname;
              parentID = documentSnapshot.id;
            });
          }
        }
      },
    );
  }

  void _getSpecialistID() async {
    FirebaseFirestore.instance
        .collection('specialist')
        .where('phoneNumber', isEqualTo: session["specialistPhone"])
        .limit(1)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.length > 0) {
          var documentSnapshot = querySnapshot.docs.first;
          if (documentSnapshot.exists) {
            setState(() {
              specialistID = documentSnapshot.id;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70.0,
        backgroundColor: Color.fromARGB(160, 145, 75, 185),
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<bool>(
              stream: buttonEnabledStream(session["date"].toDate()),
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.data == true) {
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await [Permission.camera, Permission.microphone]
                              .request()
                              .then((value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallPage(
                                  channelName: session.id,
                                ),
                              ),
                            );
                          });
                        },
                        icon: Icon(
                          Icons.video_camera_front_rounded,
                          color: Color.fromRGBO(247, 230, 206, 1),
                          size: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      SizedBox(width: 110),
                    ],
                  );
                } else {
                  return SizedBox(width: 140);
                }
              },
            ),
            //  name
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10),
              child: Text(
                parentFullName,
                style: GoogleFonts.vazirmatn(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromRGBO(247, 230, 206, 1),
                    height: 1.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color.fromRGBO(247, 230, 206, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Icon(
                      Icons.person_outlined,
                      size: 35,
                      color: Color.fromARGB(160, 145, 75, 185),
                    )),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color.fromRGBO(247, 230, 206, 1),
                size: 25,
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('messages')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    // List<MessageLine> messageWidgets = [];
                    if (!snapshot.hasData) {}

                    try {
                      final messages = snapshot.data!.docs;
                      messageWidgets.clear();
                      for (var message in messages) {
                        if ((message.get('sender') == specialistID &&
                                message.get('receiver') == parentID &&
                                message.get('sessionID') == session.id) ||
                            (message.get('sender') == parentID &&
                                message.get('receiver') == specialistID &&
                                message.get('sessionID') == session.id)) {
                          final messageText = message.get('text');
                          final messageSender = message.get('sender');
                          final messageTime =
                              formattedDate(message.get('time'), 'hh:mm a');
                          final currentUser = specialistID;

                          final messageWidget = Message(
                            sender: messageSender,
                            text: messageText,
                            time: formattedDate(message.get('time'),
                                'EEE MMM dd HH:mm:ss yyyy'),
                            messageTime: messageTime,
                            isMe: currentUser == messageSender,
                          );

                          if ((message.get('sender') == parentID &&
                                  message.get('receiver') == specialistID) &&
                              (message.get('status') == "new")) {
                            _firestore
                                .collection("messages")
                                .doc(message.id)
                                .update({
                              'status': "old",
                            });
                            _firestore
                                .collection("messages")
                                .doc(message.id)
                                .update({
                              'unread': false,
                            });
                          }

                          messageWidgets.add(messageWidget);
                        }
                      }
                      if (messageWidgets.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (err) {}
                    return Expanded(
                      child: GroupedListView<Message, DateTime>(
                        reverse: true,
                        order: GroupedListOrder.DESC,
                        elements: messageWidgets,
                        groupBy: (message) => DateTime(
                            HttpDate.parse(message.time).year,
                            HttpDate.parse(message.time).month,
                            HttpDate.parse(message.time).day),
                        groupHeaderBuilder: (Message message) => SizedBox(
                          height: 45,
                          child: Center(
                            child: Card(
                              color: Color.fromARGB(159, 190, 184, 193),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  DateFormat.EEEE('ar_SA')
                                      .format(HttpDate.parse(message.time)),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      height: 1.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        itemBuilder: (context, Message message) =>
                            MessageLine(message: message),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      ),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(174, 194, 179, 0.42),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (messageText != null && messageText != "") {
                            _firestore.collection('messages').add({
                              'text': messageText,
                              'receiver': parentID,
                              'sender': specialistID,
                              'time': FieldValue.serverTimestamp(),
                              'status': "new",
                              'unread': true,
                              'sessionID': session.id,
                            });
                            messageTextController.clear();
                            messageText = null;
                          }
                        },
                        icon: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Icon(
                            Icons.send_rounded,
                            //textDirection: TextDirection.rtl,
                            color: Color.fromARGB(160, 145, 75, 185),
                            size: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                            textAlign: TextAlign.end,
                            cursorColor: Colors.deepPurple[900],
                            controller: messageTextController,
                            onChanged: (value) {
                              messageText = value;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              hintText: 'اكتب شيئًا',
                              border: InputBorder.none,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'^\s')),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Message {
  final String sender;
  final String text;
  final String time;
  final bool isMe;
  final String? messageTime;
  Message({
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
    this.messageTime,
  });
}

class MessageLine extends StatelessWidget {
  const MessageLine({required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment:
            message.isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          ClipPath(
            clipper: message.isMe
                ? LowerNipMessageClipper((MessageType.RECEIVE))
                : LowerNipMessageClipper(MessageType.SEND),
            child: Material(
              color: message.isMe
                  ? Color.fromARGB(159, 164, 109, 195)
                  : Color.fromRGBO(247, 230, 206, 1),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Text('${message.text}',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 15,
                      color: message.isMe ? Colors.white : Colors.black45,
                    )),
              ),
            ),
          ),
          //
          SizedBox(
            height: 5,
          ),
          Text(
            '${message.messageTime}',
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
