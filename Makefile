.PHONY: all clean
all:
	@echo \#\# Building course site...
	Rscript -e 'blogdown::hugo_build(local = TRUE)'
	Rscript R/build.R
clean:
	@echo Clean all
	rm -rf docs/*
include: make.R
