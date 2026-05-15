import common
import re

def a_orig(data):
    res = 0
    pattern = r"mul\((\d{1,3}),(\d{1,3})\)"

    for m in re.finditer(pattern, data):
        common.log(f'{m.group()} : {m.group(1)} x {m.group(2)}')
        res += int(m.group(1)) * int(m.group(2))

    return res

def a(data):
    pattern = r"mul\((\d{1,3}),(\d{1,3})\)"
    return sum([int(m.group(1)) * int(m.group(2)) for m in re.finditer(pattern, data)])

def b(data):
    res = 0
    do_mul = True
    pattern = r"do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)"

    for m in re.finditer(pattern, data):
        match m.group():
            case "do()":
                common.log('do')
                do_mul = True
            case "don't()":
                common.log("don't")
                do_mul = False
            case _:
                if do_mul:
                    common.log(f'+ {m.group()} : {m.group(1)} x {m.group(2)}')
                    res += int(m.group(1)) * int(m.group(2))
                else:
                    common.log(f'- {m.group()} : {m.group(1)} x {m.group(2)}')

    return res

if __name__ == "__main__":
    common.start(a, b)

