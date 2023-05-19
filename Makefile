VERSION ?= 1.20.0
NIGHTLY = $(shell date -I)-guinightly
DOPT = --network=host

build.gui:
	docker build $(DOPT) --build-arg BASE=openmodelica/openmodelica:v$(VERSION)-ompython -t openmodelica/openmodelica:v$(VERSION)-gui - < Dockerfile.gui

build.guinightly:
	docker build $(DOPT) --build-arg BASE=openmodelica/openmodelica:v$(VERSION)-ompython -t openmodelica/openmodelica:$(NIGHTLY) - < Dockerfile.guinightly

build:
	docker build $(DOPT) --build-arg VERSION=$(VERSION) -t openmodelica/openmodelica:v$(VERSION)-minimal - < Dockerfile
	docker build $(DOPT) --build-arg BASE=openmodelica/openmodelica:v$(VERSION)-minimal -t openmodelica/openmodelica:v$(VERSION)-ompython - < Dockerfile.ompython
	docker build $(DOPT) --build-arg BASE=openmodelica/openmodelica:v$(VERSION)-ompython -t openmodelica/openmodelica:v$(VERSION)-gui - < Dockerfile.gui

upload:
	docker push openmodelica/openmodelica:v$(VERSION)-minimal
	docker push openmodelica/openmodelica:v$(VERSION)-ompython
	docker push openmodelica/openmodelica:v$(VERSION)-gui
