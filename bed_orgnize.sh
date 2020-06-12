#seperate DEL and DUP

awk '{print $0"\tS2"}' sample2.manta.del_dup.final.bed  > 2_CNV_final.bed
awk '{print $0"\tS27"}' sample27.manta.del_dup.final.bed  > 27_CNV_final.bed
awk '{print $0"\tS6"}' sample6.manta.del_dup.final.bed  > 6_CNV_final.bed
awk '{print $0"\tS30"}' sample30.manta.del_dup.final.bed  > 30_CNV_final.bed
cat 2_CNV_final.bed | grep DEL > 2_DEL.bed
cat 2_CNV_final.bed | grep DUP > 2_DUP.bed

cat 27_CNV_final.bed | grep DEL > 27_DEL.bed
cat 27_CNV_final.bed | grep DUP > 27_DUP.bed

cat 6_CNV_final.bed | grep DEL > 6_DEL.bed
cat 6_CNV_final.bed | grep DUP > 6_DUP.bed

cat 30_CNV_final.bed | grep DEL > 30_DEL.bed
cat 30_CNV_final.bed | grep DUP > 30_DUP.bed


cat 2_DEL.bed 6_DEL.bed | sort -k1,1 -k2,2n >  2_6_combined_DEL.bed
cat 27_DEL.bed 30_DEL.bed | sort -k1,1 -k2,2n > 27_30_combined_DEL.bed
cat 2_DUP.bed 6_DUP.bed | sort -k1,1 -k2,2n > 2_6_combined_DUP.bed
cat 27_DUP.bed 30_DUP.bed | sort -k1,1 -k2,2n > 27_30_combined_DUP.bed

bedtools merge -i 2_6_combined_DEL.bed > Ctrl_merged_DEL.bed
bedtools merge -i 2_6_combined_DUP.bed > Ctrl_merged_DUP.bed
bedtools merge -i 27_30_combined_DEL.bed > Exp_merged_DEL.bed
bedtools merge -i 27_30_combined_DUP.bed > Exp_merged_DUP.bed

bedtools intersect -a Ctrl_merged_DEL.bed -b Exp_merged_DEL.bed > shared_DEL.bed
bedtools intersect -a Ctrl_merged_DUP.bed -b Exp_merged_DUP.bed > shared_DUP.bed

#Get uniq region for each group
# a file should have bigger ranger than b file
bedtools subtract -a Ctrl_merged_DEL.bed -b shared_DEL.bed > Ctrl_uniq_DEL.bed
bedtools subtract -a Exp_merged_DEL.bed -b shared_DEL.bed >Exp_uniq_DEL.bed
bedtools subtract -a Ctrl_merged_DUP.bed -b shared_DUP.bed > Ctrl_uniq_DUP.bed
bedtools subtract -a Exp_merged_DUP.bed -b shared_DUP.bed >Exp_uniq_DUP.bed


awk '{print $0"\tExp_uniq_del"}' Exp_uniq_DEL.bed > Exp_uniq_DEL_final.bed

awk '{print $0"\tExp_uniq_dup"}' Exp_uniq_DUP.bed > Exp_uniq_DUP_final.bed
awk '{print $0"\tCtrl_uniq_del"}' Ctrl_uniq_DEL.bed > Ctrl_uniq_DEL_final.bed
awk '{print $0"\tCtrl_uniq_dup"}' Ctrl_uniq_DUP.bed > Ctrl_uniq_DUP_final.bed
awk '{print $0"\tShared_dup"}' shared_DUP.bed > shared_DUP_final.bed
awk '{print $0"\tShared_del"}' shared_DEL.bed > shared_DEL_final.bed


cat Exp_uniq_DEL_final.bed Exp_uniq_DUP_final.bed  Ctrl_uniq_DEL_final.bed Ctrl_uniq_DUP_final.bed shared_DUP_final.bed shared_DEL_final.bed > final_bed_visual.bed
