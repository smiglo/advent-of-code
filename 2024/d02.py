import common

def a(data):
    res = 0
    for l in data.splitlines():
        l = list(map(int, l.strip().split()))
        common.log(f'l: {l}')
        if any(l[i]<=l[i+1] for i in range(len(l)-1)) and any(l[i]>l[i+1] for i in range(len(l)-1)):
            common.log("-1")
            continue
        r = [(a, b) for a, b in zip(l, l[1:]) if 0 < abs(a-b) <= 3]
        common.log(f'r: {r}')
        if len(l) - len(r) != 1:
            common.log("-1")
            continue
        res += 1
    return res

def b(data):
    res = 0
    for l in data.splitlines():
        l_orig = list(map(int, l.strip().split(' ')))
        for i in range(len(l_orig)):
            l = l_orig[:i] + l_orig[i+1:]
            common.log(f'l: {l}')
            if any(l[i]<=l[i+1] for i in range(len(l)-1)) and any(l[i]>l[i+1] for i in range(len(l)-1)):
                common.log("-1")
                continue
            r = [(a, b) for a, b in zip(l, l[1:]) if 0 < abs(a-b) <= 3]
            common.log(f'r: {r}')
            if len(l) - len(r) != 1:
                common.log("-2")
                continue
            res += 1
            break
    return res

if __name__ == "__main__":
    common.start(a, b)

