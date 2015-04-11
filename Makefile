OO := ocamlfind ocamlopt

all: test.out
	./test.out

# build `ppx_sh.out`
ppx_sh.cmx: ppx_sh.ml
	$(OO) -annot -c -package compiler-libs.common ocamlcommon.cmxa $<
ppx_sh.out: ppx_sh.cmx
	$(OO) -o $@ -package compiler-libs.common ocamlcommon.cmxa $<

# build `sh.cmx`
sh.cmx: sh.ml
	$(OO) -annot -c $<

# build `test.out`
test.cmx: test.ml ppx_sh.out sh.cmx
	$(OO) -annot -c -package oUnit -ppx ./ppx_sh.out sh.cmx $<
test.out: test.cmx ppx_sh.out sh.cmx
	$(OO) -linkpkg -o $@ -package oUnit -ppx ./ppx_sh.out sh.cmx $<

# dumps the post-processed AST
ast-%: % ppx_sh.out sh.cmx
	$(OO) -dparsetree -ppx ./ppx_sh.out sh.cmx $<

# dumps the post-processed source code
src-%: % ppx_sh.out sh.cmx
	$(OO) -dsource -ppx ./ppx_sh.out sh.cmx $<

clean:
	@rm -f *.annot *.cache *.cm* *.log *.o *.out

.PHONY: all clean ast-%.ml src-%.ml
