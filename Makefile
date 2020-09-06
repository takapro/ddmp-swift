ALL = inOut
LIB = ddmp.swift main.swift

all: $(ALL)

inOut: inOut.swift $(LIB)
	swiftc $^ -o $@

clean:
	rm -f $(ALL)
