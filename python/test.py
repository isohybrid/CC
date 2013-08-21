import random

a = []
b = []
c = []
t = 0

for i in range(0, 20):
    m = random.randint(0, 10000)
    n = random.randint(0, 10000)
    a.append(m)
    b.append(n)

print len(a) + 1
print "unsorted list"
print a
print b
for i in range(0, 20):
    for j in range(i + 1, 20):
        if a[i] > a[j]:
            tmp = a[i]
            a[i] = a[j]
            a[j] = tmp
        if b[i] > b[j]:
            tmp = b[i]
            b[i] = b[j]
            b[j] = tmp
print "sorted list"
print a
print b

for i in range(0, 20):
    tmp = a[i] - b[i]
    c.append(tmp)
    t = t + tmp
print "the list c"
print c
print t

c = a + b
print "sorted list of c........."
print c


def list_sum(lst):
    i = 0
    lsum = 0
    for i in range(0, len(lst)):
        lsum = lsum + lst[i]
    return lsum

a = []
b = []
a.append(c[38])
b.append(c[39])
i = 0
for i in range(0, 19):
    if list_sum(a) > list_sum(b):
        a.append(c[2 * i])
        b.append(c[2 * i + 1])
    else:
        a.append(c[2 * i + 1])
        b.append(c[2 * i])

print "The result....................."
asum = list_sum(a)
bsum = list_sum(b)
print asum
print bsum
print a
print b
