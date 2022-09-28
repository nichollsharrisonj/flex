all: oh-one-one balanced

oh-one-one: oh-one-one.ll FALexer.hh
	flex -o oh-one-one.cc oh-one-one.ll
	g++ -std=c++17 -g -o oh-one-one oh-one-one.cc

end-oh-one-one: end-oh-one-one.ll FALexer.hh
	flex -o end-oh-one-one.cc end-oh-one-one.ll
	g++ -std=c++17 -g -o end-oh-one-one end-oh-one-one.cc

balanced: balanced.ll balanced.hh
	flex -o balanced.cc balanced.ll
	g++ -std=c++17 -g -o balanced balanced.cc

multiple-balanced: multiple-balanced.ll multiple-balanced.hh
	flex -o multiple-balanced.cc multiple-balanced.ll
	g++ -std=c++17 -g -o multiple-balanced multiple-balanced.cc

even-0s-even-1s: even-0s-even-1s.ll FALexer.hh
	flex -o even-0s-even-1s.cc even-0s-even-1s.ll
	g++ -std=c++17 -g -o even-0s-even-1s even-0s-even-1s.cc

even-abs: even-abs.ll FALexer.hh
	flex -o even-abs.cc even-abs.ll
	g++ -std=c++17 -g -o even-abs even-abs.cc

clean:
	touch oh-one-one balanced multiple-balaned even-abs end-oh-one-one even-0s-even-1s foo~
	rm *~ oh-one-one balanced multiple-balaned even-abs end-oh-one-one even-0s-even-1s
	touch oh-one-one.cc balanced.cc multiple-balaned.cc even-abs.cc end-oh-one-one.cc even-0s-even-1s.cc
	rm oh-one-one.cc balanced.cc multiple-balaned.cc even-abs.cc end-oh-one-one.cc even-0s-even-1s.cc
