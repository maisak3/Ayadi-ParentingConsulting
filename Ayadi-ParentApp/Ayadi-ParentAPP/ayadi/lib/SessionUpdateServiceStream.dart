import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SessionUpdateService {
  List<Map<String, dynamic>> _sessions = [];
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _subscription;
  late Timer _timer;

  Future<void> fetchSessions() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('sessions').where("time", isEqualTo: "upcoming").get();

    final sessions = querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Add the document ID to the map
      return data;
    }).toList();

    _sessions = sessions;
  }

  void start() {
    print("In the SessionUpdateService class!!");
    // Fetch the sessions once at the beginning
    fetchSessions();

    // Start listening for changes in the sessions collection
    _subscription = FirebaseFirestore.instance
        .collection('sessions')
        .snapshots()
        .listen((snapshot) {
      // Trigger the fetchSessions method when changes occur
      fetchSessions();
    });

    // Start a timer that runs every minute
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now();
      for (final session in _sessions) {
        final sessionStartTime = session['date'].toDate();
        final timeElapsed = now.difference(sessionStartTime);
        if (timeElapsed >= Duration(minutes: 45) && session['time'] == 'upcoming') {
          // Update the session status to "done"
          session['time'] = 'done';
          // Update the session document in Firestore
          FirebaseFirestore.instance
              .collection('sessions')
              .doc(session['id'])
              .update({'time': 'done'})
              .then((_) => print("${session["id"]} updated successfully"))
              .catchError((error) => print("Error updating session: $error"));
        }
      }
    });
  }

  void stop() {
    // Cancel the subscription and timer
    _subscription.cancel();
    _timer.cancel();
  }

  List<Map<String, dynamic>> get sessions => _sessions;
}