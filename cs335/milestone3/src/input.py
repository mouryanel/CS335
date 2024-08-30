# Functions
def area(length: int, width: int) -> int:
  x: int = length* width
  return x


def main():
  x: int =3
  y: int =5
  ar: int = area(x, y)
  print(ar)

if __name__ == "__main__":
  main()
