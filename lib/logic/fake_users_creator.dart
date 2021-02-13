import 'dart:math';

import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/location_repository.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';

void createFakeUsers() async {
  final repo = UsersRepository();

  final firstDate = DateTime(1973, 01, 01);
  final secondDate = DateTime(2002, 03, 23);

  final currentLocation = await LocationRepository().getCurrentLocation();

  for (int i = 0; i < 50; i++) {
    final name = i % 2 == 0
        ? _menNames[i % _menNames.length]
        : _womenNames[i % _womenNames.length];
    final daysDiff = Random().nextInt(secondDate.difference(firstDate).inDays);
    final birthDate = secondDate.subtract(Duration(days: daysDiff));
    final fakeUser = User(
      id: 'asdsa$i',
      name: name,
      birthDate: birthDate,
      gender: i % 2 == 0 ? Gender.Man : Gender.Woman,
      caption: 'Best caption ever. Super unique',
      location: currentLocation,
    );

    await repo.createUser(fakeUser);
  }
}

final _menNames = [
  "Adam",
  "Alex",
  "Aaron",
  "Ben",
  "Carl",
  "Dan",
  "David",
  "Edward",
  "Fred",
  "Frank",
  "George",
  "Hal",
  "Hank",
  "Ike",
  "John",
  "Jack",
  "Joe",
  "Larry",
  "Monte",
  "Matthew",
  "Mark",
  "Nathan",
  "Otto",
  "Paul",
  "Peter",
  "Roger",
  "Roger",
  "Steve",
  "Thomas",
  "Tim",
  "Ty",
  "Victor",
  "Walter",
];

final _womenNames = [
  "Emily",
  "Hannah",
  "Madison",
  "Ashley",
  "Sarah",
  "Alexis",
  "Samantha",
  "Jessica",
  "Elizabeth",
  "Taylor",
  "Lauren",
  "Alyssa",
  "Kayla",
  "Abigail",
  "Brianna",
  "Olivia",
  "Emma",
  "Megan",
  "Grace",
  "Victoria",
  "Rachel",
  "Anna",
  "Sydney",
  "Destiny",
  "Morgan",
  "Jennifer",
  "Jasmine",
  "Haley",
  "Julia",
  "Kaitlyn",
];
