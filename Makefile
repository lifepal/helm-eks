VERSION?=v2

build:
	docker build -t lifepal/helm-eks:$(VERSION) . -f Dockerfile

push:
	docker push lifepal/helm-eks:$(VERSION)

bp: build push
