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

exports.acceptanceCreatedMen = functions.firestore.document('/users/men/men/{userId}/acceptances/{documentId}')
.onCreate(async (snap, context) => await executeAcceptanceCreated(snap, context));

exports.acceptanceCreatedWomen = functions.firestore.document('/users/women/women/{userId}/acceptances/{documentId}')
.onCreate(async (snap, context) => await executeAcceptanceCreated(snap, context));

async function executeAcceptanceCreated(snap, context) {
    const acceptingUserId = context.params.userId;
    const acceptedUserId = snap.data()['userId'];

    console.log('User', acceptingUserId, 'accepted user', acceptedUserId);

    const genderCollection = getGenderCollection(acceptedUserId);

    const doc = await genderCollection.doc(`${acceptedUserId}/acceptances/${acceptingUserId}`).get();
    
    if (doc.exists) {
        console.log('It\'s a match!');
        await createMatch(acceptingUserId, acceptedUserId);
    } else {
        console.log('No match');
    }    
}

exports.matchRemovedMen = functions.firestore.document('/users/men/men/{userId}/matches/{documentId}')
.onDelete(async (snap, context) => await executeMatchRemoved(snap, context));

exports.matchRemovedWomen = functions.firestore.document('/users/women/women/{userId}/matches/{documentId}')
.onDelete(async (snap, context) => await executeMatchRemoved(snap, context));

async function executeMatchRemoved(snap, context) {
    const unmatchingUId = context.params.userId;
    const unmatchedUId = snap.data()['userId'];

    console.log('User', unmatchingUId, 'unmatched user', unmatchedUId);

    const genderCollection = getGenderCollection(unmatchedUId);

    await genderCollection.doc(`${unmatchedUId}/matches/${unmatchingUId}`).delete();  
}

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

    await removeAcceptanceRecord(firstUserRef, secondUser.id);
    await removeAcceptanceRecord(secondUserRef, firstUser.id);
}

async function createMatchRecord(userRef, macthedUserData, matchDate) {
    await userRef.collection('matches').doc(macthedUserData.data().id).set({
        userId: macthedUserData.data().id,
        name: macthedUserData.data().name,
        birthDate: macthedUserData.data().birthDate,
        date: matchDate,
        conversationId: null,
    });
}

async function removeAcceptanceRecord(userRef, acceptanceId) {
    await userRef.collection('acceptances').doc(acceptanceId).delete();
}

exports.conversationCreated = functions.firestore.document('/conversations/{conversationId}')
    .onCreate(async (snap, context) => {
        const firstUid = snap.data().userIds[0];
        const secondUid = snap.data().userIds[1];
        const conversationId = snap.data().conversationId;

        console.log('User', firstUid, 'created conversation with user', secondUid);

        const firstUserRef = getGenderCollection(firstUid).doc(firstUid);
        const secondUserRef = getGenderCollection(secondUid).doc(secondUid);

        const firstUser = await firstUserRef.get();
        const secondUser = await secondUserRef.get();

        await putConversationIdInMatchRecord(firstUserRef, secondUid, conversationId);
        await putConversationIdInMatchRecord(secondUserRef, firstUid, conversationId);

        await createConversationOverviewRecord(firstUserRef, secondUser, conversationId);
        await createConversationOverviewRecord(secondUserRef, firstUser, conversationId);
});

async function createConversationOverviewRecord(userRef, otherUserData, conversationId) {
    await userRef.collection('conversations').doc(conversationId).set({
        conversationId: conversationId,
        userId: otherUserData.data().id,
        userName: otherUserData.data().name,
        lastMessage: null,
        lastMessageRead: false
    });
}

async function putConversationIdInMatchRecord(userRef, matchId, conversationId) {
    await userRef.collection('matches').doc(matchId).update({
        conversationId: conversationId
    });
}

exports.messageSent = functions.firestore.document('/conversations/{conversationId}/messages/{messageId}')
    .onCreate(async (snap, context) => {
        const conversationId = context.params.conversationId;
        const conversation = await db.collection('conversations').doc(conversationId).get();

        const firstUid = conversation.data().userIds[0];
        const secondUid = conversation.data().userIds[1];

        const firstUserRef = getGenderCollection(firstUid).doc(firstUid);
        const secondUserRef = getGenderCollection(secondUid).doc(secondUid);

        if(snap.data().userId == firstUid) {
            await updateLastMessageInConversation(firstUserRef, conversationId, snap.data(), true);
            await updateLastMessageInConversation(secondUserRef, conversationId, snap.data(), false);
        } else {
            await updateLastMessageInConversation(firstUserRef, conversationId, snap.data(), false);
            await updateLastMessageInConversation(secondUserRef, conversationId, snap.data(), true);
        }
    });

async function updateLastMessageInConversation(userRef, conversationId, message, readByDefault) {
    await userRef.collection('conversations').doc(conversationId).update({
        lastMessage: message,
        lastMessageRead: readByDefault
    });
}