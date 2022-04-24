import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_dong/models/chat.dart';
import 'package:ding_dong/models/user.dart';
import 'package:ding_dong/screen/home/add_friend.dart';

class DatabaseService {
  final String? data;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat');
  DatabaseService([this.data]);

  //seach friend by id
  Future getUserById(String id) async {
    try {
      return await userCollection.where('DD id', isEqualTo: id).get();
    } catch (e) {
      print(e.toString());
    }
  }

  //get data from firestore
  Data _getUserData(DocumentSnapshot snapshot) {
    return Data(
      dId: (snapshot.data() as dynamic)['DD id'],
      email: (snapshot.data() as dynamic)['Email'],
      name: (snapshot.data() as dynamic)['Name'],
    );
  }

  Stream<Data> get getMyData {
    return userCollection.doc(data).snapshots().map(_getUserData);
  }

  //upload data to firestore
  Future uploadUserData(String ddId, String email, String name) async {
    return await userCollection.doc(data).set({
      'Name': name,
      'DD id': ddId,
      'Email': email,
    });
  }

  Future upateUserData(String name, String ddId, String email) async {
    return await userCollection.doc(data).set({
      'Name': name,
      'DD id': ddId,
      'Email': email,
    });
  }

  //upadate my data from firestore
  FutureData _updateDataFromSnapshot(DocumentSnapshot snapshot) {
    return FutureData(
      uid: data!,
      dId: (snapshot.data() as dynamic)['DD id'],
      email: (snapshot.data() as dynamic)['Email'],
      name: (snapshot.data() as dynamic)['Name'],
    );
  }

  Stream<FutureData> get changeName {
    return userCollection.doc(data).snapshots().map(_updateDataFromSnapshot);
  }

  //create chat room in firestore
  Future createChatRoom(String chatId, List user, String chatRoomId) async {
    try {
      return await chatCollection
          .doc(chatId)
          .set({'Users': user, 'ChatRoomId': chatRoomId});
    } catch (e) {
      print(e.toString());
    }
  }

  //get your own id
  Future getMyId(String uid) async {
    return userCollection.doc(uid).get();
  }

  //add chat to firestore
  addChat(String chatRoomId, message, myId, time, date, chatTime) {
    try {
      return chatCollection.doc(chatRoomId).collection('chats').doc(date).set({
        'SendBy': myId,
        'Message': message,
        'Time': time,
        'Format Time': chatTime
      });
    } on Exception catch (e) {
      return e.toString();
    }
  }

  //chat from snapshot
  List<Chat> _getChatFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Chat(
        chat: (doc.data() as dynamic)['Message'],
        sendBy: (doc.data() as dynamic)['SendBy'],
        time: (doc.data() as dynamic)['Format Time'],
      );
    }).toList();
  }

  //get chat from firestore
  Stream<List<Chat>> get getChat {
    return chatCollection
        .doc(data)
        .collection('chats')
        .orderBy('Time')
        .snapshots()
        .map(_getChatFromSnapshot);
  }

  //search if room already exists
  Future getRoom(String roomId) async {
    return await chatCollection.doc(roomId).get();
  }

  List<Friend> _getFriendListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Friend(
          id0: (doc.data() as dynamic)['Users'][0],
          id1: (doc.data() as dynamic)['Users'][1]);
    }).toList();
  }

  //get friend list
  Stream<List<Friend>> get friendList {
    return chatCollection
        .where('Users', arrayContains: data)
        .snapshots()
        .map(_getFriendListFromSnapshot);
  }
}
