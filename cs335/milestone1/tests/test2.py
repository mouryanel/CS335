class SegmentTree:
    def __init__(self, arr: list[int]):
        self.size = len(arr)
        self.tree = [0] * (4 * self.size)
        self.lazy = [0] * (4 * self.size)
        self.build(arr, 0, 0, self.size - 1)

    def build(self, arr: list[int], idx: int, left: int, right: int) -> None:
        if left == right:
            self.tree[idx] = arr[left]
            return

        mid = left + (right - left) // 2
        self.build(arr, 2 * idx + 1, left, mid)
        self.build(arr, 2 * idx + 2, mid + 1, right)
        self.tree[idx] = self.tree[2 * idx + 1] + self.tree[2 * idx + 2]

    def update(self, idx: int, delta: int, left: int, right: int, pos: int) -> None:
        if left == right:
            self.tree[idx] += delta
            return

        mid = left + (right - left) // 2
        if pos <= mid:
            self.update(2 * idx + 1, delta, left, mid, pos)
        else:
            self.update(2 * idx + 2, delta, mid + 1, right, pos)
        self.tree[idx] = self.tree[2 * idx + 1] + self.tree[2 * idx + 2]

    def range_update(self, start: int, end: int, delta: int, idx: int, left: int, right: int) -> None:
        if right is None:
            right = self.size - 1

        if left > end or right < start:
            return

        if left >= start and right <= end:
            self.tree[idx] += delta * (right - left + 1)
            if left != right:
                self.lazy[2 * idx + 1] += delta
                self.lazy[2 * idx + 2] += delta
            return

        mid = left + (right - left) // 2
        self.range_update(start, end, delta, 2 * idx + 1, left, mid)
        self.range_update(start, end, delta, 2 * idx + 2, mid + 1, right)
        self.tree[idx] = self.tree[2 * idx + 1] + self.tree[2 * idx + 2]

    def query(self, start: int, end: int, idx: int, left: int, right: int, carry: int) -> int:
        if right is None:
            right = self.size - 1

        if left > end or right < start:
            return 0

        if left >= start and right <= end:
            return self.tree[idx] + carry * (right - left + 1)

        mid = left + (right - left) // 2
        return self.query(start, end, 2 * idx + 1, left, mid, carry + self.lazy[idx]) + self.query(start, end, 2 * idx + 2, mid + 1, right, carry + self.lazy[idx])

def main() -> None:
    arr = [1, 2, 3, 4, 5]
    seg_tree = SegmentTree(arr)

    print("Segment tree:", seg_tree.tree)

    seg_tree.range_update(0, 2, 3)
    print("Segment tree after range update:", seg_tree.tree)

    print("Value at index 2:", seg_tree.query(2, 2))

if __name__ == "__main__":
    main()
