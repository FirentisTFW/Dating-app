const functions = require("firebase-functions");
const firebase = require("firebase");
// Required for side-effects
require("firebase/firestore");

const credentials = require("./credentials")

firebase.initializeApp({
    apiKey: credentials.API_KEY,
    authDomain: credentials.AUTH_DOMAIN,
    projectId: credentials.PROJECT_ID,
});

const db = firebase.firestore();
db.useEmulator("localhost", 8080);

// --------------------------------------------------------------------------------------------------

exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});
// Required for side-effects

exports.acceptanceCreated = functions.firestore.document('/users/men/men/{userId}/acceptances/{documentId}')
.onCreate(async (snap, context) => {
    const acceptingUserId = context.params.userId;
    const acceptedUserId = snap.data()['userId'];
    
    console.log('User', acceptingUserId, 'accepted user', acceptedUserId);

    const genderCollection = getGenderCollection(acceptedUserId);

    const doc = await genderCollection.doc(`${acceptedUserId}/acceptances/${acceptingUserId}`).get();
    
    if(doc.exists) {
        console.log('It\'s a match!');
        await createMatch(acceptingUserId, acceptedUserId);
    } else {
        console.log('No match');
    }    
});

function getGenderCollection(userId) {
    if(userId[0] == 'm')
        return db.collection(`/users/men/men`);
    return db.collection(`/users/women/women`);
}

async function createMatch(firstUid, secondUid) {
    console.log('Creating match');

    const firstUserRef = getGenderCollection(firstUid).doc(firstUid);
    const secondUserRef = getGenderCollection(secondUid).doc(secondUid);

    const firstUser = await firstUserRef.get();
    const secondUser = await secondUserRef.get();
    
    const matchDate = new Date().getTime();

    await createMatchRecord(firstUserRef, secondUser, matchDate);
    await createMatchRecord(secondUserRef, firstUser, matchDate);
}

async function createMatchRecord(userRef, macthedUserData, matchDate) {
    await userRef.collection('matches').doc(macthedUserData.data().id).set({
        userId: macthedUserData.data().id,
        name: macthedUserData.data().name,
        birthDate: macthedUserData.data().birthDate,
        date: matchDate,
    });
}