const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onUserDeleted = functions
  .region("europe-west3")
  .auth.user()
  .onDelete(async (user) => {
    let firestore = admin.firestore();
    let userRef = firestore.doc("REKTEFE/" + user.uid);
    await firestore.collection("REKTEFE").doc(user.uid).delete();
  });
