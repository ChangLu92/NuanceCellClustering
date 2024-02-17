# NuanceCellClustering


Registration/main_gui.m : manually registration between Nuance and H&E images
input: 
1. H&E image 
2, multispectral images (raw)
output:
Overlaid H&E image


step 1. Integration: calculate the ave intensity per cell and integrate all cells into a matrix;
input: 
1. H&E image (.jpg)
2, multispectral images (preprocessed) (.tif)
3, cell segments position (.zip)
parameters: t: threthold for removing cell outliers 
output: a cell-biomarker matrix including cell intensity from all folders (e.g. 'cellmarker_rescale_intergration_t=3。mat')


step 2. clustering.m: cell clustering based on cos-kmediods clustering 
Cell intensities are calculated based on the multispectral imaging intensities
input: a cell-biomarker matrix including cell intensity from all folders
parameters:
k : the number of cell clusters
dn = 'cosine'; % distance measure
output: clustering results of the cell-biomarker matrix (e.g. 'cellmarker_rescale_intergration_t=3')


step 3. Clu_Analysis.mlx
1, visulization of clustering results: t-SNE, MST, histogram of median intensity per cluster,  positions of each cell cluster on all H&E Images
2, the cell count per cluster, per folder(image), and per cluster per folder(image)

step 4. MSTexpr.mlx : visualize 1) the ave intensities of any biomarker on MST; 2) percentage of positive cells per cluster.

step 5. reclustering.mlx : cluster to supercluster 

step 6. SuperClu_Analysis.mix : cell count per supercluster; H&E visualization; polar histogram; inich analysis