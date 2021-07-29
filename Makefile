all: upload


pull:
	# to support github pull to avoid complete rebuild
	docker pull joezuntz/txpipe


upload: base
	# for now this next one is actually the same as txpipe-firecrown
	docker push joezuntz/txpipe


in2p3:
	cd txpipe-in2p3 && docker build -t joezuntz/in2p3 .
	docker push joezuntz/in2p3


base:
	cd txpipe-base && docker build -t joezuntz/txpipe .


.PHONY: base upload all base pull in2p3