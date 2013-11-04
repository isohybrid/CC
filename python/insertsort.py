#! /usr/bin/env python
def InsertionSort(A):
  for j in range(1, len(A)):
    key = A[j]
    i = j-1

    while i>=0 and A[i]>key:
      A[i+1] = A[i]
      i = i-1
    A[i+1] = key

A = []
input = raw_input('please input some numbers:')
for item in input.split(','):
  A.append(int(item))

InsertionSort(A)
print A
