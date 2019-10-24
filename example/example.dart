import 'package:class_test/class_test.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class Animal {
  String get kingdom;
  String get order;
  String get family;
}

class Dog implements Animal {
  String get kingdom => 'Animalia';
  String get order => 'Carnivora';
  String get family => 'Canidae';
}

class Cat implements Animal {
  String get kingdom => 'Animalia';
  String get order => 'Carnivora';
  String get family => 'Felidae';
}



abstract class AnimalTest extends Test {
  Animal animal;

  AnimalTest(this.animal, String name): super(name);

  @override
  void declareTests() {
    declareTest('belongs to Animalia kingdom', () {
      expect(animal.kingdom, 'Animalia');
    });
    declareTest('belongs to Carnivora order', () {
      expect(animal.order, 'Carnivora');
    });
  }
}

class DogTest extends AnimalTest {
  DogTest(): super(Dog(), 'Dog');

  @override
  void declareTests() {
    super.declareTests();
    declareTest('belongs to Canidae family', () {
      expect(animal.family, 'Canidae');
    });
  }
}

class CatTest extends AnimalTest {
  CatTest(): super(Cat(), 'Cat');

  @override
  void declareTests() {
    super.declareTests();
    declareTest('belongs to Felidae family', () {
      expect(animal.family, 'Felidae');
    });
  }
}

void main() {
  DogTest().run();
  CatTest().run();
}