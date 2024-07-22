import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String fullName;
  final String email;
  final String address;
  final String city;
  final String country;
  final String zipCode;

  const User({
    this.id,
    this.fullName = '',
    this.email = '',
    this.address = '',
    this.city = '',
    this.country = '',
    this.zipCode = '',
  });

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? address,
    String? city,
    String? country,
    String? zipCode,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'address': address,
      'city': city,
      'country': country,
      'zipCode': zipCode,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as String : null,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      city: map['city'] as String,
      country: map['country'] as String,
      zipCode: map['zipCode'] as String,
    );
  }

  Map<String, dynamic> toDocument() => toMap();

  factory User.fromSnapshot(DocumentSnapshot snapshot) =>
      User.fromMap(snapshot.data() as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id!,
      fullName,
      email,
      address,
      city,
      country,
      zipCode,
    ];
  }
}
