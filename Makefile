VERSION ?= 1.21.0
NIGHTLY = $(shell date -I)-guinightly
DOPT = --network=host
BDIR = .build

ifeq ($(DOCKERHUBTOKEN),)
  $(info *** Waring: env var DOCKERHUBTOKEN not set, cannot push images to dockerhub)
endif

.PHONY: build.gui
build.gui: $(BDIR)/openmodelica-v$(VERSION)-gui.info

upload.gui: $(BDIR)/openmodelica-v$(VERSION)-gui.info
	echo "$(DOCKERHUBTOKEN)" | docker login --username ppenguin --password-stdin
	docker push ppenguin/openmodelica:v$(VERSION)-gui

.PRECIOUS: $(BDIR)/%-minimal.info
$(BDIR)/%-minimal.info: | $(BDIR)/
	docker build $(DOPT) \
		--build-arg VERSION=$$(echo '$(notdir $*)' | awk -F'-' '{ print $$2 }') \
		-t ppenguin/$$(echo '$(notdir $*)' | awk -F'-' '{ print $$1":"$$2 }')-minimal \
		- < Dockerfile \
	&& date -Is > $@

.PRECIOUS: $(BDIR)/%-ompython.info
$(BDIR)/%-ompython.info: $(BDIR)/%-minimal.info | $(BDIR)/
	docker build $(DOPT) \
		--build-arg BASE=ppenguin/$$(echo '$(notdir $*)' | awk -F'-' '{ print $$1":"$$2 }')-minimal \
		-t ppenguin/$$(echo '$(notdir $*)' | awk -F'-' '{ print $$1":"$$2 }')-ompython \
		- < Dockerfile.ompython \
	&& date -Is > $@

.PRECIOUS: $(BDIR)/%-gui.info
$(BDIR)/%-gui.info: $(BDIR)/%-ompython.info | $(BDIR)/
	docker build $(DOPT) \
		--build-arg BASE=ppenguin/$$(echo '$(notdir $*)' | awk -F'-' '{ print $$1":"$$2 }')-ompython \
		-t ppenguin/$$(echo '$(notdir $*)' | awk -F'-' '{ print $$1":"$$2 }')-gui \
		- < Dockerfile.gui \
	&& date -Is > $@

%/:
	mkdir $@