import pyrtl
import ucsbcs154lab3_cpu as cpu
from sys import argv

if __name__ == '__main__':
    # Start a simulation trace
    sim_trace = pyrtl.SimulationTrace()

    # Initialize the i_mem with your instructions.
    i_mem_init = {}
    with open(argv[1], 'r') as fin:
        i = 0
        for line in fin.readlines():
            i_mem_init[i] = int(line, 16)
            i += 1

    sim = pyrtl.Simulation(tracer=sim_trace, memory_value_map={
        cpu.i_mem : i_mem_init
    })

    # Run for an arbitrarily large number of cycles.
    for cycle in range(500):
        sim.step({})

    # Use render_trace() to debug if your code doesn't work.
    # sim_trace.render_trace()

    # You can also print out the register file or memory like so if you want to debug:
    DATA_MEMORY = sim.inspect_mem(cpu.d_mem)
    REGISTER_FILE = sim.inspect_mem(cpu.rf)

    EXP_DATA_MEMORY = dict[int, int]()
    EXP_REGISTER_FILE = list[str]()

    with open(argv[2], 'r') as fin:
        EXP_REGISTER_FILE = fin.readline().split(',')
        for key_value in fin.readline().split(',')[:-1]:
            key_value = key_value.strip('\n')
            key, value = tuple([ int(x) for x in key_value.split('=') ])
            EXP_DATA_MEMORY[key] = value

    for key in DATA_MEMORY:
        exp_value = EXP_DATA_MEMORY.get(key)
        if exp_value is None:
            print("Couldn't find a used memory slot at", key, "should be of value", exp_value, "instead, None")
            exit(1)
        if exp_value != DATA_MEMORY[key]:
            print("Different values in memory: mem[" + key + "] should be", exp_value, "instead", value)
            exit(1)
    
    for key in REGISTER_FILE:
        exp_value = REGISTER_FILE[key]
        if exp_value != REGISTER_FILE[key]:
            print("Different values in registers: rf[" + key + "] should be", exp_value, "instead", REGISTER_FILE[key])
            exit(1)

    # Perform some sanity checks to see if your program worked correctly
    # assert(sim.inspect_mem(cpu.d_mem)[0] == 10)
    # assert(sim.inspect_mem(cpu.rf)[8] == 10)    # $v0 = rf[8]
    print('Passed!')