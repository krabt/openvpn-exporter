GO_FILES := $(shell find . -name '*.go' -not -path './vendor/*')
BINARY := openvpn-exporter
IMAGE_NAME ?= openvpn-exporter
IMAGE_TAG ?= latest

.PHONY: all build test fmt check-fmt image clean

all: build

build:
	go build -ldflags="-s -w" -o $(BINARY) .

test:
	go test ./...

fmt:
	gofmt -w $(GO_FILES)

check-fmt:
	@unformatted="$$(gofmt -l $(GO_FILES))"; \
	if [ -n "$$unformatted" ]; then \
		printf 'Go files need formatting:\n%s\n' "$$unformatted"; \
		exit 1; \
	fi

image: build
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

clean:
	rm -f $(BINARY)