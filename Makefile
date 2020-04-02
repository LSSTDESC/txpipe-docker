all: base cosmosis firecrown

upload:
	docker push joezuntz/txpipe-base
	docker push joezuntz/txpipe-cosmosis
	docker push joezuntz/txpipe-firecrown

base:
	cd txpipe-base && docker build -t joezuntz/txpipe-base .

cosmosis: base
	cd txpipe-cosmosis && docker build -t joezuntz/txpipe-cosmosis .

firecrown: base
	cd txpipe-firecrown && docker build -t joezuntz/txpipe-firecrown .


.PHONY: base cosmosis firecrown upload all