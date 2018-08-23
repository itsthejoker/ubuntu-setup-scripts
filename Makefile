all: tools shell

tools: pyenv youtube-dl micro htop

pyenv:
	./tools/pyenv.sh

youtube-dl:
	./tools/youtube-dl.sh

micro:
	./tools/micro.sh

htop:
	./tools/htop.sh

shell:
	./fish.sh
