import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/place_model.dart';

class PlacesRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  PlacesRemoteDataSource(this.firestore, this.auth);

  Future<List<PlaceModel>> getPlaces() async {
    final snapshot = await firestore.collection('places').get();
    return snapshot.docs
        .map((doc) => PlaceModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<void> toggleBookmark(String placeId) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final bookmarkRef = firestore
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .doc(placeId);

    final doc = await bookmarkRef.get();
    if (doc.exists) {
      await bookmarkRef.delete();
    } else {
      await bookmarkRef.set({
        'placeId': placeId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<List<String>> getBookmarkedPlaceIds() async {
    final user = auth.currentUser;
    if (user == null) {
      // If no user is logged in, return empty list ??
      // For now throw or return empty. Return empty seems safer for UI.
      return [];
    }

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<void> seedPlaces() async {
    // ... existing implementation
    final collection = firestore.collection('places');
    final snapshot = await collection.get();

    bool needsUpdate = false;
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if ((data['imageUrl'] != null &&
                data['imageUrl'].toString().startsWith('http')) ||
            data['price'] == null) {
          needsUpdate = true;
          break;
        }
      }
    }

    if (snapshot.docs.isEmpty || needsUpdate) {
      // Delete existing if update needed
      if (needsUpdate) {
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }

      final List<Map<String, dynamic>> initialPlaces = [
        {
          'name': 'Eiffel Tower',
          'description':
              'A wrought-iron lattice tower on the Champ de Mars. Named after Gustave Eiffel, it was built for the 1889 World\'s Fair. A global cultural icon of France and one of the most recognizable structures in the world.',
          'imageUrl': 'assets/images/details-1.jpg',
          'location': 'Paris, France',
          'rating': 4.8,
          'price': 120.0,
        },
        {
          'name': 'Great Wall of China',
          'description':
              'A series of fortifications built across historical Chinese borders to protect against nomadic groups. The most famous sections were built by the Ming dynasty. It is a UNESCO World Heritage site and global icon.',
          'imageUrl': 'assets/images/details-2.jpg',
          'location': 'China',
          'rating': 4.7,
          'price': 150.0,
        },
        {
          'name': 'Taj Mahal',
          'description':
              'An ivory-white marble mausoleum on the Yamuna river bank in Agra. Commissioned in 1632 by Shah Jahan for his wife Mumtaz Mahal. A UNESCO World Heritage Site and jewel of Muslim art in India.',
          'imageUrl': 'assets/images/details-3.jpg',
          'location': 'Agra, India',
          'rating': 4.9,
          'price': 80.0,
        },
        {
          'name': 'Machu Picchu',
          'description':
              'A 15th-century Inca citadel on a mountain ridge in Peru. Often called the "Lost City of the Incas". Built for emperor Pachacuti around 1450 and abandoned a century later. A symbol of Inca power.',
          'imageUrl': 'assets/images/details-4.jpg',
          'location': 'Peru',
          'rating': 4.8,
          'price': 190.0,
        },
        {
          'name': 'Colosseum',
          'description':
              'An oval amphitheatre in the centre of Rome, Italy. The largest ancient amphitheatre ever built. Construction began in 72 AD under Vespasian. Could hold 50,000 spectators for gladiatorial contests.',
          'imageUrl': 'assets/images/details-5.jpg',
          'location': 'Rome, Italy',
          'rating': 4.7,
          'price': 110.0,
        },
        {
          'name': 'Statue of Liberty',
          'description':
              'A colossal neoclassical sculpture on Liberty Island, NYC. A gift from France to the US in 1886. The figure of Libertas holds a torch and a tablet inscribed with the date of the Declaration of Independence.',
          'imageUrl': 'assets/images/place2.jpg',
          'location': 'New York, USA',
          'rating': 4.6,
          'price': 95.0,
        },
      ];

      for (final place in initialPlaces) {
        await collection.add(place);
      }
    }
  }
}
