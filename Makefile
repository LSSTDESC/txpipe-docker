all: base cosmosis firecrown tomo

upload: base cosmosis firecrown
	docker push joezuntz/txpipe-base
	# for now this next one is actually the same as the base.
	docker push joezuntz/txpipe
	docker push joezuntz/txpipe-cosmosis
	docker push joezuntz/txpipe-firecrown
	docker push joezuntz/txpipe-tomo

base:
	cd txpipe-base && docker build -t joezuntz/txpipe-base .
	# for now, the txpipe repo is the same as the base one
	docker tag joezuntz/txpipe-base joezuntz/txpipe


cosmosis: base
	cd txpipe-cosmosis && docker build -t joezuntz/txpipe-cosmosis .

firecrown: base
	cd txpipe-firecrown && docker build -t joezuntz/txpipe-firecrown .

tomo: firecrown
	cd txpipe-tomo && docker build -t joezuntz/txpipe-tomo .

.PHONY: base cosmosis firecrown tomo upload all