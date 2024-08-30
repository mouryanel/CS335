class MinHeap:
    def __init__(self):
        self.heap = []

    def heapify_up(self, idx: int) -> None:
        if idx == 0:
            return

        parent_idx = (idx - 1) // 2
        if self.heap[parent_idx] > self.heap[idx]:
            self.heap[parent_idx], self.heap[idx] = self.heap[idx], self.heap[parent_idx]
            self.heapify_up(parent_idx)

    def heapify_down(self, idx: int) -> None:
        left_child_idx = 2 * idx + 1
        right_child_idx = 2 * idx + 2
        smallest = idx

        if left_child_idx < len(self.heap) and self.heap[left_child_idx] < self.heap[smallest]:
            smallest = left_child_idx

        if right_child_idx < len(self.heap) and self.heap[right_child_idx] < self.heap[smallest]:
            smallest = right_child_idx

        if smallest != idx:
            self.heap[idx], self.heap[smallest] = self.heap[smallest], self.heap[idx]
            self.heapify_down(smallest)

    def push(self, val: int) -> None:
        self.heap.append(val)
        self.heapify_up(len(self.heap) - 1)

    def pop(self) -> int:
        if len(self.heap) == 0:
            raise IndexError("Heap is empty")
        
        if len(self.heap) == 1:
            return self.heap.pop()

        root_val = self.heap[0]
        self.heap[0] = self.heap.pop()
        self.heapify_down(0)
        return root_val

    def peek(self) -> int:
        if len(self.heap) == 0:
            raise IndexError("Heap is empty")
        return self.heap[0]

def main() -> None:
    heap = MinHeap()

    heap.push(5)
    heap.push(3)
    heap.push(7)
    heap.push(1)
    heap.push(9)

    print("Min heap:", heap.heap)

    print("Top element:", heap.peek())

    print("Popped element:", heap.pop())
    print("Min heap after pop:", heap.heap)

if __name__ == "__main__":
    main()
