
all: upload


pull:
	# to support github pull to avoid complete rebuild
	docker pull joezuntz/txpipe


upload: conda
	# for now this next one is actually the same as txpipe-firecrown
	docker push joezuntz/txpipe

in2p3:
	cd txpipe-in2p3 && docker build --progress=plain -t joezuntz/in2p3 .
	docker push joezuntz/in2p3

dev: pull
	cd txpipe-dev && DOCKER_BUILDKIT=0 docker build --progress=plain -t joezuntz/txpipe-dev .


conda:
	cd txpipe-conda && docker build --progress=plain -t joezuntz/txpipe .
	docker tag joezuntz/txpipe joezuntz/txpipe:latest


.PHONY: all pull upload in2p3 conda
