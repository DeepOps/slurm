NAME=slurm-build
DIST_DIR=./dist/

build:
	docker build --pull -t $(NAME) .
	-docker ps -a -f "name=$(NAME)" | xargs -r docker rm
	docker create --name="$(NAME)" "$(NAME)"
	rm -rf $(DIST_DIR)
	docker cp "$(NAME):/dist" "$(DIST_DIR)"
	docker rm "$(NAME)"
