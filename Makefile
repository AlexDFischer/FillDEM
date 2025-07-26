# Use pkg-config style command to get all necessary GDAL flags.
# --cflags gets the include paths (-I/usr/include/gdal)
# --libs gets the library paths and names (-L/path/to/lib -lgdal)
# The 'shell' function executes the command and captures its output.
GDAL_FLAGS = $(shell gdal-config --cflags) $(shell gdal-config --libs)

OUTPUT_FOLDER = output

$(OUTPUT_FOLDER)/fillDEM: $(OUTPUT_FOLDER)/dem.o $(OUTPUT_FOLDER)/main.o $(OUTPUT_FOLDER)/utils.o $(OUTPUT_FOLDER)/FillDEM_Zhou-Direct.o $(OUTPUT_FOLDER)/FillDEM_Zhou-OnePass.o $(OUTPUT_FOLDER)/FillDEM_Zhou-TwoPass.o
	g++ $(OUTPUT_FOLDER)/dem.o $(OUTPUT_FOLDER)/main.o $(OUTPUT_FOLDER)/utils.o $(OUTPUT_FOLDER)/FillDEM_Zhou-Direct.o $(OUTPUT_FOLDER)/FillDEM_Zhou-OnePass.o $(OUTPUT_FOLDER)/FillDEM_Zhou-TwoPass.o -lgdal --std=c++11 -fpermissive -o $(OUTPUT_FOLDER)/fillDEM

$(OUTPUT_FOLDER)/dem.o: dem.h utils.h dem.cpp | $(OUTPUT_FOLDER)
	g++ -c dem.cpp -o $(OUTPUT_FOLDER)/dem.o --std=c++11 -fpermissive $(GDAL_FLAGS)
$(OUTPUT_FOLDER)/main.o: dem.h Node.h utils.h FillDEM_Zhou-Direct.cpp FillDEM_Zhou-OnePass.cpp FillDEM_Zhou-TwoPass.cpp main.cpp | $(OUTPUT_FOLDER)
	g++ -c main.cpp -o $(OUTPUT_FOLDER)/main.o --std=c++11 -fpermissive $(GDAL_FLAGS)
$(OUTPUT_FOLDER)/utils.o: dem.h utils.h utils.cpp | $(OUTPUT_FOLDER)
	g++ -c utils.cpp -o $(OUTPUT_FOLDER)/utils.o --std=c++11 -fpermissive $(GDAL_FLAGS)
$(OUTPUT_FOLDER)/FillDEM_Zhou-Direct.o: dem.h Node.h utils.h FillDEM_Zhou-Direct.cpp | $(OUTPUT_FOLDER)
	g++ -c FillDEM_Zhou-Direct.cpp -o $(OUTPUT_FOLDER)/FillDEM_Zhou-Direct.o --std=c++11 -fpermissive $(GDAL_FLAGS)
$(OUTPUT_FOLDER)/FillDEM_Zhou-OnePass.o: dem.h Node.h utils.h FillDEM_Zhou-OnePass.cpp | $(OUTPUT_FOLDER)
	g++ -c FillDEM_Zhou-OnePass.cpp -o $(OUTPUT_FOLDER)/FillDEM_Zhou-OnePass.o --std=c++11 -fpermissive $(GDAL_FLAGS)
$(OUTPUT_FOLDER)/FillDEM_Zhou-TwoPass.o: dem.h Node.h utils.h FillDEM_Zhou-TwoPass.cpp | $(OUTPUT_FOLDER)
	g++ -c FillDEM_Zhou-TwoPass.cpp -o $(OUTPUT_FOLDER)/FillDEM_Zhou-TwoPass.o --std=c++11 -fpermissive $(GDAL_FLAGS)

clean:
	@echo "cleanning project"
	-rm -rf $(OUTPUT_FOLDER)/fillDEM $(OUTPUT_FOLDER)/*.o
	@echo "clean completed"
.PHONY: clean

$(OUTPUT_FOLDER):
	mkdir -p $(OUTPUT_FOLDER)

