class Shape:
    def __init__(self, color: str):
        self.color = color

    def draw(self) -> None:
        pass

class Circle(Shape):
    def draw(self) -> None:
        print("Drawing a", self.color, "circle")

class Rectangle(Shape):
    def draw(self) -> None:
        print("Drawing a", self.color, "rectangle")


class Animal:
    def __init__(self, name: str):
        self.name = name

    def speak(self) -> None:
        pass

class Dog(Animal):
    def speak(self) -> None:
        print(self.name + " says Woof!")

class Cat(Animal):
    def speak(self) -> None:
        print(self.name + " says Meow!")


def main() -> None:
    circle = Circle("blue")
    rectangle = Rectangle("red")

    for shape in shapes:
        shape.draw()

    dog = Dog("Buddy")
    cat = Cat("Whiskers")
    
    for animal in animals:
        animal.speak()

if __name__ == "__main__":
    main()
