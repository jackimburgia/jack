# https://quantatrisk.com/2014/12/06/gpu-accelerated-finance-in-python-with-numbapro/

import numpy as np
import math
import time
from numba import *
from numba import cuda
from blackscholes import black_scholes  # save the previous code as

# black_scholes.py

RISKFREE = 0.02
VOLATILITY = 0.30

A1 = 0.31938153
A2 = -0.356563782
A3 = 1.781477937
A4 = -1.821255978
A5 = 1.330274429
RSQRT2PI = 0.39894228040143267793994605993438


# @cuda.jit(argtypes=(double,), restype=double, device=True, inline=True)
@cuda.jit(device=True, inline=True)
def cnd_cuda(d):
    K = 1.0 / (1.0 + 0.2316419 * math.fabs(d))
    ret_val = (RSQRT2PI * math.exp(-0.5 * d * d) *
               (K * (A1 + K * (A2 + K * (A3 + K * (A4 + K * A5))))))
    if d > 0:
        ret_val = 1.0 - ret_val
    return ret_val


# @cuda.jit(argtypes=(double[:], double[:], double[:], double[:], double[:], double, double))
@cuda.jit()
def black_scholes_cuda(callResult, putResult, S, X, T, R, V):
    #    S = stockPrice
    #    X = optionStrike
    #    T = optionYears
    #    R = Riskfree
    #    V = Volatility
    i = cuda.threadIdx.x + cuda.blockIdx.x * cuda.blockDim.x
    if i >= S.shape[0]:
        return
    sqrtT = math.sqrt(T[i])
    d1 = (math.log(S[i] / X[i]) + (R + 0.5 * V * V) * T[i]) / (V * sqrtT)
    d2 = d1 - V * sqrtT
    cndd1 = cnd_cuda(d1)
    cndd2 = cnd_cuda(d2)

    expRT = math.exp((-1. * R) * T[i])
    callResult[i] = (S[i] * cndd1 - X[i] * expRT * cndd2)


def randfloat(rand_var, low, high):
    return (1.0 - rand_var) * low + rand_var * high


def main():
    OPT_N = 4000000
    iterations = 10

    callResultNumpy = np.zeros(OPT_N)
    putResultNumpy = -np.ones(OPT_N)
    stockPrice = randfloat(np.random.random(OPT_N), 5.0, 30.0)
    optionStrike = randfloat(np.random.random(OPT_N), 1.0, 100.0)
    optionYears = randfloat(np.random.random(OPT_N), 0.25, 10.0)
    callResultNumba = np.zeros(OPT_N)
    putResultNumba = -np.ones(OPT_N)
    callResultNumbapro = np.zeros(OPT_N)
    putResultNumbapro = -np.ones(OPT_N)

    # Numpy ----------------------------------------------------------------
    time0 = time.time()
    for i in range(iterations):
        black_scholes(callResultNumpy, putResultNumpy, stockPrice,
                      optionStrike, optionYears, RISKFREE, VOLATILITY)
    time1 = time.time()
    dtnumpy = ((1000 * (time1 - time0)) / iterations) / OPT_N
    # print("\nNumpy Time            %f msec per option") % (dtnumpy)
    print("Numpy Time {} msec per option".format(dtnumpy))

    # print(callResultNumpy[0])

    # CUDA -----------------------------------------------------------------
    time0 = time.time()
    blockdim = 1024, 1
    griddim = int(math.ceil(float(OPT_N) / blockdim[0])), 1
    stream = cuda.stream()
    d_callResult = cuda.to_device(callResultNumbapro, stream)
    d_putResult = cuda.to_device(putResultNumbapro, stream)
    d_stockPrice = cuda.to_device(stockPrice, stream)
    d_optionStrike = cuda.to_device(optionStrike, stream)
    d_optionYears = cuda.to_device(optionYears, stream)

    time2 = time.time()

    for i in range(iterations):
        black_scholes_cuda[griddim, blockdim, stream](
            d_callResult, d_putResult, d_stockPrice, d_optionStrike,
            d_optionYears, RISKFREE, VOLATILITY)
        # d_callResult.to_host(stream)
        # d_putResult.to_host(stream)
        # d_callResult.copy_to_host(stream)
        # d_putResult.copy_to_host(stream)
        d_callResult.copy_to_host(stream=stream)
        d_putResult.copy_to_host(stream=stream)
        stream.synchronize()

    time3 = time.time()
    dtcuda = ((1000 * (time3 - time2)) / iterations) / OPT_N

    # print("Numbapro CUDA Time    %f msec per option (speed-up %.1fx)\n") % (dtcuda, dtnumpy/dtcuda)
    print("Numbapro CUDA Time {} msec per option (speed-up {}x)".format(dtcuda, dtnumpy/dtcuda))
    #   print(callResultNumbapro)

if __name__ == "__main__":
    import sys
    main()