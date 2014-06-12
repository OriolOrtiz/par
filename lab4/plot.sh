gnuplot -e "set ylabel 'Time (s)'; set xlabel 'MAX_LEVEL';"`
          `"set term pdf color; set output 'level5.pdf';"`
          `"unset key; set grid ytics;"`
	  `"set xrange[5:45];"`
          `"plot 'level5.csv' using 1:2 with lines;"

gnuplot -e "set ylabel 'Time (s)'; set xlabel 'MAX_LEVEL';"`
          `"set term pdf color; set output 'level.pdf';"`
          `"unset key; set grid ytics;"`
          `"plot 'level.csv' using 1:2 with lines;"


gnuplot -e "set ylabel 'Time (s)'; set xlabel 'Number of threads';"`
          `"set term pdf color; set output 'times.pdf';"`
          `"unset key; set grid ytics;"`
          `"plot 'times.csv' using 1:2 with lp linecolor 3;"
