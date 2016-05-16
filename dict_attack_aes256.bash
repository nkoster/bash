#!/bin/bash
dict=(wouter manga anime hentai kanokon bitcoins linux babbage janneke fight club patema inverted hal paprika hell boy pizza)

((n_elements=${#dict[@]}, max_index=n_elements - 1))

echo -e "\n---- stage 1\n"

for ((i = 0; i <= max_index; i++))
do
  echo "${dict[i]}"
done >aap0

echo -e "\n---- stage 2\n"

for ((i = 0; i <= max_index; i++))
do
  for ((ii = 0; ii <= max_index; ii++))
  do
    echo "${dict[i]}${dict[ii]}"
  done
done >>aap0

#echo -e "\n---- stage 3\n"

#for ((i = 0; i <= max_index; i++))
#do
#  for ((ii = 0; ii <= max_index; ii++))
#  do
#    for ((iii = 0; iii <= max_index; iii++))
#    do
#      echo "${dict[i]}${dict[ii]}${dict[iii]}"
#    done
#  done
#done >>aap0

echo -e "\n---- stage 4\n"

for n in a b c d e f g h i j k l m n o p r s t u v w x y z
do
  echo -e "\n---- stage 4 run ${n}\n"
  for nn in a b c d e f g h i j k l m n o p r s t u v w x y z
  do
    cat aap0 | \
    tr [$nn] [${nn^}]
  done | sort -u > aap1
  cat aap1 >>aap0
  cat aap0 | sort -u >aap1
  mv aap1 aap0
done
