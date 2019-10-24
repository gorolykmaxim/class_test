# class_test

Allows structuring flutter tests using classes instead of functions to 
simplify polymorphism testing.

This library is just a simple OO wrapper on top of the original flutter
test package.

## Getting Started

Lets imagine you need to test following classes:

```dart
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
```

Normally you would have to write identical tests both for a Dog and
a Cat. Doing this with low code duplication using flutter's default test 
package might become tricky pretty quickly due to the usage of functions 
instead of classes.

But worry not: let's define our tests as classes.

First, lets create a test that would work both for a Dog and a Cat:
```dart
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
```

Now, lets create tests for a Dog and a Cat with parts of those tests
that are actually different:
```dart
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
```

In order for this two tests to run, lets include them in the main
function:
```dart
void main() {
  DogTest().run();
  CatTest().run();
}
```

## Setup and teardown

To specify setUp* and tearDown* method bodies, you can simply
override corresponding methods of the Test class.