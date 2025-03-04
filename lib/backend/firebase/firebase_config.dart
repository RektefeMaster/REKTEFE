import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyA8gGg-mQL7p57kmVU8BVbpDHjDa6WLRRM",
            authDomain: "rektefe-f5b13.firebaseapp.com",
            projectId: "rektefe-f5b13",
            storageBucket: "rektefe-f5b13.firebasestorage.app",
            messagingSenderId: "509841981751",
            appId: "1:509841981751:web:c2b3e00c631ead831a1ab2",
            measurementId: "G-WTF175ZTE8"));
  } else {
    await Firebase.initializeApp();
  }
}
