

awk '$4==1' promoter.txt > c1.bed
awk '$4==2' promoter.txt > c2.bed
awk '$4==3' promoter.txt > c3.bed
awk '$4==4' promoter.txt > c4.bed
awk '$4==5' promoter.txt > c5.bed

# group means cluster in Fig. 2D
# head promoter.txt 
# chr	start	end	group
# 1A	61420	61634	3
# 1A	93487	93629	4
# 1A	284854	285069	3
# 1A	1336874	1337355	5
# 1A	1801328	1801787	1
# 1A	1811889	1812252	1
# 1A	2514843	2515045	1
# 1A	2642462	2642622	5
# 1A	2942142	2942245	5



ls *bed | while read line; do bedtools getfasta -fi ~/data/161010_Chinese_Spring_v1.0_pseudomolecules.fasta -fo ${line%bed}fa -bed ${line} ; done

cat c1.sh
ame --o c1  --control all.proximal.fa c1.fa ~/motifs/Ath_TF_binding_motifs.meme

sh c1.sh
cp c1.sh c2.sh;sed -i 's/c1/c2/g' c2.sh;sh c2.sh
cp c1.sh c3.sh;sed -i 's/c1/c3/g' c3.sh;sh c3.sh
cp c1.sh c4.sh;sed -i 's/c1/c4/g' c4.sh;sh c4.sh
cp c1.sh c5.sh;sed -i 's/c1/c5/g' c5.sh;sh c5.sh

cat c1.sh
ame --o c1  --control all.proximal.fa c1.fa ~/rgtdata/motifs/Ath_TF_binding_motifs.meme
