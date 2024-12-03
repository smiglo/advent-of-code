import common

def getVert(data, i, j, l):
    s = [ data[i+k][j] for k in range(l) ]
    return ''.join(s)

def getDiag1(data, i, j, l):
    s = [ data[i+k][j+k] for k in range(l) ]
    return ''.join(s)

def getDiag2(data, i, j, l):
    s = [ data[i+k][j-k] for k in range(l) ]
    return ''.join(s)

def a(data):
    data = data.splitlines()
    n = len(data)
    m = len(data[0])

    p = 'XMAS'
    p_rev = p[::-1]
    p_len = len(p)

    count = 0
    for i in range(n):
        for j in range(m):
            if j <= m - p_len:
                if data[i][j:j+p_len] == p or data[i][j:j+p_len] == p_rev:
                    count += 1
                    common.log('[{:03d}] Ho: ({:3d}, {:3d}) rev: {:b}'.format(count, i, j, data[i][j:j+p_len] == p_rev))
            if i <= n - p_len:
                s = getVert(data, i, j, p_len)
                if s == p or s == p_rev:
                    count += 1
                    common.log('[{:03d}] Ve: ({:3d}, {:3d}) rev: {:b}'.format(count, i, j, s == p_rev))
            if i <= n - p_len and j <= n - p_len:
                s = getDiag1(data, i, j, p_len)
                if s == p or s == p_rev:
                    count += 1
                    common.log('[{:03d}] D1: ({:3d}, {:3d}) rev: {:b}'.format(count, i, j, s == p_rev))
            if i <= n - p_len and j >= p_len - 1:
                s = getDiag2(data, i, j, p_len)
                if s == p or s == p_rev:
                    count += 1
                    common.log('[{:03d}] D2: ({:3d}, {:3d}) rev: {:b}'.format(count, i, j, s == p_rev))

    return count

def b(data):
    data = data.splitlines()
    n = len(data)
    m = len(data[0])

    p = 'MAS'
    p_rev = p[::-1]
    p_len = len(p)

    count = 0
    for i in range(1, n-1):
        for j in range(1, m-1):
            if data[i][j] != 'A':
                continue
            s1 = getDiag1(data, i-1, j-1, 3)
            s2 = getDiag2(data, i-1, j+1, 3)
            common.log(f': {s1} {s2}')
            if ( s1 == p or s1 == p_rev ) and (s2 == p or s2 == p_rev):
                count += 1

    return count

if __name__ == "__main__":
    common.start(a, b)

