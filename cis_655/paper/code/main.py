from numba import jit, cuda
import numpy as np
import numpy_financial as npf
from timeit import default_timer as timer

def print_hi(name):
    # Use a breakpoint in the code line below to debug your script.
    print(f'Hi, {name}')  # Press Ctrl+F8 to toggle the breakpoint.


# normal function to run on cpu
def func(a):
    for i in range(10000000):
        a[i] += 1

    # function optimized to run on gpu


@jit(target_backend='cuda')
def func2(a):
    for i in range(10000000):
        a[i] += 1



if __name__ == "__main__":
    # a = npf.pmt(.01, 500, 45000)
    # print(a)

    n = 10000000
    a = np.ones(n, dtype=np.float64)

    start = timer()
    func(a)
    print("without GPU:", timer() - start)

    start = timer()
    func2(a)
    print("with GPU:", timer() - start)