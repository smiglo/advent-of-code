import common

def a(data):
    res = 0
    left = []
    right = []
    for l in data.splitlines():
        l = list(map(int, l.strip().split()))
        left.append(l[0])
        right.append(l[1])

    for a , b in zip(sorted(left), sorted(right)):
        res += abs(a-b)

    return res

def b(data):
    res = 0
    left = []
    right = []
    for l in data.splitlines():
        l = list(map(int, l.strip().split()))
        left.append(l[0])
        right.append(l[1])

    for i in left:
        res += i * len([x for x in right if x == i])

    return res

if __name__ == "__main__":
    common.start(a, b)

