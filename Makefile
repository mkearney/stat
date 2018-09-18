.PHONY: all clean
all:
	echo '## blogdown::hugo_build(local = TRUE)'
	Rscript -e 'blogdown::hugo_build(local = TRUE)'
	echo '## Rscript R/build.R'
	Rscript R/build.R
	echo '## All done!'
clean:
	@echo Clean all
	rm -rf docs/*
include: make.R
