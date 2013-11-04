#! /usr/bin/env python

def merge(list_a, list_b):
  key_a, key_b = 0, 0
  result= []
  len_a = len(list_a)
  len_b = len(list_b)
  while key_a < len_a and key_b < len_b:
    if list_a[key_a] <= list_b[key_b]:
      result.append(list_a[key_a])
      key_a += 1
    else:
      result.append(list_b[key_b])
      key_b += 1
  while key_a < len_a:
    result.append(list_a[key_a])
    key_a += 1
  while key_b < len_b:
    result.append(list_b[key_b])
    key_b += 1
  return result

# loop
def merge_sort1(list):
  length = len(list)
  result = []
  step = 1
  while(step <= (length+1)/2):
    result = []
    for i in range(0, length, step*2):
      max_key = i + 2*step
      result.extend(merge(list[i:i+step], list[i+step:i+step*2]))
    list = result
    step += 1
  return result

# recursion
def merge_sort2(list):
  length = len(list)
  if length == 1:
    return list
  else:
    temp_a = merge_sort2(list[0: length/2])
    temp_b = merge_sort2(list[length/2: length])
    return merge(temp_a, temp_b)

A = []
input = raw_input('please input the number:')
for item in input.split(','):
  A.append(int(item))

print merge_sort1(A)
print merge_sort2(A)
