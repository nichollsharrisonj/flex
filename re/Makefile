all: oh-one-one no-ab calculator abcs

oh-one-one: oh-one-one.ll
	flex -o oh-one-one.cc oh-one-one.ll
	g++ -std=c++17 -g -o oh-one-one oh-one-one.cc

not-oh-one-one: not-oh-one-one.ll
	flex -o not-oh-one-one.cc not-oh-one-one.ll
	g++ -std=c++17 -g -o not-oh-one-one not-oh-one-one.cc

no-ab: no-ab.ll
	flex -o no-ab.cc no-ab.ll
	g++ -std=c++17 -g -o no-ab no-ab.cc

calculator: calculator.ll
	flex -o calculator.cc calculator.ll
	g++ -std=c++17 -g -o calculator calculator.cc

abcs: abcs.ll
	flex -o abcs.cc abcs.ll
	g++ -std=c++17 -g -o abcs abcs.cc

even: even.ll
	flex -o even.cc even.ll
	g++ -std=c++17 -g -o even even.cc


clean:
	touch oh-one-one no-ab calculator abcs not-oh-one-one even
	rm oh-one-one no-ab calculator abcs not-oh-one-one even
	touch oh-one-one.cc no-ab.cc calculator.cc abcs.cc not-oh-one-one.cc even.cc
	rm oh-one-one.cc no-ab.cc calculator.cc abcs.cc not-oh-one-one.cc even.cc
