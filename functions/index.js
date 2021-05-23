/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.CarStatus = functions.firestore.document("Cars/{zrga}")
    .onUpdate((change, context) => {
      console.log("zrga");
      const newValue = change.after.data();
      console.log(newValue);

      // Notification details.
      // eslint-disable-next-line max-len
      if (newValue.isVerified.localeCompare("true") == 0 && change.before.data().isVerified.localeCompare("false") == 0) {
        const payload = {
          notification: {
            title: "Car Accepted",
            tag: "CarStatus",
            click_action: "FLUTTER_NOTIFICATION_CLICK",
            // eslint-disable-next-line max-len

            // eslint-disable-next-line max-len
            body: "Hello " + change.after.data().CarOwnerName + " Your Car " + "(" + change.after.data().CarName + ")" + " is Accepted!",
          },
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "title": "Car Accepted",
            "tag": "CarStatus",
            "sound": "default",
            "status": "done",
            "screen": "MyCars",
            // eslint-disable-next-line max-len
            "body": "Hello " + change.after.data().CarOwnerName + " Your Car " + "(" + change.after.data().CarName + ")" + " is Accepted!",
          },
        };

        const previousValue = change.before.data();
        console.log(previousValue);
        console.log(change.after.data);
        return admin.messaging().sendToDevice(newValue.deviceID, payload);
      // eslint-disable-next-line max-len
      } else if (newValue.isRejected.localeCompare("true") == 0 && change.before.data().isRejected.localeCompare("false") == 0) {
        const payload = {
          notification: {
            title: "Car Rejected",
            tag: "CarStatus",

            // eslint-disable-next-line max-len

            // eslint-disable-next-line max-len
            body: "Hello " + change.after.data().CarOwnerName + " Your Car " + "(" + change.after.data().CarName + ")" + " is Rejected!",

          },
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "sound": "default",
            "status": "done",
            "screen": "MyCars",
            "title": "Car Rejected",
            "tag": "CarStatus",
            "body": "Hello " + change.after.data().CarOwnerName + " Your Car " + "(" + change.after.data().CarName + ")" + " is Rejected!",
          },
        };

        const previousValue = change.before.data();
        console.log(previousValue);
        console.log(change.after.data);
        return admin.messaging().sendToDevice(newValue.deviceID, payload);
      } else {
        return;
      }
    });

exports.DisRequest = functions.firestore.document("AddDisabilities/{zrga}")
    .onUpdate((change, context) => {
      console.log("zrga");
      const newValue = change.after.data();
      console.log(newValue);

      // Notification details.
      // eslint-disable-next-line max-len
      if (newValue.Status.localeCompare("Pending") == 0) {
        const payload = {
          notification: {
            title: newValue.PlateNumber,
            tag: newValue.PlateNumber,

            // eslint-disable-next-line max-len

            // eslint-disable-next-line max-len
            body: "Hello " + newValue.geterName + ". " + newValue.SenderName + " wants to add you to his car!",
          },
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "sound": "default",
            "status": "done",
            "screen": "screenA",
            "UserName": newValue.UN,
            "title": newValue.PlateNumber,
            "tag": newValue.PlateNumber,
            "NotifyID": newValue.NotifyID,
            "DisabilityNumber": newValue.DisabilityNumber,
            "geterName": newValue.geterName,
            "email": newValue.geterEmail,
            "authID": newValue.authID,
            "body": "Hello " + newValue.geterName + ". " + newValue.SenderName + " wants to add you to his car!",
          },
        };

        const previousValue = change.before.data();
        console.log(previousValue);
        return admin.messaging().sendToDevice(newValue.deviceID, payload);
      }
    });
// eslint-disable-next-line max-len

exports.ChildRequest = functions.firestore.document("DisabilitiesChild/{zrga}")
    .onUpdate((change, context) => {
      console.log("zrga");
      const newValue = change.after.data();
      console.log(newValue);

      // Notification details.
      // eslint-disable-next-line max-len
      if (newValue.isDisability.localeCompare("true") == 0 && change.before.data().isDisability.localeCompare("?") == 0) {
        const payload = {
          notification: {
            title: "Dependent Request Accepted",
            tag: "RequestStatus",

            // eslint-disable-next-line max-len

            // eslint-disable-next-line max-len
            body: "Hello " + change.after.data().DisabilityParentName + " Your Disability Request for your dependent " + change.after.data().ChildName + " is accepted",
          },
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "sound": "default",
            "status": "done",
            "screen": "screenA",
            "title": "Dependent Request Accepted",
            "tag": "RequestStatus",
            "body": "Hello " + change.after.data().DisabilityParentName + " Your Disability Request for your dependent " + change.after.data().ChildName + " is accepted",
          },
        };

        const previousValue = change.before.data();
        console.log(previousValue);
        return admin.messaging().sendToDevice(newValue.deviceID, payload);
        // eslint-disable-next-line max-len
      } else if (newValue.isDisability.localeCompare("false") == 0 && change.before.data().isDisability.localeCompare("?") == 0) {
        const payload = {
          notification: {
            title: "Dependent Request Rejected",
            tag: "RequestStatus",

            // eslint-disable-next-line max-len

            // eslint-disable-next-line max-len
            body: "Hello " + change.after.data().DisabilityParentName + " Your Disability Request for your dependent  " + change.after.data().ChildName + " is rejected",
          },
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "sound": "default",
            "status": "done",
            "screen": "screenA",
            "title": "Dependent Request Rejected",
            "tag": "RequestStatus",
            "body": "Hello " + change.after.data().DisabilityParentName + " Your Disability Request for your dependent  " + change.after.data().ChildName + " is rejected",
          },
        };

        const previousValue = change.before.data();
        console.log(previousValue);
        console.log(change.after.data);
        return admin.messaging().sendToDevice(newValue.deviceID, payload);
      } else {
        return;
      }
    });

exports.SelfRequest = functions.firestore.document("Disabilities/{zrga}")
    .onUpdate((change, context) => {
      console.log("zrga");
      const newValue = change.after.data();
      console.log(newValue);

      // Notification details.
      // eslint-disable-next-line max-len
      if (newValue.isDisability.localeCompare("true") == 0) {
        const payload = {
          notification: {
            title: " Self Request Accepted",
            tag: "RequestStatus",

            // eslint-disable-next-line max-len

            // eslint-disable-next-line max-len
            body: "Hello " + change.after.data().DisabilityName + " Your Disability Request for is accepted",
          },
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "sound": "default",
            "status": "done",
            "screen": "screenA",
            "title": " Self Request Accepted",
            "tag": "RequestStatus",

            // eslint-disable-next-line max-len

            // eslint-disable-next-line max-len
            "body": "Hello " + change.after.data().DisabilityName + " Your Disability Request for is accepted",
          },
        };

        const previousValue = change.before.data();
        console.log(previousValue);
        console.log(change.after.data);
        return admin.messaging().sendToDevice(newValue.deviceID, payload);
        // eslint-disable-next-line max-len
      } else if (newValue.isDisability.localeCompare("false") == 0) {
        const payload = {
          notification: {
            title: "Self Request Rejected",
            tag: "RequestStatus",

            // eslint-disable-next-line max-len

            // eslint-disable-next-line max-len
            body: "Hello " + change.after.data().DisabilityName + " Your Disability Request is rejected",
          },
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "sound": "default",
            "status": "done",
            "screen": "screenA",
            "title": "Self Request Rejected",
            "tag": "RequestStatus",

            // eslint-disable-next-line max-len

            // eslint-disable-next-line max-len
            "body": "Hello " + change.after.data().DisabilityName + " Your Disability Request is rejected",

          },
        };

        const previousValue = change.before.data();
        console.log(previousValue);
        console.log(change.after.data);
        return admin.messaging().sendToDevice(newValue.deviceID, payload);
      } else {
        return;
      }
    });
exports.Ticket = functions.firestore.document("AddTicket/{zrga}")
    .onUpdate((change, context) => {
      console.log("zrga");
      const newValue = change.after.data();
      console.log(newValue);

      // Notification details.
      // eslint-disable-next-line max-len
      const payload = {
        notification: {
          title: newValue.TicketName,
          tag: "TicketRecive",
          click_action: "FLUTTER_NOTIFICATION_CLICK",
          // eslint-disable-next-line max-len

          // eslint-disable-next-line max-len
          body: "Hello " + newValue.Name + " you have recive a " + newValue.TicketName + " ticket!",
        },
        data: {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "title": newValue.TicketName,
          "tag": "TicketRecive",
          "sound": "default",
          "status": "done",
          "screen": "MyCars",
          // eslint-disable-next-line max-len
          "body": "Hello " + newValue.Name + " you have recive a " + newValue.TicketName + " ticket!",
        },
      };


      return admin.messaging().sendToDevice(newValue.deviceID, payload);
      // eslint-disable-next-line max-len
    });

exports.AddUser = functions.firestore.document("AddUser/{zrga}")
    .onUpdate((change, context) => {
      console.log("zrga");
      const newValue = change.after.data();
      console.log(newValue);

      // Notification details.
      // eslint-disable-next-line max-len
      if (newValue.Status.localeCompare("Pending") == 0) {
        const payload = {
          notification: {
            title: "Add Request",
            tag: newValue.UN,

            // eslint-disable-next-line max-len

            // eslint-disable-next-line max-len
            body: "Hello " + newValue.geterName + ". " + newValue.SenderName + " wants to add you to his car ( " + newValue.CarName + ")",
          },
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "sound": "default",
            "status": "done",
            "screen": newValue.PlateNumber,
            "PlateNumber": newValue.PlateNumber,
            "geterUN": newValue.UN,
            "title": "Add Request",
            "tag": "AddUser",
            "email": newValue.geterEmail,
            "authID": newValue.authID,
            "NotifyID": newValue.NotifyID,
            "SenderName": newValue.SenderName,
            "SenderUserName": newValue.SenderUserName,
            "CarName": newValue.CarName,
            "geterName": newValue.geterName,
            "body": "Hello " + newValue.geterName + ". " + newValue.SenderName + " wants to add you to his car ( " + newValue.CarName + ")",
          },
        };

        return admin.messaging().sendToDevice(newValue.deviceID, payload);
      }
    });
exports.AddUser = functions.firestore.document("AddUser/{zrga}")
    .onUpdate((change, context) => {
      console.log("zrga");
      const newValue = change.after.data();
      console.log(newValue);

      // Notification details.
      // eslint-disable-next-line max-len
      if (newValue.Status.localeCompare("Pending") == 0) {
        const payload = {
          notification: {
            title: "Add Request",
            tag: newValue.UN,

            // eslint-disable-next-line max-len

            // eslint-disable-next-line max-len
            body: "Hello " + newValue.geterName + ". " + newValue.SenderName + " wants to add you to his car ( " + newValue.CarName + ")",
          },
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "sound": "default",
            "status": "done",
            "screen": newValue.PlateNumber,
            "PlateNumber": newValue.PlateNumber,
            "geterUN": newValue.UN,
            "title": "Add Request",
            "tag": "AddUser",
            "email": newValue.geterEmail,
            "authID": newValue.authID,
            "NotifyID": newValue.NotifyID,
            "SenderName": newValue.SenderName,
            "SenderUserName": newValue.SenderUserName,
            "CarName": newValue.CarName,
            "geterName": newValue.geterName,
            "body": "Hello " + newValue.geterName + ". " + newValue.SenderName + " wants to add you to his car ( " + newValue.CarName + ")",
          },
        };

        return admin.messaging().sendToDevice(newValue.deviceID, payload);
      }
    });
// eslint-disable-next-line max-len
exports.UserRequestStatus = functions.firestore.document("AddUser/{zrga}")
    .onUpdate((change, context) => {
      console.log("zrga");
      const newValue = change.after.data();
      console.log(newValue);

      // Notification details.
      // eslint-disable-next-line max-len
      if (newValue.Status.localeCompare("Accepted") == 0) {
        const payload = {
          notification: {
            title: "Request Accepted",
            tag: "RequestAcceptedUser",

            // eslint-disable-next-line max-len

            // eslint-disable-next-line max-len
            body: "Hello " + change.after.data().SenderName + " your request got accepted from " + newValue.geterName,
          },
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "sound": "default",
            "status": "done",
            "screen": "screenA",
            "title": "Request Accepted",
            "tag": "RequestAcceptedUser",
            // eslint-disable-next-line max-len
            "body": "Hello " + change.after.data().SenderName + " your request got accepted from " + newValue.geterName,
          },
        };

        const previousValue = change.before.data();
        console.log(previousValue);
        console.log(change.after.data);
        return admin.messaging().sendToDevice(newValue.SenderDeviceID, payload);
      // eslint-disable-next-line max-len
      } else if (newValue.Status.localeCompare("Rejected") == 0) {
        const payload = {
          notification: {
            title: "Request Rejected",
            tag: "RequestRejectedUser",

            // eslint-disable-next-line max-len

            // eslint-disable-next-line max-len
            body: "Hello " + change.after.data().SenderName + " your request got rejected from " + newValue.geterName,

          },
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "sound": "default",
            "status": "done",
            "screen": "screenA",
            "title": "Request Rejected",
            "tag": "RequestRejectedUser",
            // eslint-disable-next-line max-len
            "body": "Hello " + change.after.data().SenderName + " your request got rejected from " + newValue.geterName,
          },
        };

        const previousValue = change.before.data();
        console.log(previousValue);
        return admin.messaging().sendToDevice(newValue.SenderDeviceID, payload);
      } else {
        return;
      }
    });

