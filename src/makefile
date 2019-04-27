all: compile

compile:
	java -jar ../jtb132di.jar minijava.jj
	java -jar ../javacc5.jar minijava.jj
	javac Main.java

clean:
	rm -f *.class *~
