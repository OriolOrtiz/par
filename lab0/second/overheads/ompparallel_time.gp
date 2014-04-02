set term pdf color
set output 'ompparallel_time.pdf'
set xlabel 'Number of threads'
set ylabel 'Overhead (us)'
set key below

plot 'ompparallel_time.txt' using 1:2 title 'Total' lc 3, 'ompparallel_time.txt' using 1:3 title 'Per thread' lc 2
