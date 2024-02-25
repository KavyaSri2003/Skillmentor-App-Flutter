import 'package:cloud_firestore/cloud_firestore.dart';

void updateFieldName() async {
  try {
    // Get a reference to the collection
    CollectionReference mentorsCollection = FirebaseFirestore.instance.collection('mentors');

    // Retrieve all documents in the collection
    QuerySnapshot querySnapshot = await mentorsCollection.get();

    // Iterate over each document and update the field name
    querySnapshot.docs.forEach((doc) async {
      // Get the document ID
      String docId = doc.id;

      // Update the field 'mentorName' to 'name'
      await mentorsCollection.doc(docId).update({
        'name': doc['mentorName'], // Assuming 'mentorName' is the current field name
      });

      print('Field name updated for document: $docId');
    });
  } catch (e) {
    print('Error updating field name: $e');
  }
}

void main() {
  updateFieldName();
}
