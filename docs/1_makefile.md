# Makefile

# Example of a makefile with example
```make
CXX := g++
CXX_FLAGS := -Wall -Wextra -std=c++17 -ggdb

SRC_DIR := src
BIN_DIR := bin
EXECUTABLE := main

SOURCE_FILES := $(shell find $(SRC_DIR) -name "*.cpp")
$(info [INFO] Source files are: $(SOURCE_FILES))

BIN_FILES := $(patsubst $(SRC_DIR)/%.cpp, $(BIN_DIR)/%.o, $(SOURCE_FILES))
$(info [INFO] Binary files are: $(BIN_FILES))

INCLUDE_DIR := include $(shell find $(SRC_DIR) -type d -name include)
INCLUDE_FLAGS := $(foreach dir, $(INCLUDE_DIR), -I$(dir))
$(info [INFO] Include flags are: $(INCLUDE_FLAGS))

all: $(BIN_DIR)/$(EXECUTABLE)

$(BIN_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo "Compiling............" 	
	@mkdir -p $(dir $@)
	$(CXX) $(CXX_FLAGS) $(INCLUDE_FLAGS) -c $< -o $@

$(BIN_DIR)/$(EXECUTABLE): $(BIN_FILES)
	@echo "Linking.........."
	$(CXX) $(CXX_FLAGS) $^ -o $@

clean:
	rm -rf $(BIN_DIR)

run: all
	./$(BIN_DIR)/$(EXECUTABLE)

.PHONY: all clean run 
```

# Explaination
## Declare Compiler and Necessary Flags
```makefile
CXX := g++
CXX_FLAGS := -Wall -Wextra -std=c++17 -ggdb
```
- `CXX`: Defines which compiler to use. Here: `g++` (GNU C++ compiler)
- `CXX_FLAGS`: Defines compilation flags.
    - `-Wall`: Show all common warnings
    - `-Wextra`: Show extra warnings (for cleaner code)
    - `-std=c++17`: Compile code using the **C++17** standard
    - `-ggdb`: Include debugging information for GDB (helpful for debugging)

## Directory Setup
```makefile
SRC_DIR := src
BIN_DIR := bin
EXECUTABLE := main
```
- `SRC_DIR`: Where our `.cpp` files are located
- `BIN_DIR`: Where all `.o` and final executables will be saved
- `EXECUTABLE`: Name of our final compiled program (binary)

## Finding All the Source Files
```make
SOURCE_FILES := $(shell find $(SRC_DIR) -name "*.cpp")
```
- `$(shell ...)` function is used to run a shell command inside the make file.
- Shell command for finding all the `.cpp` files inside the source directory: `find src/ -name "*.cpp"`

## Mapping Source Files → Object Files
```make
BIN_FILES := $(patsubst $(SRC_DIR)/%.cpp, $(BIN_DIR)/%.o, $(SOURCE_FILES))
```
- `$(patsubst src_pattern, dest_pattern, source)` function replaces each path in `source` that matches `src_pattern` with pattern `dest_pattern` 

## Include Directory Flags
```make
INCLUDE_DIR := include $(shell find $(SRC_DIR) -type d -name include)
INCLUDE_FLAGS := $(foreach dir, $(INCLUDE_DIR), -I$(dir))
```
- `INCLUDE_DIR`: Looks for any include folders (e.g. **src/include** or top-level **include/**)
- `$(foreach dir, $(INCLUDE_DIR), -I$(dir))`:  Loops over each directory and creates -I flags.

Example: if we have `include` and `src/module/include`, then: `INCLUDE_FLAGS = -Iinclude -Isrc/module/include`

## Default Target: Build Everything
```make
all: $(BIN_DIR)/$(EXECUTABLE)
```
- `all` is the default Make target (runs if we type just `make`).
- It depends on the final executable (e.g., bin/main). So when we run: `make`, it will trigger everything needed to build `bin/main`.

## Compilation (.cpp -> .o)
```make
$(BIN_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo "Compiling............" 	
	@mkdir -p $(dir $@)
	$(CXX) $(CXX_FLAGS) $(INCLUDE_FLAGS) -c $< -o $@
```
Here
- `%`: A wildcard — matches any filename stem
- `$<`:	First dependency (the .cpp file here)
- `$@`:	The target (the .o file here)

`@mkdir -p $(dir $@)`
- `$(dir $@)`: Extracts the directory path from the target file name
- `mkdir -p`: Ensures that directory exists before compiling.
- `-p`: This flag means “don’t complain if it already exists”.
- Runs the compile command:
```
g++ -Wall -Wextra -std=c++17 -ggdb -Iinclude -c src/utils/helper.cpp -o bin/utils/helper.o
```

## Linking Rule: Combine .o to Executable
```make
$(BIN_DIR)/$(EXECUTABLE): $(BIN_FILES)
	@echo "Linking.........."
	$(CXX) $(CXX_FLAGS) $^ -o $@
```
- `$^`: All dependencies
- `$@`:	The target 

What It Does: Combines all .o files into the final program:
```
g++ -Wall -Wextra -std=c++17 -ggdb bin/main.o bin/utils/helper.o -o bin/main
```

## Cleaning Build Files
```make
clean:
	rm -rf $(BIN_DIR)
```
- `clean` removes the entire `bin/` folder (all .o and the executable).
- It is used to reset our build and start fresh. To do so run:
```
make clean
```

##  Run Target
```make
run: all
	./$(BIN_DIR)/$(EXECUTABLE)
```
- If we want just type `make run` to build and run in one step
- `run` depends on all, so it builds first if needed.
- Then it executes our program:
```
./bin/main
```

##  Phony Targets
```make
.PHONY: all clean run
```
- Tells Make these are not real files, just command names.
- Prevents confusion if a file named clean, all, or run happens to exist.

# Build Flow
```bash
make
# 1. Finds all .cpp
# 2. Compiles each → .o
# 3. Links all → bin/main
```
```bash
make run
# Builds if needed, then runs ./bin/main
```
```bash
make clean
# Deletes bin/
```
