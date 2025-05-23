mkdir log
mkdir samfiles
mkdir bamfiles
mkdir bw
mkdir peak
cat sample.txt | while read line
do
#quality control
echo "sample ${line} fastp begin"
fastp -i ${line}_R1.fq.gz -I ${line}_R2.fq.gz -o clean.${line}_R1.fq.gz -O clean.${line}_R2.fq.gz --detect_adapter_for_pe -w 8 --compression 9 -h log/${line}.html -j log/${line}.json
echo "sample ${line} fastp done"
#mapping using bwa
echo "sample ${line} bwa begin"
bwa mem -M -t 8 ./iwgscidx/ChineseSpring.bwa.index clean.${line}_R1.fq.gz clean.${line}_R2.fq.gz > samfiles/${line}.sam
echo "sample ${line} bwa done"
echo "sample ${line} filter begin"
samtools view -@ 8 -bS samfiles/${line}.sam | samtools sort -@ 8 - -o bamfiles/${line}.bam
#filter reads
samtools view -@ 8 -bS -F 1804 -f 2 -q 30 bamfiles/${line}.bam | samtools sort -@ 8 -o bamfiles/${line}.filtered.bam -
echo "sample ${line} filter done"
#remove PCR duplicates
echo "sample ${line} picard begin"
java -XX:ParallelGCThreads=8 -Xmx40g -jar ~/software/picard/picard.jar MarkDuplicates -I bamfiles/${line}.filtered.bam -O bamfiles/${line}.rmdup.bam -M log/${line}.rmdup.metrics.txt -REMOVE_DUPLICATES true
echo "sample ${line} picard done"
#convert bam file to bigwig file
samtools index -c bamfiles/${line}.rmdup.bam
echo "sample ${line} bamcoverage begin"
bamCoverage -p 8 -bs 10 --effectiveGenomeSize 14600000000 --normalizeUsing RPKM --smoothLength 50 -b bamfiles/${line}.rmdup.bam -o bw/${line}.bw
echo "sample ${line} bamcoverage done"
#peak calling for ATAC-seq data
echo "sample ${line} macs2 begin"
macs2 callpeak -t bamfiles/${line}.rmdup.bam -q 0.05 -f BAMPE --nomodel --extsize 200 --shift -100 -g 14600000000 -n ${line}
echo "sample ${line} macs2 done"
rm samfiles/${line}.sam
done
