all: deliverable.pdf

deliverable.pdf: deliverable.hal
	hal deliverable.hal > deliverable.tex
	pdflatex -shell-escape deliverable.tex
	rm deliverable.tex

