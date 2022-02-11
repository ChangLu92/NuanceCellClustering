# NuanceCellClustering


main_gui.m : manually registration between Nuance and H&E images
input: 
1. H&E image 
2, multispectral images (raw)
output:
Overlaid H&E image


main.m: cell clustering based on cos-kmediods clustering 
Cell intensities are calculated based on the multispectral imaging intensities
For a ROI,
input: 
1. H&E image (.jpg)
2, multispectral images (preprocessed) (.tif)
3, cell segments position (.zip)

parameters:
1, t: threthold for removing cell outliers 
2, k: the number of cell clusters
3, dis: distance measure

output:
1: a cell-biomarker matrix of all ROIs
2, a clustering results of the cell-biomarker matrix
3, the number of cell in each cluster
4, visulization of clustering results: t-SNE, MST, histogram of median intensity per cluster,  positions of each cell cluster on all H&E Images
5, the cell count per cluster, per folder(image), and per cluster per folder(image)


