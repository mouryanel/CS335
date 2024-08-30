def main():
    a: int = 15
    b: int = 7
    c: int = 20

    result: int = 0

    if a > b :
        result = a * c + b * c
    elif a <= b or c == 0:
        result = (a - b) / 2
    else:
        result = (b * c) % a

    print(result)

if __name__ == "__main__":
    main()
