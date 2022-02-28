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


original:
	cd txpipe-original && docker build --progress=plain -t joezuntz/txpipe-original .

conda:
	cd txpipe-conda && docker build --progress=plain -t joezuntz/txpipe .


.PHONY: all pull upload in2p3 original conda
