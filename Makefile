CF_FLAGS=--verbose
DOCKER=docker
BUILDFLAGS=
RUNFLAGS=
VERSION=3.6.2-1
OWNER=bahamat
MASTERFILES_GIT_URL=
MASTERFILES_GIT_BRANCH=
DESIGNCENTER_GIT_URL=
DESIGNCENTER_GIT_BRANCH=

ifneq ($(MASTERFILES_GIT_URL),)
	RUNFLAGS:=$(RUNFLAGS) -e MASTERFILES_GIT_URL=$(MASTERFILES_GIT_URL)
endif

ifneq ($(MASTERFILES_GIT_BRANCH),)
	RUNFLAGS:=$(RUNFLAGS) -e MASTERFILES_GIT_BRANCH=$(MASTERFILES_GIT_BRANCH)
endif

ifneq ($(DESIGNCENTER_GIT_URL),)
	RUNFLAGS:=$(RUNFLAGS) -e DESIGNCENTER_GIT_URL=$(DESIGNCENTER_GIT_URL)
endif

ifneq ($(DESIGNCENTER_GIT_BRANCH),)
	RUNFLAGS:=$(RUNFLAGS) -e DESIGNCENTER_GIT_BRANCH=$(DESIGNCENTER_GIT_BRANCH)
endif

RUNFLAGS:=$(RUNFLAGS) -e CF_FLAGS=$(CF_FLAGS)

all: build

build:
	docker build $(BUILDFLAGS) -t="$(OWNER)/cfengine:$(VERSION)" .

run: build
	docker run $(RUNFLAGS) "${OWNER}/cfengine:$(VERSION)"

runv: build
	docker run $(RUNFLAGS) -v `pwd`:/data "$(OWNER)/cfengine:$(VERSION)"

kill:
	docker kill `docker ps -q` || echo nothing to kill
	docker rm -f `docker ps -a -q` || echo nothing to clean

clean: kill
	docker rmi "$(OWNER)/cfengine:$(VERSION)" || echo no image to remove