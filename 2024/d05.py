import common
import pprint

def get_wrongs(l, afters):
    ll = len(l)
    l_wrong = []
    match = True
    for i, vi in enumerate(l):
        for vj in l[i+1:]:
            if not vj in afters or not vi in afters[vj]: continue
            match = False
            l_wrong.append((vi, vj))
    return (match, l_wrong)

def compute(compute_mode, data):
    common.log()
    afters = {}
    mode='afters'
    res = 0
    for l in data.splitlines():
        match mode:
            case 'afters':
                if not l:
                    mode='pages'
                    common.log(f'afters={pprint.pformat(afters, indent=2)}')
                    common.log()
                    continue
                v, a = map(int, l.split('|'))
                if not v in afters: afters[v] = []
                afters[v].append(a)
            case 'pages':
                if not l: break
                l = list(map(int, l.split(',')))
                ll = len(l)
                match, l_wrong = get_wrongs(l, afters)
                match compute_mode:
                    case 'A':
                        if not match: continue
                        res += l[ll//2]
                        common.log(f'{l} --> {l[ll//2]}')
                    case 'B':
                        if match: continue
                        while not match:
                            common.log(f'{l}')
                            common.log(f'  {l_wrong}')
                            for v in l_wrong:
                                ii, ij = l.index(v[0]), l.index(v[1])
                                common.log(f'  swap l[{ii}] x l[{ij}] --> {l[ii]} x {l[ij]}')
                                l[ii], l[ij] = l[ij], l[ii]
                            match, l_wrong = get_wrongs(l, afters)
                        res += l[ll//2]
                        common.log(f'  {l} :: {l[ll//2]}')
    common.log()
    return res

def a(data):
    return compute('A', data)

def b(data):
    return compute('B', data)

if __name__ == "__main__":
    common.start(a, b)

