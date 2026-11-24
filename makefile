.PHONY: force
force:

VTRACER ?= $(HOME)/.cargo/bin/vtracer
$(VTRACER):
	cargo install vtracer

.PRECIOUS: %.png
%.png:
	curl --fail --silent --show-error --location --remove-on-error --url "https://github.com/$*.png?size=460" --output "$@"


mode ?= opt
ifeq ($(mode),full)
filter_speckle := 0
gradient_step := 1
else ifeq ($(mode),opt)
filter_speckle := 4
gradient_step := 8
else
$(error Unknown mode '$(mode)'. Use mode=opt or mode=full)
endif
ilyar.svg:
%.svg: %.png $(VTRACER) force
	$(VTRACER) --input "$<" --output "$@" \
	  --colormode color \
	  --hierarchical stacked \
	  --mode pixel \
	  --color_precision 8 \
	  --filter_speckle $(filter_speckle) \
	  --gradient_step $(gradient_step)
	npx -y svgo --pretty --indent 2 --eol lf --final-newline "$@"
