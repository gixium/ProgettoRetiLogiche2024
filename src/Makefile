GHDL = ghdl
SRC_DIR = src
TEST_DIR = test
SRC_ENTITY = project_reti_logiche
TEST_ENTITY = project_tb

.PHONY: all analyze simulate synthesize clean

all: analyze simulate

analyze:
	$(GHDL) -a $(SRC_DIR)/*.vhd $(TEST_DIR)/*.vhd

simulate:
	$(GHDL) -e $(TEST_ENTITY)
	$(GHDL) -r $(TEST_ENTITY) --vcd=$(TEST_ENTITY).vcd

synthesize:
	$(GHDL) --synth project_reti_logiche

clean:
	rm -f *.o
	rm -f *.cf
