import common

def a(data):
    common.log('A')
    res = None
    return res

def b(data):
    common.log('B')
    res = None
    return res

if __name__ == "__main__":
    common.start(a, b)

