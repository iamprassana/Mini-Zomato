import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_zomato/data/models/restaurant.dart';

class FirebaseAuthRemoteDataSource {
  FirebaseAuthRemoteDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final String uid = credential.user!.uid;
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return credential;
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  Future<String?> getUserDisplayName() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;
    final data = doc.data();
    return data != null ? data['name'] as String? : null;
  }

  // Indian and International restaurants near Amaravati, Andhra Pradesh
  List<Restaurant> getFakeRestaurants() {
    return [
      Restaurant(
        id: '1',
        name: 'Punjabi Dhaba',
        imageUrl:
            'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400',
        cuisine: 'North Indian',
        rating: 4.6,
        deliveryTime: 25,
        deliveryFee: 30,
        minOrder: 200,
        address: 'Amaravati, Andhra Pradesh',
        menu: [
          MenuItem(
            id: '1',
            name: 'Butter Chicken',
            description: 'Creamy tomato-based curry with tender chicken pieces',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=300',
            category: 'Main Course',
            isVeg: false,
            isSpicy: false,
          ),
          MenuItem(
            id: '2',
            name: 'Dal Makhani',
            description: 'Slow-cooked black lentils with cream and butter',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=300',
            category: 'Main Course',
            isVeg: true,
            isSpicy: false,
          ),
          MenuItem(
            id: '3',
            name: 'Tandoori Roti',
            description: 'Whole wheat bread baked in clay oven',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=300',
            category: 'Breads',
            isVeg: true,
            isSpicy: false,
          ),
        ],
      ),
      Restaurant(
        id: '2',
        name: 'South Indian Delights',
        imageUrl:
            'https://images.unsplash.com/photo-1563379091339-03246963d4a9?w=400',
        cuisine: 'South Indian',
        rating: 4.4,
        deliveryTime: 20,
        deliveryFee: 25,
        minOrder: 150,
        address: 'Guntur, Andhra Pradesh',
        menu: [
          MenuItem(
            id: '4',
            name: 'Masala Dosa',
            description: 'Crispy rice crepe with spiced potato filling',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1563379091339-03246963d4a9?w=300',
            category: 'Breakfast',
            isVeg: true,
            isSpicy: false,
          ),
          MenuItem(
            id: '5',
            name: 'Idli Sambar',
            description: 'Steamed rice cakes with lentil soup',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1563379091339-03246963d4a9?w=300',
            category: 'Breakfast',
            isVeg: true,
            isSpicy: false,
          ),
          MenuItem(
            id: '6',
            name: 'Filter Coffee',
            description: 'Traditional South Indian filter coffee',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1563379091339-03246963d4a9?w=300',
            category: 'Beverages',
            isVeg: true,
            isSpicy: false,
          ),
        ],
      ),
      Restaurant(
        id: '3',
        name: 'Andhra Spice House',
        imageUrl:
            'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400',
        cuisine: 'Andhra',
        rating: 4.7,
        deliveryTime: 22,
        deliveryFee: 20,
        minOrder: 180,
        address: 'Vijayawada, Andhra Pradesh',
        menu: [
          MenuItem(
            id: '7',
            name: 'Andhra Chicken Curry',
            description: 'Spicy chicken curry with authentic Andhra spices',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300',
            category: 'Main Course',
            isVeg: false,
            isSpicy: true,
          ),
          MenuItem(
            id: '8',
            name: 'Gongura Pachadi',
            description: 'Tangy sorrel leaves chutney',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300',
            category: 'Side Dish',
            isVeg: true,
            isSpicy: true,
          ),
          MenuItem(
            id: '9',
            name: 'Pesarattu',
            description: 'Green gram dosa with ginger chutney',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300',
            category: 'Breakfast',
            isVeg: true,
            isSpicy: false,
          ),
        ],
      ),
      Restaurant(
        id: '4',
        name: 'Tamil Nadu Kitchen',
        imageUrl:
            'https://images.unsplash.com/photo-1551218808-94e220e084d2?w=400',
        cuisine: 'Tamil',
        rating: 4.5,
        deliveryTime: 28,
        deliveryFee: 35,
        minOrder: 200,
        address: 'Nellore, Andhra Pradesh',
        menu: [
          MenuItem(
            id: '10',
            name: 'Chettinad Chicken',
            description: 'Spicy Chettinad style chicken curry',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1551218808-94e220e084d2?w=300',
            category: 'Main Course',
            isVeg: false,
            isSpicy: true,
          ),
          MenuItem(
            id: '11',
            name: 'Pongal',
            description: 'Creamy rice and lentil dish',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1551218808-94e220e084d2?w=300',
            category: 'Breakfast',
            isVeg: true,
            isSpicy: false,
          ),
          MenuItem(
            id: '12',
            name: 'Rasam',
            description: 'Spicy tamarind soup with herbs',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1551218808-94e220e084d2?w=300',
            category: 'Soup',
            isVeg: true,
            isSpicy: true,
          ),
        ],
      ),
      Restaurant(
        id: '5',
        name: 'Kerala Delights',
        imageUrl:
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        cuisine: 'Kerala',
        rating: 4.6,
        deliveryTime: 30,
        deliveryFee: 40,
        minOrder: 250,
        address: 'Kakinada, Andhra Pradesh',
        menu: [
          MenuItem(
            id: '13',
            name: 'Kerala Fish Curry',
            description: 'Coconut-based fish curry with spices',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=300',
            category: 'Main Course',
            isVeg: false,
            isSpicy: true,
          ),
          MenuItem(
            id: '14',
            name: 'Appam with Stew',
            description: 'Soft rice hoppers with vegetable stew',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=300',
            category: 'Breakfast',
            isVeg: true,
            isSpicy: false,
          ),
          MenuItem(
            id: '15',
            name: 'Malabar Parotta',
            description: 'Layered flatbread with curry',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=300',
            category: 'Breads',
            isVeg: true,
            isSpicy: false,
          ),
        ],
      ),
      Restaurant(
        id: '6',
        name: 'Pizza Hut',
        imageUrl:
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
        cuisine: 'Italian',
        rating: 4.2,
        deliveryTime: 30,
        deliveryFee: 50,
        minOrder: 400,
        address: 'Amaravati, Andhra Pradesh',
        menu: [
          MenuItem(
            id: '16',
            name: 'Margherita Pizza',
            description: 'Classic tomato sauce with mozzarella cheese',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=300',
            category: 'Pizza',
            isVeg: true,
            isSpicy: false,
          ),
          MenuItem(
            id: '17',
            name: 'Chicken Tikka Pizza',
            description: 'Indian spiced chicken on pizza base',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=300',
            category: 'Pizza',
            isVeg: false,
            isSpicy: true,
          ),
        ],
      ),
      Restaurant(
        id: '7',
        name: 'KFC India',
        imageUrl:
            'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400',
        cuisine: 'American',
        rating: 4.1,
        deliveryTime: 25,
        deliveryFee: 40,
        minOrder: 300,
        address: 'Guntur, Andhra Pradesh',
        menu: [
          MenuItem(
            id: '18',
            name: 'Chicken Bucket',
            description: 'Crispy fried chicken with sides',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300',
            category: 'Chicken',
            isVeg: false,
            isSpicy: false,
          ),
          MenuItem(
            id: '19',
            name: 'Veg Zinger Burger',
            description: 'Spicy veg patty with lettuce and mayo',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300',
            category: 'Burgers',
            isVeg: true,
            isSpicy: true,
          ),
        ],
      ),
      Restaurant(
        id: '8',
        name: 'Domino\'s Pizza',
        imageUrl:
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
        cuisine: 'Italian',
        rating: 4.0,
        deliveryTime: 20,
        deliveryFee: 30,
        minOrder: 350,
        address: 'Vijayawada, Andhra Pradesh',
        menu: [
          MenuItem(
            id: '20',
            name: 'Pepperoni Pizza',
            description: 'Spicy pepperoni with melted cheese',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=300',
            category: 'Pizza',
            isVeg: false,
            isSpicy: true,
          ),
          MenuItem(
            id: '21',
            name: 'Paneer Tikka Pizza',
            description: 'Indian cottage cheese with tikka spices',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=300',
            category: 'Pizza',
            isVeg: true,
            isSpicy: true,
          ),
        ],
      ),
      Restaurant(
        id: '9',
        name: 'McDonald\'s India',
        imageUrl:
            'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400',
        cuisine: 'American',
        rating: 3.9,
        deliveryTime: 18,
        deliveryFee: 25,
        minOrder: 200,
        address: 'Amaravati, Andhra Pradesh',
        menu: [
          MenuItem(
            id: '22',
            name: 'McAloo Tikki Burger',
            description: 'Spiced potato patty with fresh vegetables',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300',
            category: 'Burgers',
            isVeg: true,
            isSpicy: false,
          ),
          MenuItem(
            id: '23',
            name: 'Chicken Maharaja Mac',
            description: 'Double chicken patty with special sauce',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300',
            category: 'Burgers',
            isVeg: false,
            isSpicy: false,
          ),
        ],
      ),
      Restaurant(
        id: '10',
        name: 'Subway India',
        imageUrl:
            'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400',
        cuisine: 'American',
        rating: 4.0,
        deliveryTime: 22,
        deliveryFee: 20,
        minOrder: 150,
        address: 'Guntur, Andhra Pradesh',
        menu: [
          MenuItem(
            id: '24',
            name: 'Veg Delite Sub',
            description: 'Fresh vegetables with choice of bread',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300',
            category: 'Sandwiches',
            isVeg: true,
            isSpicy: false,
          ),
          MenuItem(
            id: '25',
            name: 'Chicken Tikka Sub',
            description: 'Spiced chicken with fresh vegetables',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300',
            category: 'Sandwiches',
            isVeg: false,
            isSpicy: true,
          ),
        ],
      ),
      Restaurant(
        id: '11',
        name: 'Haldiram\'s',
        imageUrl:
            'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400',
        cuisine: 'North Indian',
        rating: 4.4,
        deliveryTime: 20,
        deliveryFee: 20,
        minOrder: 150,
        address: 'Amaravati, Andhra Pradesh',
        menu: [
          MenuItem(
            id: '26',
            name: 'Chole Bhature',
            description: 'Spicy chickpeas with fried bread',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=300',
            category: 'Breakfast',
            isVeg: true,
            isSpicy: true,
          ),
          MenuItem(
            id: '27',
            name: 'Samosa',
            description: 'Crispy pastry with spiced potato filling',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=300',
            category: 'Snacks',
            isVeg: true,
            isSpicy: true,
          ),
        ],
      ),
      Restaurant(
        id: '12',
        name: 'Bikanerwala',
        imageUrl:
            'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400',
        cuisine: 'North Indian',
        rating: 4.2,
        deliveryTime: 18,
        deliveryFee: 15,
        minOrder: 100,
        address: 'Vijayawada, Andhra Pradesh',
        menu: [
          MenuItem(
            id: '28',
            name: 'Kachori',
            description: 'Crispy pastry with lentil filling',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=300',
            category: 'Snacks',
            isVeg: true,
            isSpicy: true,
          ),
          MenuItem(
            id: '29',
            name: 'Rasgulla',
            description: 'Sweet cottage cheese balls in sugar syrup',
            price: 100,
            imageUrl:
                'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=300',
            category: 'Desserts',
            isVeg: true,
            isSpicy: false,
          ),
        ],
      ),
    ];
  }
}
