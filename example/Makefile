PROJECT_NAME=$$(basename $$(pwd))

build:
	docker build --build-arg PROJECT_NAME=$(PROJECT_NAME) -t $(PROJECT_NAME) .

compile:
	docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" $(PROJECT_NAME) go build -o $(PROJECT_NAME)

init:
	docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" $(PROJECT_NAME) dep init \
		|| docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" $(PROJECT_NAME) dep ensure

run:
	docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" $(PROJECT_NAME) realize start --run main.go

clean:
	@rm -rf vendor .realize.yaml app Gopkg.*