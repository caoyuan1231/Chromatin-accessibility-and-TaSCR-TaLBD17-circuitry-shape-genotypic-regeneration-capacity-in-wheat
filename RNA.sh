
cat sample.txt | while read line
do
fastp -i ${line}_1.fq.gz -I ${line}_2.fq.gz -o clean.${line}_R1.fq.gz -O clean.${line}_R2.fq.gz --detect_adapter_for_pe -w 8 --compression 9 -h log/${line}.html -j log/${line}.json
hisat2 --dta -x ./iwgscidx/ChineseSpring.hisat2 -p 8 -1 clean.${line}_R1.fq.gz -2 clean.${line}_R2.fq.gz -S samfiles/${line}.sam
samtools view -@ 8 -bS samfiles/${line}.sam | samtools sort -@ 8 - -o bamfiles/${line}.bam
#count using featureCount
featureCounts -T 8 -t exon -p -P -B -C -g gene_id -a ./IWGSC_v1.1_HC_20170706.gtf -o featurecount/${line}.feacount.txt bamfiles/${line}.bam
rm samfiles/${line}.sam
done

