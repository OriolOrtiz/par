all: deliverable.pdf

deliverable.pdf: deliverable.hal
	hal deliverable.hal > deliverable.tex
	pdflatex -shell-escape -interaction=nonstopmode deliverable.tex
	rm deliverable.tex

