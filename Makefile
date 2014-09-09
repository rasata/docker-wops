ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VOL_DIR := /var/volumes
NAME := whops

build:
	docker build -t y0ug/$(NAME) $(ROOT_DIR)

perm:
	sudo mkdir -p $(VOL_DIR)/$(NAME)_home
	sudo chown -R 5000:5000 $(VOL_DIR)/$(NAME)_home

run:
	docker run -d \
		-privileged \
		-v $(VOL_DIR)/$(NAME)_home:/home/y0ug \
		-v $(VOL_DIR)/www:/var/www \
		-v $(VOL_DIR)/syslog-ng:/etc/syslog-ng \
		-h $(NAME) --name $(NAME) y0ug/$(NAME)

cur:
	docker run -d  \
		-v $(VOL_DIR)/$(NAME)_home:/home/y0ug \
		-v $(VOL_DIR)/www:/var/www \
		-v $(VOL_DIR)/syslog-ng:/etc/syslog-ng \
		-h $(NAME) --name $(NAME) y0ug/$(NAME):cur

destroy:
	-docker rm -f $(NAME)

commit:
	docker commit -m "save" $(NAME) y0ug/$(NAME):cur

stop:
	docker stop $(NAME)
