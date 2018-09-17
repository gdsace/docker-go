PROJECT_NAME=$$(basename $$(pwd))
PROJECT_TAG=$(PROJECT_NAME):latest

# builds the base docker image
build:
	docker build --build-arg PROJECT_NAME=$(PROJECT_NAME) -t $(PROJECT_TAG) .

# installs or initialises the dependencies
init:
	docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" $(PROJECT_TAG) dep init \
		|| docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" $(PROJECT_TAG) dep ensure

# runs the project
run:
	docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" $(PROJECT_TAG) realize start --run main.go

# lint the project code
lint:
	docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" $(PROJECT_TAG) golint

# runs the test on the project
test:
	docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" $(PROJECT_TAG) go test -v -cover -coverprofile=coverage.out

# runs the tests in watch mode on the project
test.watch:
	docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" $(PROJECT_TAG) goconvey

# compiles the project binary
compile:
	docker run -v "$$(pwd):/go/src/$(PROJECT_NAME)" $(PROJECT_TAG) go build -o $(PROJECT_NAME)

# cleans up the example project *do not copy to your own project
clean:
	@rm -rf vendor .realize.yaml app Gopkg.*