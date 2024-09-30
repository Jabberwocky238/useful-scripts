from functools import lru_cache, cached_property, singledispatch
from contextlib import contextmanager
# https://docs.python.org/3.12/library/contextlib.html?highlight=contextlib#module-contextlib
# https://docs.python.org/3.12/library/functools.html?highlight=functools#module-functools

from time import time, perf_counter

@contextmanager
def timer(label):
    # Code to acquire resource, e.g.:
    start = perf_counter()
    try:
        yield
    finally:
        # Code to release resource, e.g.:
        end = perf_counter()
        print(f"{label} :\n{(end - start)*1000} milli secs")

def fib(num):
    if num == 1 or num == 2:
        return num
    else:
        return fib(num-1) + fib(num-2)
    
@lru_cache(maxsize=128, typed=False)
def fiblru(num):
    if num == 1 or num == 2:
        return num
    else:
        return fiblru(num-1) + fiblru(num-2)
    
@cached_property
def fibcp(num=20):
    if num == 1 or num == 2:
        return num
    else:
        return fibcp(num-1) + fibcp(num-2)

# 函数重载singledispatch
@singledispatch
def accept_what(s: str):
    if type(s) != str:
        raise Exception("类型不对")
    print(type(s), " ", s)

@accept_what.register
def accept_what_WTF(s: int):
    if type(s) != int:
        raise Exception("类型不对")
    print(type(s), " ", s)

@accept_what.register
def accept_what_WTF(s: float):
    if type(s) != float:
        raise Exception("类型不对")
    print(type(s), " ", s)
    
if __name__ == '__main__':
    with timer("test my fib"):
        fib(20)
    with timer("test my fib cached_property"):
        fibcp
    with timer("test my fib lru_cache"):
        fiblru(20)

    accept_what("字符串")
    accept_what(666)
    accept_what(666.666)