CXX = g++
CXXFLAGS = -Werror -Wall -Wextra -Wno-unused-parameter -O3

mipsinterpret: main.o Utils.o
	$(CXX) $(CXXFLAGS) $^ -o $@

clean:
	rm -f mipsinterpret ../mipsinterpret *.o *.mips*