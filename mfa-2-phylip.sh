#!/bin/bash

# USAGE:
sh mfa-2-phylip.sh [mfa.aln] [PREFIX]

MFA=${1}
PREFIX=${2}

# generate random prefix for all tmp files
RAND_1=`echo $((1 + RANDOM % 100))`
RAND_2=`echo $((100 + RANDOM % 200))`
RAND_3=`echo $((200 + RANDOM % 300))`
RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

# index
samtools faidx ${MFA}

# make fofn from mfa                       
grep ">" ${MFA} | tr -d '>' > ${RAND}_fofn.txt

# get number of taxa in fofn
N_TAXA=`wc -l ${RAND}_fofn.txt | awk '{print $1}'`

for TAXA in $(cat ${RAND}_fofn.txt); do

	samtools faidx ${MFA} ${TAXA} | grep -v ">" | tr -d '\n' >> ${RAND}.seq
	echo "" >> ${RAND}.seq	

done

wait

# get len of seq
WC=`head -1 ${RAND}.seq | wc | awk '{print $3}'`
ONE=1
let SEQ_LEN=${WC}-${ONE}

echo "${N_TAXA} ${SEQ_LEN}" > ${RAND}_tmp_head.txt

paste ${RAND}_fofn.txt ${RAND}.seq > ${RAND}_tmp_seq.txt

cat ${RAND}_tmp_head.txt ${RAND}_tmp_seq.txt > ${PREFIX}.phylip

# rm tmp files
rm ${RAND}_*

		
