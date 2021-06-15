const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();

// Below code is for chat notification

// exports.sendNotification = functions.firestore
//     .document("chats/{message}").onCreate((snapshot, context) => {
//       const userId = snapshot.data().userIdTo;
//       const title = snapshot.data().userNameFrom;
//       const message = snapshot.data().text;

//       console.log("We have a notification to send to", userId);

//       const ref = db.collection("userDeviceToken").doc(userId);
//       try {
//         ref.get().then((tokenSnapshot) => {
//           if (!tokenSnapshot.exists) {
//             return console.log("Token not available!");
//           } else {
//             console.log("Token Document data:", tokenSnapshot.data());

//             const token = tokenSnapshot.data().deviceToken;

//             const payload = {
//               notification: {
//                 title: title,
//                 body: message,
//                 sound: "default",
//                 clickAction: "FLUTTER_NOTIFICATION_CLICK",
//               },
//             };

//             try {
//               const response = admin.messaging()
// .sendToDevice(token, payload);
//               return console.log("Notification sent : Success", response);
//             } catch (err) {
//               return console.log("Error sending Notification : Failed", err);
//             }
//           }
//         });
//       } catch (err) {
//         console.log("Error getting document", err);
//       }
//     });

// notification for product create to specific user

// exports.prodCreateNotification = functions.firestore
//     .document("products/{message}").onCreate((snapshot, context) => {
//       const userId = snapshot.data().userDetailDocId;
//       const title = snapshot.data().prodName;
//       const message = "Product Created Sussfully!";

//       console.log("We have a notification to send to", userId);

//       const ref = db.collection("userDeviceToken").doc(userId);
//       try {
//         ref.get().then((tokenSnapshot) => {
//           if (!tokenSnapshot.exists) {
//             return console.log("Token not available!");
//           } else {
//             console.log("Token Document data:", tokenSnapshot.data());

//             const token = tokenSnapshot.data().deviceToken;

//             const payload = {
//               notification: {
//                 title: title,
//                 body: message,
//                 sound: "default",
//                 clickAction: "FLUTTER_NOTIFICATION_CLICK",
//               },
//             };

//             try {
//               const response = admin.messaging()
// .sendToDevice(token, payload);
//               return console.log("Notification sent : Success", response);
//             } catch (err) {
//               return console.log("Error sending Notification : Failed", err);
//             }
//           }
//         });
//       } catch (err) {
//         console.log("Error getting document", err);
//       }
//     });

// // notification for product create to admin user

// exports.prodCreateAdminNotification = functions.firestore
//     .document("products/{message}").onCreate((snapshot, context) => {
//       // const userId = snapshot.data().userDetailDocId;
//       const title = snapshot.data().prodName;
//       const message = "Product Created Sussfully!";

//       console.log("We have a notification to send to Admin");

//       const ref = db.collection("userDeviceToken")
//           .where("userLevel", "==", "Admin");
//       try {
//         ref.get().then((tokenSnapshot) => {
//           if (tokenSnapshot.empty) {
//             return console.log("Token not available!");
//           } else {
//             console.log("Token Document data exist:");

//             const tokens =[];

//             // for (const token of tokenSnapshot) {
//             //   tokens.push(token.data().deviceToken);
//             // }

//             tokenSnapshot.forEach((doc) => {
//               tokens.push(doc.data().deviceToken);
//               console.log("Admin Token:", doc.data().deviceToken);
//             });


//             const payload = {
//               notification: {
//                 title: title,
//                 body: message,
//                 sound: "default",
//                 clickAction: "FLUTTER_NOTIFICATION_CLICK",
//               },
//             };

//             try {
//               const response = admin.messaging()
// .sendToDevice(tokens, payload);
//               return console.log("Notification sent : Success", response);
//             } catch (err) {
//               return console.log("Error sending Notification : Failed", err);
//             }
//           }
//         });
//       } catch (err) {
//         console.log("Error getting document", err);
//       }
//     });


// // notification for product update to admin user

// exports.prodUpdateAdminNotification = functions.firestore
//     .document("products/{message}").onUpdate((change, context) => {
//       // const userId = snapshot.data().userDetailDocId;
//       const title = change.after.data().prodName;
//       const newStatus = change.after.data().status;
//       const oldStatus = change.before.data().status;
//       const newListingStatus = change.after.data().listingStatus;
//       const oldListingStatus = change.before.data().listingStatus;
//       let message = "";
//       message = "Product Updated Sussfully!";
//       if (newStatus != oldStatus) {
//         message = "Product Status Updated :" + newStatus;
//       }
//       if (newListingStatus != oldListingStatus) {
//         message = "Product Listing Status Updated :" + newListingStatus;
//       }
//       console.log("message ", message);
//       console.log("We have a notification to send to Admin");

//       const ref = db.collection("userDeviceToken")
//           .where("userLevel", "==", "Admin");
//       try {
//         ref.get().then((tokenSnapshot) => {
//           if (tokenSnapshot.empty) {
//             return console.log("Token not available!");
//           } else {
//             console.log("Token Document data exist:");

//             const tokens =[];

//             // for (const token of tokenSnapshot) {
//             //   tokens.push(token.data().deviceToken);
//             // }

//             tokenSnapshot.forEach((doc) => {
//               tokens.push(doc.data().deviceToken);
//               console.log("Admin Token:", doc.data().deviceToken);
//             });


//             const payload = {
//               notification: {
//                 title: title,
//                 body: message,
//                 sound: "default",
//                 clickAction: "FLUTTER_NOTIFICATION_CLICK",
//               },
//             };

//             try {
//               const response = admin.messaging()
// .sendToDevice(tokens, payload);
//               return console.log("Notification sent : Success", response);
//             } catch (err) {
//               return console.log("Error sending Notification : Failed", err);
//             }
//           }
//         });
//       } catch (err) {
//         console.log("Error getting document", err);
//       }
//     });

// // notification for product update to specific user

// exports.prodUpdateNotification = functions.firestore
//     .document("products/{message}").onUpdate((change, context) => {
//       const userId = change.after.data().userDetailDocId;
//       const title = change.after.data().prodName;
//       const newStatus = change.after.data().status;
//       const oldStatus = change.before.data().status;
//       const newListingStatus = change.after.data().listingStatus;
//       const oldListingStatus = change.before.data().listingStatus;
//       let message = "";
//       message = "Product Updated Sussfully!";
//       if (newStatus != oldStatus) {
//         message = "Product Status Updated :" + newStatus;
//       }
//       if (newListingStatus != oldListingStatus) {
//         message = "Product Listing Status Updated :" + newListingStatus;
//       }
//       console.log("message ", message);

//       console.log("We have a notification to send to", userId);

//       const ref = db.collection("userDeviceToken").doc(userId);
//       try {
//         ref.get().then((tokenSnapshot) => {
//           if (!tokenSnapshot.exists) {
//             return console.log("Token not available!");
//           } else {
//             console.log("Token Document data:", tokenSnapshot.data());

//             const token = tokenSnapshot.data().deviceToken;

//             const payload = {
//               notification: {
//                 title: title,
//                 body: message,
//                 sound: "default",
//                 clickAction: "FLUTTER_NOTIFICATION_CLICK",
//               },
//             };

//             try {
//               const response = admin.messaging()
// .sendToDevice(token, payload);
//               return console.log("Notification sent : Success", response);
//             } catch (err) {
//               return console.log("Error sending Notification : Failed", err);
//             }
//           }
//         });
//       } catch (err) {
//         console.log("Error getting document", err);
//       }
//     });

// // notification for product delete to specific user

// exports.prodDeleteNotification = functions.firestore
//     .document("products/{message}").onDelete((snapshot, context) => {
//       const userId = snapshot.data().userDetailDocId;
//       const title = snapshot.data().prodName;

//       let message = "";
//       message = "Product Deleted Sussfully!";

//       console.log("message ", message);

//       console.log("We have a notification to send to", userId);

//       const ref = db.collection("userDeviceToken").doc(userId);
//       try {
//         ref.get().then((tokenSnapshot) => {
//           if (!tokenSnapshot.exists) {
//             return console.log("Token not available!");
//           } else {
//             console.log("Token Document data:", tokenSnapshot.data());

//             const token = tokenSnapshot.data().deviceToken;

//             const payload = {
//               notification: {
//                 title: title,
//                 body: message,
//                 sound: "default",
//                 clickAction: "FLUTTER_NOTIFICATION_CLICK",
//               },
//             };

//             try {
//               const response = admin.messaging()
// .sendToDevice(token, payload);
//               return console.log("Notification sent : Success", response);
//             } catch (err) {
//               return console.log("Error sending Notification : Failed", err);
//             }
//           }
//         });
//       } catch (err) {
//         console.log("Error getting document", err);
//       }
//     });

// notification for product update to admin user

exports.prodDeleteAdminNotification = functions.firestore
    .document("products/{message}").onDelete((snapshot, context) => {
      // const userId = snapshot.data().userDetailDocId;
      const title = snapshot.data().prodName;

      let message = "";
      message = "Product Deleted Sussfully!";

      console.log("message ", message);
      console.log("We have a notification to send to Admin");

      const ref = db.collection("userDeviceToken")
          .where("userLevel", "==", "Admin");
      try {
        ref.get().then((tokenSnapshot) => {
          if (tokenSnapshot.empty) {
            return console.log("Token not available!");
          } else {
            console.log("Token Document data exist:");

            const tokens =[];

            // for (const token of tokenSnapshot) {
            //   tokens.push(token.data().deviceToken);
            // }

            tokenSnapshot.forEach((doc) => {
              tokens.push(doc.data().deviceToken);
              console.log("Admin Token:", doc.data().deviceToken);
            });


            const payload = {
              notification: {
                title: title,
                body: message,
                sound: "default",
                clickAction: "FLUTTER_NOTIFICATION_CLICK",
              },
            };

            try {
              const response = admin.messaging().sendToDevice(tokens, payload);
              return console.log("Notification sent : Success", response);
            } catch (err) {
              return console.log("Error sending Notification : Failed", err);
            }
          }
        });
      } catch (err) {
        console.log("Error getting document", err);
      }
    });

// below is not useful

// admin.initializeApp(functions.config().functions);

// exports.myFunction = functions.firestore
//     .document("chats/{message}").onCreate((snapshot, context)=>{
//       console.log(snapshot.data().userNameTo);
//       return admin.messaging().sendToTopic(
//           snapshot.data().userNameTo, {notification:
//         {title: snapshot.data().userNameFrom, body: snapshot.data().text,
//           clickAction: "FLUTTER_NOTIFICATION_CLICK",
//         }});
//     });

// exports.onCreateNotification = functions.firestore
//     .document("chats/{message}").onCreate((snapshot, context) => {
//       console.log(snapshot.data().userNameTo);

//       let token = "";

//       console.log("staring to get token");
//       return admin
//           .firestore()
//           .collection("userDeviceToken")
//           .doc(snapshot.data().userIdTo).get().then((tokenSnapshot) => {
//             console.log("0");
//             console.log(tokenSnapshot.data());
//             console.log("01");
//             console.log(tokenSnapshot.data().deviceToken);

//             token = tokenSnapshot.data().deviceToken;
//             return admin.messaging().sendToDevice(
//                 token, {notification:
//             {title: snapshot.data().userNameFrom, body: snapshot.data().text,
//               sound: "default",
//               clickAction: "FLUTTER_NOTIFICATION_CLICK",
//             }});
//           });


// //

// console.log("1");
// console.log(tokenData["deviceToken"]);
// console.log("2");
// console.log(tokenData.doc);
// console.log("3");
// console.log(tokenData.data().deviceToken);
// console.log("4");
// console.log(tokenData.doc.data().deviceToken);
// console.log("5");
// console.log(tokenData.data());
// console.log("6");
// console.log(tokenData.data().deviceToken);
// console.log("7");

// token = tokenData["deviceToken"];

// return admin.messaging().sendToDevice(
//     token, {notification:
//   {title: snapshot.data().userNameFrom, body: snapshot.data().text,
//     sound: "default",
//     clickAction: "FLUTTER_NOTIFICATION_CLICK",
//   }});

// //
// });


