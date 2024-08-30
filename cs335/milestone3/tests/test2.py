def main():
    # Initialize variables with type annotations
    a: int = 10
    b: int = 5
    result: int = 0

    # Perform arithmetic operations
    result = a + b
    print("Sum:", result)

    result = a - b
    print("Difference:", result)

    result = a * b
    print("Product:", result)

    result = a / b
    print("Quotient:", result)

    # Use a list in a for loop
    data: list[int] = [-2, 45, 0, 11, -9]
    print("List:")

    for i in range(len(data)):
        print(data[i])

if __name__ == "__main__":
    main()
