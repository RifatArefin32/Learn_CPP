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