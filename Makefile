ALL = inOut incr pq01 pq02
LIB = ddmp.swift compose.swift main.swift

.PHONY: all clean
.PRECIOUS: %.dot

all: $(ALL)

%: %.swift $(LIB)
	swiftc $^ -o $@

%.dot: %
	./$< > $@

%.png: %.dot
	dot -T png $< -o $@
	open $@

clean:
	rm -f $(ALL) *.dot *.png
