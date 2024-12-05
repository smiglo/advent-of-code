import common
import sys
import pprint

llvl = 2

directions = {
    "current": 0,
    "v": [ 'U', 'R', 'D', 'L' ],
    "steps": {
        "U": (-1,  0),
        "R": ( 0,  1),
        "D": ( 1,  0),
        "L": ( 0, -1)
    }
}

visited = None

def pp(msg):
    print(msg, file=sys.stderr)

def get_dir(idx = None):
    v = idx
    match v:
        case '+1': v= (directions["current"] + 1) % len(directions["v"])
        case '+2': v= (directions["current"] + 2) % len(directions["v"])
        case None: v = directions["current"]
    return directions["v"][v]

def step_for_dir(d = None):
    return directions["steps"][d or get_dir()]

def next_dir():
    directions["current"] = (directions["current"] + 1) % len(directions["v"])

def test(data):
    step = directions["steps"][get_dir()]
    pp(step)
    next_dir()
    step = step_for_dir()
    pp(step)
    return None

def get_start_pos(data):
    for i, di in enumerate(data):
        for j, dj in enumerate(di):
            if dj == "^": return (i, j)
    return (-1, -1)

def pprint_map(data, pos, force=False):
    if not common.log_enabled() and not force: return
    mS = '{{{'
    mE = '}}}'
    common.log(f'# {mS}', force)
    # common.log(f'    {''.join([ f'{i//10}' for i in range(len(data[0])) ])}', force)
    # common.log(f'    {''.join([ f'{(i%100)//10}' for i in range(len(data[0])) ])}', force)
    common.log(f'    {''.join([ f'{i%10}' for i in range(len(data[0])) ])}', force)
    data[pos[0]][pos[1]] = '@'
    for i, di in enumerate(data):
        s = '{:3d} '.format(i)
        for j, dj in enumerate(di):
            if (i, j) == pos: s+= '@'
            elif visited[i][j] and visited[i][j] != ['#']: s += '*'
            elif dj == '.': s += ' '
            else: s += dj
        common.log(f'{s}')
    common.log(f'# {mE}', force=force)

def next_pos(pos, step):
    return tuple(x+y for x, y in zip(pos, step))

def visit(data, pos):
    visited[pos[0]][pos[1]].append(get_dir())
    return data

def go(data):
    step = directions["steps"][get_dir()]
    wait_for_key = common.log_enabled()
    wait_for_key = False
    pos = get_start_pos(data)
    log_force = False
    it = 0
    loops = 0
    end = False
    mS = '{{{'
    mE = '}}}'
    while not end:
        it += 1
        common.log(f'[{it}] p={pos} dir:{get_dir()}/{step} # {mS}', log_force)
        first = True
        dir_op = None
        step_next = None
        while True:
            visit(data, pos)
            np = next_pos(pos, step)
            if llvl >= 3: common.log(f'[{it}] np={np}, pos={pos}')
            if not (0 <= np[0] < len(data) and 0 <= np[1] < len(data[0])):
                if llvl >= 3: common.log(' -- END --')
                if llvl >= 2: pprint_map(data, pos, log_force)
                end = True
                break
            if data[np[0]][np[1]] == '#': break
            if it > 2:
                if first:
                    first = False
                    dir_op = get_dir('+2')
                    step_next = step_for_dir(get_dir('+1'))
                nnp = pos
                last = None
                common.log(f'[{it}] checking: B: {np} {dir_op}/{step_next} # {mS}')
                while True:
                    if not (0 <= nnp[0] < len(data) and 0 <= nnp[1] < len(data[0])):
                        break
                    common.log(f'[{it}] checking: p:{nnp} vis:{visited[nnp[0]][nnp[1]]} last:{last}')
                    if visited[nnp[0]][nnp[1]] == [ '#' ]:
                        if dir_op in last:
                            loops += 1
                            common.log(f'LOOP: {loops}')
                        break
                    last = visited[nnp[0]][nnp[1]]
                    nnp = next_pos(nnp, step_next)
                common.log(f'[{it}] checking # {mE}')
            pos = np
        if end:
            common.log(f'[{it}] # {mE}', log_force)
            break
        if llvl >= 2: pprint_map(data, pos, log_force)
        common.log(f'[{it}] p={pos} s={step} # {mE}', log_force)
        next_dir()
        step = step_for_dir()
        if wait_for_key:
            match input().lower():
                case 'q': break
        if it == 200: break
    return (data, loops)

def a(data):
    res = None
    data = data.splitlines()
    data = [ list(l) for l in data ]
    global visited
    visited = []
    for l in data:
        nv = []
        for vi in l:
            v = []
            if vi == '#': v.append('#')
            nv.append(v)
        visited.append(nv)
    (data, _) = go(data)
    # common.log(f'{pprint.pformat(visited, indent=2)}')
    res = len([l for l in visited for vis in l if vis and vis[0] != '#'])
    return res

def b(data):
    data = data.splitlines()
    data = [ list(l) for l in data ]
    global visited
    visited = []
    for l in data:
        nv = []
        for vi in l:
            v = []
            if vi == '#': v.append('#')
            nv.append(v)
        visited.append(nv)
    (_, loops) = go(data)
    return loops

if __name__ == "__main__":
    # common.start(test, b)
    common.start(a, b)

