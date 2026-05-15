import sys
import os

log_module = 'G'
log_print = None

def log_enabled():
    return log_print

def log(msg = None, force=False):
    if not log_print and not force:
        return
    if not msg:
        print(file=sys.stderr)
        return
    print('{}: {}'.format(log_module, msg), file=sys.stderr)

def start(a, b):

    global log_module
    global log_print

    variant = 'a'
    file = None
    if len(sys.argv) >= 2:
        variant = sys.argv[1]
    if len(sys.argv) >= 3:
        file = sys.argv[2]

    if not file:
        fbase = os.path.basename(sys.argv[0]).split('.')[0]
        file = f'in-{fbase}-test.txt'

    log_env = os.environ.get('LOG_ENABLED')
    if log_env == None:
        log_env = ''
    match log_env.lower():
        case 'true':
            log_print = True
        case 'false':
            log_print = False
        case _:
            log_print = not file.endswith('fina.txt')

    log(f'Variant: {variant}, data-file: {file}')

    data = None
    with open(file, 'r') as f:
        data = f.read()

    result = None

    match variant:
        case 'a':
            log_module = 'A'
            result = a(data)
        case 'b':
            log_module = 'B'
            result = b(data)
        case _:
            log(f'unknown variant {variant}, f={file}')

    log_module = 'G'
    if result:
        log(f'Result: {result}')
        print(result)

