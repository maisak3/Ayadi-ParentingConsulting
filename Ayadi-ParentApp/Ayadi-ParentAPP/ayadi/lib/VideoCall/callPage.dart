import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class CallPage extends StatefulWidget {
  final String channelName;
  const CallPage({Key? key, required this.channelName}) : super(key: key);
  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late RtcEngine _engine;
  late Timer _timer;
  int remainingMinutes = 45;
  int remainingSeconds = 59;
  bool loading = false;
  String appId = "e40efc02373141e29b8335a254039012";
  List _remotUid = [];
  double xPosition = 0;
  double yPosition = 0;
  bool muted = false;
  bool isCameraOff = false;
  bool isSessionEnded = false;
  bool timerColor = true;
  @override
  void initState() {
    super.initState();
    initializeAgora();
  }

  @override
  void dispose() {
    super.dispose();
    _engine.destroy();
    //_timer.cancel(); // Cancel the timer
  }

  Future<void> initializeAgora() async {
    setState(() {
      loading = true;
    });
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.Communication); //
    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        print('channel joined');
      },
      userJoined: (uid, elapsed) {
        print('user joined: $uid');
        setState(() {
          _remotUid.add(uid);
        });
      },
      userOffline: (uid, reason) {
        print('user offline: $uid');
        setState(() {
          _remotUid.remove(uid);
        });
      },
    ));
    await _engine.joinChannel(null, widget.channelName, null, 0).then((value) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (loading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Center(
                  child: renderRemoteeView(context),
                ),
                Positioned(
                  top: 70 + yPosition,
                  left: 20 + xPosition,
                  child: GestureDetector(
                    onPanUpdate: (tapInfo) {
                      setState(() {
                        xPosition += tapInfo.delta.dx;
                        yPosition += tapInfo.delta.dy;
                      });
                    },
                    child: (isCameraOff)
                        ? Container(
                            width: 100,
                            height: 130,
                            color: Colors.black,
                            // child: Icon(
                            //   Icons.videocam_off_rounded,
                            //   color: Colors.grey,
                            //   size: 100,
                            // ),
                          )
                        : Container(
                            width: 100,
                            height: 130,
                            child: const RtcLocalView.SurfaceView(),
                          ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: _toolbar(),
                ),
                // Display timer
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('sessions')
                        .doc(widget.channelName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var session = snapshot.data;
                        DateTime sessionTime = session!["date"].toDate();
                        DateTime endTime =
                            sessionTime.add(Duration(minutes: 45));
                        return Positioned(
                          top: 70,
                          right: 40,
                          child: CountdownTimer(
                            endTime: endTime.millisecondsSinceEpoch,
                            widgetBuilder: (_, time) {
                              if ((time!.min!) < 10) {
                                timerColor = false;
                              }
                              if (time == null) {
                                _onCallEnd();
                                return Container();
                              }
                              return Container(
                                width: 80,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (timerColor)
                                      ? Color.fromARGB(160, 145, 75, 185)
                                      : Colors.red,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3f000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${(time.min == null) ? 0 : time.min} : ${(time.sec == null) ? 0 : time.sec}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
              ],
            ),
    );
  }

  Widget renderRemoteeView(context) {
    if (_remotUid.isNotEmpty) {
      if (_remotUid.length == 1) {
        return RtcRemoteView.SurfaceView(
          uid: _remotUid[0],
          channelId: widget.channelName,
        );
      } else if (_remotUid.length == 2) {
        return Column(
          children: [
            RtcRemoteView.SurfaceView(
              uid: _remotUid[1],
              channelId: widget.channelName,
            ),
            RtcRemoteView.SurfaceView(
              uid: _remotUid[2],
              channelId: widget.channelName,
            ),
          ],
        );
      } else {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 11 / 20,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
              ),
              itemCount: _remotUid.length,
              itemBuilder: (BuildContext context, index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RtcRemoteView.SurfaceView(
                    uid: _remotUid[index],
                    channelId: widget.channelName,
                  ),
                );
              }),
        );
      }
    } else {
      return Text(
        "في انتظار انضمام المستخدم الآخر",
        style: GoogleFonts.vazirmatn(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.black,
        ),
      );
    }
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.only(
        bottom: 30,
      ),
      child: Row(
        children: [
          RawMaterialButton(
            onPressed: () {
              _onToggleMute();
            },
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(5),
            elevation: 2,
            fillColor:
                (muted) ? Color.fromARGB(160, 145, 75, 185) : Colors.white,
            child: Icon(
              (muted) ? Icons.mic_off_rounded : Icons.mic_rounded,
              color: (muted) ? Colors.white : Color.fromARGB(160, 145, 75, 185),
              size: 35,
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              _onToggleCamera();
            },
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(5),
            elevation: 2,
            fillColor: (isCameraOff)
                ? Color.fromARGB(160, 145, 75, 185)
                : Colors.white,
            child: Icon(
              (isCameraOff)
                  ? Icons.videocam_off_rounded
                  : Icons.videocam_rounded,
              color: (isCameraOff)
                  ? Colors.white
                  : Color.fromARGB(160, 145, 75, 185),
              size: 35,
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              _onCallEnd();
            },
            shape: CircleBorder(),
            padding: EdgeInsets.all(5),
            elevation: 2,
            fillColor: Colors.redAccent,
            child: const Icon(
              Icons.call_end_rounded,
              color: Colors.white,
              size: 35,
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              _onSwitchCamera();
            },
            shape: CircleBorder(),
            padding: EdgeInsets.all(5),
            elevation: 2,
            fillColor: Colors.white,
            child: const Icon(
              Icons.cameraswitch_rounded,
              color: Color.fromARGB(160, 145, 75, 185),
              size: 35,
            ),
          ),
        ],
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onToggleCamera() {
    setState(() {
      isCameraOff = !isCameraOff;
    });
    _engine.enableLocalVideo(!isCameraOff);
    _engine.muteLocalVideoStream(isCameraOff);
  }

  void _onCallEnd() {
    _engine.leaveChannel().then((value) {
      Navigator.pop(context);
    });
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }
}
