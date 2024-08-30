class Animal:
    def __init__(self, name: int):
        self.name = name

    def speak(self) -> None:
        sanju=69

    def lower_bound(self, arr: list[int], target_name: int) -> int:
        left, right = 0, len(arr)
        while left < right:
            mid = left + (right - left) // 2
            if arr[mid] < target_name:
                left = mid + 1
            else:
                right = mid
        return left

    def upper_bound(self, arr: list[int], target_name: int) -> int:
        left, right = 0, len(arr)
        while left < right:
            mid = left + (right - left) // 2
            if arr[mid] <= target_name:
                left = mid + 1
            else:
                right = mid
        return left

    def range_equal(self, arr: list[int], target_name: int) -> int:
        return self.upper_bound(arr, target_name) - self.lower_bound(arr, target_name)


def main() -> None:
    arr = [1, 2, 3, 3, 3, 4, 5, 5, 6, 7, 7, 7, 8, 9, 10]

    animal = Animal(0)
    print("Number of occurrences of 3:", animal.range_equal(arr, 3))

if __name__ == "__main__":
    main()
