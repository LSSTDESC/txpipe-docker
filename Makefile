all: upload

subimages=cosmosis firecrown firecrown-dev tomo

pull:
	# to support github pull to avoid complete rebuild
	docker pull joezuntz/txpipe-base

images: $(subimages)

upload: $(subimages) base 
	# for now this next one is actually the same as txpipe-firecrown
	docker tag joezuntz/txpipe-firecrown joezuntz/txpipe
	docker push joezuntz/txpipe-base
	for subimage in $(subimages) ; do \
    	echo docker push joezuntz/txpipe-$$subimage ; \
	done
	docker push joezuntz/txpipe


base:
	cd txpipe-base && docker build -t joezuntz/txpipe-base .
	# for now, the txpipe repo is the same as the base one

$(subimages): % : base txpipe-%/Dockerfile
	cd txpipe-$@ && docker build -t joezuntz/txpipe-$@ .



.PHONY: base $(subimages) upload all